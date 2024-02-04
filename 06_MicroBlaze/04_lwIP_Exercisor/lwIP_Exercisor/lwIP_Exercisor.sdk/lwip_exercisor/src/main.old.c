/*
 * main.cpp
 *
 *  Created on: Nov 24, 2017
 */

#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"

#include "xgpio.h"
#include "xintc.h"
#include "xllfifo.h"

#define MAX_FRAME_SIZE 1506
#define WORD_SIZE 4

static XGpio gpio_1;
static XGpio gpio_2;

static XLlFifo fifo_1;
static XLlFifo fifo_2;

static XIntc intController;

void echoData(XLlFifo *fifo)
{
	u32 recv_len;
	char buffer[MAX_FRAME_SIZE];
	u32 words[100];

	recv_len = (XLlFifo_iRxGetLen(fifo))/WORD_SIZE;
	XGpio_DiscreteWrite(&gpio_2, 2, 0x202);
	XGpio_DiscreteWrite(&gpio_2, 2, recv_len);
	XGpio_DiscreteWrite(&gpio_2, 2, 0x203);
	if (recv_len > 0)
	{
		XGpio_DiscreteWrite(&gpio_2, 2, 0x204);

		// Receive entire buffer amount
		XLlFifo_Read(fifo, buffer, (recv_len * WORD_SIZE));
		XGpio_DiscreteWrite(&gpio_2, 2, 0x210 + recv_len);

		int i;
		u32 word = 0;

		u32 sumOfValues = 0;
		for( i = 0; i < recv_len; i++) {
			int index = (i*4);
			word =  (buffer[index+3] << 24) |
					(buffer[index+2] << 16) |
					(buffer[index+1] <<  8) |
					(buffer[index+0])
					;

			XGpio_DiscreteWrite(&gpio_2, 2, i);
			XGpio_DiscreteWrite(&gpio_2, 2, word);

			words[i] = word;
			sumOfValues += word;
		}

		XGpio_DiscreteWrite(&gpio_2, 2, recv_len);
		XGpio_DiscreteWrite(&gpio_2, 2, 0xFF01);
		XGpio_DiscreteWrite(&gpio_2, 2, sumOfValues);
		XGpio_DiscreteWrite(&gpio_2, 2, 0xFF02);

			// Now echo the data back out
			XGpio_DiscreteWrite(&gpio_2, 2, 0xFE01);
			if (XLlFifo_iTxVacancy(fifo)) {
				XGpio_DiscreteWrite(&gpio_2, 2, 0xFE02);
				for ( i = 0; i < recv_len; i++) {
					XGpio_DiscreteWrite(&gpio_2, 2, i);
					XGpio_DiscreteWrite(&gpio_2, 2, words[i]);
					XLlFifo_TxPutWord(fifo, words[i]);
				}
				XGpio_DiscreteWrite(&gpio_2, 2, 0xFE03);

				XLlFifo_iTxSetLen(fifo, (4 * recv_len));
				XGpio_DiscreteWrite(&gpio_2, 2, 0xFE04);
			}
	}
	XGpio_DiscreteWrite(&gpio_2, 2, 0x220);

}

void handler_0(void *CallbackRef)
{
	static int counter_0 = 0;

	XGpio_DiscreteWrite(&gpio_2, 2, 0x4000 + counter_0++);
	XIntc_Acknowledge(&intController, 0);
}

void handler_1(void *CallbackRef)
{
	static int counter_1 = 0;

	XGpio_DiscreteWrite(&gpio_2, 2, 0x5000 + counter_1++);
	XIntc_Acknowledge(&intController, 1);
}

