EESchema Schematic File Version 4
LIBS:FencingScoreXmit-cache
EELAYER 29 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title "Wireless Fencing Score Indicator - Transmitter"
Date "2018-02-13"
Rev "1"
Comp "David Rice"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L FencingScoreXmit-rescue:PIC16F18323-I_JQ IC1
U 1 1 5A834A3D
P 4500 5100
F 0 "IC1" H 4550 4000 60  0000 C CNN
F 1 "PIC16F18323-I/JQ" V 4500 5100 60  0000 C CNN
F 2 "Housings_DFN_QFN:QFN-16-1EP_4x4mm_Pitch0.65mm" H 4550 4400 60  0001 C CNN
F 3 "" H 4550 4400 60  0000 C CNN
	1    4500 5100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 5A834A90
P 5300 1500
F 0 "C2" H 5325 1600 50  0000 L CNN
F 1 "1uF" H 5325 1400 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 5338 1350 50  0001 C CNN
F 3 "" H 5300 1500 50  0001 C CNN
	1    5300 1500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5A834BCF
P 3000 1500
F 0 "C1" H 3025 1600 50  0000 L CNN
F 1 "10uF" H 3025 1400 50  0000 L CNN
F 2 "Capacitors_SMD:C_0805" H 3038 1350 50  0001 C CNN
F 3 "" H 3000 1500 50  0001 C CNN
	1    3000 1500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5A834C67
P 3450 4600
F 0 "R1" V 3530 4600 50  0000 C CNN
F 1 "10K" V 3450 4600 50  0000 C CNN
F 2 "Resistors_SMD:R_0805" V 3380 4600 50  0001 C CNN
F 3 "" H 3450 4600 50  0001 C CNN
	1    3450 4600
	0    1    1    0   
$EndComp
$Comp
L FencingScoreXmit-rescue:MCP1824S33_DB U1
U 1 1 5A834FFF
P 4150 1350
F 0 "U1" H 4150 1650 60  0000 C CNN
F 1 "MCP1824S33/DB" H 4150 1450 60  0000 C CNN
F 2 "TO_SOT_Packages_SMD:SOT-223" H 4150 1350 60  0001 C CNN
F 3 "" H 4150 1350 60  0000 C CNN
	1    4150 1350
	1    0    0    -1  
$EndComp
$Comp
L FencingScoreXmit-rescue:nRF24L01+-MOD-DavidsMakerWorks_Custom RF1
U 1 1 5A835277
P 7750 5400
F 0 "RF1" H 7750 4700 60  0000 C CNN
F 1 "nRF24L01+-MOD" H 7750 5400 60  0000 C CNN
F 2 "DavidsMakerWorks_Custom:nRF24L01+-Module" H 7750 5400 60  0001 C CNN
F 3 "" H 7750 5400 60  0000 C CNN
	1    7750 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 5A8352E2
P 3150 5100
F 0 "C3" H 3175 5200 50  0000 L CNN
F 1 "0.1uF" H 3175 5000 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 3188 4950 50  0001 C CNN
F 3 "" H 3150 5100 50  0001 C CNN
	1    3150 5100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5A83533C
P 6700 5400
F 0 "C4" H 6725 5500 50  0000 L CNN
F 1 "0.1uF" H 6725 5300 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 6738 5250 50  0001 C CNN
F 3 "" H 6700 5400 50  0001 C CNN
	1    6700 5400
	1    0    0    -1  
$EndComp
$Comp
L FencingScoreXmit-rescue:Conn_01x02 J1
U 1 1 5A835414
P 1800 1300
F 0 "J1" H 1800 1400 50  0000 C CNN
F 1 "PWR_IN" H 1800 1100 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02_Pitch2.54mm" H 1800 1300 50  0001 C CNN
F 3 "" H 1800 1300 50  0001 C CNN
	1    1800 1300
	1    0    0    -1  
$EndComp
$Comp
L FencingScoreXmit-rescue:Conn_01x04 J2
U 1 1 5A835475
P 5850 4500
F 0 "J2" H 5850 4700 50  0000 C CNN
F 1 "SCORE_MACH" H 5850 4200 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x04_Pitch2.54mm" H 5850 4500 50  0001 C CNN
F 3 "" H 5850 4500 50  0001 C CNN
	1    5850 4500
	1    0    0    -1  
