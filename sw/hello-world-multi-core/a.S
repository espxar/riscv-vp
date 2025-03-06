
main：     文件格式 elf32-littleriscv


Disassembly of section .text.core0:

80000000 <_start_core0>:
80000000:	000070b3          	and	ra,zero,zero
80000004:	00007133          	and	sp,zero,zero
80000008:	000071b3          	and	gp,zero,zero
8000000c:	00007233          	and	tp,zero,zero
80000010:	000072b3          	and	t0,zero,zero
80000014:	00007333          	and	t1,zero,zero
80000018:	000073b3          	and	t2,zero,zero
8000001c:	00007433          	and	s0,zero,zero
80000020:	000074b3          	and	s1,zero,zero
80000024:	00007533          	and	a0,zero,zero
80000028:	000075b3          	and	a1,zero,zero
8000002c:	00007633          	and	a2,zero,zero
80000030:	000076b3          	and	a3,zero,zero
80000034:	00007733          	and	a4,zero,zero
80000038:	000077b3          	and	a5,zero,zero
8000003c:	00007833          	and	a6,zero,zero
80000040:	000078b3          	and	a7,zero,zero
80000044:	00007933          	and	s2,zero,zero
80000048:	000079b3          	and	s3,zero,zero
8000004c:	00007a33          	and	s4,zero,zero
80000050:	00007ab3          	and	s5,zero,zero
80000054:	00007b33          	and	s6,zero,zero
80000058:	00007bb3          	and	s7,zero,zero
8000005c:	00007c33          	and	s8,zero,zero
80000060:	00007cb3          	and	s9,zero,zero
80000064:	00007d33          	and	s10,zero,zero
80000068:	00007db3          	and	s11,zero,zero
8000006c:	00007e33          	and	t3,zero,zero
80000070:	00007eb3          	and	t4,zero,zero
80000074:	00007f33          	and	t5,zero,zero
80000078:	00007fb3          	and	t6,zero,zero
8000007c:	00004117          	auipc	sp,0x4
80000080:	42410113          	addi	sp,sp,1060 # 800044a0 <stack_end_core0>
80000084:	00000517          	auipc	a0,0x0
80000088:	01c50513          	addi	a0,a0,28 # 800000a0 <core0_main_entry>
8000008c:	000500e7          	jalr	a0
80000090:	05d00893          	li	a7,93
80000094:	020102b7          	lui	t0,0x2010
80000098:	f1402873          	csrr	a6,mhartid
8000009c:	0102a023          	sw	a6,0(t0) # 2010000 <SYSCALL_ADDR>

800000a0 <core0_main_entry>:
800000a0:	ff010113          	addi	sp,sp,-16
800000a4:	00112623          	sw	ra,12(sp)
800000a8:	00812423          	sw	s0,8(sp)
800000ac:	01010413          	addi	s0,sp,16
800000b0:	00000513          	li	a0,0
800000b4:	00006097          	auipc	ra,0x6
800000b8:	f4c080e7          	jalr	-180(ra) # 80006000 <wait_for_step>
800000bc:	01f00593          	li	a1,31
800000c0:	800067b7          	lui	a5,0x80006
800000c4:	18c78513          	addi	a0,a5,396 # 8000618c <putChr+0x6c>
800000c8:	00006097          	auipc	ra,0x6
800000cc:	fe0080e7          	jalr	-32(ra) # 800060a8 <sendString>
800000d0:	00006097          	auipc	ra,0x6
800000d4:	f70080e7          	jalr	-144(ra) # 80006040 <advance_step>
800000d8:	0000006f          	j	800000d8 <core0_main_entry+0x38>

Disassembly of section .text.core1:

