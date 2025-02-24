#include <iomanip>

#ifdef __APPLE__
// macOS 没有 <byteswap.h>，使用内建字节交换函数
#define bswap_16(x) OSSwapInt16(x)
#define bswap_32(x) OSSwapInt32(x)
#define bswap_64(x) OSSwapInt64(x)
#include <libkern/OSByteOrder.h>
#else
#include <byteswap.h>
#endif
//#include <byteswap.h>

#include "register_format.h"

RegisterFormater::RegisterFormater(Architecture arch) {
	this->arch = arch;
	this->stream << std::setfill('0') << std::hex;
}

void RegisterFormater::formatRegister(uint64_t value) {
	switch (arch) {
	case RV32:
		stream << std::setw(8) << bswap_32(value);
		break;
	case RV64:
		stream << std::setw(16) << bswap_64(value);
		break;
	default:
		throw std::invalid_argument("Architecture not implemented");
	}
}

std::string RegisterFormater::str(void) {
	return this->stream.str();
}
