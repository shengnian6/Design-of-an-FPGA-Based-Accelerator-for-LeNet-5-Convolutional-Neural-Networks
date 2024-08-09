#ifndef __Matrix_Mul_H_
#define __Matrix_Mul_H_

#include "xparameters.h"
#include "xil_printf.h"

#define My_DMA_Ctrl_0 (*(volatile unsigned int *)(XPAR_DMA_CONTROLLER_0_BASEADDR))
#define My_DMA_Ctrl_1 (*(volatile unsigned int *)(XPAR_DMA_CONTROLLER_0_BASEADDR+4))
#define My_DMA_Ctrl_2 (*(volatile unsigned int *)(XPAR_DMA_CONTROLLER_0_BASEADDR+8))
#define My_DMA_Ctrl_3 (*(volatile unsigned int *)(XPAR_DMA_CONTROLLER_0_BASEADDR+12))
#define My_DMA_Ctrl_4 (*(volatile unsigned int *)(XPAR_DMA_CONTROLLER_0_BASEADDR+16))
#define My_DMA_Ctrl_5 (*(volatile unsigned int *)(XPAR_DMA_CONTROLLER_0_BASEADDR+20))

void Matrix_Mul_Set(unsigned int height,unsigned int width,void *Matrx_A_Base_Addr,void *Matrx_B_Base_Addr,void *Matrx_C_Base_Addr);
void Matrix_Mul_Start(void);
int Matrix_Mul_Done(void);
void Matrix_Mul_Show_Registers(void);

#endif