80001000 <_start_core1>:
80001000:	000070b3          	and	ra,zero,zero
80001004:	00007133          	and	sp,zero,zero
80001008:	000071b3          	and	gp,zero,zero
8000100c:	00007233          	and	tp,zero,zero
80001010:	000072b3          	and	t0,zero,zero
80001014:	00007333          	and	t1,zero,zero
80001018:	000073b3          	and	t2,zero,zero
8000101c:	00007433          	and	s0,zero,zero
80001020:	000074b3          	and	s1,zero,zero
80001024:	00007533          	and	a0,zero,zero
80001028:	000075b3          	and	a1,zero,zero
8000102c:	00007633          	and	a2,zero,zero
80001030:	000076b3          	and	a3,zero,zero
80001034:	00007733          	and	a4,zero,zero
80001038:	000077b3          	and	a5,zero,zero
8000103c:	00007833          	and	a6,zero,zero
80001040:	000078b3          	and	a7,zero,zero
80001044:	00007933          	and	s2,zero,zero
80001048:	000079b3          	and	s3,zero,zero
8000104c:	00007a33          	and	s4,zero,zero
80001050:	00007ab3          	and	s5,zero,zero
80001054:	00007b33          	and	s6,zero,zero
80001058:	00007bb3          	and	s7,zero,zero
8000105c:	00007c33          	and	s8,zero,zero
80001060:	00007cb3          	and	s9,zero,zero
80001064:	00007d33          	and	s10,zero,zero
80001068:	00007db3          	and	s11,zero,zero
8000106c:	00007e33          	and	t3,zero,zero
80001070:	00007eb3          	and	t4,zero,zero
80001074:	00007f33          	and	t5,zero,zero
80001078:	00007fb3          	and	t6,zero,zero
8000107c:	00004117          	auipc	sp,0x4
80001080:	82410113          	addi	sp,sp,-2012 # 800048a0 <stack_end_core1>
80001084:	00000517          	auipc	a0,0x0
80001088:	01c50513          	addi	a0,a0,28 # 800010a0 <core1_main_entry>
8000108c:	000500e7          	jalr	a0
80001090:	05d00893          	li	a7,93
80001094:	020102b7          	lui	t0,0x2010
80001098:	f1402873          	csrr	a6,mhartid
8000109c:	0102a023          	sw	a6,0(t0) # 2010000 <SYSCALL_ADDR>

800010a0 <core1_main_entry>:
800010a0:	ff010113          	addi	sp,sp,-16
800010a4:	00112623          	sw	ra,12(sp)
800010a8:	00812423          	sw	s0,8(sp)
800010ac:	01010413          	addi	s0,sp,16
800010b0:	00100513          	li	a0,1
800010b4:	00005097          	auipc	ra,0x5
800010b8:	f4c080e7          	jalr	-180(ra) # 80006000 <wait_for_step>
800010bc:	01f00593          	li	a1,31
800010c0:	800067b7          	lui	a5,0x80006
800010c4:	1ac78513          	addi	a0,a5,428 # 800061ac <putChr+0x8c>
800010c8:	00005097          	auipc	ra,0x5
800010cc:	fe0080e7          	jalr	-32(ra) # 800060a8 <sendString>
800010d0:	00005097          	auipc	ra,0x5
800010d4:	f70080e7          	jalr	-144(ra) # 80006040 <advance_step>
800010d8:	0000006f          	j	800010d8 <core1_main_entry+0x38>

Disassembly of section .text.core2:

80002000 <_start_core2>:
80002000:	000070b3          	and	ra,zero,zero
80002004:	00007133          	and	sp,zero,zero
80002008:	000071b3          	and	gp,zero,zero
8000200c:	00007233          	and	tp,zero,zero
80002010:	000072b3          	and	t0,zero,zero
80002014:	00007333          	and	t1,zero,zero
80002018:	000073b3          	and	t2,zero,zero
8000201c:	00007433          	and	s0,zero,zero
80002020:	000074b3          	and	s1,zero,zero
80002024:	00007533          	and	a0,zero,zero
80002028:	000075b3          	and	a1,zero,zero
8000202c:	00007633          	and	a2,zero,zero
80002030:	000076b3          	and	a3,zero,zero
80002034:	00007733          	and	a4,zero,zero
80002038:	000077b3          	and	a5,zero,zero
8000203c:	00007833          	and	a6,zero,zero
80002040:	000078b3          	and	a7,zero,zero
80002044:	00007933          	and	s2,zero,zero
80002048:	000079b3          	and	s3,zero,zero
8000204c:	00007a33          	and	s4,zero,zero
80002050:	00007ab3          	and	s5,zero,zero
80002054:	00007b33          	and	s6,zero,zero
80002058:	00007bb3          	and	s7,zero,zero
8000205c:	00007c33          	and	s8,zero,zero
80002060:	00007cb3          	and	s9,zero,zero
80002064:	00007d33          	and	s10,zero,zero
80002068:	00007db3          	and	s11,zero,zero
8000206c:	00007e33          	and	t3,zero,zero
80002070:	00007eb3          	and	t4,zero,zero
80002074:	00007f33          	and	t5,zero,zero
80002078:	00007fb3          	and	t6,zero,zero
8000207c:	00003117          	auipc	sp,0x3
80002080:	c2410113          	addi	sp,sp,-988 # 80004ca0 <stack_end_core2>
80002084:	00000517          	auipc	a0,0x0
80002088:	01c50513          	addi	a0,a0,28 # 800020a0 <core2_main_entry>
8000208c:	000500e7          	jalr	a0
80002090:	05d00893          	li	a7,93
80002094:	020102b7          	lui	t0,0x2010
80002098:	f1402873          	csrr	a6,mhartid
8000209c:	0102a023          	sw	a6,0(t0) # 2010000 <SYSCALL_ADDR>

