	.include "hardware.s"
	.include "macro.s"
	.include "debug.s"
	
	
	.text
	;;.global _start
	.proc _start
	.global _start
	;; .code 32
_start:	
	jmp HW_INIT
	nop
	;**************************************************************************
	;* Global register aliases, CHECK COMPATIBILITY WITH COMPILER!!
	;**************************************************************************
	lr	= r31
	spsr	=r30
	psr	= r29
	sp	= r27 ;; stack pointer, 
	ra	= r28 ;; a register reserved for assembler only!
	
	;; parameter registers
	prm1	= r0
	prm2	= r1
	prm3	= r2
	prm4	= r3
	gr		= r4 ;; global
	;; return value
	rval	= r5


	;**************************************************************************
	;* Configuration
	;**************************************************************************

	;; 32 bit super user mode for all interrupt service routines
	ISR_MODE_IL = 0xfff 
	ISR_MODE_UM = 0x000
	USER_FLAGS = 0x19
	;; External interrupt sources
	;; EINT0	-	button SW0
	;; EINT1	-	button SW0
	;; EINT2	-	button SW0
	;; EINT3	-	button SW0
	;; EINT4	-	UART, RX ints
	;; EINT5	-	UART, TX ints
	;; EINT6	-	NoC interrupt
	;; EINT7	-	unused, associated to timer

	;; Allow timer, UART & button interrupts  EINT0...EINT7)
	;;INT_MASK	= 0xff0
	INT_MASK	= 0x730 ;; NO UART
	;;INT_MASK	= 0xff0 ;; 

	;; Interrupt priorities (0 - highest, 15 - lowest)
	;; NoC priority     = 0
	;; UART priority    = 1,2
	;; timer priority   = 3
	;; buttons priority = 4
	EINT_PRI    = 0x30214444
	;; Coprocessor interruts unused
	COP_INT_PRI = 0xFFFF

	;; The entire memory address space is protected from user code
	;; by default. Correct values depend on application
	;;DMEM_BOUND_LO   = 0x000030C0
	;;DMEM_BOUND_HI   = 0x0020000F
	;;DMEM_BOUND_LO   = 0x00000000
	IMEM_BOUND_LO   = 0x00100000	
	IMEM_BOUND_HI   = 0x001FFFFF
	MEM_CONF        = 0x2

	;; Zero wait cycles for coprocessor bus and the instruction memory
	;;two wait cycles for data memory
	WAIT_CYCLE_CONF = 0x000
	
	;; Default coprocessor interfacing mode (the only one supported)
	COP_IF_CONF     = 0x100

	;; Timer tick of 10ms at 50 MHz
	;; Timer interrupts enabled, timer0 associated to EXT_INT7
	;; continuous mode
	TIMER0_CONF  = 0xE700
	TMR0_MAX_CNT = 500000000
.endproc _start
	
;**************************************************************************
;* HARDWARE initialization at bootup
;**************************************************************************
.text
;; .code 32

					;; aliases for HW_INIT
					base	= r25
					data	= r24
					temp	= r23
					addr	= r22

				NOP
