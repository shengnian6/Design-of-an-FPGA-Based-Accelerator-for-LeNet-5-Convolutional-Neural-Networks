/******************************************************************************
* Copyright (c) 2018 - 2022 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

#include "xplmi.h"
#include "xplmi_error_node.h"
#include "xplmi_hw.h"
#include "xplmi_ipi.h"
#include "xplmi_scheduler.h"
#include "xplmi_sysmon.h"
#include "xplmi_util.h"
#include "xpm_api_plat.h"
#include "xpm_bisr.h"
#include "xpm_device.h"
#include "xpm_common.h"
#include "xpm_defs.h"
#include "xpm_err.h"
#include "xpm_nodeid.h"
#include "xpm_psm.h"
#include "xpm_regs.h"
#include "xpm_subsystem.h"
#include "xsysmonpsv.h"
#include "xpm_ioctl.h"
#include "xpm_ipi.h"
#include "xpm_psm_api.h"
#include "xpm_powerdomain.h"
#include "xpm_pmcdomain.h"
#include "xpm_pslpdomain.h"
#include "xpm_psfpdomain.h"
#include "xpm_cpmdomain.h"
#include "xpm_hnicxdomain.h"
#include "xpm_pldomain.h"
#include "xpm_npdomain.h"
#include "xpm_notifier.h"
#include "xpm_pll.h"
#include "xpm_reset.h"
#include "xpm_domain_iso.h"
#include "xpm_pmc.h"
#include "xpm_apucore.h"
#include "xpm_rpucore.h"
#include "xpm_psm.h"
#include "xpm_periph.h"
#include "xpm_requirement.h"
#include "xpm_mem.h"
#include "xpm_debug.h"
#include "xpm_pldevice.h"

#define XPm_RegisterWakeUpHandler(GicId, SrcId, NodeId)	\
	{ \
		Status = XPlmi_GicRegisterHandler(GicId, SrcId, \
				XPm_DispatchWakeHandler, (void *)(NodeId)); \
		if (Status != XST_SUCCESS) {\
			goto END;\
		}\
	}

/* Macro to typecast PM API ID */
#define PM_API(ApiId)			((u32)ApiId)

#define PM_IOCTL_FEATURE_BITMASK ( \
	(1ULL << (u64)IOCTL_GET_APU_OPER_MODE) | \
	(1ULL << (u64)IOCTL_SET_APU_OPER_MODE) | \
	(1ULL << (u64)IOCTL_GET_RPU_OPER_MODE) | \
	(1ULL << (u64)IOCTL_SET_RPU_OPER_MODE) | \
	(1ULL << (u64)IOCTL_RPU_BOOT_ADDR_CONFIG) | \
	(1ULL << (u64)IOCTL_SET_TAPDELAY_BYPASS) | \
	(1ULL << (u64)IOCTL_SD_DLL_RESET) | \
	(1ULL << (u64)IOCTL_SET_SD_TAPDELAY) | \
	(1ULL << (u64)IOCTL_SET_PLL_FRAC_MODE) | \
	(1ULL << (u64)IOCTL_GET_PLL_FRAC_MODE) | \
	(1ULL << (u64)IOCTL_SET_PLL_FRAC_DATA) | \
	(1ULL << (u64)IOCTL_GET_PLL_FRAC_DATA) | \
	(1ULL << (u64)IOCTL_WRITE_GGS) | \
	(1ULL << (u64)IOCTL_READ_GGS) | \
	(1ULL << (u64)IOCTL_WRITE_PGGS) | \
	(1ULL << (u64)IOCTL_READ_PGGS) | \
	(1ULL << (u64)IOCTL_SET_BOOT_HEALTH_STATUS) | \
	(1ULL << (u64)IOCTL_OSPI_MUX_SELECT) | \
	(1ULL << (u64)IOCTL_USB_SET_STATE) | \
	(1ULL << (u64)IOCTL_GET_LAST_RESET_REASON))

