/******************************************************************************
* Copyright (c) 2018 - 2022 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/


#ifndef XPM_API_PLAT_H_
#define XPM_API_PLAT_H_

#include "xplmi_cmd.h"
#include "xil_types.h"
#include "xstatus.h"
#include "xpm_defs.h"
#include "xpm_nodeid.h"
#include "xpm_common.h"
#include "xpm_regs.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Persistent global general storage register base address */
#define PGGS_BASEADDR	(0xF1110050U)

typedef struct XPm_Subsystem XPm_Subsystem;

int XPm_RegisterWakeUpHandlers(void);


XStatus XPm_InitNode(u32 NodeId, u32 Function, const u32 *Args, u32 NumArgs);
XStatus XPm_HookAfterPlmCdo(void);

XStatus XPm_PlatAddNode(const u32 *Args, u32 NumArgs);

XStatus XPm_PlatFeatureCheck(const u32 ApiId, u32 *const Version);

int XPm_PlatProcessCmd(XPlmi_Cmd *Cmd, u32 *ApiResponse);

XStatus XPm_PlatQuery(const u32 Qid, const u32 Arg1, const u32 Arg2,
		  const u32 Arg3, u32 *const Output);
XStatus XPm_PlatAddDevRequirement(XPm_Subsystem *Subsystem, u32 DeviceId,
				     u32 ReqFlags, const u32 *Args, u32 NumArgs);

XStatus XPm_PlatAddNodePower(const u32 *Args, u32 NumArgs);

maybe_unused static inline XStatus XPm_PlatAddRequirement(const u32 *Args, const u32 NumArgs)
{
	(void)Args;
	(void)NumArgs;
	return XST_INVALID_PARAM;
}
maybe_unused static inline XStatus XPm_PlatAddDevice(const u32 *Args, u32 NumArgs)
{
	(void)Args;
	(void)NumArgs;
	return XST_INVALID_PARAM;
}

maybe_unused static inline XStatus XPm_PlatInit(void)
{
	return XST_SUCCESS;
};

maybe_unused static inline XStatus XPm_EnableDdrSr(const u32 SubsystemId)
{
	/*
	 * TODO: If subsystem is using DDR and NOC Power Domain is idle,
	 * enable self-refresh as post suspend requirement
	 */
	(void)SubsystemId;
	return XST_SUCCESS;
}
maybe_unused static inline XStatus XPm_DisableDdrSr(const u32 SubsystemId)
{
	/* TODO: If subsystem is using DDR, disable self-refresh */
	(void)SubsystemId;
	return XST_SUCCESS;
}
maybe_unused static inline void XPm_ClearScanClear(void)
{
	XPm_Out32(PSMX_GLOBAL_SCAN_CLEAR_TRIGGER, 0U);
	XPm_Out32(PSMX_GLOBAL_MEM_CLEAR_TRIGGER, 0U);
}
maybe_unused static inline XStatus IsOnSecondarySLR(u32 SubsystemId)
{
	(void)SubsystemId;
	return XST_FAILURE;
}
#ifdef __cplusplus
}
#endif

/** @} */
#endif /* XPM_API_PLAT_H_ */
