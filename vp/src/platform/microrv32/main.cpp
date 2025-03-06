#include <cstdlib>
#include <ctime>

#include "core/common/clint.h"
#include "elf_loader.h"
#include "debug_memory.h"
#include "iss.h"
#include "mem.h"
#include "memory.h"
#include "syscall.h"
#include "microrv32_uart.h"
#include "microrv32_led.h"
#include "microrv32_gpio.h"
#include "util/options.h"
#include "platform/common/options.h"

#include "gdb-mc/gdb_server.h"
#include "gdb-mc/gdb_runner.h"

#include <boost/io/ios_state.hpp>
#include <boost/program_options.hpp>
#include <iomanip>
#include <iostream>

using namespace rv32;
namespace po = boost::program_options;

class BasicOptions : public Options {
public:
	typedef unsigned int addr_t;

	addr_t clint_start_addr = 0x2000000;
	addr_t clint_end_addr = 0x200ffff;
	addr_t sys_start_addr = 0x02010000;
	addr_t sys_end_addr = 0x020103ff;
	addr_t mem_start_addr = 0x80000000;
	addr_t mem_end_addr = 0x80ffffff;
	addr_t led_start_addr = 0x81000000;
	addr_t led_end_addr = 0x810000ff;
	addr_t uart_start_addr = 0x82000000;
	addr_t uart_end_addr = 0x820000ff;
	addr_t gpio_a_start_addr = 0x83000000;
	addr_t gpio_a_end_addr = 0x830000ff;
	
	addr_t mem_size = mem_end_addr - mem_start_addr;

	bool use_E_base_isa = false;

#ifdef SINGLE_CORE
	// Original single core implementation
	OptionValue<unsigned long> entry_point;

	BasicOptions(void) {
        	// clang-format off
		add_options()
			("use-E-base-isa", po::bool_switch(&use_E_base_isa), "use the E instead of the I integer base ISA")
			("entry-point", po::value<std::string>(&entry_point.option),"set entry point address (ISS program counter)");
        	// clang-format on
	}

	void parse(int argc, char **argv) override {
		Options::parse(argc, argv);

		entry_point.finalize(parse_ulong_option);
	}
#else
    // Multi-core implementation
    OptionValue<unsigned long> entry_point; // Added definition for multi-core default entry point
    OptionValue<std::string> entry_points_str;
    // Set each core's entry_point, using comma for seperation
    std::vector<uint64_t> entry_points;

    BasicOptions(void) {
        // clang-format off
        add_options()
            ("use-E-base-isa", po::bool_switch(&use_E_base_isa), "use the E instead of the I integer base ISA")
            ("entry-point", po::value<std::string>(&entry_point.option), "set entry point address (ISS program counter)")
            ("entry-points", po::value<std::string>(&entry_points_str.option), "comma separated entrypoints for each core");
        // clang-format on
    }

    void parse(int argc, char **argv) override {
    	// std::cout << "[DEBUG] Command line args:";
		// for (int i = 0; i < argc; i++) {
		//     std::cout << " " << argv[i];
		// }
		// std::cout << std::endl;

        Options::parse(argc, argv);

	    // manually parse --entry-points
	    for (int i = 1; i < argc; i++) {
	        if (std::string(argv[i]).find("--entry-points") == 0) {
	            std::string entry_value;
	            if (std::string(argv[i]).find("=") != std::string::npos) {
	                // handle --entry-points=0x80000028,0x80001028 
	                entry_value = std::string(argv[i]).substr(std::string("--entry-points=").length());
	                entry_points_str.available = true;
	            } else if (i + 1 < argc) {
	                // handle --entry-points 0x80000028,0x80001028 
	                entry_value = std::string(argv[i + 1]);
	                entry_points_str.available = true;
	            }
	            // std::cout << "[DEBUG] Manually parsed entry_points_str: " << entry_value << std::endl;
	            entry_points_str.value = entry_value;
	        }
	    }

	    // std::cout << "[DEBUG] entry_points_str.available: " << entry_points_str.available << std::endl;
	    // std::cout << "[DEBUG] Parsed entry_points_str: " << entry_points_str.value << std::endl;

        entry_point.finalize(parse_ulong_option);
        // std::cout << "[DEBUG] Parsed entry_point: " << entry_point.value << std::endl;


        if (entry_points_str.available) {
            std::istringstream iss(entry_points_str.value);
            std::string token;
            while (std::getline(iss, token, ',')) {
                // automatically identify hexadecimal or decimal
                entry_points.push_back(std::stoull(token, nullptr, 0));
            }
        }
    }
#endif
};