#define PM_QUERY_FEATURE_BITMASK ( \
	(1ULL << (u64)XPM_QID_CLOCK_GET_NAME) | \
	(1ULL << (u64)XPM_QID_CLOCK_GET_TOPOLOGY) | \
	(1ULL << (u64)XPM_QID_CLOCK_GET_FIXEDFACTOR_PARAMS) | \
	(1ULL << (u64)XPM_QID_CLOCK_GET_MUXSOURCES) | \
	(1ULL << (u64)XPM_QID_CLOCK_GET_ATTRIBUTES) | \
	(1ULL << (u64)XPM_QID_CLOCK_GET_NUM_CLOCKS) | \
	(1ULL << (u64)XPM_QID_CLOCK_GET_MAX_DIVISOR))

XStatus XPm_PlatAddDevRequirement(XPm_Subsystem *Subsystem, u32 DeviceId,
				     u32 ReqFlags, const u32 *Args, u32 NumArgs)
{
	XStatus Status = XST_FAILURE;
	u32 PreallocCaps, PreallocQoS;
	XPm_Device *Device = NULL;
	u32 Flags = ReqFlags;

	/* This is a general case for adding requirements */
	if (6U > NumArgs) {
		Status = XST_INVALID_PARAM;
		goto done;
	}
	(void)Args[3];	/* Args[3] is reserved */
	PreallocCaps = Args[4];
	PreallocQoS = Args[5];

	/* Device must be present in the topology at this point */
	Device = (XPm_Device *)XPmDevice_GetById(DeviceId);
	if (NULL == Device) {
		Status = XST_INVALID_PARAM;
		goto done;
	}
	Status = XPmRequirement_Add(Subsystem, Device, Flags, PreallocCaps, PreallocQoS);

done:
	return Status;
}

int XPm_PlatProcessCmd(XPlmi_Cmd *Cmd, u32 *ApiResponse)
{
	XStatus Status = XST_FAILURE;
	u32 CmdId = Cmd->CmdId & 0xFFU;
	const u32 *Pload = Cmd->Payload;
	u32 Len = Cmd->Len;

	(void)ApiResponse;

	switch (CmdId) {
	case PM_API(PM_BISR):
		Status =  XPmBisr_Repair(Pload[0]);
		break;
	case PM_API(PM_INIT_NODE):
		Status = XPm_InitNode(Pload[0], Pload[1], &Pload[2], Len-2U);
		break;
	case PM_API(PM_APPLY_TRIM):
		Status = XPm_PldApplyTrim(Pload[0]);
		break;
	default:
		PmErr("CMD: INVALID PARAM\r\n");
		Status = XST_INVALID_PARAM;
		break;
	}

	return Status;
}

/*****************************************************************************/
/**
 * @brief This is the handler for wake up interrupts
 *
 * @param  DeviceIdx	Index of peripheral device
 *
 * @return Status	XST_SUCCESS if processor wake successfully
 *			XST_FAILURE or error code in case of failure
 *
 *****************************************************************************/
static int XPm_DispatchWakeHandler(void *DeviceIdx)
{
	XStatus Status;

	Status = XPm_GicProxyWakeUp((u32)DeviceIdx);
	return Status;
}

/****************************************************************************/
/**
 * @brief Register wakeup handlers with XilPlmi
 * @return XST_SUCCESS on success and error code on failure
 ****************************************************************************/
int XPm_RegisterWakeUpHandlers(void)
{
	int Status = XST_FAILURE;

	/**
	 * Register the events for PM
	 */
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC23, XPM_NODEIDX_DEV_SPI_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC24, XPM_NODEIDX_DEV_SPI_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC25, XPM_NODEIDX_DEV_UART_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC26, XPM_NODEIDX_DEV_UART_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC29, XPM_NODEIDX_DEV_USB_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC30, XPM_NODEIDX_DEV_USB_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP0, (u32)XPLMI_GICP0_SRC31, XPM_NODEIDX_DEV_USB_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC0, XPM_NODEIDX_DEV_USB_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC1, XPM_NODEIDX_DEV_USB_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC2, XPM_NODEIDX_DEV_USB_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC3, XPM_NODEIDX_DEV_USB_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC4, XPM_NODEIDX_DEV_USB_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC5, XPM_NODEIDX_DEV_USB_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP1, (u32)XPLMI_GICP1_SRC6, XPM_NODEIDX_DEV_USB_1);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP5, (u32)XPLMI_GICP5_SRC24, XPM_NODEIDX_DEV_SDIO_0);
	XPm_RegisterWakeUpHandler((u32)XPLMI_PMC_GIC_IRQ_GICP5, (u32)XPLMI_GICP5_SRC25, XPM_NODEIDX_DEV_SDIO_0);

