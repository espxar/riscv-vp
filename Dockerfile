# XXX: Need Alpine Linux Edge since the latest release (3.19)
# only ships SystemC 2.3.3 and does hence not support aarch64.
FROM alpine:edge

RUN apk update && apk add --no-cache  build-base cmake boost-dev \
	systemc-dev systemc-static git gcc-riscv-none-elf \
	g++-riscv-none-elf newlib-riscv-none-elf gdb-multiarch

RUN adduser -G users -g 'RISC-V VP User' -D riscv-vp
ADD --chown=riscv-vp:users . /home/riscv-vp/riscv-vp
RUN su - riscv-vp -c 'env USE_SYSTEM_SYSTEMC=ON MAKEFLAGS="-j$(nproc)" make -C /home/riscv-vp/riscv-vp'
RUN su - riscv-vp -c 'echo export RISCV_PREFIX=\"riscv-none-elf-\" >> /home/riscv-vp/.profile'
RUN su - riscv-vp -c 'echo export PATH=\"$PATH:/home/riscv-vp/riscv-vp/vp/build/bin\" >> /home/riscv-vp/.profile'
CMD su - riscv-vp
