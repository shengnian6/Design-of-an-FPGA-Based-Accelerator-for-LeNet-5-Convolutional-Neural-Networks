/******************************************************************************
* Copyright (c) 2022 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/


/*****************************************************************************/
/**
*
* @file xsecure_plat_kat.c
*
* This file contains known answer tests for versal net
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date        Changes
* ----- ---- ---------- -------------------------------------------------------
* 5.0   kpt  07/15/2022 Initial release
*
* </pre>
*
* @note
*
******************************************************************************/

/***************************** Include Files *********************************/
#include "xsecure_plat_kat.h"
#include "xsecure_rsa.h"
#include "xsecure_hmac.h"
#include "xsecure_error.h"
#include "xil_util.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

#define XSECURE_TRNG_KAT_DEFAULT_DF_lENGTH	7U
#define XSECURE_TRNG_KAT_DEFAULT_SEED_LIFE	2U
#define XSECURE_TRNG_KAT_SEED_LEN_IN_BYTES	128U

/************************** Function Prototypes ******************************/

static int XSecure_TrngHealthTest(XSecure_TrngInstance *InstancePtr);

/************************** Variable Definitions *****************************/

/*****************************************************************************/
/**
 * This function performs KAT on HMAC (SHA3-384).
 *
 * @param 	none
 *
 * @return	returns the error codes
 *		returns XST_SUCCESS on success
 *
 *****************************************************************************/
int XSecure_HmacKat(XSecure_Sha3 *SecureSha3)
{
	volatile int Status = XST_FAILURE;
	volatile u32 Index;
	XSecure_HmacRes Hmac = {0U};
	XSecure_Hmac HmacInstance;
	const u8 HmacExpected[XSECURE_HASH_SIZE_IN_BYTES] = {
		0x0E,0x1D,0x1E,0x2A,0x22,0x6F,0xB9,0x56,
		0x10,0x4F,0x10,0x00,0x8A,0x50,0xE3,0x5E,
		0xAB,0x2E,0x37,0xB5,0xE0,0x9F,0xA1,0x68,
		0x2F,0xE4,0x93,0x59,0x71,0x96,0xCC,0x1B,
		0x40,0xFD,0xCB,0xDD,0x93,0x4F,0x01,0x3A,
		0xB2,0x64,0xE9,0xC5,0x2B,0xB0,0x2E,0x52
	};
	u8 *HmacKey = XSecure_GetKatAesKey();
	u8 *HmacMsg = XSecure_GetKatMessage();

	Status = XSecure_HmacInit(&HmacInstance, SecureSha3,
				(UINTPTR)HmacKey, XSECURE_KAT_KEY_SIZE_IN_BYTES);
	if (Status != XST_SUCCESS) {
		Status = XSECURE_HMAC_KAT_INIT_ERROR;
		goto END;
	}
	Status = XSecure_HmacUpdate(&HmacInstance, (UINTPTR)HmacMsg,
				XSECURE_KAT_MSG_LEN_IN_BYTES);
	if (Status != XST_SUCCESS) {
		Status = XSECURE_HMAC_KAT_UPDATE_ERROR;
		goto END;
	}
	Status = XSecure_HmacFinal(&HmacInstance, &Hmac);
	if (Status != XST_SUCCESS) {
		Status = XSECURE_HMAC_KAT_FINAL_ERROR;
		goto END;
	}
	Status = XSECURE_HMAC_KAT_ERROR;
	for(Index = 0U; Index < XSECURE_HASH_SIZE_IN_BYTES; Index++) {
		if (HmacExpected[Index] != Hmac.Hash[Index]) {
			Status = XSECURE_HMAC_KAT_ERROR;
			goto END;
		}
	}

	if(Index == XSECURE_HASH_SIZE_IN_BYTES) {
		Status = XST_SUCCESS;
	}
END:
	(void)memset((void *)Hmac.Hash, (u32)0,
			XSECURE_HASH_SIZE_IN_BYTES);

	return Status;
}

/*************************************************************************************************/
/**
 * @brief
 * This function runs DRBG self test i.e DRBG full cycle Instantiate+Reseed, Reseed and Generate
 *
 * @param	InstancePtr Pointer to XSecure_TrngInstance.
 *
 * @return
 * 		- XST_SUCCESS On success
 * 		- Error Code On failure
 *
 **************************************************************************************************/
