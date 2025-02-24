#include "ethernet.h"

// #include <netinet/ether.h>
#ifdef __APPLE__
#include <net/ethernet.h>  // macOS 兼容版本
// #include <net/if_ether.h>
#include <net/if_dl.h>      // 可能包含 MAC 地址解析
#include <sys/socket.h>     // 提供 Ethernet 结构体
// #define iphdr ip             // 让 iphdr 兼容 struct ip

#define ETH_P_IP ETHERTYPE_IP      // macOS 需要手动定义
#define ETH_P_ARP ETHERTYPE_ARP
#define ETH_ALEN ETHER_ADDR_LEN


#else
#include <netinet/ether.h>
#endif

#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
// for debug
#include <arpa/inet.h>


#include <netinet/ip.h>

#ifdef __APPLE__
struct ethhdr {
    uint8_t h_dest[6];   // 目标 MAC
    uint8_t h_source[6]; // 源 MAC
    uint16_t h_proto;    // 协议
};
struct udphdr {
	u_short source;               /* source port */
	u_short dest;               /* destination port */
	u_short len;                /* udp length */
	u_short check;                 /* udp checksum */
};

/*
 * User-settable options (used with setsockopt).
 */
#define UDP_NOCKSUM     0x01    /* don't checksum outbound payloads */

#else
#include <netinet/udp.h>
#endif
// #include <netinet/udp.h>

#ifdef __APPLE__
#include <sys/socket.h>   // macOS 替代
#include <net/ethernet.h> // Ethernet 相关
#include <net/if_dl.h>    // MAC 地址解析
#else
#include <linux/if_packet.h>  // Linux 版本
#endif
// #include <linux/if_packet.h>


//#include <netpacket/packet.h>
#include <net/if.h>
//#include <linux/if_ether.h>
#include <fcntl.h>


// #include <linux/if_tun.h>
#ifdef __APPLE__
#include <net/if_utun.h>   // macOS TUN 设备支持
#include <sys/socket.h>    // macOS 网络支持
#define IFF_TUN 0x0001
#define IFF_TAP 0x0002
#define IFF_NO_PI 0x1000
#define TUNSETIFF 0x400454ca
#else
#include <linux/if_tun.h>  // Linux 版本
#endif

#include <sys/ioctl.h>

#include <ifaddrs.h>
#include <netdb.h>


#ifdef __APPLE__

struct iphdr {
#ifdef _IP_VHL
	u_char  ip_vhl;                 /* version << 4 | header length >> 2 */
#else
#if BYTE_ORDER == LITTLE_ENDIAN
	u_int   ihl:4,                /* header length */
	    version:4;                     /* version */
#endif
#if BYTE_ORDER == BIG_ENDIAN
	u_int   version:4,                 /* version */
	    ihl:4;                    /* header length */
#endif
#endif /* not _IP_VHL */
	u_char  tos;                 /* type of service */
	u_short tot_len;                 /* total length */
	u_short id;                  /* identification */
	u_short frag_off;                 /* fragment offset field */
#define IP_RF 0x8000                    /* reserved fragment flag */
#define IP_DF 0x4000                    /* dont fragment flag */
#define IP_MF 0x2000                    /* more fragments flag */
#define IP_OFFMASK 0x1fff               /* mask for fragmenting bits */
	u_char  ttl;                 /* time to live */
	u_char  protocol;                   /* protocol */
	u_short check;                 /* checksum */
	// struct  in_addr saddr, daddr;  /* source and dest address */
	unsigned int saddr, daddr;  /* source and dest address */

};
#endif

using namespace std;

static const char IF_NAME[] = "tap0";

#define SYS_CHECK(arg, msg)           \
	if ((arg) < 0) {                  \
		perror(msg);                  \
		throw runtime_error("error"); \
	}

void printHex(const unsigned char *buf, const uint32_t len) {
	for (uint8_t i = 0; i < len; i++) {
		printf("%s%02X", i > 0 ? ":" : "", buf[i]);
	}
}