int Intc_Setup(u16 DeviceId)
{
//	int base = 0x3000;
	int Status;

	/*
	 * Initialize the interrupt controller driver so that it is ready to use.
	 */
	Status = XIntc_Initialize(&intController, DeviceId);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// 0 to XPAR_INTC_MAX_NUM_INTR_INPUTS - 1
	Status = XIntc_Connect(&intController, 0,
					   (XInterruptHandler)handler_0,
					   (void *)0);
	Status = XIntc_Connect(&intController, 1,
						   (XInterruptHandler)handler_1,
						   (void *)0);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Start the interrupt controller such that interrupts are enabled for
	 * all devices that cause interrupts, specify simulation mode so that
	 * an interrupt can be caused by software rather than a real hardware
	 * interrupt.
	 */
	Status = XIntc_Start(&intController, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Enable the interrupt for the device and then cause (simulate) an
	 * interrupt so the handlers will be called.
	 */
	XIntc_Enable(&intController, 0);
	XIntc_Enable(&intController, 1);

	/*
	 * Initialize the exception table.
	 */
	Xil_ExceptionInit();

	/*
	 * Register the interrupt controller handler with the exception table.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XIntc_DeviceInterruptHandler,
			(void*) 0);

	/*
	 * Enable exceptions.
	 */
	Xil_ExceptionEnable();

	XGpio_DiscreteWrite(&gpio_1, 2, 0x3000);
	return XST_SUCCESS;
}

int main(void)
{
	/*
	 *  Initialize GPIO #1, and #2
	**/
	// Initialize GPIO #1
	{
		XGpio_Initialize(&gpio_1, XPAR_AXI_GPIO_0_DEVICE_ID);
		XGpio_SetDataDirection(&gpio_1, 1, 0xFFFFFFFF); /* 0xFFFFFFFF means input */

		XGpio_Initialize(&gpio_1, XPAR_AXI_GPIO_0_DEVICE_ID);
		XGpio_SetDataDirection(&gpio_1, 2, 0x0); /* 0 means output */
	}
	XGpio_DiscreteWrite(&gpio_1, 2, 0x100);

	// Initialize GPIO #2
	{
		XGpio_Initialize(&gpio_2, XPAR_AXI_GPIO_1_DEVICE_ID);
		XGpio_SetDataDirection(&gpio_2, 1, 0xFFFFFFFF); /* 0xFFFFFFFF means input */

		XGpio_Initialize(&gpio_2, XPAR_AXI_GPIO_1_DEVICE_ID);
		XGpio_SetDataDirection(&gpio_2, 2, 0x0); /* 0 means output */
	}
	XGpio_DiscreteWrite(&gpio_1, 2, 0x101);


	/*
	 *  Initialize FIFOs
	 *
	**/
	int Status;
	XLlFifo_Config *Config;
	Status = XST_SUCCESS;

	// Initialize FIFO #1
	XGpio_DiscreteWrite(&gpio_1, 2, 0x102);
	Config = XLlFfio_LookupConfig(XPAR_AXI_FIFO_0_DEVICE_ID);
	if (!Config)
	{
		XGpio_DiscreteWrite(&gpio_1, 2, 0x103);
		return XST_FAILURE;
	}
	Status = XLlFifo_CfgInitialize(&fifo_1, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		XGpio_DiscreteWrite(&gpio_1, 2, 0x104);
		return XST_FAILURE;
	}

	// Initialize FIFO #2
	XGpio_DiscreteWrite(&gpio_1, 2, 0x105);
	Config = XLlFfio_LookupConfig(XPAR_AXI_FIFO_1_DEVICE_ID);
	if (!Config)
	{
		XGpio_DiscreteWrite(&gpio_1, 2, 0x106);
		return XST_FAILURE;
	}
	Status = XLlFifo_CfgInitialize(&fifo_2, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		XGpio_DiscreteWrite(&gpio_1, 2, 0x107);
		return XST_FAILURE;
	}

	/*
	 *  Initialize Interrupts
	 *
	**/
	Intc_Setup(XPAR_INTC_SINGLE_DEVICE_ID);

	// Main Loop
	u32 last_0 = 0;
	u32 last_1 = 0;

	XGpio_DiscreteWrite(&gpio_1, 2, 0x108);
	while(1)
	{
		// Check GPIO #1
		XGpio_DiscreteWrite(&gpio_1, 2, 0x301);
		u32 gpi_val_0 = XGpio_DiscreteRead(&gpio_1, 1);
		if(gpi_val_0 != last_0) {
			last_0 = gpi_val_0;
			XGpio_DiscreteWrite(&gpio_1, 2, (last_0 + last_0));
		}
		// Check GPIO #2
		XGpio_DiscreteWrite(&gpio_1, 2, 0x302);
		u32 gpi_val_1 = XGpio_DiscreteRead(&gpio_2, 1);
		if(gpi_val_1 != last_1) {
			last_1 = gpi_val_1;
			XGpio_DiscreteWrite(&gpio_2, 2, (last_1 + last_1));
		}

		// Check FIFO #1
		XGpio_DiscreteWrite(&gpio_1, 2, 0x303);
		if( XLlFifo_RxOccupancy(&fifo_1) )
		{
			XGpio_DiscreteWrite(&gpio_1, 2, 0x109);
			echoData(&fifo_1);
		}

		// Check FIFO #2
		XGpio_DiscreteWrite(&gpio_1, 2, 0x304);
		if( XLlFifo_RxOccupancy(&fifo_2) )
		{
			XGpio_DiscreteWrite(&gpio_1, 2, 0x10A);
			echoData(&fifo_2);
		}
	}

	return 0;
}


