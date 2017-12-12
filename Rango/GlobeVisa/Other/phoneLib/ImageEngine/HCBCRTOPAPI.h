
/////////////////////////////////////////////////////////////////////////
//
//	File:		HCBCRTOPAPI.h
//  
//	Author:		Hotcard Technology Pte. Ltd.
//				CDZ			
//
//	Purpose :	Define Hotcard BCR API Functions In The Applicaton Moduler
//
//	Date:		20100121
//
/////////////////////////////////////////////////////////////////////////

#ifndef _T_HC_BCR_TOP_API_H
#define _T_HC_BCR_TOP_API_H

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
//			Int HC_StartBCR(BEngine **ppEngine, 
//							Char *pDataPath, 
//							Char *pConfigFile, 
//							Int nLanguage)
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
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_StartBCR(BEngine **ppEngine, 
					   Char *pDataPath, 
					   Char *pConfigFile,
					   Int nLanguage);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_CloseBCR(BEngine **pEngine)
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

EXPORT Int HC_CloseBCR(BEngine **pEngine);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_DoImageBCR(BEngine *pEngine,
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

EXPORT  Int HC_DoImageBCR(BEngine *pEngine,
						  BImage *pImage, 
				          BField **ppField);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_DoImageBlk(BEngine *pEngine,
//							  BImage *pImage, 
//							  BField **ppField) 
//
//			In manual BCR mode, to extract field position information from 
//			a name card image.
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

EXPORT  Int HC_DoImageBlk(BEngine *pEngine,
						  BImage *pImage, 
				          BField **ppField);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_GetFieldText(BEngine *pEngine,
//							   BImage *pImage, 
//			                   BField *pField,
//			                   Char *text, 
//			                   Int size) 
//
//			In manual BCR mode, to extract field information from the specified  
//			field (defined by field structure).
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
//			pField	
//					A pointer to a field information structures.
//		
//			text	
//					The buffer to contain text result.
//
//			size	
//					Size of the buffer text.
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_GetFieldText(BEngine *pEngine, 
						   BImage *pImage,
						   BField *pField, 
						   Char *text, 
						   Int size);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetNamecardFace(BEngine *pEngine, Int mode)
//
//			Set which side of namecard to process
//
//	Return Value		
//			0 - fail;
//			1 - success.
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			mode = OCR_CARD_FNT	 - for the front side of card;
//				   OCR_CARD_BAK  - for the back side of card.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_SetNamecardFace(BEngine *pEngine, Int mode);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetManualProcess(BEngine *pEngine, Int manual)
//
//			Turn on/off manual process mode.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			manual	
//					OCR_READ_AUTO	: auto BCR
//					OCR_READ_MANUAL	: manual BCR
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_SetManualProcess(BEngine *pEngine, Int manual);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetMultiStep(BEngine *pEngine, Int mode)
//
//			Turn on/off manual process mode.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			manual	
//					OCR_STEP_SINGLE	- Single step BCR
//					OCR_STEP_MULTI	- Multi step BCR
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_SetMultiStep(BEngine *pEngine, Int mode);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			BField *HC_GetBField(BField *pField, BFieldID fid)
//
//			To retreive the BField node with the given field ID. It 
//			searches the link downward only from the given BField node
//
//	Return Value		
//			A pointer to the found BField node.  
//			NULL if it is not found.
//
//	Parameters	
//			pField	
//					Pointer to a link of the field information 
//					structure.
//
//
//			fid		Specifies the BField ID
//
/////////////////////////////////////////////////////////////////////////

EXPORT  BField *HC_GetBField(BField *pfield, BFieldID fid);


#ifdef __pcbcr

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			
//          Int HC_SegmentImage(BEngine *pEngine, BImage *pImage, BRect **ppRect, Int *pSize, Int key)
//          Int HC_SegmentImageEx(BEngine *pEngine, BImage *pImage, BField **ppField, Int key)
//
//			To segment image.
//          HC_SegmentImageEx: use in Hotcard PC BCR application,the function name was changed from HC_SegmentImage1.   
//
//	Return Value		
//			0 - Fail;
//			1 - Success.
//
//	Parameters	
//			ppField	
//					Pointer to a link of the field information 
//					structure.
//          ppRect
//                  Pointer to a link of the rect information
//                  structure.
//          pSize
//                  The number of rect datas
//
//			key	
//         	     0 : Segment for BCR cards
//               1 : Segment for photo
//
/////////////////////////////////////////////////////////////////////////
EXPORT Int HC_SegmentImage(BEngine *pEngine, BImage *pImage, BRect **ppRect, Int *pSize, Int key);
EXPORT Int HC_SegmentImageEx(BEngine *pEngine, BImage *pImage, BField **ppField, Int key);
	
/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_CropImage(BEngine *pEngine, BImage *pImage, BRect **ppRect, Int *pSize)
//
//			To crop image.
//
//	Return Value		
//			0 - Fail;
//			1 - Success.
//
//	Parameters	
//          ppRect
//                  Pointer to a link of the rect information
//                  structure.
//          pSize
//                  The number of rect datas
//			
/////////////////////////////////////////////////////////////////////////
EXPORT Int HC_CropImage(BEngine *pEngine, BImage *pImage, BRect **ppRect, Int *pSize);	

#endif
/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			void HC_freeBRect(BEngine *pEngine, BRect **ppRect, Int *pSize)
//
//			To free rect datas.
//
//	Return Value		
//
//
//	Parameters	
//          ppRect
//                  Pointer to a link of the rect information
//                  structure.
//          pSize
//                  The number of rect datas
//			
/////////////////////////////////////////////////////////////////////////
EXPORT void HC_freeBRect(BEngine *pEngine, BRect **ppRect, Int *pSize);

/////////////////////////////////////////////////////////////////////////
/**************
功能：判断前景区域是否在指定矩形框内
输入：原图像pImage以及区域坐标rect
输入：区域外扩和内缩大小threshold
输入：angle：取值范围[0, 5]的整数，容许角度差
输出返回值：result (4位)：
00000001(1)表示有左边框线
00000010(2)表示有右边框线
00000100(4)表示有上边框线
00001000(8)表示有下边框线
当返回值 -1时，threshold超界
***************/	
/////////////////////////////////////////////////////////////////////////
EXPORT Char HC_CheckCardEdgeLine(BEngine *pEngine, BImage *pImage, TRect rect, int threshold, int angle,int ratio_outside,int ratio_inside);
//新的
EXPORT Char HC_GetBandCardBorder(BImage *pImage, TRect rect);

EXPORT BImage *HC_DupImage(BImage *src, BRect *rect);
EXPORT Int HC_GetFileBorder(SCAN_IMAGE *pImgSrc,TQuadrilateral *pStQuadrilateral);
EXPORT Int HC_GetPerspectiveImg( SCAN_IMAGE *pImgSrc, TQuadrilateral *pStQuadrilateral);
#ifdef _VIDEO_REC_SWITCH
EXPORT Int HC_YMVR_RecognizeVedio(UChar **ppData,Int width,Int height, Int set, BRect *pRect, Int(*func)(Int));
EXPORT Int HC_YMVR_GetResult(Char *pResult);
EXPORT BImage * HC_YMVR_GetHeadInfo();
EXPORT BImage * HC_YMVR_GetPicInfo();
#endif
//获取LicenseStr
EXPORT void HC_getLicenseStr(char *pText);
EXPORT Int HC_GetIDconfs(BField *pField);
EXPORT unsigned char * HC_getYData(unsigned short * pRgb565, int width, int height);//add by qiuronghuo20100603
#if defined(__cplusplus)
}
#endif

#endif	// _T_HC_BCR_H