800020a0 <core2_main_entry>:
800020a0:	ff010113          	addi	sp,sp,-16
800020a4:	00112623          	sw	ra,12(sp)
800020a8:	00812423          	sw	s0,8(sp)
800020ac:	01010413          	addi	s0,sp,16
800020b0:	00200513          	li	a0,2
800020b4:	00004097          	auipc	ra,0x4
800020b8:	f4c080e7          	jalr	-180(ra) # 80006000 <wait_for_step>
800020bc:	01f00593          	li	a1,31
800020c0:	800067b7          	lui	a5,0x80006
800020c4:	1cc78513          	addi	a0,a5,460 # 800061cc <putChr+0xac>
800020c8:	00004097          	auipc	ra,0x4
800020cc:	fe0080e7          	jalr	-32(ra) # 800060a8 <sendString>
800020d0:	00004097          	auipc	ra,0x4
800020d4:	f70080e7          	jalr	-144(ra) # 80006040 <advance_step>
800020d8:	0000006f          	j	800020d8 <core2_main_entry+0x38>

Disassembly of section .text.core3:

80003000 <_start_core3>:
80003000:	000070b3          	and	ra,zero,zero
80003004:	00007133          	and	sp,zero,zero
80003008:	000071b3          	and	gp,zero,zero
8000300c:	00007233          	and	tp,zero,zero
80003010:	000072b3          	and	t0,zero,zero
80003014:	00007333          	and	t1,zero,zero
80003018:	000073b3          	and	t2,zero,zero
8000301c:	00007433          	and	s0,zero,zero
80003020:	000074b3          	and	s1,zero,zero
80003024:	00007533          	and	a0,zero,zero
80003028:	000075b3          	and	a1,zero,zero
8000302c:	00007633          	and	a2,zero,zero
80003030:	000076b3          	and	a3,zero,zero
80003034:	00007733          	and	a4,zero,zero
80003038:	000077b3          	and	a5,zero,zero
8000303c:	00007833          	and	a6,zero,zero
80003040:	000078b3          	and	a7,zero,zero
80003044:	00007933          	and	s2,zero,zero
80003048:	000079b3          	and	s3,zero,zero
8000304c:	00007a33          	and	s4,zero,zero
80003050:	00007ab3          	and	s5,zero,zero
80003054:	00007b33          	and	s6,zero,zero
80003058:	00007bb3          	and	s7,zero,zero
8000305c:	00007c33          	and	s8,zero,zero
80003060:	00007cb3          	and	s9,zero,zero
80003064:	00007d33          	and	s10,zero,zero
80003068:	00007db3          	and	s11,zero,zero
8000306c:	00007e33          	and	t3,zero,zero
80003070:	00007eb3          	and	t4,zero,zero
80003074:	00007f33          	and	t5,zero,zero
80003078:	00007fb3          	and	t6,zero,zero
8000307c:	00002117          	auipc	sp,0x2
80003080:	02410113          	addi	sp,sp,36 # 800050a0 <stack_end_core3>
80003084:	00000517          	auipc	a0,0x0
80003088:	01c50513          	addi	a0,a0,28 # 800030a0 <core3_main_entry>
8000308c:	000500e7          	jalr	a0
80003090:	05d00893          	li	a7,93
80003094:	020102b7          	lui	t0,0x2010
80003098:	f1402873          	csrr	a6,mhartid
8000309c:	0102a023          	sw	a6,0(t0) # 2010000 <SYSCALL_ADDR>