HW_INIT:			ldri	base, CCB_BASE_ADDR_BOOT
					ldri	data, CCB_BASE
					st		data, base, CCB_BASE_OFFST

					;; reload address after remap
					mov		base, data

					;; configure peripheral address space
					ldri	data, PCB_BASE
					st		data, base, PCB_BASE_OFFST
					ldri	data, PCB_END
					st		data, base, PCB_END_OFFST
					ldri	data, PCB_AMASK
					st		data, base, PCB_AMASK_OFFST

					;; Set interrupt vectors
					ldra	addr, COP0_ISR
					st		addr, base, COP0_INT_VEC_OFFST
					ldra	addr, COP1_ISR
					st		addr, base, COP1_INT_VEC_OFFST
					ldra	addr, COP2_ISR
					st		addr, base, COP2_INT_VEC_OFFST
					ldra	addr, COP3_ISR
					st		addr, base, COP3_INT_VEC_OFFST
					ldra	addr, EINT0_ISR
					st		addr, base, EXT_INT0_VEC_OFFST
					ldra	addr, EINT1_ISR
					st		addr, base, EXT_INT1_VEC_OFFST
					ldra	addr, EINT2_ISR
					st		addr, base, EXT_INT2_VEC_OFFST
					ldra	addr, EINT3_ISR
					st		addr, base, EXT_INT3_VEC_OFFST
					ldra	addr, EINT4_ISR
					st		addr, base, EXT_INT4_VEC_OFFST
					ldra	addr, EINT5_ISR
					st		addr, base, EXT_INT5_VEC_OFFST
					ldra	addr, EINT6_ISR
					st		addr, base, EXT_INT6_VEC_OFFST
					ldra	addr, EINT7_ISR
					st		addr, base, EXT_INT7_VEC_OFFST

					;; Interrupt configuration
					ldri	data, ISR_MODE_IL
					st		data, base, INT_MODE_IL_OFFST
					ldri	data, ISR_MODE_UM
					st		data, base, INT_MODE_UM_OFFST
					ldri	data, INT_MASK
					st		data, base, INT_MASK_OFFST
					ldri	data, EINT_PRI
					st		data, base, EXT_INT_PRI_OFFST
					ldri	data, COP_INT_PRI
					st		data, base, COP_INT_PRI_OFFST

					;; Memory and bus configuration
					ldra	data, DMEM_BOUND_LO
					st		data, base, DMEM_BOUND_LO_OFFST
					ldra	data, DMEM_BOUND_HI
					st		data, base, DMEM_BOUND_HI_OFFST
					ldri	data, IMEM_BOUND_LO
					st		data, base, IMEM_BOUND_LO_OFFST
					ldri	data, IMEM_BOUND_HI
					st		data, base, IMEM_BOUND_HI_OFFST
					ldri	data, MEM_CONF
					st		data, base, MEM_CONF_OFFST
					ldri	data, WAIT_CYCLE_CONF
					st		data, base, BUS_CONF_OFFST
					ldri	data, COP_IF_CONF
					st		data, base, COP_CONF_OFFST

					;; System entry addresses
					ldra	addr, SYSTEM_ADDR
					st	addr, base, SYSTEM_ADDR_OFFST
					ldra	addr, EHANDLER
					st	addr, base, EXCEP_ADDR_OFFST

					;; Configuration of timer0 (timer1 not used here)
					ldri	data, TMR0_MAX_CNT
					st	data, base, TMR0_MAX_CNT_OFFST
					lli	data, 0
					st	data, base, TMR0_CNT_OFFST
					lli	temp, TIMER0_CONF
					ld	data, base, TMR_CONF_OFFST
					conh	data, data, temp
					st	data, base, TMR_CONF_OFFST

					;; Finally start initialization for application
					jmp	START_APP
					xor	gr, gr, gr


;**************************************************************************
;* Default exception handler
;**************************************************************************
;* Blinks exception cause code on seven segment display. Leds are also
;* illuminated since remapping of CCB could prevent retrieval of exception
;* code.
;* Execution gets stuck here.
;**************************************************************************


					base		= r25
					lo			= r24
					hi			= r23
					blink		= r22
					temp		= r21
					delay_count	= r20
					ecode		= r19
					
					;; Approximate blinking rate of 1Hz at 50 MHz
					EH_LOOP_DELAY = 1562500

					;; defaults
EHANDLER:				ei
					lli		blink, 32 ;; enable blinking
					ldri	base, CCB_BASE

					;; If we can read base address then we probably
					;; hit CCB (cannot be 100% sure)
					ld		temp, base, 0
					cmp		c0, temp, base
					;; If CCB is remapped to unknown location, we cannot
					;; retrieve exception code => keep display blank
					beq		c0, blink_blink	;; replace if()
					nop
					xor		blink, blink, blink
blink_blink:	
					;; get exception code from CCB
					ld		ecode, base, EXCEPTION_CS_OFFST
					andi	lo, ecode, 0xf ;; extract lo part
					ori		lo, lo, 32 ;; set blank
					srli	hi, ecode, 4 ;; extract high part
					ori		hi, hi, 32 ;; set blank
					lli		temp, 0 ;; leds