END:
	return Status;
}

/*****************************************************************************/
/**
 * @brief	This function is to link devices to the default subsystem.
 *
 * @return	XST_SUCCESS on success and error code on failure
 *
 *****************************************************************************/
static XStatus XPm_AddReqsDefaultSubsystem(XPm_Subsystem *Subsystem)
{
	XStatus Status = XST_FAILURE;
	u32 i = 0, j = 0UL, Prealloc = 0, Capability = 0;
	const XPm_Requirement *Req = NULL;
	const u32 DefaultPreallocDevList[][2] = {
		{PM_DEV_PSM_PROC, (u32)PM_CAP_ACCESS},
		{PM_DEV_UART_0, (u32)XPM_MAX_CAPABILITY},
		{PM_DEV_UART_1, (u32)XPM_MAX_CAPABILITY},
		{PM_DEV_ACPU_0_0, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_0_1, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_0_2, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_0_3, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_1_0, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_1_1, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_1_2, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_1_3, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_2_0, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_2_1, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_2_2, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_2_3, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_3_0, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_3_1, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_3_2, (u32)PM_CAP_ACCESS},
		{PM_DEV_ACPU_3_3, (u32)PM_CAP_ACCESS},
		{PM_DEV_SDIO_0, (u32)PM_CAP_ACCESS | (u32)PM_CAP_SECURE},
		{PM_DEV_QSPI, (u32)PM_CAP_ACCESS | (u32)PM_CAP_SECURE},
		{PM_DEV_OSPI, (u32)PM_CAP_ACCESS | (u32)PM_CAP_SECURE},
		{PM_DEV_RPU_A_0, (u32)PM_CAP_ACCESS | (u32)PM_CAP_SECURE},
		{PM_DEV_RPU_B_0, (u32)PM_CAP_ACCESS | (u32)PM_CAP_SECURE},
		{PM_DEV_IPI_0, (u32)PM_CAP_ACCESS},
		{PM_DEV_IPI_1, (u32)PM_CAP_ACCESS},
		{PM_DEV_IPI_2, (u32)PM_CAP_ACCESS},
		{PM_DEV_IPI_3, (u32)PM_CAP_ACCESS},
		{PM_DEV_IPI_4, (u32)PM_CAP_ACCESS},
		{PM_DEV_IPI_5, (u32)PM_CAP_ACCESS},
		{PM_DEV_IPI_6, (u32)PM_CAP_ACCESS},
	};

	/*
	 * Only fill out default subsystem requirements:
	 *   - if no proc/mem/periph requirements are present
	 *   - if only 1 subsystem has been added
	 */
	Req = Subsystem->Requirements;
	while (NULL != Req) {
		u32 SubClass = NODESUBCLASS(Req->Device->Node.Id);
		/**
		 * Requirements can be present for non-plm managed nodes in PMC CDO
		 * (e.g. regnodes, ddrmcs etc.), thus only check for proc/mem/periph
		 * requirements which are usually present in subsystem definition;
		 * and stop as soon as first such requirement is found.
		 */
		if (((u32)XPM_NODESUBCL_DEV_CORE == SubClass) ||
		    ((u32)XPM_NODESUBCL_DEV_PERIPH == SubClass) ||
		    ((u32)XPM_NODESUBCL_DEV_MEM == SubClass)) {
			Status = XST_SUCCESS;
			break;
		}
		Req = Req->NextDevice;
	}
	if (XST_SUCCESS ==  Status) {
		goto done;
	}

	for (i = 0; i < (u32)XPM_NODEIDX_DEV_MAX; i++) {
		/*
		 * Note: XPmDevice_GetByIndex() assumes that the caller
		 * is responsible for validating the Node ID attributes
		 * other than node index.
		 */
		XPm_Device *Device = XPmDevice_GetByIndex(i);
		if ((NULL != Device) && (1U == XPmDevice_IsRequestable(Device->Node.Id))) {
			Prealloc = 0;
			Capability = 0;

			for (j = 0; j < ARRAY_SIZE(DefaultPreallocDevList); j++) {
				if (Device->Node.Id == DefaultPreallocDevList[j][0]) {
					Prealloc = 1;
					Capability = DefaultPreallocDevList[j][1];
					break;
				}
			}
			/**
			 * Since default subsystem is hard-coded for now, add security policy
			 * for all peripherals as REQ_ACCESS_SECURE. This allows any device
			 * with a _master_ port to be requested in secure mode if the topology
			 * supports it.
			 */
			Status = XPmRequirement_Add(Subsystem, Device,
					REQUIREMENT_FLAGS(Prealloc,
						(u32)REQ_ACCESS_SECURE,
						(u32)REQ_NO_RESTRICTION),
					Capability, XPM_DEF_QOS);
			if (XST_SUCCESS != Status) {
				goto done;
			}
		}
	}

	/* Add reset permissions */
	Status = XPmReset_AddPermForGlobalResets(Subsystem);
	if (XST_SUCCESS != Status) {
		goto done;
	}

	Status = XST_SUCCESS;

done:
	return Status;
}