void printDec(const unsigned char *buf, const uint32_t len) {
	for (uint8_t i = 0; i < len; i++) {
		printf("%s%d", i > 0 ? "." : "", buf[i]);
	}
}

void dump_ethernet_frame(uint8_t *buf, size_t size, bool verbose = false) {
	uint8_t *readbuf = buf;
	struct ether_header *eh = (struct ether_header *)readbuf;

	if (verbose) {
		cout << "destination MAC: ";
		printHex(reinterpret_cast<unsigned char *>(&eh->ether_dhost), 6);
		cout << endl;
		cout << "source MAC     : ";
		printHex(reinterpret_cast<unsigned char *>(&eh->ether_shost), 6);
		cout << endl;
		cout << "type           : " << ntohs(eh->ether_type) << endl;
	}

	readbuf += sizeof(struct ethhdr);
	switch (ntohs(eh->ether_type)) {
		case ETH_P_IP: {
			cout << "IP ";
			struct in_addr source;
			struct in_addr dest;
			struct iphdr *ip = (struct iphdr *)readbuf;
			memset(&source, 0, sizeof(source));
			source.s_addr = ip->saddr;
			memset(&dest, 0, sizeof(dest));
			dest.s_addr = ip->daddr;
			if (verbose) {
				cout << endl;
				cout << "\t|-Version               : " << ip->version << endl;
				cout << "\t|-Internet Header Length: " << ip->ihl << " DWORDS or " << ip->ihl * 4 << " Bytes" << endl;
				cout << "\t|-Type Of Service       : " << (unsigned int)ip->tos << endl;
				cout << "\t|-Total Length          : " << ntohs(ip->tot_len) << " Bytes" << endl;
				cout << "\t|-Identification        : " << ntohs(ip->id) << endl;
				cout << "\t|-Time To Live          : " << (unsigned int)ip->ttl << endl;
				cout << "\t|-Protocol              : " << (unsigned int)ip->protocol << endl;
				cout << "\t|-Header Checksum       : " << ntohs(ip->check) << endl;
				cout << "\t|-Source IP             : " << inet_ntoa(source) << endl;
				cout << "\t|-Destination IP        : " << inet_ntoa(dest) << endl;
			}
			readbuf += ip->ihl * 4;
			switch (ip->protocol) {
				case IPPROTO_UDP: {
					cout << "UDP ";
					struct udphdr *udp = (struct udphdr *)readbuf;
					if (verbose) {
						cout << endl;
						cout << "\t|-Source port     : " << ntohs(udp->source) << endl;
						cout << "\t|-Destination port: " << ntohs(udp->dest) << endl;
						cout << "\t|-Length          : " << ntohs(udp->len) << endl;
						cout << "\t|-Checksum        : " << ntohs(udp->check) << endl;
					}
					readbuf += sizeof(udphdr);
					switch (ntohs(udp->dest)) {
						case 67:
						case 68:
							cout << "DHCP ";
							switch (readbuf[0]) {
								case 1:
									cout << "DISCOVER/REQUEST";
									break;
								case 2:
									cout << "ACK";
									break;
								default:
									cout << "UNKNOWN (" << to_string(readbuf[0]) << ")";
									goto printHex;
							}
							break;
						default:
							break;
					}
					return;
				}
				case IPPROTO_TCP:
					cout << "TCP ";
					if (verbose)
						cout << endl;
					return;
				case IPPROTO_ICMP:
					cout << "ICMP ";
					switch (readbuf[0]) {
						case 0:
							cout << "ECHO REPLY";
							break;
						case 3:
							cout << "DEST UNREACHABLE";
							break;
						case 8:
							cout << "ECHO REQUEST";
							break;
						default:
							cout << "Sonstiges";
					}
					if (verbose)
						cout << endl;
				default:
					return;
			}
			break;
		}
		case ETH_P_ARP: {
			cout << "ARP ";
			struct arp_eth_header *arp = (struct arp_eth_header *)readbuf;
			if (verbose) {
				cout << endl;
				cout << "\t|-Sender MAC: ";
				printHex((uint8_t *)&arp->sender_mac, 6);
				cout << endl;
				cout << "\t|-Sender IP : ";
				printDec((uint8_t *)&arp->sender_ip, 4);
				cout << endl;
				cout << "\t|-DEST MAC  : ";
				printHex((uint8_t *)&arp->target_mac, 6);
				cout << endl;
				cout << "\t|-DEST IP   : ";
				printDec((uint8_t *)&arp->target_ip, 4);
				cout << endl;
			}
			cout << "\t|-Operation : "
			     << (ntohs(arp->oper) == 1 ? "REQUEST" : ntohs(arp->oper) == 2 ? "REPLY" : "INVALID");
			return;
			break;
		}
		default:
			cout << "unknown protocol";
			return;
	}
printHex:
	ios_base::fmtflags f(cout.flags());
	for (unsigned i = 0; i < size; ++i) {
		cout << hex << setw(2) << setfill('0') << (int)buf[i] << " ";
	}
	cout.flags(f);
}