eh_blink_loop:				ldri	delay_count, EH_LOOP_DELAY
					;; Update blank status to get blinking effect
					xor		lo, lo, blink
					xor		hi, hi, blink

					;; Write code to display (or blank display)
					movtc	SSEG_ONES, r0, lo
					movtc	SSEG_TENS, r0, hi
					;; Update leds also
					not		temp, temp
					movtc	LEDS, r0, temp

					;; Loop delay (could use timer, but CCB might be lost)
eh_delay_loop:				cmpi	c0, delay_count, 0
					bne		c0, eh_delay_loop
					addi	delay_count, delay_count, -1
					jmp		eh_blink_loop
					nop
;;					const char rVH[] ="3d VH!"



;**************************************************************************
;* Default system call handler, do nothing
;**************************************************************************

SYSTEM_ADDR:				chrs	2
					mov	prm1, prm1
					mov	prm2, prm2
					chrs	3
					cmpi	c0, prm1, SYSCAL_PRINT
					bne	c0, system_exit
					nop
					push	lr
					jal	bprint ; !!!
					mov	prm1, prm2
					ei
					;;jal	ttick_wait
					;;lli	prm1, 50
					pop	lr
	
system_exit:				retu
					nop

;**************************************************************************
;* Default interrupt service routines, code section
;**************************************************************************

COP0_ISR:			reti
					nop
					nop
					nop
COP1_ISR:			reti
					nop
					nop
					nop
COP2_ISR:			reti
					nop
					nop
					nop
COP3_ISR:			reti
					nop
					nop
					nop


;; Each button has a toggle bit which is inverted every time
;; the button is pressed (rising edge on button line)
;**************************************************************************
;* Interrupt service routine for external interrupt number 0
;* In this FPGA demo, push button SW0 is connected to interrupt line 0
;**************************************************************************

					addr	= r25
					bcount	= r24
					cvalues	= r23

EINT0_ISR:			push	addr
					push	bcount
					push	cvalues

					ldra	addr, BUTTON_STATUS
					ld		cvalues, addr, 0
					exb		bcount, cvalues, 0
					addiu	bcount, bcount, 1 ;; update press count
					andi	bcount, bcount, 0xff
					andi	cvalues, cvalues, 0xff
					or		cvalues, cvalues, bcount
					st		cvalues, addr, 0

					pop		cvalues
					pop		bcount
					pop		addr
					reti
					nop
					nop
					nop

;**************************************************************************
;* Interrupt service routine for external interrupt number 1
;* In this FPGA demo, push button SW1 is connected to interrupt line 1
;**************************************************************************

					addr	= r25
					bcount	= r24
					cvalues	= r23
					mask	= r22

EINT1_ISR:			push	addr
					push	bcount
					push	cvalues
					push	mask

					ldri	mask, 0x0000ff00
					ldra	addr, BUTTON_STATUS
					ld		cvalues, addr, 0
					exb		bcount, cvalues, 1
					addiu	bcount, bcount, 1 ;; update press count
					slli	bcount, bcount, 8
					and		bcount, bcount, mask
					not		mask, mask
					and		cvalues, cvalues, mask
					or		cvalues, cvalues, bcount
					st		cvalues, addr, 0

					pop		mask
					pop		cvalues
					pop		bcount
					pop		addr
					reti
					nop
					nop
					nop

;**************************************************************************
;* Interrupt service routine for external interrupt number 2
;* In this FPGA demo, push button SW2 is connected to interrupt line 2
;**************************************************************************

					addr	= r25
					bcount	= r24
					cvalues	= r23
					mask	= r22

EINT2_ISR:			push	addr
					push	bcount
					push	cvalues
					push	mask

					ldri	mask, 0x00ff0000
					ldra	addr, BUTTON_STATUS
					ld		cvalues, addr, 0
					exb		bcount, cvalues, 1
					addiu	bcount, bcount, 1 ;; update press count
					slli	bcount, bcount, 16
					and		bcount, bcount, mask
					not		mask, mask
					and		cvalues, cvalues, mask
					or		cvalues, cvalues, bcount
					st		cvalues, addr, 0

					pop		mask
					pop		cvalues
					pop		bcount
					pop		addr
					reti
					nop
					nop
					nop

