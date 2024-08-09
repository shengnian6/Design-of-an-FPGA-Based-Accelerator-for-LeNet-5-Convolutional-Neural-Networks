/******************************************************************************
* Copyright (c) 2022 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/


#include "pm_client.h"
#include <xil_cache.h>
#include "xil_util.h"
#include "xpm_nodeid.h"
#if defined (__aarch64__)
#include <xreg_cortexa53.h>
#elif defined (__arm__)
#include <xreg_cortexr5.h>
#endif

#ifndef __microblaze__
/** @cond xilpm_internal */
#define XPM_ARRAY_SIZE(x)		(sizeof(x) / sizeof(x[0]))

#define MPIDR_AFFLVL_MASK		(0xFFU)

#define WFI				__asm__ ("wfi")
#endif

#if defined (__aarch64__)
#define PM_APU_CORE_COUNT_PER_CLUSTER	(4U)
#define CORE_PWRDN_EN_BIT_MASK		(0x1U)
#define MPIDR_AFF1_SHIFT		(8U)
#define MPIDR_AFF2_SHIFT		(16U)

static struct XPm_Proc Proc_APU0_0 = {
	.DevId = PM_DEV_ACPU_0_0,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU0_1 = {
	.DevId = PM_DEV_ACPU_0_1,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU0_2 = {
	.DevId = PM_DEV_ACPU_0_2,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU0_3 = {
	.DevId = PM_DEV_ACPU_0_3,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU1_0 = {
	.DevId = PM_DEV_ACPU_1_0,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU1_1 = {
	.DevId = PM_DEV_ACPU_1_1,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU1_2 = {
	.DevId = PM_DEV_ACPU_1_2,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU1_3 = {
	.DevId = PM_DEV_ACPU_1_3,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU2_0 = {
	.DevId = PM_DEV_ACPU_2_0,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU2_1 = {
	.DevId = PM_DEV_ACPU_2_1,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU2_2 = {
	.DevId = PM_DEV_ACPU_2_2,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU2_3 = {
	.DevId = PM_DEV_ACPU_2_3,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU3_0 = {
	.DevId = PM_DEV_ACPU_3_0,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU3_1 = {
	.DevId = PM_DEV_ACPU_3_1,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU3_2 = {
	.DevId = PM_DEV_ACPU_3_2,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_APU3_3 = {
	.DevId = PM_DEV_ACPU_3_3,
	.Ipi = NULL,
};

static struct XPm_Proc *const ProcList[] = {
	&Proc_APU0_0,
	&Proc_APU0_1,
	&Proc_APU0_2,
	&Proc_APU0_3,
	&Proc_APU1_0,
	&Proc_APU1_1,
	&Proc_APU1_2,
	&Proc_APU1_3,
	&Proc_APU2_0,
	&Proc_APU2_1,
	&Proc_APU2_2,
	&Proc_APU2_3,
	&Proc_APU3_0,
	&Proc_APU3_1,
	&Proc_APU3_2,
	&Proc_APU3_3,
};

struct XPm_Proc *PrimaryProc = &Proc_APU0_0;
#elif defined (__arm__)
#define PM_RPU_CORE_COUNT_PER_CLUSTER	(2U)
#define PSX_RPU_CLUSTER_A_BASEADDR	(0xEB580000U)
#define PSX_RPU_CLUSTER_B_BASEADDR	(0xEB590000U)
#define PSX_RPU_CLUSTER_A0_BASEADDR	(0xEB588000U)
#define PSX_RPU_CLUSTER_A1_BASEADDR	(0xEB58C000U)
#define PSX_RPU_CLUSTER_B0_BASEADDR	(0xEB598000U)
#define PSX_RPU_CLUSTER_B1_BASEADDR	(0xEB59C000U)
#define RPU_PWRDWN_OFFSET		(0x80U)
#define CLUSTER_CFG_OFFSET		(0x0U)
#define RPU_PWRDWN_EN_MASK		(0x1U)
#define MPIDR_AFF0_SHIFT		(0U)
#define MPIDR_AFF1_SHIFT		(8U)
#define RPU_GLBL_CNTL_SLSPLIT_MASK	(0x1U)

static struct XPm_Proc Proc_RPU_A_0 = {
	.DevId = PM_DEV_RPU_A_0,
	.PwrCtrl = PSX_RPU_CLUSTER_A0_BASEADDR + RPU_PWRDWN_OFFSET,
	.PwrDwnMask = RPU_PWRDWN_EN_MASK,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_RPU_A_1 = {
	.DevId = PM_DEV_RPU_A_1,
	.PwrCtrl = PSX_RPU_CLUSTER_A1_BASEADDR + RPU_PWRDWN_OFFSET,
	.PwrDwnMask = RPU_PWRDWN_EN_MASK,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_RPU_B_0 = {
	.DevId = PM_DEV_RPU_B_0,
	.PwrCtrl = PSX_RPU_CLUSTER_B0_BASEADDR + RPU_PWRDWN_OFFSET,
	.PwrDwnMask = RPU_PWRDWN_EN_MASK,
	.Ipi = NULL,
};

static struct XPm_Proc Proc_RPU_B_1 = {
	.DevId = PM_DEV_RPU_B_1,
	.PwrCtrl = PSX_RPU_CLUSTER_B1_BASEADDR + RPU_PWRDWN_OFFSET,
	.PwrDwnMask = RPU_PWRDWN_EN_MASK,
	.Ipi = NULL,
};

static struct XPm_Proc *const ProcList[] = {
	&Proc_RPU_A_0,
	&Proc_RPU_A_1,
	&Proc_RPU_B_0,
	&Proc_RPU_B_1,
};

struct XPm_Proc *PrimaryProc = &Proc_RPU_A_0;
char ProcName[7] = "RPU";
static char RPU_LS_A[] = "RPU_A";
static char RPU_LS_B[] = "RPU_B";
static char RPU_A0[] = "RPU_A0";
static char RPU_A1[] = "RPU_A1";
static char RPU_B0[] = "RPU_B0";
static char RPU_B1[] = "RPU_B1";
#endif

/**
 *  XPm_SetPrimaryProc() - Set primary processor based on processor ID
 */
#ifndef __microblaze__
XStatus XPm_SetPrimaryProc(void)
{
	u32 ProcId;
	XStatus Status = (s32)XST_FAILURE;
	u64 CpuId;
	u64 ClusterId;

#if defined (__aarch64__)
	CpuId = (mfcp(MPIDR_EL1) >> MPIDR_AFF1_SHIFT) & MPIDR_AFFLVL_MASK;
	ClusterId = (mfcp(MPIDR_EL1) >> MPIDR_AFF2_SHIFT) & MPIDR_AFFLVL_MASK;
	ProcId = (((u32)ClusterId * PM_APU_CORE_COUNT_PER_CLUSTER) + (u32)CpuId);
#elif defined (__arm__)
	CpuId = (mfcp(XREG_CP15_MULTI_PROC_AFFINITY) >> MPIDR_AFF0_SHIFT) & MPIDR_AFFLVL_MASK;
	ClusterId = (mfcp(XREG_CP15_MULTI_PROC_AFFINITY) >> MPIDR_AFF1_SHIFT) & MPIDR_AFFLVL_MASK;
	ProcId = (((u32)ClusterId * PM_RPU_CORE_COUNT_PER_CLUSTER) + (u32)CpuId);
	if (PM_RPU_CORE_COUNT_PER_CLUSTER > ProcId) {
		if (0U == (XPm_Read(PSX_RPU_CLUSTER_A_BASEADDR + CLUSTER_CFG_OFFSET) & RPU_GLBL_CNTL_SLSPLIT_MASK)) {
			ProcId = 0U;
			Status = Xil_SMemCpy(ProcName, sizeof(RPU_LS_A), RPU_LS_A, sizeof(RPU_LS_A), sizeof(RPU_LS_A));
			if (XST_SUCCESS != Status) {
				goto done;
			}
			XPm_Dbg("Running in lock-step mode\r\n");
		} else {
			if (0U == ProcId) {
				Status = Xil_SMemCpy(ProcName, sizeof(RPU_A0), RPU_A0, sizeof(RPU_A0), sizeof(RPU_A0));
				if (XST_SUCCESS != Status) {
					goto done;
				}
			} else {
				Status = Xil_SMemCpy(ProcName, sizeof(RPU_A1), RPU_A1, sizeof(RPU_A1), sizeof(RPU_A1));
				if (XST_SUCCESS != Status) {
					goto done;
				}
			}
		}
	} else if ((PM_RPU_CORE_COUNT_PER_CLUSTER * 2U) > ProcId) {
		if (0U == (XPm_Read(PSX_RPU_CLUSTER_B_BASEADDR + CLUSTER_CFG_OFFSET) & RPU_GLBL_CNTL_SLSPLIT_MASK)) {
			ProcId = 2U;
			Status = Xil_SMemCpy(ProcName, sizeof(RPU_LS_B), RPU_LS_B, sizeof(RPU_LS_B), sizeof(RPU_LS_B));
			if (XST_SUCCESS != Status) {
				goto done;
			}
			XPm_Dbg("Running in lock-step mode\r\n");
		} else {
			if (2U == ProcId) {
				Status = Xil_SMemCpy(ProcName, sizeof(RPU_B0), RPU_B0, sizeof(RPU_B0), sizeof(RPU_B0));
				if (XST_SUCCESS != Status) {
					goto done;
				}
			} else {
				Status = Xil_SMemCpy(ProcName, sizeof(RPU_B1), RPU_B1, sizeof(RPU_B1), sizeof(RPU_B1));
				if (XST_SUCCESS != Status) {
					goto done;
				}
			}
		}
	} else {
		/* Required for MISRA */
	}
#endif

	Status = XST_SUCCESS;

	PrimaryProc = ProcList[ProcId];

#if defined (__arm__)
done:
#endif
	return Status;
}
#else
XStatus XPm_SetPrimaryProc(void)
{
	PrimaryProc = &Proc_MB_PL_0;
	return XST_SUCCESS;
}
#endif

#ifndef __microblaze__
struct XPm_Proc *XPm_GetProcByDeviceId(u32 DeviceId)
{
	struct XPm_Proc *Proc = NULL;
	u8 Idx;

	for (Idx = 0; Idx < XPM_ARRAY_SIZE(ProcList); Idx++) {
		if (DeviceId == ProcList[Idx]->DevId) {
			Proc = ProcList[Idx];
			break;
		}
	}

	return Proc;
}
#endif

void XPm_ClientSuspend(const struct XPm_Proc *const Proc)
{
	/* Disable interrupts at processor level */
	XpmDisableInterrupts();

#if defined (__arm__)
	u32 PwrDwnReg;
	/* Set powerdown request */
	PwrDwnReg = XPm_Read(Proc->PwrCtrl);
	PwrDwnReg |= Proc->PwrDwnMask;
	XPm_Write(Proc->PwrCtrl, PwrDwnReg);
#else
	u64 Val;
	Val = mfcp(S3_0_C15_C2_7);
	Val |= CORE_PWRDN_EN_BIT_MASK;
	mtcp(S3_0_C15_C2_7, Val);
	(void)Proc;
#endif
}

void XPm_ClientWakeUp(const struct XPm_Proc *const Proc)
{
#if defined (__arm__)
	if (NULL != Proc) {
		u32 Val;

		Val = XPm_Read(Proc->PwrCtrl);
		Val &= ~Proc->PwrDwnMask;
		XPm_Write(Proc->PwrCtrl, Val);
	}
#else
	u64 Val;
	Val = mfcp(S3_0_C15_C2_7);
	Val &= ~CORE_PWRDN_EN_BIT_MASK;
	mtcp(S3_0_C15_C2_7, Val);
	(void)Proc;
#endif
}

#ifndef __microblaze__
void XPm_ClientSuspendFinalize(void)
{
	u32 CtrlReg;

	/* Flush the data cache only if it is enabled */
#ifdef __aarch64__
	CtrlReg = (u32)mfcp(SCTLR_EL3);
	if (0U != (XREG_CONTROL_DCACHE_BIT & CtrlReg)) {
		Xil_DCacheFlush();
	}
#else
	CtrlReg = mfcp(XREG_CP15_SYS_CONTROL);
	if (0U != (XREG_CP15_CONTROL_C_BIT & CtrlReg)) {
		Xil_DCacheFlush();
	}
#endif

	XPm_Dbg("Going to WFI...\n");
	WFI;
	XPm_Dbg("WFI exit...\n");
}
#endif

void XPm_ClientAbortSuspend(void)
{
#if defined (__arm__)
	u32 PwrDwnReg;

	/* Clear powerdown request */
	PwrDwnReg = XPm_Read(PrimaryProc->PwrCtrl);
	PwrDwnReg &= ~PrimaryProc->PwrDwnMask;
	XPm_Write(PrimaryProc->PwrCtrl, PwrDwnReg);
#else
	u64 Val;
	Val = mfcp(S3_0_C15_C2_7);
	Val &= ~CORE_PWRDN_EN_BIT_MASK;
	mtcp(S3_0_C15_C2_7, Val);
#endif

	/* Enable interrupts at processor level */
	XpmEnableInterrupts();
}

/** @endcond */
