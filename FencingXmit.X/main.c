/*
 * Remote Fencing Score Display - Transmitter
 * Designed and implemented by David Rice
 *
 * Created on January 20, 2018, 6:22 PM
 * 
 * Designed for PIC16F18323 or PIC16F18325
 * 
 * Interfaces with nRF24L01+ 2.4 GHz RF module for transmission
 */

// PIC16F18323 Configuration Bit Settings

// 'C' source line config statements

// CONFIG1
#pragma config FEXTOSC = OFF    // FEXTOSC External Oscillator mode Selection bits (Oscillator not enabled)
#pragma config RSTOSC = HFINT1  // Power-up default value for COSC bits (HFINTOSC (1MHz))
#pragma config CLKOUTEN = OFF   // Clock Out Enable bit (CLKOUT function is disabled; I/O or oscillator function on OSC2)
#pragma config CSWEN = ON       // Clock Switch Enable bit (Writing to NOSC and NDIV is allowed)
#pragma config FCMEN = OFF      // Fail-Safe Clock Monitor Enable (Fail-Safe Clock Monitor is disabled)

// CONFIG2
#pragma config MCLRE = ON       // Master Clear Enable bit (MCLR/VPP pin function is MCLR; Weak pull-up enabled)
#pragma config PWRTE = ON       // Power-up Timer Enable bit (PWRT enabled)
#pragma config WDTE = OFF       // Watchdog Timer Enable bits (WDT disabled; SWDTEN is ignored)
#pragma config LPBOREN = OFF    // Low-power BOR enable bit (ULPBOR disabled)
#pragma config BOREN = ON       // Brown-out Reset Enable bits (Brown-out Reset enabled, SBOREN bit ignored)
#pragma config BORV = LOW       // Brown-out Reset Voltage selection bit (Brown-out voltage (Vbor) set to 2.45V)
#pragma config PPS1WAY = ON     // PPSLOCK bit One-Way Set Enable bit (The PPSLOCK bit can be cleared and set only once; PPS registers remain locked after one clear/set cycle)
#pragma config STVREN = ON      // Stack Overflow/Underflow Reset Enable bit (Stack Overflow or Underflow will cause a Reset)
#pragma config DEBUG = OFF      // Debugger enable bit (Background debugger disabled)

// CONFIG3
#pragma config WRT = OFF        // User NVM self-write protection bits (Write protection off)
#pragma config LVP = ON         // Low Voltage Programming Enable bit (Low Voltage programming enabled. MCLR/VPP pin function is MCLR. MCLRE configuration bit is ignored.)

// CONFIG4
#pragma config CP = OFF         // User NVM Program Memory Code Protection bit (User NVM code protection disabled)
#pragma config CPD = OFF        // Data NVM Memory Code Protection bit (Data NVM code protection disabled)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

#include "nRF24L01P.h"

/* CONFIGURABLE OPTIONS START HERE */
#define RF_CHANNEL      0x0CU
/* CONFIGURABLE OPTIONS END HERE */

#define _XTAL_FREQ      4000000

#define ADDR_LEN        5
#define PAYLOAD_WIDTH   1

#define LEFT_RED_MASK       0b00110000
#define RIGHT_GREEN_MASK    0b00001100
#define LEFT_WHITE_MASK     0b11000000
#define RIGHT_WHITE_MASK    0b00000011

#define LEFT_RED_ON     PORTAbits.RA0
#define RIGHT_GREEN_ON  PORTAbits.RA1
#define LEFT_WHITE_ON   PORTAbits.RA2
#define RIGHT_WHITE_ON  PORTAbits.RA4

const uint8_t strip1_addr[ADDR_LEN] = { 0x50, 0x46, 0x46, 0x43, 0xAA };
const uint8_t strip2_addr[ADDR_LEN] = { 0x50, 0x46, 0x46, 0x43, 0xBB };
const uint8_t mask1_addr[ADDR_LEN] = { 0x50, 0x46, 0x46, 0x43, 0xCC };
const uint8_t mask2_addr[ADDR_LEN] = { 0x50, 0x46, 0x46, 0x43, 0xDD };

uint8_t transfer_spi(uint8_t data) {
    SSP1BUF = data;
    
    while (!SSP1STATbits.BF);
    
    data = SSP1BUF;
    
    return data;
}

void init_ports(void) {
    /* Disable all analog features */
    ANSELA = 0x00;
    ANSELC = 0x00;
     
    /* Initialize PORTA inputs on RA0, RA1, RA2, RA4 */
    TRISA = _TRISA_TRISA0_MASK | _TRISA_TRISA1_MASK | _TRISA_TRISA2_MASK | _TRISA_TRISA4_MASK;
    
    /* Initialize all ports as outputs except RC1 (SDI) and RC5 (RF_IRQ) */
    TRISC = _TRISC_TRISC1_MASK | _TRISC_TRISC5_MASK;
    
    /* Pull all outputs low except RC3 (RF_CSN) */
    LATA = 0x00;
    LATC = _LATC_LATC3_MASK;
    
    /* Set TTL input level on RC1 (SDI1) and RC5 (RF_IRQ) */
    INLVLCbits.INLVLC1 = 0;
    INLVLCbits.INLVLC5 = 0;
}