$EndComp
$Comp
L FencingScoreXmit-rescue:Conn_01x06 J3
U 1 1 5A8354CA
P 7700 2650
F 0 "J3" H 7700 2950 50  0000 C CNN
F 1 "ICSP" H 7700 2250 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x06_Pitch2.54mm" H 7700 2650 50  0001 C CNN
F 3 "" H 7700 2650 50  0001 C CNN
	1    7700 2650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 5A83561D
P 1350 1050
F 0 "#PWR01" H 1350 900 50  0001 C CNN
F 1 "+5V" H 1350 1190 50  0000 C CNN
F 2 "" H 1350 1050 50  0001 C CNN
F 3 "" H 1350 1050 50  0001 C CNN
	1    1350 1050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 5A835647
P 1350 1650
F 0 "#PWR02" H 1350 1400 50  0001 C CNN
F 1 "GND" H 1350 1500 50  0000 C CNN
F 2 "" H 1350 1650 50  0001 C CNN
F 3 "" H 1350 1650 50  0001 C CNN
	1    1350 1650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 5A837C2E
P 4150 2050
F 0 "#PWR03" H 4150 1800 50  0001 C CNN
F 1 "GND" H 4150 1900 50  0000 C CNN
F 2 "" H 4150 2050 50  0001 C CNN
F 3 "" H 4150 2050 50  0001 C CNN
	1    4150 2050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR04
U 1 1 5A837C5A
P 3000 1050
F 0 "#PWR04" H 3000 900 50  0001 C CNN
F 1 "+5V" H 3000 1190 50  0000 C CNN
F 2 "" H 3000 1050 50  0001 C CNN
F 3 "" H 3000 1050 50  0001 C CNN
	1    3000 1050
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR05
U 1 1 5A837CFB
P 5300 1050
F 0 "#PWR05" H 5300 900 50  0001 C CNN
F 1 "+3.3V" H 5300 1190 50  0000 C CNN
F 2 "" H 5300 1050 50  0001 C CNN
F 3 "" H 5300 1050 50  0001 C CNN
	1    5300 1050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR06
U 1 1 5A838DDB
P 3150 4050
F 0 "#PWR06" H 3150 3900 50  0001 C CNN
F 1 "+5V" H 3150 4190 50  0000 C CNN
F 2 "" H 3150 4050 50  0001 C CNN
F 3 "" H 3150 4050 50  0001 C CNN
	1    3150 4050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 5A838F6E
P 6700 6100
F 0 "#PWR07" H 6700 5850 50  0001 C CNN
F 1 "GND" H 6700 5950 50  0000 C CNN
F 2 "" H 6700 6100 50  0001 C CNN
F 3 "" H 6700 6100 50  0001 C CNN
	1    6700 6100
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR08
U 1 1 5A83900F
P 6700 4600
F 0 "#PWR08" H 6700 4450 50  0001 C CNN
F 1 "+3.3V" H 6700 4740 50  0000 C CNN
F 2 "" H 6700 4600 50  0001 C CNN
F 3 "" H 6700 4600 50  0001 C CNN
	1    6700 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 1300 1350 1300
Wire Wire Line
	1350 1300 1350 1050
Wire Wire Line
	1600 1400 1350 1400
Wire Wire Line
	1350 1400 1350 1650
Wire Wire Line
	3000 1350 3350 1350
Wire Wire Line
	5300 1350 4950 1350
Wire Wire Line
	3000 1050 3000 1350
Wire Wire Line
	3000 1650 3000 1900
Wire Wire Line
	3000 1900 4150 1900
Wire Wire Line
	4150 1750 4150 1900
Wire Wire Line
	5300 1900 5300 1650
Connection ~ 4150 1900
Wire Wire Line
	5300 1050 5300 1350
Wire Wire Line
	3700 4400 3150 4400
Wire Wire Line
	3150 4050 3150 4400
Wire Wire Line
	3150 5250 3150 5900
Wire Wire Line
	3150 5900 3700 5900
Wire Wire Line
	5300 4400 5400 4400
Wire Wire Line
	5300 4500 5500 4500
