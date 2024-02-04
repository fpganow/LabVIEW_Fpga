/*
 * main.c
 *
 *  Created on: Aug 26, 2017
 *      Author: John
 */

#include <stdio.h>
#include <xil_printf.h>
#include "xparameters.h"
//#include "xil_cache.h"
#include "xgpio.h"
//#include "xllfifo.h"

#define MAX_FRAME_SIZE 1506
#define WORD_SIZE 4

static XGpio GpioInput;
static XGpio GpioOutput;

//static XLlFifo FifoInstance;

int main() {
//	Xil_ICacheEnable();
//	Xil_DCacheEnable();

	{
		XGpio_Initialize(&GpioInput, XPAR_AXI_GPIO_0_DEVICE_ID);
		XGpio_SetDataDirection(&GpioInput, 1, 0xFFFFFFFF); /* 0xFFFFFFFF means input */

		XGpio_Initialize(&GpioOutput, XPAR_AXI_GPIO_0_DEVICE_ID);
		XGpio_SetDataDirection(&GpioOutput, 2, 0x0); /* 0 means output */
	}

	XGpio_DiscreteWrite(&GpioOutput, 2, 0x102);

	{
		int Status;
//		XLlFifo_Config *Config;
		Status = XST_SUCCESS;

		// Initialize FIFO
		XGpio_DiscreteWrite(&GpioOutput, 2, 0x1);
//		Config = XLlFfio_LookupConfig(XPAR_AXI_FIFO_0_DEVICE_ID);
//		if (!Config) {
//			XGpio_DiscreteWrite(&GpioOutput, 2, 0x2);
//			return XST_FAILURE;
//		}
//		Status = XLlFifo_CfgInitialize(&FifoInstance, Config,
//				Config->BaseAddress);
		if (Status != XST_SUCCESS) {
			XGpio_DiscreteWrite(&GpioOutput, 2, 0x3);
			return XST_FAILURE;
		}

		// Loop
		while(1)
		{
			// Check if data is available
			// Now Read Data
	  	   int i;
	  	   u32 ReceiveLength;
	  	   u32 RxWord;
	  	   char buffer[MAX_FRAME_SIZE];

	  	   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB01);
	  	   //xil_printf(" Receiving data ....\n\r");
	  	   /* Read Recieve Length */
	  	   // This appears to be blocking
//	  	   ReceiveLength = (XLlFifo_iRxGetLen(&FifoInstance))/WORD_SIZE;
	  	   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB02);

	  	   if(ReceiveLength > 0)
	  	   {
	  		   XGpio_DiscreteWrite(&GpioOutput, 2, ReceiveLength);
		  	   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB03);

		  	   /* Start Receiving */
//		  	   for ( i=0; i < ReceiveLength; i++)
//		  	   {
//		  		   RxWord = 0;
//		  		   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB04);
//		  		   RxWord = XLlFifo_RxGetWord(&FifoInstance);
//		  		   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB05);
//
//		  		   if(XLlFifo_iRxOccupancy(&FifoInstance))
//		  		   {
//		  			   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB06);
//		  			   RxWord = XLlFifo_RxGetWord(&FifoInstance);
//		  			   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB07);
//		  		   }
//
//		  		   *(buffer+i) = RxWord;
//		  	   }
	  	   } // end if
	  	   XGpio_DiscreteWrite(&GpioOutput, 2, 0xB08);
		} // end while

//		// Now Send Data
//		XGpio_DiscreteWrite(&GpioOutput, 2, 0x5);
//		if (XLlFifo_iTxVacancy(&FifoInstance)) {
//			XGpio_DiscreteWrite(&GpioOutput, 2, 0x6);
//			XLlFifo_TxPutWord(&FifoInstance, 0x10);
//
//			XGpio_DiscreteWrite(&GpioOutput, 2, 0x7);
//			XLlFifo_TxPutWord(&FifoInstance, 0x20);
//
//			XGpio_DiscreteWrite(&GpioOutput, 2, 0x8);
//			XLlFifo_TxPutWord(&FifoInstance, 0x30);
//
//			XGpio_DiscreteWrite(&GpioOutput, 2, 0x9);
//			XLlFifo_iTxSetLen(&FifoInstance, (4 * 3));
//		}

		XGpio_DiscreteWrite(&GpioOutput, 2, 0xA001);
	}

//	Xil_DCacheDisable();
//	Xil_ICacheDisable();

	return 0;
}
