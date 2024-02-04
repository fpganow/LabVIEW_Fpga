/*
 * main.c
 *
 *  Created on: Jun 27, 2017
 *      Author: John
 */

#include "xparameters.h"
#include "xil_cache.h"
#include "xiomodule.h"

static XIOModule gpio;

u8 uintrd_1 = 16 + XPAR_IOMODULE_0_SYSTEM_INTC_INTERRUPT_0_INTR;
u8 uintrd_2 = 16 + XPAR_IOMODULE_0_SYSTEM_INTC_INTERRUPT_1_INTR;

//static XIOModule gpioOut_2;
//static XIOModule ioModule;

//void host_handler( void )
//{
//	// Can  we detect which interrupt was raised?
//	static int intCount = 100;
//	intCount++;
//	u32 out_val = 10000 + intCount;
//	XIOModule_DiscreteWrite(&gpioOut_2, 2, out_val);
//
//	// Acknowledge Interrupt
//	XIOModule_Acknowledge(&gpioOut_2, uintrd);
//
//	// Acknowledge that we have acknowledged the IRQ
//	XIOModule_DiscreteWrite(&gpioOut_2, 2, 5001);
//
//	// Read size from I/O Bus
//	u32 packetLen = 0;
//	packetLen = XIOModule_IoReadWord(&ioModule, 0x0);
//
//	XIOModule_DiscreteWrite(&gpioOut_2, 2, 5002);
//
////	// Read data from I/O Bus
////	u32 *packetData;
////	int i;
////	packetData = (u32 *)malloc(packetLen * sizeof(u32));
////
////	for(i=0; i<packetLen; i++)
////	{
////		*(packetData+i) = XIOModule_IoReadWord(&ioModule, 0);
////	}
//
//	// Write size to GPO2
//	XIOModule_DiscreteWrite(&gpioOut_2, 2, packetLen);
//
//	// Write data to I/O Bus
////	free(packetData);
//}

void myISR_1( void )
{
	static int count_1 = 100;
	count_1 ++;
	u32 out_val = (count_1 * 100) + 1;
	XIOModule_DiscreteWrite(&gpio, 2, out_val);
	XIOModule_Acknowledge(&gpio, uintrd_1);

//	u32 packetLen;
//	XIOModule_DiscreteWrite(&gpio, 1, 1437);
//	packetLen = XIOModule_IoReadWord(&gpio, 0x4);
//	XIOModule_DiscreteWrite(&gpio, 2, packetLen);
	// Read size from I/O Bus
	u32 packetLen = 0;
	packetLen = XIOModule_IoReadWord(&gpio, 0x0);

	// Write size to GPO2
	XIOModule_DiscreteWrite(&gpio, 2, packetLen);

	// Read data from I/O Bus
	u32 *packetData;
	int i;
	packetData = (u32 *)malloc(packetLen * sizeof(u32));

	for(i=0; i<packetLen; i++)
	{
		*(packetData+i) = XIOModule_IoReadWord(&gpio, 0);
	}

	// Write same packet out of I/O Bus
	XIOModule_IoWriteWord(&gpio, 0x8, packetLen);
	for(i=0; i<packetLen; i++)
	{
		XIOModule_IoWriteWord(&gpio, 0x8, *(packetData+i));
	}

	// Write data to I/O Bus
	free(packetData);
}

void myISR_2( void )
{
	static int count_2 = 100;
	count_2 ++;
	u32 out_val = (count_2 * 100) + 2;
	XIOModule_DiscreteWrite(&gpio, 2, out_val);
	XIOModule_Acknowledge(&gpio, uintrd_2);

	XIOModule_IoWriteWord(&gpio, 0x4, out_val);
}

