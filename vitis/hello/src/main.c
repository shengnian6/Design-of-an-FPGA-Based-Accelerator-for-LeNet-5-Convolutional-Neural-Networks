/****************************************************************************************************************

			   ______   _   __   _   __       ___                  __                __
			  / ____/  / | / /  / | / /      /   | _____________  / /__  _________ _/ /_____  _____
			 / /      /  |/ /  /  |/ /      / /| |/ ___/ ___/ _ \/ / _ \/ ___/ __ `/ __/ __ \/ ___/
			/ /___   / /|  /  / /|  /      / ___ / /__/ /__/  __/ /  __/ /  / /_/ / /_/ /_/ / /
			\____/  /_/ |_/  /_/ |_/      /_/  |_\___/\___/\___/_/\___/_/   \__,_/\__/\____/_/


*******************************************************************************************************************/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "Matrix_Mul.h"
#include "xtime_l.h"
#include "xil_cache.h"
#include "img_flow.h"

#define Featmap_Size 30
#define Kernel_Size 3

#define din_len 900	// (Featmap_Size*Featmap_Size)
#define dout_len 10
//#define PRINT_ACC 1
#define TEST_NUM 1

int din[din_len];
int win[1];
int dout[dout_len];

float fix2fp(int fix_num, int bit_width, int quant_width);
int pow2n(int n);

int main()
{
	float float_num;
	float float_max;
	int true_imgs = 0, false_imgs = 0;
	int bit_width = 16;
	int quant_width = 11;
	XTime tEnd, tCur;
	u32 tUsed;

    init_platform();
    Xil_DCacheDisable();	// More Important !!!!!!!!!!

    xil_printf("\n\r\
       ______   _   __   _   __       ___                  __                __               \r\
      / ____/  / | / /  / | / /      /   | _____________  / /__  _________ _/ /_____  _____   \r\
     / /      /  |/ /  /  |/ /      / /| |/ ___/ ___/ _ \\/ / _ \\/ ___/ __ `/ __/ __ \\/ ___/\r\
    / /___   / /|  /  / /|  /      / ___ / /__/ /__/  __/ /  __/ /  / /_/ / /_/ /_/ / /       \r\
    \\____/  /_/ |_/  /_/ |_/      /_/  |_\\___/\\___/\\___/_/\\___/_/   \\__,_/\\__/\\____/_/\n\r");


    xil_printf("\n\r ****** Accelerating !!! ******\r");
    xil_printf("\n\r =>=>=>=>===>>>>>>>>===>=>=>=>=\r");

   // 1-配置参数
   //Matrix_Mul_Set(din_len,dout_len,din,win,dout);
   //Matrix_Mul_Show_Registers();
    XTime_GetTime(&tCur);
	for (int n = 0; n< TEST_NUM; n++)
	{

		//XTime_GetTime(&tCur);
		Matrix_Mul_Set(din_len,dout_len,img[n],win,dout);
		// 2-开始计算
		Matrix_Mul_Start();

		// 3-结束计算
		while(!Matrix_Mul_Done());

#if PRINT_ACC
		int img_num = 0;
		float_max = 0;
		for (int i = 0; i < dout_len; i++)
		{
			float_num = fix2fp(dout[i], bit_width, quant_width);

			if (float_num > float_max)
			{
				img_num = i;
				float_max = float_num;
			}
//				xil_printf("dout[%d] = %4x\n\r",i, dout[i]);
		}

		if (img_num == img_label[n])
		{
			true_imgs++;
//				xil_printf("\r ****** true !!! ****** <%d>\n", n);
		}
		else
		{
			false_imgs++;
//				xil_printf("\r ****************** false !!! ******************* <%d>\n", n);
//				for (i = 0; i < dout_len; i++)
//				{
//					float_num = fix2fp(dout[i], bit_width, quant_width);
//
//					if (float_num < 0)
//						xil_printf("dout[%d] = -%4x\n\r",i, dout[i]);
//					else
//						xil_printf("dout[%d] = %4x\n\r",i, dout[i]);
//				}
		}

//准确率
			xil_printf("\n The true number of image is %d\n", img_label[n]);
	    	xil_printf(" The predicted number of image is %d\n", img_num);
#endif

	}

	XTime_GetTime(&tEnd);
	tUsed = ((tEnd-tCur)*1000000)/(COUNTS_PER_SECOND);

//时间
	xil_printf("\r ****** Done !!! ******\r");
	xil_printf("\n\r Calculate time is %d us\r\n",tUsed);

#if PRINT_ACC
	xil_printf("\n ********************************* \n");
	xil_printf(" **********   Result   *********** \n");
	xil_printf(" ********************************* \n ");

	xil_printf("\n The number of true  images is %d", true_imgs);
	xil_printf("\n The number of false images is %d\n", false_imgs);

	float accuracy;
	accuracy = (float)true_imgs/(true_imgs + false_imgs);

	int frac;
	frac = (int)(accuracy*10000);

	if (frac < 10000)
		xil_printf("\n The accuracy is 0.%d\n", frac);
	else
		xil_printf("\n The accuracy is 100%\n");
#endif

	cleanup_platform();
    return 0;
}

int pow2n(int n)
{
     int pow2n=1, i;
     for(i=0; i<n; i++)
     {
    	 pow2n*=2;
     }

     return pow2n;
}

float fix2fp(int fix_num, int bit_width, int quant_width)
{
	float float_num;

    if (fix_num >= pow2n(bit_width-1))
        float_num = (float)(fix_num - pow2n(bit_width)) / pow2n(quant_width);
    else
        float_num = (float)fix_num / pow2n(quant_width);

    return float_num;
}
