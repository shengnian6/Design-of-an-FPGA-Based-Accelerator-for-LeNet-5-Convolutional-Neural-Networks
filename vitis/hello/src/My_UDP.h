#ifndef __My_UDP_H__
#define __My_UDP_H__

#include "lwip/udp.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "lwip/dhcp.h"
#include "netif/xadapter.h"
#include "xil_printf.h"
#include "sleep.h"
//#include "xscutimer.h"

#define min(a,b) ((a>b)?b:a)

void My_UDP_Init(void);
void UDP_Send(char *data,unsigned int length);
char* UDP_Recv(unsigned int length);

void lwip_init();
void platform_enable_interrupts(void);
void platform_setup_interrupts(void);
void Print_Pbuf(char *name,struct pbuf *p);
void UDP_callback(void *arg, struct udp_pcb *upcb, struct pbuf *p, ip_addr_t *addr, u16_t port);

#endif
