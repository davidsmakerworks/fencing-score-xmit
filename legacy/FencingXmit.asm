/*
 * FencingXmit.asm
 *
 * Interfaces with scoring box using nRF24L01+ transceiver module
 *
 * Configuration values are located at beginning of CSEG
 *
 * Set ATtiny2313 fuses:
 *
 * CKDIV8: disabled
 * SUT_CKSEL: INTRCOSC_4MHZ_14CK_65MS
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * 
 */ 

.include "tn2313def.inc"
.include "nRF24L01P.inc" 

/* Define pins for RF module functions */
.equ RF_CE = PORTD0
.equ RF_CSN = PORTD1
.equ RF_IRQ = PORTD2

/* 5-byte address length */
.equ ADDR_LEN = 0x05

.dseg
Channel:
	.byte 0x01

AddrS1:
	.byte 0x05
AddrS2:
	.byte 0x05
AddrM1:
	.byte 0x05
AddrM2:
	.byte 0x05

.cseg
.org 0x0000
	rjmp Reset

.org INT_VECTORS_SIZE

/* CONFIG STARTS HERE */

CHANNEL_PM: // Frequency = 2400 MHz + CHANNEL
	.db 0x0C,0x00

ADDR_S1_PM: // Strip box 1 address - MSByte first
	.db 0x50, 0x46, 0x46, 0x43, 0xAA, 0x00
ADDR_S2_PM: // Strip box 2 address - MSByte first
	.db 0x50, 0x46, 0x46, 0x43, 0xBB, 0x00
ADDR_M1_PM: // Mask 1 address - MSByte first
	.db 0x50, 0x46, 0x46, 0x43, 0xCC, 0x00
ADDR_M2_PM: // Mask 2 address - MSByte first
	.db 0x50, 0x46, 0x46, 0x43, 0xDD, 0x00

/* CONFIG ENDS HERE */

Reset:
	/* Initialize stack pointer */
	ldi r16, RAMEND
	out SPL, r16

	/* Set DO and SCK as outputs to RF module */
	ldi r16, (1<<PORTB7)|(1<<PORTB6)
	out DDRB, r16

	/* Set CE and CSN as outputs to RF module */
	ldi r16, (1<<PORTD0)|(1<<PORTD1)
	out DDRD, r16

	/* Get initial channel value from program memory and store it in RAM */
	ldi ZL, low(CHANNEL_PM<<1)
	ldi ZH, high(CHANNEL_PM<<1)
	ldi XL, low(Channel)
	ldi XH, high(Channel)
	lpm r16, Z
	st X, r16

	/* Get initial address values (5 bytes) from program memory and store it in RAM */
	/* Strip box 1*/
	ldi ZL, low(ADDR_S1_PM<<1)
	ldi ZH, high(ADDR_S1_PM<<1)
	ldi XL, low(AddrS1)
	ldi XH, high(AddrS1)
	rcall InitAddr

	/* Strip box 2 */
	ldi ZL, low(ADDR_S2_PM<<1)
	ldi ZH, high(ADDR_S2_PM<<1)
	ldi XL, low(AddrS2)
	ldi XH, high(AddrS2)
	rcall InitAddr

	/* Mask unit 1 */
	ldi ZL, low(ADDR_M1_PM<<1)
	ldi ZH, high(ADDR_M1_PM<<1)
	ldi XL, low(AddrM1)
	ldi XH, high(AddrM1)
	rcall InitAddr

	/* Mask unit 2 */
	ldi ZL, low(ADDR_M2_PM<<1)
	ldi ZH, high(ADDR_M2_PM<<1)
	ldi XL, low(AddrM2)
	ldi XH, high(AddrM2)
	rcall InitAddr

	sbi PORTD, RF_CSN
	cbi PORTD, RF_CE

	/* Set 500 uSec retry interval and 4 maximum retries */
	ldi r17, SETUP_RETR
	ldi r18, (ARD_500)|(ARC_4)
	rcall SetRegisterSingle

	/* Set RF power to 0 dBm and data rate to 1 mBit/sec */
	ldi r17, RF_SETUP
	ldi r18, RF_PWR_0DBM
	rcall SetRegisterSingle

	/* Set 5-byte address width */
	ldi r17, SETUP_AW
	ldi r18, AW_5
	rcall SetRegisterSingle

	/* Set initial RF channel */
	ldi r17, RF_CH
	ldi XH, high(Channel)
	ldi XL, low(Channel)
	ld r18, X
	rcall SetRegisterSingle

	/* Mask RX_DR interrupt on RF module, enable CRC, power up RF module in transmit-standby mode */
	ldi r17, CONFIG
	ldi r18, (1<<MASK_RX_DR)|(1<<EN_CRC)|(1<<PWR_UP)
	rcall SetRegisterSingle

	/* Clear any pending RF module interrupts */
	ldi r17, STATUS
	ldi r18, (1<<TX_DS)|(1<<MAX_RT)|(1<<RX_DR)
	rcall SetRegisterSingle