void init_osc(void) {
    /* Set frequency of HFINTOSC to 4 MHz */
    OSCFRQbits.HFFRQ = 0b0011;
    
    /* Set clock divider to 1:1 to achieve Fosc of 4 MHz */
    OSCCON1bits.NDIV = 0b0000;
}

void init_spi(void) {
    /* Set MSSP1 to SPI Master mode, clock = Fosc / 4 = 1 MHz at Fosc = 4 MHz */
    SSP1CON1bits.SSPM = 0b0000;
    
    /* Transmit data on active-to-idle transition */
    SSP1STATbits.CKE = 1;
    
    /* Enable MSSP1 */
    SSP1CON1bits.SSPEN = 1;
}

void init_pps(void) {
    bool state;
    
    /* Preserve global interrupt state and disable interrupts */
    state = INTCONbits.GIE;
    INTCONbits.GIE = 0;
    
    /* Unlock PPS */
    PPSLOCK = 0x55;
    PPSLOCK = 0xAA;
    PPSLOCKbits.PPSLOCKED = 0;
    
    /* SCK1 on RC0 */
    RC0PPS = 0b11000;
    
    /* SDI1 on RC1 */
    SSP1DATPPS = 0b10001;
    
    /* SDO1 on RC2 */
    RC2PPS = 0b11001;
    
    /* Lock PPS */
    PPSLOCK = 0x55;
    PPSLOCK = 0xAA;
    PPSLOCKbits.PPSLOCKED = 1;
    
    /* Restore global interrupt state */
    INTCONbits.GIE = state;
}

void init_interrupts(void) {
    /* Interrupt on falling edge of external interrupt pin */
    INTCONbits.INTEDG = 0;
    
    /* Interrupt on change of scoring light pins (RA0 - RA2, RA4) */
    IOCAPbits.IOCAP0 = 1;
    IOCANbits.IOCAN0 = 1;
    
    IOCAPbits.IOCAP1 = 1;
    IOCANbits.IOCAN1 = 1;
    
    IOCAPbits.IOCAP2 = 1;
    IOCANbits.IOCAN2 = 1;
    
    IOCAPbits.IOCAP4 = 1;
    IOCANbits.IOCAN4 = 1;
    
    /* Enable IOC interrupt */
    PIE0bits.IOCIE = 1;
}

void init_rf(void) {
    /* Allow for maximum possible RF module startup time */
    __delay_ms(100);
    
    /* Set 500 uSec retry interval and 4 maximum retries */
    nrf24_write_register(NRF24_SETUP_RETR, NRF24_ARD_500 | NRF24_ARC_4);
    
    /* Set RF power to 0 dBm and data rate to 1 Mbit/Sec */
    nrf24_write_register(NRF24_RF_SETUP, NRF24_RF_PWR_0DBM);
    
    /* Set 5-byte address width */
    nrf24_write_register(NRF24_SETUP_AW, NRF24_AW_5);
    
    /* Set initial RF channel */
    nrf24_write_register(NRF24_RF_CH, RF_CHANNEL);
    
    /* Mask RX_DR interrupt on RF module, enable CRC, power up RF module in transmit-standby mode */
    nrf24_write_register(NRF24_CONFIG, NRF24_MASK_RX_DR | NRF24_EN_CRC | NRF24_PWR_UP);
    
    /* Clear any pending RF module interrupts */
    nrf24_write_register(NRF24_STATUS, NRF24_TX_DS | NRF24_MAX_RT | NRF24_RX_DR);
}

/* 
 * Sets RF module address and sends packet to specified address
 * 
 * Blocks until packet is acknowledged or until max retries are exceeded
 */
void send_packet(uint8_t *addr, uint8_t *buf, uint8_t len)
{
    nrf24_write_register_multi(NRF24_RX_ADDR_P0, addr, ADDR_LEN);
    nrf24_write_register_multi(NRF24_TX_ADDR, addr, ADDR_LEN);
    
    nrf24_flush_tx();
    nrf24_write_payload(buf, len);

    /* Strobe RF CE line to send one packet of data */
    NRF24_CE = 1;
    __delay_us(15);
    NRF24_CE = 0;

    while (NRF24_IRQ);

    nrf24_write_register(NRF24_STATUS, NRF24_TX_DS | NRF24_MAX_RT);
}

void main(void) {
    uint8_t buf;
    
    /* Initialize peripherals */
    init_ports();
    init_osc();
    init_spi();
    init_pps();
    init_interrupts();
    init_rf();
    
    while(1) {     
        SLEEP();
        
        IOCAF = 0x00;
        buf = 0x00;

        if (LEFT_RED_ON) {
            buf |= LEFT_RED_MASK;
        }

        if (RIGHT_GREEN_ON) {
            buf |= RIGHT_GREEN_MASK;
        }

        if (LEFT_WHITE_ON) {
            buf |= LEFT_WHITE_MASK;
        }

        if (RIGHT_WHITE_ON) {
            buf |= RIGHT_WHITE_MASK;
        }

        send_packet(strip1_addr, &buf, PAYLOAD_WIDTH);
        send_packet(strip2_addr, &buf, PAYLOAD_WIDTH);
        send_packet(mask1_addr, &buf, PAYLOAD_WIDTH);
        send_packet(mask2_addr, &buf, PAYLOAD_WIDTH);
    }
}