;**************************************************************************
;* Interrupt service routine for external interrupt number 3
;* In this FPGA demo, push button SW3 is connected to interrupt line 3
;**************************************************************************

					addr	= r25
					bcount	= r24
					cvalues	= r23
					mask	= r22

EINT3_ISR:			push	addr
					push	bcount
					push	cvalues
					push	mask

					ldri	mask, 0xff000000
					ldra	addr, BUTTON_STATUS
					ld		cvalues, addr, 0
					exb		bcount, cvalues, 1
					addiu	bcount, bcount, 1 ;; update press count
					slli	bcount, bcount, 24
					and		bcount, bcount, mask
					not		mask, mask
					and		cvalues, cvalues, mask
					or		cvalues, cvalues, bcount
					st		cvalues, addr, 0

					pop		mask
					pop		cvalues
					pop		bcount
					pop		addr
					reti
					nop
					nop
					nop


;**************************************************************************
;* Interrupt service routine for external interrupt number 4
;* In this FPGA demo, used by UART receiver interrupt signal
;**************************************************************************
					ptr1	= r25
					base	= r24
					data	= r23
					indx	= r22
					temp	= r21
					ptr2	= r20

EINT4_ISR:			push	base
					push	data
					push	indx
					push	ptr1
					push	ptr2

					;; check from STATUS whether we have received data or not
					ldri	ptr1, UART_BASE
					ld		data, ptr1, UART_STATUS
					andi	data, data, UART_RX_FULL

					;; If the interrupt was caused by error or something else => ignore
					cmpi	c6, data, UART_RX_FULL
					bne		c6, EIH4_EXIT
					nop

					;; get received data from UART
					ld		data, ptr1, UART_RX_DATA

					;; get current head pointer
					ldra	ptr1, RX_HEAD_INDX
					ld		indx, ptr1, 0

					;; store data to input buffer
					ldra	ptr2, RX_BUFF
					addu	ptr2, ptr2, indx ;; indexed addressing
					st		data, ptr2, 0

					;; update and save head pointer
					addiu	indx, indx, 4
					andi	indx, indx, 0xfff ;; modulo 4096
					st		indx, ptr1, 0

					pop		ptr2
					pop		ptr1
EIH4_EXIT:			pop		indx
					pop		data
					pop		base
					reti
					nop
					nop
					nop

;**************************************************************************
;* Interrupt service routine for external interrupt number 5
;* In this FPGA demo, used by UART transmitter interrupt signal
;* NOTE: Transmitter errors are ignored...
;**************************************************************************

					base	= r25
					data	= r24

EINT5_ISR:			push	base
					push	data
					push	lr

					;; Check if transmitter is empty, ignore errors
					ldri	base, UART_BASE
					ld		data, base, UART_STATUS
					andi	data, data, UART_TX_EMPTY
					cmpi	c5, data, UART_TX_EMPTY
					ldra	base, sys_send_byte

					;; send (if outgoing bytes...)
					bne	c5, if1 ;; replace if()
					nop
					jalr	base
					nop

if1:					pop		lr
					pop		data
					pop		base
					reti
					nop
					nop
					nop

;**************************************************************************
;* Interrupt service routine for external interrupt number 6
;* In this FPGA demo, unused
;**************************************************************************

EINT6_ISR:			reti
					nop
					nop
					nop

;**************************************************************************
;* Interrupt service routine for external interrupt number 7
;* In this FPGA demo, EINT7 is associated with internal timer 0.
;**************************************************************************

					;; update system time
					base	= r25
					data	= r24

