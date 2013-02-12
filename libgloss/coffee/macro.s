reserved = r26
sp       = r28
prm1     = r0
prm2     = r1
;; replaced sp identifier with r27

.macro	push rname
	addi r27, r27, -4
	st \rname, r27, 0
	.endm

.macro	pop rname
	ld \rname, r27, 0
	addi r27, r27, 4
.endm

.macro	halt
	jmp		-4
	nop
.endm


	SYSCAL_PRINT = 0
	
.macro debug_msg label
	addi r27, r27, -4
	st   r1, r27, 0
	addi r27, r27, -4
	st   r0, r27, 0
	xor  r0, r0, r0
	ldra r1, \label
	scall
	nop
	ld   r0, r27, 0
	addi r27, r27, 4
	ld   r1, r27, 0
	addi r27, r27, 4	
.endm

;; also stack pointer is placed on stack!!
.macro	pusha 
	addi r27, r27, -128
	st r0, r27, 4
	st r1, r27, 8
	st r2, r27, 12
	st r3, r27, 16
	st r4, r27, 20
	st r5, r27, 24
	st r6, r27, 28
	st r7, r27, 32
	st r8, r27, 36
	st r9, r27, 40
	st r10, r27, 44
	st r11, r27, 48
	st r12, r27, 52
	st r13, r27, 56
	st r14, r27, 60
	st r15, r27, 64
	st r16, r27, 68
	st r17, r27, 72
	st r18, r27, 76
	st r19, r27, 80
	st r20, r27, 84
	st r21, r27, 88
	st r22, r27, 92
	st r23, r27, 96
	st r24, r27, 100
	st r25, r27, 104
	st r26, r27, 108
	st r27, r27, 112
	st r27, r27, 116
	st r29, r27, 120
	st r30, r27, 124
	st r31, r27, 128
.endm

.macro	popa
	ld r0, r27, 4
	ld r1, r27, 8
	ld r2, r27, 12
	ld r3, r27, 16
	ld r4, r27, 20
	ld r5, r27, 24
	ld r6, r27, 28
	ld r7, r27, 32
	ld r8, r27, 36
	ld r9, r27, 40
	ld r10, r27, 44
	ld r11, r27, 48
	ld r12, r27, 52
	ld r13, r27, 56
	ld r14, r27, 60
	ld r15, r27, 64
	ld r16, r27, 68
	ld r17, r27, 72
	ld r18, r27, 76
	ld r19, r27, 80
	ld r20, r27, 84
	ld r21, r27, 88
	ld r22, r27, 92
	ld r23, r27, 96
	ld r24, r27, 100
	ld r25, r27, 104
	ld r26, r27, 108
	ld r27, r27, 112
	ld r27, r27, 116
	ld r29, r27, 120
	ld r30, r27, 124
	ld r31, r27, 128
	addi r27, r27, 128
.endm