Loop:
	in r16, PINB
	andi r16, 0b00001111 // Discard unused input bits
	cp r16, r0
	breq Loop

	mov r0, r16

	ldi r16, FLUSH_TX
	rcall SendCommand

	ldi r17, STATUS
	ldi r18, (1<<TX_DS)|(1<<MAX_RT)
	rcall SetRegisterSingle	

	sbi PORTD, RF_CE

	ldi XL, low(AddrS1)
	ldi XH, high(AddrS1)
	rcall SetAddress
	mov r17, r0
	rcall TransmitPayload
Wait1:
	sbic PIND, RF_IRQ
	rjmp Wait1
	ldi r17, STATUS
	ldi r18, (1<<TX_DS)|(1<<MAX_RT)
	rcall SetRegisterSingle

	ldi XL, low(AddrS2)
	ldi XH, high(AddrS2)
	rcall SetAddress
	mov r17, r0
	rcall TransmitPayload

Wait2:
	sbic PIND, RF_IRQ
	rjmp Wait2
	ldi r17, STATUS
	ldi r18, (1<<TX_DS)|(1<<MAX_RT)
	rcall SetRegisterSingle

	ldi XL, low(AddrM1)
	ldi XH, high(AddrM1)
	rcall SetAddress
	mov r17, r0
	rcall TransmitPayload
Wait3:
	sbic PIND, RF_IRQ
	rjmp Wait3
	ldi r17, STATUS
	ldi r18, (1<<TX_DS)|(1<<MAX_RT)
	rcall SetRegisterSingle

	ldi XL, low(AddrM2)
	ldi XH, high(AddrM2)
	rcall SetAddress
	mov r17, r0
	rcall TransmitPayload
Wait4:
	sbic PIND, RF_IRQ
	rjmp Wait4
	ldi r17, STATUS
	ldi r18, (1<<TX_DS)|(1<<MAX_RT)
	rcall SetRegisterSingle

	cbi PORTD, RF_CE

	rjmp Loop

/* 
 * TransmitPayload
 *
 * Inputs:
 * 
 * r17 = payload byte to send
 *
 */

TransmitPayload:
	push r16
	cbi PORTD, RF_CSN
	ldi r16, W_TX_PAYLOAD
	rcall SPITransfer
	mov r16, r17
	rcall SPITransfer
	sbi PORTD, RF_CSN
	pop r16
	ret

/*
 * SendCommand
 *
 * Inputs:
 *
 * r16 = command byte to send
 *
 */

SendCommand:
	cbi PORTD, RF_CSN
	rcall SPITransfer
	sbi PORTD, RF_CSN
	ret

/*
 * SetAddress
 *
 * Inputs:
 *
 * r25 = number of address bytes
 * XH:XL = address of address bytes (MSByte first)
 *
 */

SetAddress:
	push XH
	push XL
	ldi r25, ADDR_LEN
	ldi r17, RX_ADDR_P0
	rcall SetRegisterMulti
	pop XL
	pop XH
	ldi r25, ADDR_LEN
	ldi r17, TX_ADDR
	rcall SetRegisterMulti
	ret

/*
 * SetRegisterSingle
 * 
 * Inputs:
 * 
 * r17 = register to set
 * r18 = desired register value (byte)
 *
 */

SetRegisterSingle:
	push r16
	cbi PORTD, RF_CSN
	ldi r16, W_REGISTER
	add r16, r17
	rcall SPITransfer
	mov r16, r18
	rcall SPITransfer
	sbi PORTD, RF_CSN
	pop r16
	ret

/*
 * SetRegisterMulti
 * 
 * Inputs:
 * 
 * r17 = register to set
 * r25 = number of bytes in register value
 * XH:XL = starting address of register value
 *
 */

SetRegisterMulti:
	push r16
	cbi PORTD, RF_CSN
	ldi r16, W_REGISTER
	add r16, r17
	rcall SPITransfer
	add XL, r25
SetLoop:
	ld r16, -X
	rcall SPITransfer
	dec r25
	brne SetLoop
	sbi PORTD, RF_CSN
	pop r16
	ret

/* 
 * GetRegisterSingle
 *
 * Inputs:
 * 
 * r17 = register to retrieve
 *
 * Outputs:
 *
 * r16 = register value (byte)
 *
 */

GetRegisterSingle:
	cbi PORTD, RF_CSN
	ldi r16, R_REGISTER
	add r16, r17
	rcall SPITransfer
	ldi r16, SPI_NOP
	rcall SPITransfer
	sbi PORTD, RF_CSN
	ret

/* 
 * SPITransfer
 *
 * Inputs:
 * 
 * r16 = data (byte) to transmit on SPI bus
 *
 * Outputs:
 *
 * r16 = data (byte) received from SPI bus
 *
 */
	
SPITransfer:
	out USIDR, r16
	ldi r16, (1<<USIOIF)
	out USISR, r16
	ldi r16, (1<<USIWM0)|(1<<USICS1)|(1<<USICLK)|(1<<USITC)
SPITransferLoop:
	out USICR, r16
	sbis USISR, USIOIF
	rjmp SPITransferLoop
	in r16, USIDR
	ret

InitAddr:
	push r16
	push r17
	ldi r17, ADDR_LEN
InitAddrLoop:
	lpm r16, Z+
	st X+, r16
	dec r17
	brne InitAddrLoop
	pop r17
	pop r16
	ret