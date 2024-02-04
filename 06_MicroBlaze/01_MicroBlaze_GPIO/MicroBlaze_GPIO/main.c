/*
 * main.c
 *
 *  Created on: Jun 23, 2017
 *      Author: John
 */


#include <stdio.h>
#include "xparameters.h"
#include "xil_cache.h"
#include "xgpio.h"

int main()
{
   Xil_ICacheEnable();
   Xil_DCacheEnable();

   {
	   XGpio GpioInput;
	   XGpio_Initialize(&GpioInput, XPAR_AXI_GPIO_0_DEVICE_ID);
	   XGpio_SetDataDirection(&GpioInput, 1, 0xFFFFFFFF); /* 0xFFFFFFFF means input */

	   XGpio GpioOutput;
	   XGpio_Initialize(&GpioOutput, XPAR_AXI_GPIO_0_DEVICE_ID);
  	   XGpio_SetDataDirection(&GpioOutput, 2, 0x0); /* 0 means output */

   	   u32 gpi_1;
   	   while(1)
   	   {
   		   gpi_1 = XGpio_DiscreteRead(&GpioInput, 1);
   		   XGpio_DiscreteWrite(&GpioOutput, 2, gpi_1 + gpi_1);
   	   }
   }

   Xil_DCacheDisable();
   Xil_ICacheDisable();
   return 0;
}
