/******************************************************************************
* Copyright (c) 2022 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
*******************************************************************************/

/*****************************************************************************/
/**
*
* @file xsecure_plat_katclient.c
*
* This file contains the implementation of the client interface functions for
* KAT.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 5.0   kpt  07/18/22 Initial release
*
* </pre>
* @note
*
******************************************************************************/

/***************************** Include Files *********************************/
#include "xsecure_plat_katclient.h"
#include "xsecure_plat_defs.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/

/*****************************************************************************/
/**
 *
 * @brief	This function sends IPI request to PLM to perform TRNG KAT and health tests
 *
 * @param	InstancePtr  Pointer to the client instance
 *
 * @return
 *	-	XST_SUCCESS - When KAT Pass
 *	-	Errorcode - On failure
 *
 ******************************************************************************/
int XSecure_TrngKat(XSecure_ClientInstance *InstancePtr)
{
	volatile int Status = XST_FAILURE;
	u32 Payload[XSECURE_PAYLOAD_LEN_2U];

	if ((InstancePtr == NULL) || (InstancePtr->MailboxPtr == NULL)) {
		goto END;
	}

	/* Fill IPI Payload */
	Payload[0U] = HEADER(0U, XSECURE_API_KAT);
	Payload[1U] = (u32)XSECURE_API_TRNG_KAT;

	Status = XSecure_ProcessMailbox(InstancePtr->MailboxPtr, Payload, sizeof(Payload)/sizeof(u32));

END:
	return Status;
}

/*****************************************************************************/
/**
 *
 * @brief	This function sends IPI request to PLM to set
 *          or clear kat mask of KAT's running on CPM5N, NICSEC.
 *
 * @param	InstancePtr - Pointer to the client instance
 * @param   KatOp		- Operation to set or clear KAT mask
 * @param   KatId		- KAT id to be set or cleared
 *
 * @return
 *	-	XST_SUCCESS - On Success
 *	-	Errorcode - On failure
 *
 ******************************************************************************/
int XSecure_UpdateKatStatus(XSecure_ClientInstance *InstancePtr, XSecure_KatId KatOp, XSecure_KatId KatId) {
	volatile int Status = XST_FAILURE;
	u32 Payload[XSECURE_PAYLOAD_LEN_3U];

	if ((InstancePtr == NULL) || (InstancePtr->MailboxPtr == NULL)) {
		goto END;
	}

	if ((KatOp != XSECURE_API_KAT_SET) && (KatOp != XSECURE_API_KAT_CLEAR)) {
		goto END;
	}

	if ((KatId < XSECURE_API_CPM5N_AES_XTS) || (KatId > XSECURE_API_NICSEC_KAT)) {
		goto END;
	}

	/* Fill IPI Payload */
	Payload[0U] = HEADER(0U, XSECURE_API_KAT);
	Payload[1U] = (u32)KatOp;
	Payload[2U] = (u32)KatId;

	Status = XSecure_ProcessMailbox(InstancePtr->MailboxPtr, Payload, sizeof(Payload)/sizeof(u32));
END:
	return Status;
}