int XSecure_TrngDRBGKat(XSecure_TrngInstance *InstancePtr) {
	volatile int Status = XST_FAILURE;
	XSecure_TrngUserConfig UsrCfg;
	u8 RandBuf[XSECURE_TRNG_SEC_STRENGTH_IN_BYTES];

	const u8 ExtSeed[XSECURE_TRNG_KAT_SEED_LEN_IN_BYTES] = {
			0x3BU, 0xC3U, 0xEDU, 0x64U, 0xF4U, 0x80U, 0x1CU, 0xC7U,
			0x14U, 0xCCU, 0x35U, 0xEDU, 0x57U, 0x01U, 0x2AU, 0xE4U,
			0xBCU, 0xEFU, 0xDEU, 0xF6U, 0x7CU, 0x46U, 0xA6U, 0x34U,
			0xC6U, 0x79U, 0xE8U, 0x91U, 0x5DU, 0xB1U, 0xDBU, 0xA7U,
			0x49U, 0xA5U, 0xBBU, 0x4FU, 0xEDU, 0x30U, 0xB3U, 0x7BU,
			0xA9U, 0x8BU, 0xF5U, 0x56U, 0x4DU, 0x40U, 0x18U, 0x9FU,
			0x66U, 0x4EU, 0x39U, 0xC0U, 0x60U, 0xC8U, 0x8EU, 0xF4U,
			0x1CU, 0xB9U, 0x9DU, 0x7BU, 0x97U, 0x8BU, 0x69U, 0x62U,
			0x45U, 0x0CU, 0xD4U, 0x85U, 0xFCU, 0xDCU, 0x5AU, 0x2BU,
			0xFDU, 0xABU, 0x92U, 0x4AU, 0x12U, 0x52U, 0x7DU, 0x45U,
			0xD2U, 0x61U, 0x0AU, 0x06U, 0x74U, 0xA7U, 0x88U, 0x36U,
			0x4BU, 0xA2U, 0x65U, 0xEEU, 0x71U, 0x0BU, 0x5AU, 0x4EU,
			0x33U, 0xB2U, 0x7AU, 0x2EU, 0xC0U, 0xA6U, 0xF2U, 0x7DU,
			0xBDU, 0x7DU, 0xDFU, 0x07U, 0xBBU, 0xE2U, 0x86U, 0xFFU,
			0xF0U, 0x8EU, 0xA4U, 0xB1U, 0x46U, 0xDBU, 0xF7U, 0x8CU,
			0x3CU, 0x62U, 0x4DU, 0xF0U, 0x51U, 0x50U, 0xE7U, 0x85U
	};

	const u8 ReseedEntropy[XSECURE_TRNG_KAT_SEED_LEN_IN_BYTES] = {
			0xDFU, 0x5EU, 0x4DU, 0x4FU, 0x38U, 0x9EU, 0x2AU, 0x3EU,
			0xF2U, 0xABU, 0x46U, 0xE3U, 0xA0U, 0x26U, 0x77U, 0x84U,
			0x0BU, 0x9DU, 0x29U, 0xB0U, 0x5DU, 0xCEU, 0xC8U, 0xC3U,
			0xF9U, 0x4DU, 0x32U, 0xF7U, 0xBAU, 0x6FU, 0xA3U, 0xB5U,
			0x35U, 0xCBU, 0xC7U, 0x5CU, 0x62U, 0x48U, 0x01U, 0x65U,
			0x3AU, 0xAAU, 0x34U, 0x2DU, 0x89U, 0x6EU, 0xEFU, 0x6FU,
			0x69U, 0x96U, 0xE7U, 0x84U, 0xDAU, 0xEFU, 0x4EU, 0xBEU,
			0x27U, 0x4EU, 0x9FU, 0x88U, 0xB1U, 0xA0U, 0x7FU, 0x83U,
			0xDBU, 0x4AU, 0xA9U, 0x42U, 0x01U, 0xF1U, 0x84U, 0x71U,
			0xA9U, 0xEFU, 0xB9U, 0xE8U, 0x7FU, 0x81U, 0xC7U, 0xC1U,
			0x6CU, 0x5EU, 0xACU, 0x00U, 0x47U, 0x34U, 0xA1U, 0x75U,
			0xC0U, 0xE8U, 0x7FU, 0x48U, 0x00U, 0x45U, 0xC9U, 0xE9U,
			0x41U, 0xE3U, 0x8DU, 0xD8U, 0x4AU, 0x63U, 0xC4U, 0x94U,
			0x77U, 0x59U, 0xD9U, 0x50U, 0x2AU, 0x1DU, 0x4CU, 0x47U,
			0x64U, 0xA6U, 0x66U, 0x60U, 0x16U, 0xE7U, 0x29U, 0xC0U,
			0xB1U, 0xCFU, 0x3BU, 0x3FU, 0x54U, 0x49U, 0x31U, 0xD4U
	};

	const u8 PersString[XSECURE_TRNG_PERS_STRING_LEN_IN_BYTES] = {
			0xB2U, 0x80U, 0x7EU, 0x4CU, 0xD0U, 0xE4U, 0xE2U, 0xA9U,
			0x2FU, 0x1FU, 0x5DU, 0xC1U, 0xA2U, 0x1FU, 0x40U, 0xFCU,
			0x1FU, 0x24U, 0x5DU, 0x42U, 0x61U, 0x80U, 0xE6U, 0xE9U,
			0x71U, 0x05U, 0x17U, 0x5BU, 0xAFU, 0x70U, 0x30U, 0x18U,
			0xBCU, 0x23U, 0x18U, 0x15U, 0xCBU, 0xB8U, 0xA6U, 0x3EU,
			0x83U, 0xB8U, 0x4AU, 0xFEU, 0x38U, 0xFCU, 0x25U, 0x87U
	};

	const u8 ExpectedOutput[XSECURE_TRNG_SEC_STRENGTH_IN_BYTES] = {
			0xEEU, 0xA7U, 0x5BU, 0xB6U, 0x2BU, 0x97U, 0xF0U, 0xC0U,
			0x0FU, 0xD6U, 0xABU, 0x13U, 0x00U, 0x87U, 0x7EU, 0xF4U,
			0x00U, 0x7FU, 0xD7U, 0x56U, 0xFEU, 0xE5U, 0xDFU, 0xA6U,
			0x55U, 0x5BU, 0xB2U, 0x86U, 0xDDU, 0x81U, 0x73U, 0xB2U
	};

	Status = Xil_SMemSet(&UsrCfg, sizeof(XSecure_TrngUserConfig), 0U, sizeof(XSecure_TrngUserConfig));
	if (Status != XST_SUCCESS) {
		goto END;
	}

	UsrCfg.DFLength = XSECURE_TRNG_KAT_DEFAULT_DF_lENGTH;
	UsrCfg.Mode = XSECURE_TRNG_DRNG_MODE;
	UsrCfg.SeedLife = XSECURE_TRNG_KAT_DEFAULT_SEED_LIFE;
	UsrCfg.AdaptPropTestCutoff = XSECURE_TRNG_USER_CFG_ADAPT_TEST_CUTOFF;
	UsrCfg.RepCountTestCutoff = XSECURE_TRNG_USER_CFG_REP_TEST_CUTOFF;

	Status = XSecure_TrngInstantiate(InstancePtr, ExtSeed, XSECURE_TRNG_KAT_SEED_LEN_IN_BYTES, PersString,
			&UsrCfg);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	Status = XSecure_TrngReseed(InstancePtr, ReseedEntropy, UsrCfg.DFLength);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	Status = XSecure_TrngGenerate(InstancePtr, RandBuf, XSECURE_TRNG_SEC_STRENGTH_IN_BYTES);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	Status = Xil_SMemCmp(ExpectedOutput, XSECURE_TRNG_SEC_STRENGTH_IN_BYTES, RandBuf, XSECURE_TRNG_SEC_STRENGTH_IN_BYTES,
			XSECURE_TRNG_SEC_STRENGTH_IN_BYTES);
	if (Status != XST_SUCCESS) {
		Status = XSECURE_TRNG_KAT_FAILED_ERROR;
		goto END;
	}

	Status = XSecure_TrngUninstantiate(InstancePtr);
	if (Status != XST_SUCCESS) {
		goto END;
	}

END:
	return Status;
}