EINT7_ISR:			push	base
					push	data

					ldra	base, TIME_struct

					;; 10 ms
					ld		data, base, 0
					addiu	data, data, 1
					cmpi	c7, data, 100
					blt		c7, EIH7_EXIT ; replace if
					nop
					xor		data, data, data
					st		data, base, 0

					;; seconds
					ld		data, base, 4
					addiu	data, data, 1
					cmpi	c7, data, 60
					blt		c7, EIH7_EXIT ; replace if
					nop
					xor		data, data, data
					st		data, base, 4

					;; minutes
					ld		data, base, 8
					addiu	data, data, 1
					cmpi	c7, data, 60
					blt		c7, EIH7_EXIT ; replace if
					nop
					xor		data, data, data
					st		data, base, 8

					;; hours
					ld		data, base, 16
					addiu	data, data, 1
					cmpi	c7, data, 24
					blt		c7, if2; replace if
					nop
					xor	data, data, data
if2:					st	data, base, 16

EIH7_EXIT:				pop		data
					pop		base
					reti
					nop
					nop
					nop
					
					
					
					
;**************************************************************************
;* PROCEDURE
;**************************************************************************
;* NAME:		bprint
;* PARAMS:		prm1: pointer to start of string
;* NOTES:       Corrupts prm1 register. 
;*              No need to wait for UART since the string is placed in a
;*              buffer. The actual sending is done by interrupt routines.
;* DESCRIPTION: sends null terminated string to serial port. The string is
;*              expecteded to be a byte string (one byte per char).
;**************************************************************************

					base	= r25
					char	= r24
					dst		= r23
					indx	= r22
					temp	= r21
					
bprint:				push	base
					push	char
					push	dst
					push	indx
					push	lr
					push	temp

					;; get buffer pointer and index
					ldra	base, TX_BUFF
					ldra	indx, TX_HEAD_INDX
					ld		indx, indx, 0
					;; do modulo 4096 as a precaution
					;; cannot be sure about data initialization
					andi	indx, indx, 0x1ff
					;; Calculate destination by indexing
bprint_loop:		addu	dst, base, indx
					;; get a word from source buffer
					ld		char, prm1, 0
					;; extract a single byte according to address
					not		temp, prm1 ;; big endian!!
					andi	temp, temp, 3
					slli	temp, temp, 3
					srl		char, char, temp
					andi	char, char, 0xff
					st		char, dst, 0
					;; check for terminating zero
					cmpi	c4, char, 0
					beq		c4, bprint_exit
					nop
					;; increment buffer index (modulo 1024)
					addiu	indx, indx, 4
					andi	indx, indx, 0x1ff
					addiu	prm1, prm1, 1 ;; upd source ptr

					jmp		bprint_loop
					nop

					;; update head pointer
bprint_exit:		ldra	dst, TX_HEAD_INDX
					st		indx, dst, 0

					;; kick first out if needed
					ldri	base, UART_BASE
					ldra	dst, sys_send_byte
					ld		temp, base, UART_STATUS
					andi	temp, temp, UART_TX_EMPTY
					cmpi	c4, temp, UART_TX_EMPTY
					bne	c4, if4	; replace if
					nop
					jalr	dst
					nop
	
if4:					pop		temp
					pop		lr
					pop		indx
					pop		dst
					pop		char
					pop		base
					jmpr	lr
					nop

;**************************************************************************
;* Application init
;**************************************************************************
;**************************************************************************
					


START_APP:		
					ldra	sp, sys_stack	;; set stack pointer
					jal	UART_configuration
					nop
					nop
					ei		;; enable interrupts
					jmp	user_prog
					nop
	
;**************************************************************************
;* PROCEDURE
;**************************************************************************
;* NAME:		sys_send_byte
;* PARAMS:		none, uses global data
;* NOTES:		Should be used by system only! 
;*              Assumes that the transmitter is empty...
;* DESCRIPTION: writes a single byte to UART.
;**************************************************************************

					addr		= r25
					base		= r24
					data		= r23
					head		= r22
					head_indx	= r21
					tail		= r20
					tail_indx	= r19


sys_send_byte:		push	addr
					push	base
					push	data
					scon	data
					push	data
					push	head
					push	head_indx
					push	tail
					push	tail_indx

					ldra	head, TX_HEAD_INDX
					ldra	tail, TX_TAIL_INDX
					ldra	base, TX_BUFF
					;; Must use di/ei pair to prevent other instances
					;; of this procedure to corrupt values. 
					;; Safe IE flag status to c2
					andi	data, psr, PSR_IE
					cmpi	c2, data, PSR_IE
					;;di

					;; update ring buffer indexes. If head equals tail, there's
					;; nothing to be sent.
					ld		head_indx, head, 0
					ld		tail_indx, tail, 0
					addu	addr, base, tail_indx
					cmp		c1, head_indx, tail_indx
					beq	c1, if5	;  replace if
					nop
					addiu	tail_indx, tail_indx, 4