800030a0 <core3_main_entry>:
800030a0:	ff010113          	addi	sp,sp,-16
800030a4:	00112623          	sw	ra,12(sp)
800030a8:	00812423          	sw	s0,8(sp)
800030ac:	01010413          	addi	s0,sp,16
800030b0:	00300513          	li	a0,3
800030b4:	00003097          	auipc	ra,0x3
800030b8:	f4c080e7          	jalr	-180(ra) # 80006000 <wait_for_step>
800030bc:	01f00593          	li	a1,31
800030c0:	800067b7          	lui	a5,0x80006
800030c4:	1ec78513          	addi	a0,a5,492 # 800061ec <putChr+0xcc>
800030c8:	00003097          	auipc	ra,0x3
800030cc:	fe0080e7          	jalr	-32(ra) # 800060a8 <sendString>
800030d0:	00003097          	auipc	ra,0x3
800030d4:	f70080e7          	jalr	-144(ra) # 80006040 <advance_step>
800030d8:	0000006f          	j	800030d8 <core3_main_entry+0x38>

Disassembly of section .text.core4:

80004000 <_start_core4>:
80004000:	000070b3          	and	ra,zero,zero
80004004:	00007133          	and	sp,zero,zero
80004008:	000071b3          	and	gp,zero,zero
8000400c:	00007233          	and	tp,zero,zero
80004010:	000072b3          	and	t0,zero,zero
80004014:	00007333          	and	t1,zero,zero
80004018:	000073b3          	and	t2,zero,zero
8000401c:	00007433          	and	s0,zero,zero
80004020:	000074b3          	and	s1,zero,zero
80004024:	00007533          	and	a0,zero,zero
80004028:	000075b3          	and	a1,zero,zero
8000402c:	00007633          	and	a2,zero,zero
80004030:	000076b3          	and	a3,zero,zero
80004034:	00007733          	and	a4,zero,zero
80004038:	000077b3          	and	a5,zero,zero
8000403c:	00007833          	and	a6,zero,zero
80004040:	000078b3          	and	a7,zero,zero
80004044:	00007933          	and	s2,zero,zero
80004048:	000079b3          	and	s3,zero,zero
8000404c:	00007a33          	and	s4,zero,zero
80004050:	00007ab3          	and	s5,zero,zero
80004054:	00007b33          	and	s6,zero,zero
80004058:	00007bb3          	and	s7,zero,zero
8000405c:	00007c33          	and	s8,zero,zero
80004060:	00007cb3          	and	s9,zero,zero
80004064:	00007d33          	and	s10,zero,zero
80004068:	00007db3          	and	s11,zero,zero
8000406c:	00007e33          	and	t3,zero,zero
80004070:	00007eb3          	and	t4,zero,zero
80004074:	00007f33          	and	t5,zero,zero
80004078:	00007fb3          	and	t6,zero,zero
8000407c:	00001117          	auipc	sp,0x1
80004080:	42410113          	addi	sp,sp,1060 # 800054a0 <stack_end_core4>
80004084:	00002517          	auipc	a0,0x2
80004088:	81c50513          	addi	a0,a0,-2020 # 800058a0 <core4_main_entry>
8000408c:	000500e7          	jalr	a0
80004090:	05d00893          	li	a7,93
80004094:	020102b7          	lui	t0,0x2010
80004098:	f1402873          	csrr	a6,mhartid
8000409c:	0102a023          	sw	a6,0(t0) # 2010000 <SYSCALL_ADDR>

800040a0 <stack_begin>:
	...

800044a0 <stack_end_core0>:
	...

800048a0 <stack_end_core1>:
	...

80004ca0 <stack_end_core2>:
	...

800050a0 <stack_end_core3>:
	...

800054a0 <stack_end_core4>:
	...

800058a0 <core4_main_entry>:
800058a0:	ff010113          	addi	sp,sp,-16
800058a4:	00112623          	sw	ra,12(sp)
800058a8:	00812423          	sw	s0,8(sp)
800058ac:	01010413          	addi	s0,sp,16
800058b0:	00400513          	li	a0,4
800058b4:	00000097          	auipc	ra,0x0
800058b8:	74c080e7          	jalr	1868(ra) # 80006000 <wait_for_step>
800058bc:	01f00593          	li	a1,31
800058c0:	800067b7          	lui	a5,0x80006
800058c4:	20c78513          	addi	a0,a5,524 # 8000620c <putChr+0xec>
800058c8:	00000097          	auipc	ra,0x0
800058cc:	7e0080e7          	jalr	2016(ra) # 800060a8 <sendString>
800058d0:	00000097          	auipc	ra,0x0
800058d4:	770080e7          	jalr	1904(ra) # 80006040 <advance_step>
800058d8:	00000013          	nop
800058dc:	00c12083          	lw	ra,12(sp)
800058e0:	00812403          	lw	s0,8(sp)
800058e4:	01010113          	addi	sp,sp,16
800058e8:	00008067          	ret

