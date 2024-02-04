/*
 * main.c
 *
 *  Created on: Sep 11, 2017
 *      Author: John
 */

#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xgpio.h"
#include "xllfifo.h"

#define MAX_FRAME_SIZE 1506
#define WORD_SIZE 4

static XGpio GpioInput;
static XGpio GpioOutput;

static XLlFifo FifoInstance;

int main()
{
	// Initialize GPIO Channel 1 and 2
	{
		XGpio_Initialize(&GpioInput, XPAR_AXI_GPIO_0_DEVICE_ID);
		XGpio_SetDataDirection(&GpioInput, 1, 0xFFFFFFFF); /* 0xFFFFFFFF means input */

		XGpio_Initialize(&GpioOutput, XPAR_AXI_GPIO_0_DEVICE_ID);
		XGpio_SetDataDirection(&GpioOutput, 2, 0x0); /* 0 means output */
	}
	XGpio_DiscreteWrite(&GpioOutput, 2, 0x100);

	// Initialize FIFO
	int Status;
	XLlFifo_Config *Config;
	Status = XST_SUCCESS;

	// Initialize FIFO
	XGpio_DiscreteWrite(&GpioOutput, 2, 0x1);
	Config = XLlFfio_LookupConfig(XPAR_AXI_FIFO_0_DEVICE_ID);
	if (!Config)
	{
		XGpio_DiscreteWrite(&GpioOutput, 2, 0x2);
		return XST_FAILURE;
	}
	Status = XLlFifo_CfgInitialize(&FifoInstance, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		XGpio_DiscreteWrite(&GpioOutput, 2, 0x3);
		return XST_FAILURE;
	}

	// Main Loop
	u32 ReceiveLength;
	char buffer[MAX_FRAME_SIZE];
	u32 words[100];

	XGpio_DiscreteWrite(&GpioOutput, 2, 0x200);
	while(1)
	{
		XGpio_DiscreteWrite(&GpioOutput, 2, 0x201);
		if( XLlFifo_RxOccupancy(&FifoInstance) )
		{
			ReceiveLength = (XLlFifo_iRxGetLen(&FifoInstance))/WORD_SIZE;
			XGpio_DiscreteWrite(&GpioOutput, 2, 0x202);
			XGpio_DiscreteWrite(&GpioOutput, 2, ReceiveLength);
			XGpio_DiscreteWrite(&GpioOutput, 2, 0x203);
			if(ReceiveLength > 0)
			{
				XGpio_DiscreteWrite(&GpioOutput, 2, 0x204);

				// Receive entire buffer amount
				XLlFifo_Read(&FifoInstance, buffer, (ReceiveLength*WORD_SIZE));
				XGpio_DiscreteWrite(&GpioOutput, 2, 0x210 + ReceiveLength);

				int i;
				u32 word = 0;


				u32 sumOfValues = 0;
				for(i=0; i<ReceiveLength; i++) {
					int index = (i*4);
					word =  (buffer[index+3] << 24) |
							(buffer[index+2] << 16) |
							(buffer[index+1] <<  8) |
							(buffer[index+0])
							;

					XGpio_DiscreteWrite(&GpioOutput, 2, i);
					XGpio_DiscreteWrite(&GpioOutput, 2, word);

					words[i] = word;
					sumOfValues += word;
				}

				XGpio_DiscreteWrite(&GpioOutput, 2, ReceiveLength);
				XGpio_DiscreteWrite(&GpioOutput, 2, 0xFF01);
				XGpio_DiscreteWrite(&GpioOutput, 2, sumOfValues);
				XGpio_DiscreteWrite(&GpioOutput, 2, 0xFF02);

				// Now echo the data back out
				XGpio_DiscreteWrite(&GpioOutput, 2, 0xFE01);
				if (XLlFifo_iTxVacancy(&FifoInstance)) {
					XGpio_DiscreteWrite(&GpioOutput, 2, 0xFE02);
					for(i=0; i<ReceiveLength; i++) {
						XGpio_DiscreteWrite(&GpioOutput, 2, i);
						XGpio_DiscreteWrite(&GpioOutput, 2, words[i]);
						XLlFifo_TxPutWord(&FifoInstance, words[i]);
					}
					XGpio_DiscreteWrite(&GpioOutput, 2, 0xFE03);

					XLlFifo_iTxSetLen(&FifoInstance, (4 * ReceiveLength));
					XGpio_DiscreteWrite(&GpioOutput, 2, 0xFE04);
				}
			}
			XGpio_DiscreteWrite(&GpioOutput, 2, 0x220);
		}
		XGpio_DiscreteWrite(&GpioOutput, 2, 0x230);
	}

	return 0;
}
