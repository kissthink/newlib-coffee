	;**************************************************************************
	;* Memory map of COFFEE core
	;* NOTES:
	;*        This memory map concerns only addresses seen by the programmer 
	;*        when accessing shared data bus (using ld and st instructions).
	;*        In reality both memories (instruction and data) have independent
	;*        address spaces (separate buses). Software should be linked
	;*        accordingly, i.e. to independent address spaces both starting
	;*        from address zero.
	;**************************************************************************
	 DMEM_START		= 0x000000
	 DMEM_END		= 0x01FFFF
	 CCB_BASE		= 0x040000
	 IMEM_START		= 0x100000
	 IMEM_END		= 0x11FFFF 
	 UART_BASE		= 0x200000
	 UART_END		= 0x20000F
	 CODEC_BASE             = 0x380000
	 TBINT_BASE             = 0x3C0000
	 VGA_BASE		= 0x300000
	 VGA_END		= 0x37FFFF
	 TB_BASE		= 0x400000
	 TB_END		        = 0x47FFFF
	 BUTTER_BASE		= 0x500000
	 BUTTER_END		= 0x57FFFF

	 ;; peripheral devices and instruction memory are accessed via PCB space
	 PCB_BASE		= 0x00100000
	 PCB_END		= 0x9FFFFFFF
	 PCB_AMASK		= 0xFFFFFFFF ;; 22 bits driven to bus

	;--------------------------------------------------------------------------
	;| Memory device address space seen by DMA UART and network interface
	;--------------------------------------------------------------------------
	;--------------------------------------------------------------------------
	;| segments in data memory
	;--------------------------------------------------------------------------
	 TOS_ADDR = 0x30DF 	; 0x3FFFF
	 
	;--------------------------------------------------------------------------
	;| Coprocessor IDs (devices on coprocessor bus)
	;--------------------------------------------------------------------------

	 SSEG_TENS    = 0
	 SSEG_ONES    = 2
	 MILK_ID      = 1
	 LEDS         = 3
	 VGAIF        = 3  ; old
	;**************************************************************************
	;* I/O device constants
	;**************************************************************************
	;--------------------------------------------------------------------------
	;| VGA driver (accessed as coprocessor 2)
	;--------------------------------------------------------------------------
   	RD_DATA = r0
	WR_DATA = r1
	WR_ADDR = r2
	RD_ADDR = r3
	COLOR_M = r4

	PIXELS_PER_ROW	= 320
	PIXELS_PER_COL	= 240
	LAYER1		= 1
	LAYER2		= 2
	LAYER3		= 3

	;--------------------------------------------------------------------------
	;| DMA UART (Connected to peripheral bus)
	;--------------------------------------------------------------------------

	UART_CONFIG		= 0
	UART_CONFIG2	= 1
	UART_IBUFF_PTR	= 2
	UART_IBUFF_BEG	= 3
	UART_IBUFF_END	= 4
	UART_IBUFF_LIM	= 5
	UART_TBUFF_PTR	= 6
	UART_TX_DATA	= 7
	UART_RX_DATA	= 8
	UART_STATUS		= 9
	;--------------------------------------------------------------------------
	;| DMA UART status flags
	;--------------------------------------------------------------------------
	UART_TX_EMPTY	= 1
	UART_RX_FULL	= 2
	UART_PR_ERR		= 4
	UART_OR_ERR_RX	= 8
	UART_OR_ERR_TX	= 16

	;**************************************************************************
	;* Core Configuration Block base address and register offsets
	;**************************************************************************

	CCB_BASE_ADDR_BOOT  = 0x00010000
	CCB_BASE_OFFST		= 0
	PCB_BASE_OFFST		= 1
	PCB_END_OFFST		= 2
	PCB_AMASK_OFFST		= 3
	COP0_INT_VEC_OFFST	= 4
	COP1_INT_VEC_OFFST	= 5
	COP2_INT_VEC_OFFST	= 6
	COP3_INT_VEC_OFFST	= 7
	EXT_INT0_VEC_OFFST	= 8
	EXT_INT1_VEC_OFFST	= 9
	EXT_INT2_VEC_OFFST	= 10
	EXT_INT3_VEC_OFFST	= 11
	EXT_INT4_VEC_OFFST	= 12
	EXT_INT5_VEC_OFFST	= 13
	EXT_INT6_VEC_OFFST	= 14
	EXT_INT7_VEC_OFFST	= 15
	INT_MODE_IL_OFFST	= 16
	INT_MODE_UM_OFFST	= 17
	INT_MASK_OFFST		= 18
	INT_SERV_OFFST		= 19
	INT_PEND_OFFST		= 20
	EXT_INT_PRI_OFFST	= 21
	COP_INT_PRI_OFFST	= 22
	EXCEPTION_CS_OFFST	= 23
	EXCEPTION_PC_OFFST	= 24
	EXCEPTION_PSR_OFFST	= 25
	DMEM_BOUND_LO_OFFST	= 26
	DMEM_BOUND_HI_OFFST	= 27
	IMEM_BOUND_LO_OFFST	= 28
	IMEM_BOUND_HI_OFFST	= 29
	MEM_CONF_OFFST		= 30
	SYSTEM_ADDR_OFFST	= 31
	EXCEP_ADDR_OFFST	= 32
	BUS_CONF_OFFST		= 33
	COP_CONF_OFFST		= 34
	TMR0_CNT_OFFST		= 35
	TMR0_MAX_CNT_OFFST	= 36
	TMR1_CNT_OFFST		= 37
	TMR1_MAX_CNT_OFFST	= 38
	TMR_CONF_OFFST		= 39
	RETI_ADDR_OFFST		= 40
	RETI_PSR_OFFST		= 41
	RETI_CR0_OFFST		= 42
	CORE_VER_ID_OFFST   = 255

	;**************************************************************************
	;* Processor status register
	;**************************************************************************
	PSR_IE		= 16
	PSR_IL		= 8
	PSR_RSWR	= 4
	PSR_RSRD	= 2
	PSR_UM		= 1