EthernetDevice::EthernetDevice(sc_core::sc_module_name, uint32_t irq_number, uint8_t *mem, std::string clonedev)
    : irq_number(irq_number), mem(mem) {
	tsock.register_b_transport(this, &EthernetDevice::transport);
	SC_THREAD(run);

	router
	    .add_register_bank({
	        {STATUS_REG_ADDR, &status},
	        {RECEIVE_SIZE_REG_ADDR, &receive_size},
	        {RECEIVE_DST_REG_ADDR, &receive_dst},
	        {SEND_SRC_REG_ADDR, &send_src},
	        {SEND_SIZE_REG_ADDR, &send_size},
	        {MAC_HIGH_REG_ADDR, &mac[0]},
	        {MAC_LOW_REG_ADDR, &mac[1]},
	    })
	    .register_handler(this, &EthernetDevice::register_access_callback);

	disabled = clonedev == string("");

	if (!disabled) {
		init_network(clonedev);
	}
}

void EthernetDevice::init_network(std::string clonedev) {
	struct ifreq ifr;
	int err;

	if ((sockfd = open(clonedev.c_str(), O_RDWR)) < 0) {
		cerr << "Error opening " << clonedev << endl;
		perror("exiting");
		assert(sockfd >= 0);
	}

	memset(&ifr, 0, sizeof(ifr));

	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;

	strncpy(ifr.ifr_name, IF_NAME, IFNAMSIZ);

	if ((err = ioctl(sockfd, TUNSETIFF, (void *)&ifr)) < 0) {
		perror("ioctl(TUNSETIFF)");
		close(sockfd);
		assert(err >= 0);
	}

	#ifdef __APPLE__
	/* Get the MAC address of the interface to send on */
	struct ifaddrs *ifap;
	if (getifaddrs(&ifap) == 0) {
	    struct ifaddrs *ifa = ifap;
	    while (ifa != NULL) {
	        if (ifa->ifa_addr != NULL && ifa->ifa_addr->sa_family == AF_LINK) {
	            struct sockaddr_dl *sdl = (struct sockaddr_dl *)ifa->ifa_addr;
	            // 通过 sockaddr_dl 获取 MAC 地址
	            if (strncmp(ifa->ifa_name, IF_NAME, IFNAMSIZ) == 0) {
	                // 保存获取到的 MAC 地址
	                memcpy(VIRTUAL_MAC_ADDRESS, LLADDR(sdl), 6);
	                break;  // 找到对应接口后跳出循环
	            }
	        }
	        ifa = ifa->ifa_next;
	    }

	    freeifaddrs(ifap);
	} else {
	    perror("getifaddrs");
	    assert(0);  // 错误处理
	}
	#else
	/* Get the MAC address of the interface to send on */
	struct ifreq ifopts;
	memset(&ifopts, 0, sizeof(struct ifreq));
	strncpy(ifopts.ifr_name, IF_NAME, IFNAMSIZ - 1);
	if (ioctl(sockfd, SIOCGIFHWADDR, &ifopts) < 0) {
		perror("SIOCGIFHWADDR");
		assert(sockfd >= 0);
	}
	// Save own MAC in register
	memcpy(VIRTUAL_MAC_ADDRESS, ifopts.ifr_hwaddr.sa_data, 6);
	#endif

	fcntl(sockfd, F_SETFL, O_NONBLOCK);
}

