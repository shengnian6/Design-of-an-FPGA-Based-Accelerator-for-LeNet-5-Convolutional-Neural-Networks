#include "Matrix_Mul.h"
#include "sleep.h"

void Matrix_Mul_Set(unsigned int din_len,unsigned int dout_len,void *Matrx_A_Base_Addr,void *Matrx_B_Base_Addr,void *Matrx_C_Base_Addr)
{
    My_DMA_Ctrl_1=din_len;
    My_DMA_Ctrl_2=dout_len;
    usleep(1);
    My_DMA_Ctrl_3=(UINTPTR)Matrx_A_Base_Addr;
    My_DMA_Ctrl_4=(UINTPTR)Matrx_B_Base_Addr;
    My_DMA_Ctrl_5=(UINTPTR)Matrx_C_Base_Addr;

}


void Matrix_Mul_Start(void)
{
	My_DMA_Ctrl_0 |= 1;
}

int Matrix_Mul_Done(void)
{
	// if (Ctrl_0 & 10)!= 0 , 判断 reg0[1] 是否等于 0
	// 若等于 1，则说明计算完成
	usleep(47);
	//return 1;
	return (My_DMA_Ctrl_0&(1<<1))!=0;
}

void Matrix_Mul_Show_Registers(void)
{
	printf("My_DMA_Ctrl_0=%d\n\r",My_DMA_Ctrl_0);
	printf("My_DMA_Ctrl_1=%d\n\r",My_DMA_Ctrl_1);
	printf("My_DMA_Ctrl_2=%d\n\r",My_DMA_Ctrl_2);
	printf("My_DMA_Ctrl_3=0x%08x\n\r",My_DMA_Ctrl_3);
	printf("My_DMA_Ctrl_4=0x%08x\n\r",My_DMA_Ctrl_4);
	printf("My_DMA_Ctrl_5=0x%08x\n\r",My_DMA_Ctrl_5);
}
