#ifndef __TEN_GIG_NETIF_H__
#define __TEN_GIG_NETIF_H__

#include "lwip/def.h"
#include "lwip/mem.h"
#include "lwip/pbuf.h"
#include <lwip/stats.h>
#include <lwip/snmp.h>
#include "netif/etharp.h"
#include "netif/ppp_oe.h"

err_t ten_gignetif_init(struct netif *netif);
void ten_gignetif_input(struct netif *netif);

#endif /* __TEN_GIG_NETIF_H__ */