XStatus XPm_HookAfterPlmCdo(void)
{
	XStatus Status = XST_FAILURE;
	XPm_Subsystem *Subsystem;

	/* If default subsystem is present, attempt to add requirements if needed. */
	Subsystem = XPmSubsystem_GetById(PM_SUBSYS_DEFAULT);
	if (((u32)1U == XPmSubsystem_GetMaxSubsysIdx()) && (NULL != Subsystem) &&
	    ((u8)ONLINE == Subsystem->State)) {
		Status = XPm_AddReqsDefaultSubsystem(Subsystem);
		if (XST_SUCCESS != Status) {
			goto done;
		}
	}

	Status = XST_SUCCESS;

done:
	return Status;
}

static XStatus PldInitNode(u32 NodeId, u32 Function, const u32 *Args, u32 NumArgs)
{
	XStatus Status = XST_FAILURE;
	u16 DbgErr = XPM_INT_ERR_UNDEFINED;
	XPm_PlDevice *PlDevice = NULL;

	PlDevice = (XPm_PlDevice *)XPmDevice_GetById(NodeId);
	if (NULL == PlDevice) {
		DbgErr = XPM_INT_ERR_INVALID_NODE;
		goto done;
	}

	if (NULL == PlDevice->Ops) {
		DbgErr = XPM_INT_ERR_NO_FEATURE;
		goto done;
	}

	switch (Function) {
	case (u32)FUNC_INIT_START:
		if (NULL == PlDevice->Ops->InitStart) {
			DbgErr = XPM_INT_ERR_NO_FEATURE;
			goto done;
		}
		Status = PlDevice->Ops->InitStart(PlDevice, Args, NumArgs);
		break;
	case (u32)FUNC_INIT_FINISH:
		if (NULL == PlDevice->Ops->InitFinish) {
			DbgErr = XPM_INT_ERR_NO_FEATURE;
			goto done;
		}
		Status = PlDevice->Ops->InitFinish(PlDevice, Args, NumArgs);
		if (XST_SUCCESS != Status) {
			goto done;
		}
		Status = XPmDomainIso_ProcessPending();
		if (XST_SUCCESS != Status) {
			DbgErr = XPM_INT_ERR_DOMAIN_ISO;
			goto done;
		}
		break;
	default:
		DbgErr = XPM_INT_ERR_INVALID_FUNC;
		break;
	}

done:
	XPm_PrintDbgErr(Status, DbgErr);
	return Status;
}

/****************************************************************************/
/**
 * @brief  This function allows to initialize the node.
 *
 * @param  NodeId	Supported power domain nodes, PLD, AIE & Protection
 * nodes
 * @param  Function	Function id
 * @param  Args		Arguments speicifc to function
 * @param  NumArgs  Number of arguments
 *
 * @return XST_SUCCESS if successful else XST_FAILURE or an error code
 * or a reason code
 *
 * @note   none
 *
 ****************************************************************************/