void EthernetDevice::send_raw_frame() {
	uint8_t sendbuf[send_size < 60 ? 60 : send_size];
	memcpy(sendbuf, &mem[send_src - 0x80000000], send_size);
	if (send_size < 60) {
		memset(&sendbuf[send_size], 0, 60 - send_size);
		send_size = 60;
	}

	cout << "SEND FRAME --->--->--->--->--->---> ";
	dump_ethernet_frame(sendbuf, send_size, true);
	cout << endl;

	struct ether_header *eh = (struct ether_header *)sendbuf;

	assert(memcmp(eh->ether_shost, VIRTUAL_MAC_ADDRESS, ETH_ALEN) == 0);

	ssize_t ans = write(sockfd, sendbuf, send_size);
	if (ans != send_size) {
		cout << strerror(errno) << endl;
	}
	assert(ans == send_size);
}

bool EthernetDevice::isPacketForUs(uint8_t *packet, ssize_t) {
	ether_header *eh = reinterpret_cast<ether_header *>(packet);
	bool virtual_match = memcmp(eh->ether_dhost, VIRTUAL_MAC_ADDRESS, ETH_ALEN) == 0;
	bool broadcast_match = memcmp(eh->ether_dhost, BROADCAST_MAC_ADDRESS, ETH_ALEN) == 0;
	bool own_packet = memcmp(eh->ether_shost, VIRTUAL_MAC_ADDRESS, ETH_ALEN) == 0;

	if (!virtual_match && !(broadcast_match && !own_packet)) {
		return false;
	}

	if (ntohs(eh->ether_type) != ETH_P_IP) {
		if (ntohs(eh->ether_type) != ETH_P_ARP) {  // Not ARP
			// cout << " dumped non-ARP " ;
			// FIXME change to true if you want other protocols than IP and ARP
			return false;
		}

		arp_eth_header *arp = reinterpret_cast<arp_eth_header *>(packet + sizeof(ether_header));

		if (memcmp(arp->target_mac, VIRTUAL_MAC_ADDRESS,
		           6)) {  // not to us directly
			// cout << " dumped ARP not targeted to US ";
			/**
			 * FIXME comment out if you want to generate arp table automatically
			 * 		 instead of having to request every neighbor explicitly
			 * 		 also to reply to ARP requests
			 */
			return true;
		}
	} else {
		// is IP
		return true;

		iphdr *ip = reinterpret_cast<iphdr *>(packet + sizeof(ether_header));
		if (ip->protocol != IPPROTO_UDP) {  // not UDP
			// cout << " dumped non-UDP ";
			// FIXME change to true if you want to use TCP or ICMP
			return false;
		}

		udphdr *udp = reinterpret_cast<udphdr *>(packet + sizeof(ether_header) + sizeof(iphdr));
		if (ntohs(udp->dest) != 67 && ntohs(udp->dest) != 68) {  // not DHCP
			// cout << " dumped non-DHCP ";
			return false;
		}
	}
	return true;
}

bool EthernetDevice::try_recv_raw_frame() {
	ssize_t ans;

	ans = read(sockfd, recv_frame_buf, FRAME_SIZE);
	assert(ans <= FRAME_SIZE);
	if (ans == 0) {
		cerr << "[ethernet] recv socket received zero bytes ... connection "
		        "closed?"
		     << endl;
		throw runtime_error("read failed");
	} else if (ans == -1) {
		if (errno == EWOULDBLOCK || errno == EAGAIN) {
			return true;
		} else
			throw runtime_error("recvfrom failed");
	}
	assert(ETH_ALEN == 6);

	if (!isPacketForUs(recv_frame_buf, ans)) {
		return false;
	}

	has_frame = true;
	receive_size = ans;
	cout << "RECEIVED FRAME <---<---<---<---<--- ";
	dump_ethernet_frame(recv_frame_buf, ans);
	cout << endl;

	return true;
}
