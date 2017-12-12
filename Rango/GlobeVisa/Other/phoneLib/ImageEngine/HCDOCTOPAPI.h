
/////////////////////////////////////////////////////////////////////////
//
//	File:		HCDOCTOPAPI.h
//  
//	Author:		Hotcard Technology Pte. Ltd.
//				CDZ			
//
//	Purpose :	Define Hotcard DOC Recognization API Functions In The Application Moduler 
//
//	Date:		20100121
//
/////////////////////////////////////////////////////////////////////////

#ifndef _T_HC_DOC_TOP_API_H
#define _T_HC_DOC_TOP_API_H

#include "HCCommonData.h"

#if defined D_API_EXPORTS
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#if defined(__cplusplus)
extern "C" {
#endif


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_StartOCR(BEngine **ppEngine, 
//							Char *pDataPath, 
//							Char *pConfigFile, 
//							Int nLanguage,
//	                        Int nReader)
//
//			To initialize the BCR engine.
//
//	Return Value		
//			An interger to indicate the status of BCR initialization. 
//			0 - Fail;
//			1 - Success.
//
//	Parameters
//			ppEngine
//					A pointer to the BEngine pointer. Call this function
//					like:
//						BEngine	*pEngine = NULL;
//						HC_StartBCR( &pEngine, ...);
//
//			pDataPath	
//					A pointer to the user-supplied buffer that contains 
//					the path where OCR data files stay.
//		
//			pConfigFile	
//					The BCR configuration file name. If pDataPath is NULL, 
//					the path of OCR data files is descriped in this configure
//					file.
//		
//			nLanguage
//					The OCR language:
//          nReader
//                  The OCR method type:OCR_READ_OCR(for single line doc),OCR_READ_DOC
//
/////////////////////////////////////////////////////////////////////////


EXPORT Int HC_StartOCR(BEngine **ppEngine, 
					   Char *pDataPath, 
					   Char *pConfigFile,
					   Int nLanguage,
					   Int nReader);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_CloseOCR(BEngine **pEngine)
//
//			To free the resources used by BCR engine.
//
//	Return Value		
//			Always return 1. 
//
//	Parameters
//			ppEngine
//					A pointer to the BEngine pointer. Call this function
//					like:
//						BEngine	*pEngine = NULL;
//						...
//						HC_CloseBCR( &pEngine);
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_CloseOCR(BEngine **pEngine);
/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_DoImageOCR(BEngine *pEngine,
//							  BImage *pImage, 
//							  BField **ppField) 
//
//			To extract field information from an image.
//
//	Return Value		
//			An interger to indicate the status of BCR. 
//			0 - Fail;
//			1 - Success.
//
//	Parameters	
//			pEngine
//					A pointer to the engine.
//
//			pImage	
//					A pointer to the user-supplied BImage buffer that 
//					contains the gray level name card image.
//		
//			ppField	
//					Return a link of field information structures
//		
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_DoImageOCR(BEngine *pEngine,
						  BImage *pImage, 
				          BField **ppField);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_DoLineOCR(BEngine *pEngine,
//			                 BImage *pImage, 
//                           BField **ppField,
//			                 Char *text, 
//			                 Int size) 
//
//			To extract field information from an image.
//
//	Return Value		
//			An interger to indicate the status of BCR. 
//			0 - Fail;
//			1 - Success.
//
//	Parameters	
//			pEngine
//					A pointer to the engine.
//
//			pImage	
//					A pointer to the user-supplied BImage buffer that 
//					contains the gray level text image.
//          ppField   
//
//                A pointer to field information.
//		
//			text	
//					The buffer to contain text result.
//
//			size	
//					Size of the buffer text.
//		
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_DoLineOCR(BEngine *pEngine,
						 BImage *pImage, 
						 BField **ppField,
						 Char *text,
						 Int size);


#if defined(__cplusplus)
}
#endif

#endif	// _T_HC_BCR_H