XStatus XPm_InitNode(u32 NodeId, u32 Function, const u32 *Args, u32 NumArgs)
{
	//changed to support minimum boot time xilpm

	XStatus Status = XST_FAILURE;
	PmDbg("NodeId: %x,Function %x\n",NodeId,Function);
	if((XPM_NODEIDX_POWER_LPD == NODEINDEX(NodeId))&&(FUNC_INIT_FINISH == Function)){
		/*
		 * Mark domain init status bit in DomainInitStatusReg
		 */
		XPm_RMW32(XPM_DOMAIN_INIT_STATUS_REG,0x2,0x2);
		XPlmi_LpdInit();
	#ifdef XPLMI_IPI_DEVICE_ID
		Status = XPlmi_IpiInit(XPmSubsystem_GetSubSysIdByIpiMask);
		if (XST_SUCCESS != Status) {
			PmErr("Error %u in IPI initialization\r\n", Status);
		}
	#else
		PmWarn("IPI is not enabled in design\r\n");
	#endif /* XPLMI_IPI_DEVICE_ID */
	}else if (((u32)XPM_NODECLASS_DEVICE == NODECLASS(NodeId)) &&
		  ((u32)XPM_NODESUBCL_DEV_PL == NODESUBCLASS(NodeId)) &&
		  ((u32)XPM_NODEIDX_DEV_PLD_MAX > NODEINDEX(NodeId))) {
		Status = PldInitNode(NodeId, Function, Args, NumArgs);
		Status = XST_SUCCESS;
		goto done;
	}else{
		PmErr("UnSupported Node %x\n",NodeId);
		Status = XPM_PM_INVALID_NODE;
		goto done;
	}

	Status = XST_SUCCESS;
done:
	return Status;

}

/****************************************************************************/
/**
 * @brief  This function queries information about the platform resources.
 *
 * @param Qid		The type of data to query
 * @param Arg1		Query argument 1
 * @param Arg2		Query argument 2
 * @param Arg3		Query argument 3
 * @param Output	Pointer to the output data
 *
 * @return XST_SUCCESS if successful else XST_FAILURE or an error code
 * or a reason code
 *
 ****************************************************************************/
XStatus XPm_PlatQuery(const u32 Qid, const u32 Arg1, const u32 Arg2,
		  const u32 Arg3, u32 *const Output)
{
	XStatus Status = XST_FAILURE;

	/* Warning Fix */
	(void) (Arg1);
	(void) (Arg2);
	(void) (Arg3);
	(void) (Output);

	switch (Qid) {
	case (u32)XPM_QID_PINCTRL_GET_NUM_PINS:
	case (u32)XPM_QID_PINCTRL_GET_NUM_FUNCTIONS:
	case (u32)XPM_QID_PINCTRL_GET_NUM_FUNCTION_GROUPS:
	case (u32)XPM_QID_PINCTRL_GET_FUNCTION_NAME:
	case (u32)XPM_QID_PINCTRL_GET_FUNCTION_GROUPS:
	case (u32)XPM_QID_PINCTRL_GET_PIN_GROUPS:
	case (u32)XPM_QID_PLD_GET_PARENT:
		Status = XST_NO_FEATURE;
		break;
	default:
		Status = XST_INVALID_PARAM;
		break;
	}

	return Status;
}