if5:					andi	tail_indx, tail_indx, 0xfff
					
		;; 					nop ;ATT!!!
					beq		c1, if6 ; replace if
					nop
					st		tail_indx, tail, 0
if6:					bne		c2, skip_ei
					ei		;; re-enable interrupts if they were enabled

skip_ei:				beq		c1, sys_send_byte_exit
					nop

					;; Get byte from buffer and send it to UART
					ld		data, addr, 0
					ldri	addr, UART_BASE
					st		data, addr, UART_TX_DATA

sys_send_byte_exit:	pop		tail_indx
					pop		tail
					pop		head_indx
					pop		head
					pop		data
					rcon	data
					pop		data
					pop		base
					pop		addr
					jmpr	lr
					nop


;**************************************************************************
;* PROCEDURE
;**************************************************************************
;* NAME:		UART_configuration
;* PARAMS:		none
;* NOTES:		
;* DESCRIPTION: 
;**************************************************************************
					;; UART settings
					;;UART_div	= 0b0000001101100011	;; 57600 bps@50MHz
					UART_div	= 0b0000001000001001	;; 57600 bps@30MHz
					UART_par	= 0b11					;; no parity
					UART_stop	= 0						;; a single stop bit
					UART_intm	= 0b0100010				;; interrupt when byte transmitted or received
					UART_dmam	= 0b0000				;; DMA features not used
					UART_endian	= 1						;; big endian (not relevant)
					UART_bmode	= 0						;; work in byte mode

					;; assembler does not support bit manipulation =>
					;; have to combine bitfield settings manually

					UART_CNFG_1	= 0b01000001000100110000001000001001
					;; bit 20 in 2nd configuration register enables UART
					UART_CNFG_2	= 0b100000000000000000000

					addr	= r25
					data	= r24

UART_configuration:			push	addr
					push	data

					ldri	addr, UART_BASE
					ldri	data, UART_CNFG_1
					st		data, addr, UART_CONFIG
					ldri	data, UART_CNFG_2
					st		data, addr, UART_CONFIG2
					xor		data, data, data
					st		data, addr, UART_STATUS

					pop		data
					pop		addr
					jmpr	lr
					nop


;IMEM_BOUND_LO:	 
user_prog:				ldri	spsr, USER_FLAGS
					;;ldra	sp, user_stack 
					ldra	lr, main 
					chrs	0
					;;ldri	sp, TOS_ADDR	;; set stack pointer
					ldra sp, user_stack 
					retu
					nop
					;;jal	main
					nop
					trap	5
	

.proc exit
.global exit
exit:
	jmp	exit
	nop
.endproc exit	

					
				

;**************************************************************************
;* BUTTON_STATUS:   button press counters, byte per button
;* TIME_struct:     integer 10ms, s, m, h;
;**************************************************************************
.data
.space 4096
user_stack:	.word 0
DMEM_BOUND_LO:	
bss_start:
BUTTON_STATUS:		.word 0xf
TIME_struct:		
TIME_struct_ms10:	.word 0
TIME_struct_sec:	.word 0
TIME_struct_min:	.word 0
TIME_struct_hour:	.word 0

TX_HEAD_INDX:		.word	0
TX_TAIL_INDX:		.word	0
RX_HEAD_INDX:		.word	0
RX_TAIL_INDX:		.word	0
TX_BUFF:			.space	512
RX_BUFF:			.space	512
			.space  1024
sys_stack:	.word 0
bss_end:
pd_lut:				.word	1
					.word	10
					.word	100
					.word	1000
					.word	10000
					.word	100000
					.word	1000000
					.word	10000000
					.word	100000000
					.word	1000000000


DMEM_BOUND_HI:	.word 0
.global shared_space
shared_space:.word 0
.space 96