Disassembly of section .text:

80006000 <wait_for_step>:
80006000:	fe010113          	addi	sp,sp,-32
80006004:	00112e23          	sw	ra,28(sp)
80006008:	00812c23          	sw	s0,24(sp)
8000600c:	02010413          	addi	s0,sp,32
80006010:	fea42623          	sw	a0,-20(s0)
80006014:	00000013          	nop
80006018:	800077b7          	lui	a5,0x80007
8000601c:	0287a783          	lw	a5,40(a5) # 80007028 <step>
80006020:	fec42703          	lw	a4,-20(s0)
80006024:	fef71ae3          	bne	a4,a5,80006018 <wait_for_step+0x18>
80006028:	00000013          	nop
8000602c:	00000013          	nop
80006030:	01c12083          	lw	ra,28(sp)
80006034:	01812403          	lw	s0,24(sp)
80006038:	02010113          	addi	sp,sp,32
8000603c:	00008067          	ret

80006040 <advance_step>:
80006040:	ff010113          	addi	sp,sp,-16
80006044:	00112623          	sw	ra,12(sp)
80006048:	00812423          	sw	s0,8(sp)
8000604c:	01010413          	addi	s0,sp,16
80006050:	800077b7          	lui	a5,0x80007
80006054:	0287a783          	lw	a5,40(a5) # 80007028 <step>
80006058:	00178713          	addi	a4,a5,1
8000605c:	800077b7          	lui	a5,0x80007
80006060:	02e7a423          	sw	a4,40(a5) # 80007028 <step>
80006064:	00000013          	nop
80006068:	00c12083          	lw	ra,12(sp)
8000606c:	00812403          	lw	s0,8(sp)
80006070:	01010113          	addi	sp,sp,16
80006074:	00008067          	ret

80006078 <main>:
80006078:	fe010113          	addi	sp,sp,-32
8000607c:	00112e23          	sw	ra,28(sp)
80006080:	00812c23          	sw	s0,24(sp)
80006084:	02010413          	addi	s0,sp,32
80006088:	fea42623          	sw	a0,-20(s0)
8000608c:	feb42423          	sw	a1,-24(s0)
80006090:	00000793          	li	a5,0
80006094:	00078513          	mv	a0,a5
80006098:	01c12083          	lw	ra,28(sp)
8000609c:	01812403          	lw	s0,24(sp)
800060a0:	02010113          	addi	sp,sp,32
800060a4:	00008067          	ret

800060a8 <sendString>:
800060a8:	fd010113          	addi	sp,sp,-48
800060ac:	02112623          	sw	ra,44(sp)
800060b0:	02812423          	sw	s0,40(sp)
800060b4:	03010413          	addi	s0,sp,48
800060b8:	fca42e23          	sw	a0,-36(s0)
800060bc:	fcb42c23          	sw	a1,-40(s0)
800060c0:	fd842783          	lw	a5,-40(s0)
800060c4:	fef42623          	sw	a5,-20(s0)
800060c8:	fdc42783          	lw	a5,-36(s0)
800060cc:	fef42423          	sw	a5,-24(s0)
800060d0:	0300006f          	j	80006100 <sendString+0x58>
800060d4:	fec42783          	lw	a5,-20(s0)
800060d8:	fff78793          	addi	a5,a5,-1
800060dc:	fef42623          	sw	a5,-20(s0)
800060e0:	fe842783          	lw	a5,-24(s0)
800060e4:	0007c783          	lbu	a5,0(a5)
800060e8:	00078513          	mv	a0,a5
800060ec:	00000097          	auipc	ra,0x0
800060f0:	034080e7          	jalr	52(ra) # 80006120 <putChr>
800060f4:	fe842783          	lw	a5,-24(s0)
800060f8:	00178793          	addi	a5,a5,1
800060fc:	fef42423          	sw	a5,-24(s0)
80006100:	fec42783          	lw	a5,-20(s0)
80006104:	fcf048e3          	bgtz	a5,800060d4 <sendString+0x2c>
80006108:	fd842783          	lw	a5,-40(s0)
8000610c:	00078513          	mv	a0,a5
80006110:	02c12083          	lw	ra,44(sp)
80006114:	02812403          	lw	s0,40(sp)
80006118:	03010113          	addi	sp,sp,48
8000611c:	00008067          	ret