/****************************************************************************/
/**
 * @brief  This function add isolation node to isolation topology database
 *
 * @param Args		pointer to isolation node arguments or payload
 * @param NumArgs	number of arguments or words in payload
 *
 * Format of payload/args (word aligned):
 *
 * +--------------------------------------------------------------------+
 * |Isolation Node ID(Node id include  class , subclass, type and Index)|
 * +--------------------------------------------+-----------------------+
 * |               rsvd[31:8]                   |      Format[7:0]      |
 * +--------------------------------------------+-----------------------+
 * |              Format specific payload (can be multiple words)       |
 * |                               ...                                  |
 * +--------------------------------------------+-----------------------+
 * |               rsvd[31:8]                   |      Format[7:0]      |
 * +--------------------------------------------+-----------------------+
 * |              Format specific payload (can be multiple words)       |
 * |                               ...                                  |
 * +--------------------------------------------------------------------+
 * |                               .                                    |
 * |                               .                                    |
 * |                               .                                    |
 * +--------------------------------------------------------------------+
 * Format entry for single word isolation control:
 * +--------------------------------------------+-----------------------+
 * |               rsvd[31:8]                   |      Format[7:0]      |
 * +--------------------------------------------+-----------------------+
 * |                           BaseAddress                              |
 * +--------------------------------------------------------------------+
 * |                           Mask                                     |
 * +--------------------------------------------------------------------+
 *
 * Format entry for power domain dependencies:
 * +----------------+----------------------------+----------------------+
 * | rsvd[31:16]    | Dependencies Count[15:8]   |      Format[7:0]     |
 * +-------------- -+ ---------------------------+----------------------+
 * |                   NodeID of Dependency0                            |
 * +--------------------------------------------------------------------+
 * |                           ...                                      |
 * +--------------------------------------------------------------------+
 *
 * @return XST_SUCCESS if successful else XST_FAILURE or an error code
 * or a reason code
 *
 * @note   None
 *
 ****************************************************************************/
static XStatus XPm_AddNodeIsolation(const u32 *Args, u32 NumArgs)
{
	XStatus Status = XST_FAILURE;
	if (3U > NumArgs) {
		Status = XST_INVALID_PARAM;
		goto done;
	}
	/* Start at beginning of the payload*/
	u32 Index = 0U;
	/* NodeID is always at the first word in payload*/
	u32 NodeId = Args[Index++];

	u32 Dependencies[PM_ISO_MAX_NUM_DEPENDENCIES] = {0U};
	u32 BaseAddr = 0U, Mask = 0U, NumDependencies = 0U;
	XPm_IsoPolarity Polarity = ACTIVE_HIGH;
	u8 Psm = (u8)0;

	XPm_IsoCdoArgsFormat Format = SINGLE_WORD_ACTIVE_LOW;
	while(Index < NumArgs) {
		/* Extract format and number of dependencies*/
		Format = (XPm_IsoCdoArgsFormat)CDO_ISO_ARG_FORMAT(Args[Index]);
		NumDependencies = CDO_ISO_DEP_COUNT(Args[Index++]);

		switch (Format){
		case SINGLE_WORD_ACTIVE_LOW:
		case SINGLE_WORD_ACTIVE_HIGH:
		case PSM_SINGLE_WORD_ACTIVE_LOW:
		case PSM_SINGLE_WORD_ACTIVE_HIGH:
			/* Format for isolation control by single word*/
			if (Format == SINGLE_WORD_ACTIVE_LOW || \
			    Format == PSM_SINGLE_WORD_ACTIVE_LOW){
				Polarity = ACTIVE_LOW;
			}

			if (Format == PSM_SINGLE_WORD_ACTIVE_HIGH || \
			    Format == PSM_SINGLE_WORD_ACTIVE_LOW){
				Psm =  (u8)1;
			}

			/* Extract BaseAddress and Mask*/
			BaseAddr = Args[Index++];
			Mask = Args[Index++];
			break;
		case POWER_DOMAIN_DEPENDENCY:
			/* Format power domain dependencies*/
			/* To save space in PMC RAM we statically allocate Dependencies list*/
			if (NumDependencies > PM_ISO_MAX_NUM_DEPENDENCIES){
				Status = XPM_INT_ERR_ISO_MAX_DEPENDENCIES;
				goto done;
			}else {
				for (u32 i = 0U ; i < NumDependencies; i++){
					Dependencies[i] = Args[Index++];
				}
			}
			break;
		default:
			Status = XPM_INT_ERR_ISO_INVALID_FORMAT;
			goto done;
		}
	}

	Status = XPmDomainIso_NodeInit(NodeId, BaseAddr, Mask, \
				       Psm, Polarity, Dependencies, NumDependencies);
done:
	return Status;
}