int sc_main(int argc, char **argv) {
	BasicOptions opt;
	opt.parse(argc, argv);

	std::srand(std::time(nullptr));  // use current time as seed for random generator

	tlm::tlm_global_quantum::instance().set(sc_core::sc_time(opt.tlm_global_quantum, sc_core::SC_NS));

#ifdef SINGLE_CORE
	// Original implementation: only 1 core
	ISS core(0, opt.use_E_base_isa);
#else
	// Change into multi-core implementation
	const int NUM_CORES = 5;
	std::vector<ISS*> cores;
	for (int i = 0; i < NUM_CORES; i++) {
	    cores.push_back(new ISS(i, opt.use_E_base_isa));
	}
#endif

	SimpleMemory mem("SimpleMemory", opt.mem_size);

	// Instantiate ELFLoader
	ELFLoader loader(opt.input_program.c_str());

	std::shared_ptr<BusLock> bus_lock = std::make_shared<BusLock>();

#ifdef SINGLE_CORE
	SimpleBus<2, 6> bus("SimpleBus");
#else
	// Create the bus with (NUM_CORES+1) masters: each core is a master + 1 debug master
	SimpleBus<NUM_CORES + 1, 6> bus("SimpleBus");
#endif

	SyscallHandler sys("SyscallHandler");

#ifdef SINGLE_CORE
	CombinedMemoryInterface iss_mem_if("MemoryInterface", core);
	// Configure bus_lock
	iss_mem_if.bus_lock = bus_lock;
	CLINT<1> clint("CLINT");
#else
	std::vector<CombinedMemoryInterface*> iss_mem_ifs;
	iss_mem_ifs.resize(NUM_CORES);
	for (int i = 0; i < NUM_CORES; i++) {
	    // Independent MemoryInterface for each core
	    std::string if_name = std::string("MemoryInterface_Core") + std::to_string(i);
	    iss_mem_ifs[i] = new CombinedMemoryInterface(if_name.c_str(), *cores[i]); 
	    // bond to the common bus_lock
	    iss_mem_ifs[i]->bus_lock = bus_lock;
	}

	// Create a shared CLINT instance for NUM_CORES cores.
	CLINT<NUM_CORES> clint("CLINT");
#endif


	DebugMemoryInterface dbg_if("DebugMemoryInterface");
	MicroRV32UART uart("MicroRV32UART");
	MicroRV32LED led("MicroRV32LED");
	MicroRV32GPIO gpio_a("MicroRV32GPIO");

	MemoryDMI dmi = MemoryDMI::create_start_size_mapping(mem.data, opt.mem_start_addr, mem.size);
#ifdef SINGLE_CORE
	InstrMemoryProxy instr_mem(dmi, core);
#else
	std::vector<InstrMemoryProxy*> instr_mems;
	instr_mems.resize(NUM_CORES);
	for (int i = 0; i < NUM_CORES; i++) {
	    // Independent instruction memory for each core
	    instr_mems[i] = new InstrMemoryProxy(dmi, *cores[i]); 
	}
#endif


	loader.load_executable_image(mem, mem.size, opt.mem_start_addr);

#ifdef SINGLE_CORE
	uint64_t entry_point = loader.get_entrypoint();
	if (opt.entry_point.available)
		entry_point = opt.entry_point.value;
	instr_memory_if *instr_mem_if = &iss_mem_if;
	data_memory_if *data_mem_if = &iss_mem_if;
	if (opt.use_instr_dmi)
		instr_mem_if = &instr_mem;
	if (opt.use_data_dmi) {
		iss_mem_if.dmi_ranges.emplace_back(dmi);
	}
	core.init(instr_mem_if, data_mem_if, &clint, entry_point, rv32_align_address(opt.mem_end_addr));
	sys.init(mem.data, opt.mem_start_addr, loader.get_heap_addr());
	sys.register_core(&core);

	if (opt.intercept_syscalls)
		core.sys = &sys;
#else
	// Get the default entry point: use the one provided by --entry-point if available,
    // otherwise use loader.get_entrypoint()
    uint64_t default_entry = (opt.entry_point.available) ? opt.entry_point.value : loader.get_entrypoint();
    // If no multiple entry points are provided, use default_entry for all cores
    if (opt.entry_points.empty()) {
        opt.entry_points.resize(NUM_CORES, default_entry);
    }
    // Initialize each core with its specific entry point from the array
	// Assume each core gets a 4K stack
	uint32_t stack_size = 0x1000;
    for (int i = 0; i < NUM_CORES; i++) {
	    // std::cout << "Core " << i << " is assigned entry point = 0x"
        //   << std::hex << opt.entry_points[i] << std::dec
        //   << std::endl;

    	// For each core, we use a distinct CombinedMemoryInterface
		instr_memory_if *instr_mem_if = iss_mem_ifs[i];
		data_memory_if  *data_mem_if  = iss_mem_ifs[i];
		if (opt.use_instr_dmi)
			instr_mem_if = instr_mems[i];
		if (opt.use_data_dmi) {
			iss_mem_ifs[i]->dmi_ranges.emplace_back(dmi);
		}
	    // Each core's stack pointer is at the top of its dedicated stack region.
	    // Here, we assume that the end of memory (opt.mem_end_addr) is the top,
	    // and each core's stack is placed contiguously downward.
	    uint32_t sp = rv32_align_address(opt.mem_end_addr) - i * stack_size;    	
	    cores[i]->init(instr_mem_if, data_mem_if, &clint, opt.entry_points[i], sp);
        sys.register_core(cores[i]);
        if (opt.intercept_syscalls)
            cores[i]->sys = &sys;
    }
	sys.init(mem.data, opt.mem_start_addr, loader.get_heap_addr());

#endif

	// address mapping
	bus.ports[0] = new PortMapping(opt.mem_start_addr, opt.mem_end_addr);
	bus.ports[1] = new PortMapping(opt.clint_start_addr, opt.clint_end_addr);
	bus.ports[2] = new PortMapping(opt.uart_start_addr, opt.uart_end_addr);
	bus.ports[3] = new PortMapping(opt.sys_start_addr, opt.sys_end_addr);
	bus.ports[4] = new PortMapping(opt.led_start_addr, opt.led_end_addr);
	bus.ports[5] = new PortMapping(opt.gpio_a_start_addr, opt.gpio_a_end_addr);

	// connect TLM sockets
#ifdef SINGLE_CORE
	iss_mem_if.isock.bind(bus.tsocks[0]);
	dbg_if.isock.bind(bus.tsocks[1]);
#else
	// Bind each core's CombinedMemoryInterface to the bus master sockets
	for (int i = 0; i < NUM_CORES; i++) {
	    iss_mem_ifs[i]->isock.bind(bus.tsocks[i]);
	}
	dbg_if.isock.bind(bus.tsocks[NUM_CORES]);
#endif

	bus.isocks[0].bind(mem.tsock);
	bus.isocks[1].bind(clint.tsock);
	bus.isocks[2].bind(uart.tsock);
	bus.isocks[3].bind(sys.tsock);
	bus.isocks[4].bind(led.tsock);
	bus.isocks[5].bind(gpio_a.tsock);

	// connect interrupt signals/communication
#ifdef SINGLE_CORE
	clint.target_harts[0] = &core;
#else
	// Assign each core to its respective CLINT slot.
	for (int i = 0; i < NUM_CORES; i++) {
	    clint.target_harts[i] = cores[i];
	}
#endif



#ifdef SINGLE_CORE
	std::vector<debug_target_if *> threads;
	threads.push_back(&core);

	core.trace = opt.trace_mode;  // switch for printing instructions
	if (opt.use_debug_runner) {
		auto server = new GDBServer("GDBServer", threads, &dbg_if, opt.debug_port);
		new GDBServerRunner("GDBRunner", server, &core);
	} else {
		new DirectCoreRunner(core);
	}

#else
   	std::vector<debug_target_if *> threads;
    for (int i = 0; i < NUM_CORES; i++) {
         cores[i]->trace = opt.trace_mode;
         threads.push_back(cores[i]);
    }

    if (opt.use_debug_runner) {
         auto server = new GDBServer("GDBServer", threads, &dbg_if, opt.debug_port);
         for (int i = 0; i < NUM_CORES; i++) {
              new GDBServerRunner("GDBRunner", server, cores[i]);
         }
    } else {
         for (int i = 0; i < NUM_CORES; i++) {
              new DirectCoreRunner(*cores[i]);
         }
    }
#endif

	//printf("Local: start simulation!\n");
	sc_core::sc_start();

#ifdef SINGLE_CORE
	core.show();
#else
	for (int i = 0; i < NUM_CORES; i++) {
    	cores[i]->show();
	}
#endif

	return 0;
}