80006120 <putChr>:
80006120:	fd010113          	addi	sp,sp,-48
80006124:	02112623          	sw	ra,44(sp)
80006128:	02812423          	sw	s0,40(sp)
8000612c:	03010413          	addi	s0,sp,48
80006130:	00050793          	mv	a5,a0
80006134:	fcf40fa3          	sb	a5,-33(s0)
80006138:	fe042623          	sw	zero,-20(s0)
8000613c:	800077b7          	lui	a5,0x80007
80006140:	0147a783          	lw	a5,20(a5) # 80007014 <UART_TX_DATA_ADDR>
80006144:	fdf44703          	lbu	a4,-33(s0)
80006148:	00e7a023          	sw	a4,0(a5)
8000614c:	800077b7          	lui	a5,0x80007
80006150:	0187a783          	lw	a5,24(a5) # 80007018 <UART_TX_CTRL_ADDR>
80006154:	00100713          	li	a4,1
80006158:	00e7a023          	sw	a4,0(a5)
8000615c:	800077b7          	lui	a5,0x80007
80006160:	0187a783          	lw	a5,24(a5) # 80007018 <UART_TX_CTRL_ADDR>
80006164:	0007a783          	lw	a5,0(a5)
80006168:	fef42623          	sw	a5,-20(s0)
8000616c:	00000013          	nop
80006170:	fec42783          	lw	a5,-20(s0)
80006174:	fe0784e3          	beqz	a5,8000615c <putChr+0x3c>
80006178:	00000013          	nop
8000617c:	02c12083          	lw	ra,44(sp)
80006180:	02812403          	lw	s0,40(sp)
80006184:	03010113          	addi	sp,sp,48
80006188:	00008067          	ret

Disassembly of section .rodata:

8000618c <.rodata>:
8000618c:	6548                	.insn	2, 0x6548
8000618e:	6c6c                	.insn	2, 0x6c6c
80006190:	52202c6f          	jal	s8,800086b2 <step+0x168a>
80006194:	5349                	.insn	2, 0x5349
80006196:	20562d43          	.insn	4, 0x20562d43
8000619a:	5056                	.insn	2, 0x5056
8000619c:	202c                	.insn	2, 0x202c
8000619e:	7962                	.insn	2, 0x7962
800061a0:	6320                	.insn	2, 0x6320
800061a2:	5b65726f          	jal	tp,8005d758 <step+0x56730>
800061a6:	5d30                	.insn	2, 0x5d30
800061a8:	0a21                	.insn	2, 0x0a21
800061aa:	0000                	.insn	2, 0x
800061ac:	6548                	.insn	2, 0x6548
800061ae:	6c6c                	.insn	2, 0x6c6c
800061b0:	52202c6f          	jal	s8,800086d2 <step+0x16aa>
800061b4:	5349                	.insn	2, 0x5349
800061b6:	20562d43          	.insn	4, 0x20562d43
800061ba:	5056                	.insn	2, 0x5056
800061bc:	202c                	.insn	2, 0x202c
800061be:	7962                	.insn	2, 0x7962
800061c0:	6320                	.insn	2, 0x6320
800061c2:	5b65726f          	jal	tp,8005d778 <step+0x56750>
800061c6:	5d31                	.insn	2, 0x5d31
800061c8:	0a21                	.insn	2, 0x0a21
800061ca:	0000                	.insn	2, 0x
800061cc:	6548                	.insn	2, 0x6548
800061ce:	6c6c                	.insn	2, 0x6c6c
800061d0:	52202c6f          	jal	s8,800086f2 <step+0x16ca>
800061d4:	5349                	.insn	2, 0x5349
800061d6:	20562d43          	.insn	4, 0x20562d43
800061da:	5056                	.insn	2, 0x5056
800061dc:	202c                	.insn	2, 0x202c
800061de:	7962                	.insn	2, 0x7962
800061e0:	6320                	.insn	2, 0x6320
800061e2:	5b65726f          	jal	tp,8005d798 <step+0x56770>
800061e6:	5d32                	.insn	2, 0x5d32
800061e8:	0a21                	.insn	2, 0x0a21
800061ea:	0000                	.insn	2, 0x
800061ec:	6548                	.insn	2, 0x6548
800061ee:	6c6c                	.insn	2, 0x6c6c
800061f0:	52202c6f          	jal	s8,80008712 <step+0x16ea>
800061f4:	5349                	.insn	2, 0x5349
800061f6:	20562d43          	.insn	4, 0x20562d43
800061fa:	5056                	.insn	2, 0x5056
800061fc:	202c                	.insn	2, 0x202c
800061fe:	7962                	.insn	2, 0x7962
80006200:	6320                	.insn	2, 0x6320
80006202:	5b65726f          	jal	tp,8005d7b8 <step+0x56790>
80006206:	0a215d33          	.insn	4, 0x0a215d33
8000620a:	0000                	.insn	2, 0x
8000620c:	6548                	.insn	2, 0x6548
8000620e:	6c6c                	.insn	2, 0x6c6c
80006210:	52202c6f          	jal	s8,80008732 <step+0x170a>
80006214:	5349                	.insn	2, 0x5349
80006216:	20562d43          	.insn	4, 0x20562d43
8000621a:	5056                	.insn	2, 0x5056
8000621c:	202c                	.insn	2, 0x202c
8000621e:	7962                	.insn	2, 0x7962
80006220:	6320                	.insn	2, 0x6320
80006222:	5b65726f          	jal	tp,8005d7d8 <step+0x567b0>
80006226:	5d34                	.insn	2, 0x5d34
80006228:	0a21                	.insn	2, 0x0a21
	...

