//***************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de Microcontroladores 
// Autor: Esteban Longo
// Proyecto: Sumador
// Descripción: Sumador binario de 4 bits
// Hardware: ATMEGA328P
// Created: 24/01/2024 17:38:15
//****************************************************
// Encabezado 
//****************************************************
.include "M328PDEF.inc"

.cseg
.org 0x00
//****************************************************
//Configuración de la Pila
//****************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17
//****************************************************

//****************************************************
//Configuración MCU
//****************************************************
SETUP:
	
	LDI	R16, (1 << CLKPCE)	//Nos permite trabajar a 1M HZ
	STS CLKPR, R16
	LDI	R16, 0b00000011
	STS CLKPR, R16
	
	LDI R16, 0b0001_1111 //Configuramos al pueto B como entradas
	OUT	PORTB, R16

	LDI R16, 0b0000_0000 //Configuración al puerto B como pull ups
	OUT DDRB, R16
	
	LDI R16, 0b1111_1100	//Configuramos el puerto D como salidas
	OUT DDRD, R16
	
	LDI R16, 0b1011_1111	//Configuramos el puerto C como salidas
	OUT DDRC, R16

	LDI R18 , 0b0000_0000	//Estos tres registros se les carga 0 
	LDI R19 , 0b0000_0000	//para ser usados
	LDI R20 , 0b0000_0000

//****************************************************
//Configuración LOOP
//****************************************************
LOOP:
	IN R16, PINB	//Leemos los pines del puerto B y los guardamos en R16
	SBRS R16, PB0	//Analizamos si el pin B0 = 1, si lo es saltamos el call, si no lo es entramos al call
	CALL NUM1		//Llamamos a la subrutina NUM1 
	SBRS R16, PB1	//Analizamos si el pin B1 = 1, si lo es saltamos el call, si no lo es entramos al call
	CALL NUM2		//Llamamos a la subrutina NUM1 
	SBRS R16, 2		//Analizamos si el pin B2 = 1, si lo es saltamos el call, si no lo es entramos al call
	CALL NUM3		//Llamamos a la subrutina NUM1 
	SBRS R16, 3		//Analizamos si el pin B3 = 1, si lo es saltamos el call, si no lo es entramos al call
	CALL NUM4		//Llamamos a la subrutina NUM1 

	OUT PORTC, R18	//EN los puertos D y C sacamos los valores de los registros respectivos
	OUT PORTD, R19

	RJMP LOOP //Regresamos al LOOP

//****************************************************
//Subrutina 
//****************************************************

//Esta subrutina sirve para el antirrebote del pushbutton
// y tambien sirve para incrementar el valor de R18 
NUM1:
	LDI R17, 200  //Sirve para hacer un delay 
	delay:
		DEC R17
		BRNE delay
	SBIS PINB, PB0		//Analiza que el puerto no siga teniendo entrada de información
	RJMP NUM1			
	INC R18
	RET

//Esta subrutina sirve para el antirrebote del pushbutton
// y tambien sirve para decrementar el valor de R18 

NUM2:
	LDI R17, 200  //Sirve para hacer un delay
	delay2:
		DEC R17
		BRNE delay2
	SBIS PINB, PB1	//Analiza que el puerto no siga teniendo entrada de información
	RJMP NUM2			
	DEC R18
	RET

//Esta subrutina sirve para el antirrebote del pushbutton
// y tambien sirve para incrementar el valor de R19

NUM3:
	LDI R17, 200	//Sirve para hacer un delay
	delay3:
		DEC R17
		BRNE delay3
	SBIS PINB, PB2	//Analiza que el puerto no siga teniendo entrada de información	
	RJMP NUM3			
	INC R19     //En esta caso se incrementa 3 veces R19 porque el puerto 
	INC R19		//solo puede ser usado desde el pin2 en adelante
	INC R19		//esto soluciona el problema de no tener los otros dos pines
	INC R20
	RET

//Esta subrutina sirve para el antirrebote del pushbutton
// y tambien sirve para decrementar el valor de R19

NUM4:
	LDI R17, 200	//Sirve para hacer un delay
	delay4:
		DEC R17
		BRNE delay4
	SBIS PINB, PB3	//Analiza que el puerto no siga teniendo entrada de información	
	RJMP NUM4
	DEC R20			
	DEC R19		//En esta caso se decrementa 3 veces R19 porque el puerto
	DEC R19		//solo puede ser usado desde el pin2 en adelante
	DEC R19		//esto soluciona el problema de no tener los otros dos pines
	RET
//****************************************************