int main()
{
   Xil_ICacheEnable();
   Xil_DCacheEnable();

   XIOModule_Initialize(&gpio, XPAR_IOMODULE_0_DEVICE_ID);
   microblaze_register_handler(XIOModule_DeviceInterruptHandler, XPAR_IOMODULE_0_DEVICE_ID);
   XIOModule_Start(&gpio);
   microblaze_enable_interrupts();

   if(XST_SUCCESS == XIOModule_Connect(&gpio, uintrd_1, (XInterruptHandler)myISR_1, XPAR_IOMODULE_0_DEVICE_ID))
   {
	   XIOModule_DiscreteWrite(&gpio, 2, 1200);
   }
   else
   {
	   XIOModule_DiscreteWrite(&gpio, 2, 1201);
   }
   XIOModule_Enable(&gpio, uintrd_1);

   if(XST_SUCCESS == XIOModule_Connect(&gpio, uintrd_2, (XInterruptHandler)myISR_2, XPAR_IOMODULE_0_DEVICE_ID))
   {
	   XIOModule_DiscreteWrite(&gpio, 3, 1300);
   }
   else
   {
	   XIOModule_DiscreteWrite(&gpio, 3, 1301);
   }
   XIOModule_Enable(&gpio, uintrd_2);

   // Write a number to GPO 1 that changes for each build
   XIOModule_DiscreteWrite(&gpio, 1, 1336);

 /*
   // IO BUS TEST #1
   u32 packetLen;
   XIOModule_DiscreteWrite(&gpio, 1, 1437);
   packetLen = XIOModule_IoReadWord(&gpio, 0x4);
   XIOModule_DiscreteWrite(&gpio, 2, packetLen);

   XIOModule_DiscreteWrite(&gpio, 1, 1438);
   packetLen = XIOModule_IoReadWord(&gpio, 0x4);
   XIOModule_DiscreteWrite(&gpio, 3, packetLen);
   // END IO BUS TEST #1
*/

   u32 gpi_1;
   u32 gpi_1_old;
   gpi_1_old = -1;
   while(1)
   {
	   gpi_1 = XIOModule_DiscreteRead(&gpio, 1);
	   if(gpi_1_old == -1)
	   {
		   gpi_1_old = gpi_1;
	   }
	   else
	   {
		   // Only update the value being output by the GPO channel 2
		   // if the value read from GPI channel 1 has changed
		   if(gpi_1_old != gpi_1)
		   {
			   XIOModule_DiscreteWrite(&gpio, 1, gpi_1 + gpi_1);
		   }
		   gpi_1_old = gpi_1;
	   }
   }

   //

//
//   XIOModule_Initialize(&ioModule, XPAR_IOMODULE_0_DEVICE_ID);
//   XIOModule_Start(&ioModule);
//   u32 packetLen = 0;
////	Xil_AssertNonvoid(InstancePtr != NULL);
////	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
////	return XIomodule_In32((InstancePtr->IoBaseAddress + ByteOffset));
//   packetLen = XIOModule_IoReadWord(&ioModule, 0x0);
//   XIOModule_DiscreteWrite(&gpioOut_temp, 1, packetLen);
//   packetLen = XIOModule_IoReadWord(&ioModule, 0x0);
////
//   print("---Entering main---\n\r");
//   {
//	   // Initialize GPI_1
//	   XIOModule gpioIn_1;
//	   XIOModule_Initialize(&gpioIn_1, XPAR_IOMODULE_0_DEVICE_ID);
//	   XIOModule_Start(&gpioIn_1);
//
//	   // Initialize GPO_1
//	   XIOModule gpioOut_1;
//	   XIOModule_Initialize(&gpioOut_1, XPAR_IOMODULE_0_DEVICE_ID);
//	   XIOModule_Start(&gpioOut_1);
//
//	   // Initialize GPO_3
//	   XIOModule gpioOut_3;
//	   XIOModule_Initialize(&gpioOut_3, XPAR_IOMODULE_0_DEVICE_ID);
//	   XIOModule_Start(&gpioOut_3);
//
//	   // Initialize IOModule for IO Bus
//	   XIOModule_Initialize(&ioModule, XPAR_IOMODULE_0_DEVICE_ID);
//	   XIOModule_Start(&ioModule);
//
//	   // Initialize GPO_2
//  	   XIOModule_Initialize(&gpioOut_2, XPAR_IOMODULE_0_DEVICE_ID);
//   	   microblaze_register_handler(XIOModule_DeviceInterruptHandler, XPAR_IOMODULE_0_DEVICE_ID);
//   	   XIOModule_Start(&gpioOut_2);
//	   microblaze_enable_interrupts();
//	   if(XST_SUCCESS == XIOModule_Connect(&gpioOut_2, uintrd, (XInterruptHandler)host_handler, XPAR_IOMODULE_0_DEVICE_ID))
//	   {
//		   XIOModule_DiscreteWrite(&gpioOut_3, 3, 1300);
//	   }
//	   else
//	   {
//		   XIOModule_DiscreteWrite(&gpioOut_3, 3, 1301);
//	   }
//	   XIOModule_Enable(&gpioOut_2, uintrd);
//
//	   // Write a number to make sure we are using the latest version of the bitfile.
//	   // I normally use the 24 hour time
//	   XIOModule_DiscreteWrite(&gpioOut_1, 1, 1140);
//	   XIOModule_DiscreteWrite(&gpioOut_2, 2, 1141);
//
//   }

   print("---Exiting main---\n\r");
   Xil_DCacheDisable();
   Xil_ICacheDisable();
   return 0;
}
