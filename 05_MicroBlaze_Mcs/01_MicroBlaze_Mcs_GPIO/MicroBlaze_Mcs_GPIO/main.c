/*
 * main.c
 *
 *  Created on: Jun 17, 2017
 *      Author: John
 */

#include "xparameters.h"
#include "xil_cache.h"
#include "xiomodule.h"

int main() 
{
   Xil_ICacheEnable();
   Xil_DCacheEnable();
   print("---Entering main---\n\r");

   {
	   XIOModule gpioIn_1;
	   XIOModule_Initialize(&gpioIn_1, XPAR_IOMODULE_0_DEVICE_ID);
	   XIOModule_Start(&gpioIn_1);

	   XIOModule gpioOut_1;
	   XIOModule_Initialize(&gpioOut_1, XPAR_IOMODULE_0_DEVICE_ID);
	   XIOModule_Start(&gpioOut_1);

	   u32 gpi_1;
	   while(1)
	   {
		   gpi_1 = XIOModule_DiscreteRead(&gpioIn_1, 1);
		   if(gpi_1 == 0)
		   {
			   gpi_1 = 50;
		   }
		   XIOModule_DiscreteWrite(&gpioOut_1, 1, gpi_1 + gpi_1);
	   }
   }

   print("---Exiting main---\n\r");
   Xil_DCacheDisable();
   Xil_ICacheDisable();
   return 0;
}