Disassembly of section .sdata:

80007000 <UART_TX_DATA_ADDR>:
80007000:	0000                	.insn	2, 0x
80007002:	8200                	.insn	2, 0x8200

80007004 <UART_TX_CTRL_ADDR>:
80007004:	0004                	.insn	2, 0x0004
80007006:	8200                	.insn	2, 0x8200

80007008 <UART_RX_DATA_ADDR>:
80007008:	0008                	.insn	2, 0x0008
8000700a:	8200                	.insn	2, 0x8200

8000700c <MTIMECMP_REG>:
8000700c:	4000                	.insn	2, 0x4000
8000700e:	0200                	.insn	2, 0x0200

80007010 <MTIME_REG>:
80007010:	bff8                	.insn	2, 0xbff8
80007012:	0200                	.insn	2, 0x0200

80007014 <UART_TX_DATA_ADDR>:
80007014:	0000                	.insn	2, 0x
80007016:	8200                	.insn	2, 0x8200

80007018 <UART_TX_CTRL_ADDR>:
80007018:	0004                	.insn	2, 0x0004
8000701a:	8200                	.insn	2, 0x8200

8000701c <UART_RX_DATA_ADDR>:
8000701c:	0008                	.insn	2, 0x0008
8000701e:	8200                	.insn	2, 0x8200

80007020 <MTIMECMP_REG>:
80007020:	4000                	.insn	2, 0x4000
80007022:	0200                	.insn	2, 0x0200

80007024 <MTIME_REG>:
80007024:	bff8                	.insn	2, 0xbff8
80007026:	0200                	.insn	2, 0x0200

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1f41                	.insn	2, 0x1f41
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <SYSCALL_ADDR-0x200ffec>
   c:	0015                	.insn	2, 0x0015
   e:	0000                	.insn	2, 0x
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	0030                	.insn	2, 0x0030
  1c:	0108                	.insn	2, 0x0108
  1e:	0b0a                	.insn	2, 0x0b0a

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	36343067          	.insn	4, 0x36343067
   a:	3639                	.insn	2, 0x3639
   c:	6664                	.insn	2, 0x6664
   e:	3930                	.insn	2, 0x3930
  10:	2936                	.insn	2, 0x2936
  12:	3120                	.insn	2, 0x3120
  14:	2e34                	.insn	2, 0x2e34
  16:	2e32                	.insn	2, 0x2e32
  18:	0030                	.insn	2, 0x0030