XStatus XPm_PlatAddNodePower(const u32 *Args, u32 NumArgs)
{
	XStatus Status = XST_FAILURE;
	u32 PowerId;
	u32 PowerType;
	u8 Width;
	u8 Shift;
	u32 BitMask;
	u32 ParentId;
	XPm_Power *PowerParent = NULL;
	XPm_HnicxDomain *HnicxDomain;

	if (1U > NumArgs) {
		Status = XST_INVALID_PARAM;
		goto done;
	}

	PowerId = Args[0];
	PowerType = NODETYPE(PowerId);
	Width = (u8)(Args[1] >> 8) & 0xFFU;
	Shift = (u8)(Args[1] & 0xFFU);
	ParentId = Args[2];

	if ((NODEINDEX(PowerId) >= (u32)XPM_NODEIDX_POWER_MAX)) {
		Status = XST_INVALID_PARAM;
		goto done;
	}

	BitMask = BITNMASK(Shift, Width);

	if ((ParentId != (u32)XPM_NODEIDX_POWER_MIN)) {
		if (NODECLASS(ParentId) != (u32)XPM_NODECLASS_POWER) {
			Status = XST_INVALID_PARAM;
			goto done;
		} else if (NODEINDEX(ParentId) >= (u32)XPM_NODEIDX_POWER_MAX) {
			Status = XST_DEVICE_NOT_FOUND;
			goto done;
		} else {
			/* Required by MISRA */
		}

		PowerParent = XPmPower_GetById(ParentId);
		if (NULL == PowerParent) {
			Status = XST_DEVICE_NOT_FOUND;
			goto done;
		}
	}

	switch (PowerType) {
	case (u32)XPM_NODETYPE_POWER_DOMAIN_HNICX:
		HnicxDomain = (XPm_HnicxDomain *)XPm_AllocBytes(sizeof(XPm_HnicxDomain));
		if (NULL == HnicxDomain) {
			Status = XST_BUFFER_TOO_SMALL;
			goto done;
		}
		Status = XPmHnicxDomain_Init(HnicxDomain, PowerId, BitMask, PowerParent);
		break;
	default:
		Status = XST_INVALID_PARAM;
		break;
	}

done:
	return Status;
}

XStatus XPm_PlatAddNode(const u32 *Args, u32 NumArgs)
{
	XStatus Status = XST_FAILURE;
	u32 Id = Args[0];

	switch (NODECLASS(Id)) {
	case (u32)XPM_NODECLASS_ISOLATION:
		Status = XPm_AddNodeIsolation(Args, NumArgs);
		break;
	default:
		Status = XST_INVALID_PARAM;
		break;
	}

	return Status;
}

/****************************************************************************/
/**
 * @brief  This function returns supported version of the given API.
 *
 * @param  ApiId	API ID to check
 * @param  Version	pointer to array of 4 words
 *  - version[0] - EEMI API version number
 *  - version[1] - lower 32-bit bitmask of IOCTL or QUERY ID
 *  - version[2] - upper 32-bit bitmask of IOCTL or Query ID
 *  - Only PM_FEATURE_CHECK version 2 supports 64-bit bitmask
 *  - i.e. version[1] and version[2]
 * @return XST_SUCCESS if successful else XST_NO_FEATURE.
 *
 * @note   None
 *
 ****************************************************************************/
XStatus XPm_PlatFeatureCheck(const u32 ApiId, u32 *const Version)
{
	XStatus Status = XST_FAILURE;

	switch (ApiId) {
	case PM_API(PM_BISR):
	case PM_API(PM_APPLY_TRIM):
	case PM_API(PM_FEATURE_CHECK):
		*Version = XST_API_BASE_VERSION;
		Status = XST_SUCCESS;
		break;
	case PM_API(PM_QUERY_DATA):
		Version[0] = XST_API_QUERY_DATA_VERSION;
		Version[1] = (u32)(PM_QUERY_FEATURE_BITMASK);
		Version[2] = (u32)(PM_QUERY_FEATURE_BITMASK >> 32);
		Status = XST_SUCCESS;
		break;
	case PM_API(PM_IOCTL):
		Version[0] = XST_API_PM_IOCTL_VERSION;
		Version[1] = (u32)(PM_IOCTL_FEATURE_BITMASK);
		Version[2] = (u32)(PM_IOCTL_FEATURE_BITMASK >> 32);
		Status = XST_SUCCESS;
		break;
	default:
		*Version = 0U;
		Status = XPM_NO_FEATURE;
		break;
	}

	return Status;
}