/*************************************************************************************************/
/**
 * @brief
 * This function runs health tests
 *
 * @param	InstancePtr Pointer to XSecure_TrngInstance.
 *
 * @return
 * 		- XST_SUCCESS On success
 * 		- Error Code On failure
 *
 **************************************************************************************************/
static int XSecure_TrngHealthTest(XSecure_TrngInstance *InstancePtr) {
	volatile int Status = XST_FAILURE;
	XSecure_TrngUserConfig UsrCfg;

	UsrCfg.Mode = XSECURE_TRNG_HRNG_MODE;
	UsrCfg.AdaptPropTestCutoff = XSECURE_TRNG_USER_CFG_ADAPT_TEST_CUTOFF;
	UsrCfg.RepCountTestCutoff = XSECURE_TRNG_USER_CFG_REP_TEST_CUTOFF;
	UsrCfg.DFLength = XSECURE_TRNG_USER_CFG_DF_LENGTH;
	UsrCfg.SeedLife = XSECURE_TRNG_USER_CFG_SEED_LIFE;

	Status = XSecure_TrngInstantiate(InstancePtr, NULL, 0U, NULL, &UsrCfg);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	Status = XSecure_TrngUninstantiate(InstancePtr);
	if (Status != XST_SUCCESS) {
		goto END;
	}

END:
	return Status;
}

/*************************************************************************************************/
/**
 * @brief
 * This function runs preoperational self tests and updates TRNG error state
 *
 * @param	InstancePtr Pointer to XSecure_TrngInstance.
 *
 * @return
 * 		- XST_SUCCESS On success
 * 		- Error Code On failure
 *
 **************************************************************************************************/
int XSecure_TrngPreOperationalSelfTests(XSecure_TrngInstance *InstancePtr) {
	volatile int Status = XST_FAILURE;

	InstancePtr->ErrorState = XSECURE_TRNG_STARTUP_TEST;

	/* Reset the TRNG state */
	Status = XSecure_TrngUninstantiate(InstancePtr);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	Status = XSecure_TrngDRBGKat(InstancePtr);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	Status = XSecure_TrngHealthTest(InstancePtr);
	if (Status != XST_SUCCESS) {
		goto END;
	}

	InstancePtr->ErrorState = XSECURE_TRNG_HEALTHY;
	Status = XST_SUCCESS;

END:
	return Status;
}