Wire Wire Line
	5300 4600 5650 4600
Wire Wire Line
	5300 4700 5650 4700
Wire Wire Line
	5300 5400 6200 5400
Wire Wire Line
	6200 5400 6200 5600
Wire Wire Line
	6200 5600 6900 5600
Wire Wire Line
	5300 5600 6100 5600
Wire Wire Line
	6100 5600 6100 5700
Wire Wire Line
	6100 5700 6900 5700
Wire Wire Line
	5300 5700 5950 5700
Wire Wire Line
	5950 5700 5950 5200
Wire Wire Line
	5950 5200 6900 5200
Wire Wire Line
	5300 5800 5850 5800
Wire Wire Line
	5850 5800 5850 5100
Wire Wire Line
	5850 5100 6900 5100
Wire Wire Line
	5300 5900 5850 5900
Wire Wire Line
	5850 5900 5850 6300
Wire Wire Line
	5850 6300 8900 6300
Wire Wire Line
	8900 6300 8900 5900
Wire Wire Line
	8900 5900 8550 5900
Wire Wire Line
	5300 5500 5750 5500
Wire Wire Line
	5750 5500 5750 4900
Wire Wire Line
	5750 4900 6400 4900
Wire Wire Line
	6400 4900 6400 4400
Wire Wire Line
	6400 4400 8800 4400
Wire Wire Line
	8800 4400 8800 4900
Wire Wire Line
	8800 4900 8550 4900
Wire Wire Line
	3700 4600 3650 4600
Wire Wire Line
	3300 4600 3150 4600
Connection ~ 3150 4600
Connection ~ 3150 4400
Wire Wire Line
	6900 5900 6700 5900
Wire Wire Line
	6700 5550 6700 5900
Connection ~ 6700 5900
Wire Wire Line
	6700 5250 6700 4900
Wire Wire Line
	6900 4900 6700 4900
Connection ~ 6700 4900
Wire Wire Line
	7500 2450 3650 2450
Wire Wire Line
	3650 2450 3650 4600
Connection ~ 3650 4600
Wire Wire Line
	7500 2550 7100 2550
Wire Wire Line
	7100 2550 7100 2100
Wire Wire Line
	7500 2650 7100 2650
Wire Wire Line
	7100 2650 7100 3400
Wire Wire Line
	7500 2750 5400 2750
Wire Wire Line
	5400 2750 5400 4400
Connection ~ 5400 4400
Wire Wire Line
	5500 4500 5500 2850
Wire Wire Line
	5500 2850 7500 2850
Connection ~ 5500 4500
$Comp
L power:+5V #PWR09
U 1 1 5A839990
P 7100 2100
F 0 "#PWR09" H 7100 1950 50  0001 C CNN
F 1 "+5V" H 7100 2240 50  0000 C CNN
F 2 "" H 7100 2100 50  0001 C CNN
F 3 "" H 7100 2100 50  0001 C CNN
	1    7100 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 5A8399E8
P 7100 3400
F 0 "#PWR010" H 7100 3150 50  0001 C CNN
F 1 "GND" H 7100 3250 50  0000 C CNN
F 2 "" H 7100 3400 50  0001 C CNN
F 3 "" H 7100 3400 50  0001 C CNN
	1    7100 3400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5A87614D
P 3150 6400
F 0 "#PWR?" H 3150 6150 50  0001 C CNN
F 1 "GND" H 3150 6250 50  0000 C CNN
F 2 "" H 3150 6400 50  0001 C CNN
F 3 "" H 3150 6400 50  0001 C CNN
	1    3150 6400
	1    0    0    -1  
$EndComp
Connection ~ 3150 5900
Wire Wire Line
	4150 1900 5300 1900
Wire Wire Line
	4150 1900 4150 2050
Wire Wire Line
	3150 4600 3150 4950
Wire Wire Line
	3150 4400 3150 4600
Wire Wire Line
	6700 5900 6700 6100
Wire Wire Line
	6700 4900 6700 4600
Wire Wire Line
	3650 4600 3600 4600
Wire Wire Line
	5400 4400 5650 4400
Wire Wire Line
	5500 4500 5650 4500
Wire Wire Line
	3150 5900 3150 6400
$EndSCHEMATC
