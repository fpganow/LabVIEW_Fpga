/*
 * main.c
 *
 *  Created on: Jan 12, 2018
 *      Author: johns
 */

//#include <stdio.h>

#include "xparameters.h"
#include "helpers.h"

//#include "lwipopts.h"
////#include "ten_gignetif.h"
//#include "lwip/init.h"
//#include "lwip/netif.h"
//
//#include "lwip/init.h"
//
//#include "lwip/debug.h"
//
//#include "lwip/mem.h"
//#include "lwip/memp.h"
//#include "lwip/sys.h"
////#include "lwip/timeouts.h"
//
//#include "lwip/stats.h"
//
//#include "lwip/ip.h"
//#include "lwip/ip_addr.h"
//#include "lwip/ip_frag.h"
//#include "lwip/udp.h"
//#include "lwip/tcp.h"
//#include "tapif.h"
//#include "netif/etharp.h"
//
//#include "udpecho_raw.h"
//#include "tcpecho_raw.h"
//
//static ip_addr_t ipaddr, netmask, gw;

int main()
{
//    print("Hello World from arty_lwip\r\n");

//    struct netif netif;
//
//    IP4_ADDR(&gw, 192, 168, 0, 1);
//    IP4_ADDR(&ipaddr, 192, 168, 0, 182);
//    IP4_ADDR(&netmask, 255, 255, 255, 0);
//
//    lwip_init();
//
//    netif_add(&netif, &ipaddr, &netmask, &gw, NULL, tapif_init, ethernet_input);
//
//    netif_set_default(&netif);
//    netif_set_up(&netif);
//    udpecho_raw_init();
//    tcpecho_raw_init();

	u32 ret = init_all();
	XGpio_DiscreteWrite(&gpio_2, 2, ret);

	XGpio_DiscreteWrite(&gpio_2, 2, 0xAD); // "Build" number, increment each time

	u32 last_0 = 0;
	u32 last_1 = 0;

    while(1)
    {
    	// CLIP
    	// New Ethernet Frame to receive
    	// New Ethernet Frame to send

    	// HOST
    	// New data to send on UDP Port
    	// New data received on UDP Port

        // Check for new ethernet frame from CLIP
    	// Submit ethernet frame via tapif_select
    	// New packet should appear in udpecho_raw.udpecho_raw_recv
    	// From udpecho_raw_recv, pass data back to host

    	// Check for new data to send from LabVIEW Host
//        tapif_select(&netif);

    	// Check GPIO #1
		u32 gpi_val_0 = XGpio_DiscreteRead(&gpio_1, 1);
		if(gpi_val_0 != last_0) {
			last_0 = gpi_val_0;
			XGpio_DiscreteWrite(&gpio_1, 2, (last_0 + last_0));
		}

		// Check GPIO #2
		u32 gpi_val_1 = XGpio_DiscreteRead(&gpio_2, 1);
		if(gpi_val_1 != last_1) {
			last_1 = gpi_val_1;
			XGpio_DiscreteWrite(&gpio_2, 2, (last_1 + last_1));
		}

		// Check FIFO #1
		if( XLlFifo_RxOccupancy(&fifo_1) )
		{
			XGpio_DiscreteWrite(&gpio_1, 2, 0x109);
			processIncomingFrame(&fifo_1, &fifo_2);
		}

		// Check FIFO #2
		if( XLlFifo_RxOccupancy(&fifo_2) )
		{
			XGpio_DiscreteWrite(&gpio_1, 2, 0x10A);
			processOutgoingFrame(&fifo_1, &fifo_2);
		}
    }

	return 0;
}
