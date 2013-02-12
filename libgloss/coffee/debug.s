;;  show two digit hex number on seven segment display
.macro debug_disp number
	addi		r28, r28, -4
	st			r0, r28, 0
	lli			r0, \number
	movtc		1, r0, r0
	exbfi		r0, r0, 4, 4
	movtc		0, r0, r0
	ld			r0, r28, 0
	addi		r28, r28, 4
.endm

.macro debug_send_char char
	addi		r28, r28, -4
	st			r0, r28, 0
	addi		r28, r28, -4
	st			r1, r28, 0
	lli			r0, \char
	ldri		r1, 0x10000
	st			r0, r1, 7
	ld			r1, r28, 0
	addi		r28, r28, 4
	ld			r0, r28, 0
	addi		r28, r28, 4	
.endm

 