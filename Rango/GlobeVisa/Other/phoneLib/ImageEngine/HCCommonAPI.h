/////////////////////////////////////////////////////////////////////////
//
//	File:		HCCommonAPI.h
//  
//	Author:		Hotcard Technology Pte. Ltd.
//				CDZ			
//
//	Purpose :	Define Hotcard Common API Used In All Application(BCR,DOC,OCR):
//
//
//	Date:		20100121
//
/////////////////////////////////////////////////////////////////////////

#ifndef _HC_COMMON_API_H
#define _HC_COMMON_API_H

#include "HCCommonData.h"

#define HC_allocBImage	HC_allocImage
#define HC_freeBImage	HC_freeImage

#if defined D_API_EXPORTS
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#if defined(__cplusplus)
extern "C" {
#endif


////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_GetVersionString(Char *version, Int buffersize)
//
//			To get the version string of BCR engine.
//
//	Return Value		
//			1 - Always.
//
//	Parameters	
//			version	
//					A pointer to the user-supplied buffer that contains 
//					the version string returned.
//		
//			buffersize	
//					Indicates the buffer size of version.
//		
/////////////////////////////////////////////////////////////////////////
	
EXPORT Int HC_GetVersionString(Char *version, Int buffersize);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_SetFontType(BEngine **ppEngine, int nLanguage)
//
//			Set name card language
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			ppEngine
//					A pointer to the BEngine pointer. 
//
//			nLanguage 
//					The OCR language:
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_SetFontType(BEngine **ppEngine, Int nLanguage);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_GetFontType(BEngine *pEngine)
//
//			Get current name card language
//
//	Return Value		
//			The OCR language;
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_GetFontType(BEngine *pEngine);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetSwitch(BEngine *pEngine, Int nSwitch, Int mode)
//
//			Set swhichs for the engine
//
//	Return Value		
//			0 - fail;
//			1 - success.
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			nSwitch             mode
//			-------				-----
//			
//			SET_OCR_IMAGE		OCR_IMG_SCAN	: Captured by scanner
//								OCR_IMG_CAMERA	: Captured by camera
//
//			SET_OCR_FLIP		OCR_FLIP_NIL	: Default from config file; 
//								OCR_FLIP_NO		: Do not detect; 
//								OCR_FLIP_YES	: Auto flip;
//
//			SET_OCR_ORIENT		OCR_ORIE_AUTO	: Auto orientation
//								OCR_ORIE_HORI	: Horizontal 
//								OCR_ORIE_VERT	: Vertical 
//
//			SET_CARD_FACE		OCR_CARD_FNT	: front of card
//								OCR_CARD_BAK	: back of card
//
//			SET_READING			OCR_READ_AUTO	: auto BCR
//								OCR_READ_MANUAL	: manual BCR
//
//			// output format
//
//			SET_CHINESE_CODE	OCR_CODE_GB		: GB code 
//								OCR_CODE_B5		: Big5 code
//
//			SET_LETTER_CASE		OCR_CASE_DEF	: default
//								OCR_CASE_UPPER	: UPPER CASE
//								OCR_CASE_LOWER	: lower case
//								OCR_CASE_TITLE	: Title Case
//
//			SET_MEMO			OCR_MEMO_NIL		: no memo
//								OCR_MEMO_OCR		: copy OCR to memo
//								OCR_MEMO_UNDEFINED	: memo for undefined field
//
//			SET_MULTI_STEPS		OCR_STEP_SINGLE	: Single step
//								OCR_STEP_MULTI	: Multi-steps
//
//			SET_IMG_WORK		OCR_IMG_FULL	: do all actions 
//								OCR_IMG_CROP	: crop gray image
//								OCR_IMG_NON		: no action for gray image
//								OCR_IMG_BW		: require B/W image
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_SetSwitch(BEngine *pEngine, Int nSwitch, Int mode);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_GetSwitch(BEngine *pEngine, Int nSwitch)
//
//			Get swhichs for the engine
//
//	Return Value		
//			-1    - fail to get switch;
//			>= 0  - the value of specified switch.
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			nSwitch 
//					Refer to HC_SetSwitch.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_GetSwitch(BEngine *pEngine, Int nSwitch);

#define HC_SetMemoSetting(pEngine, setting)		HC_SetSwitch(pEngine, SET_MEMO. setting)
#define HC_GetProcessStep(pEngine)				HC_GetSwitch(pEngine, SET_MULTI_STEPS)

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetChineseCode(BEngine *pEngine, Int codec)
//
//			Set Chinese code for recognition results
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			codec -  OCR_CODE_GB  - for GB code
//				     OCR_CODE_B5  - for Big5 code
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_SetChineseCode(BEngine *pEngine, Int codec);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetLetterCase(BEngine *pEngine, Int mode)
//
//			Set field text format.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			mode	
//					OCR_CASE_DEF	- default as on the card
//					OCR_CASE_UPPER	- UPPER CASE
//					OCR_CASE_LOWER	- lower case
//					OCR_CASE_TITLE	- Title Case
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_SetLetterCase(BEngine *pEngine, Int mode);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetAutoFlip(BEngine *pEngine, Int flip)
//
//			Set auto detect of namecard rotation.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			flip	
//					OCR_FLIP_YES  - Auto flip;
//					OCR_FLIP_NO   - Do not detect; 
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_SetAutoFlip(BEngine *pEngine, Int flip);



/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_SetImageCaptureType(BEngine *pEngine, Int mode)
//
//			Set auto detect of namecard rotation.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			flip	
//					OCR_IMG_SCAN	- image captured by scanner
//					OCR_IMG_CAMERA	- iamge captured by camera
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_SetImageCaptureType(BEngine *pEngine, Int mode);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_allocImage(BEngine *pEngine, 
//							  BImage **ppImage, 
//							  Int width, 
//							  Int height, 
//							  Int setting)
//
//			Allocate a space for a 2D image buffer.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			ppImage	
//					A pointer to a variable of BImage pointer. It will 
//					receive the address of a BImage structure.
//
//			width	
//					The width of image buffer.
//
//			height	
//					The height of image buffer.
//
//			Setting	
//					The initial value for each pixel.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_allocImage(BEngine *pEngine, 
						  BImage **ppImage, 
						  Int width, 
						  Int height,
						  Int setting);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_freeImage(BEngine *pEngine, BImage **ppImage)
//
//			Release the memory of a BImage structure.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			ppImage	
//					A pointer to a variable of BImage pointer. It is set
//					to NULL after the image has been released.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_freeImage(BEngine *pEngine, BImage **ppImage);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			BImage *HC_LoadImageMem(BEngine *pEngine, Char *pBuffer, Int width, Int height)
//
//			Read BImage from a memory space. It contains the image lines  
//			top line to bottom line. Each pixel takes one byte.
//
//	Return Value		
//			A pointer to a BImage structure if success to read the file;
//			NULL - if fail. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			pBuffer	
//					A pointer to the image data.
//
//			width, height
//					Size of the image buffer in pixels.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  BImage *HC_LoadImageMem(BEngine *pEngine, Char *pBuffer, Int width, Int height);
EXPORT  BImage *HC_LoadGRYImageMem(BEngine *pEngine, char *pBuffer, Int width, Int height);//灰度流
EXPORT  BImage *HC_LoadRGBImageMem(BEngine *pEngine, char *pBuffer, Int width, Int height);//彩色流
EXPORT  BImage *HC_LoadRGB2GryImageMem(BEngine *pEngine, char *pBuffer, Int width, Int height);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			BImage *HC_LoadImage_BMP(BEngine *pEngine, Char *filename)
//
//			Read BImage from bmp file.
//
//	Return Value		
//			A pointer to a BImage structure if success to read the file;
//			NULL - if fail. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			filename	
//					bmp filename.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  BImage *HC_LoadImage_BMP(BEngine *pEngine, Char *filename);

EXPORT  Int HC_SaveImage_BMP(BEngine *pEngine, BImage *pImage, Char *filename);
EXPORT  Int HC_SaveImage(BEngine *pEngine, BImage *pImage, Char *filename);
EXPORT  BImage *HC_IMG_DupTMastImage(BImage *pImage, TRect *rect);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			BImage *HC_LoadImageBMP(BEngine *pEngine, Char *pBitmap)
//
//			Read BImage from memory with bmp structure.
//
//	Return Value		
//			A pointer to a BImage structure if success to read the file;
//			NULL - if fail. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			pBitmap	
//					The memory with bmp structure.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  BImage *HC_LoadImageBMP(BEngine *pEngine, Char *pBitmap);

EXPORT  BImage *HC_LoadImageByteStream(BEngine *pEngine, char *pimgBitmap,int imgSize);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_PrintFieldInfo(BEngine *pEngine, 
//									BField *pField, Char *pText, Int size)
//
//			Export the filed information into a text buffer (multi lines).
//			Each field takes one line.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pFields	
//					Pointer to the field information structure
//
//			pText	
//					Text buffer to receive the field information
//
//			size
//					The size of text buffer pText
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_PrintFieldInfo(BEngine *pEngine, BField *pField, Char *pText, Int size);
EXPORT  Int HC_PrintFieldDetail(BEngine *pEngine, BField *pField);
EXPORT  Int HC_PrintOcrInfo(BEngine *pEngine, Char *pText, Int size);
EXPORT  Int HC_PrintFieldInfo_JSON(BEngine *pEngine, BField *pField, Char *pText, Int size);
/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			void HC_freeBField(BEngine *pEngine, BField *pField, Int once)
//
//			Release field memory.
//
//	Return Value		
//			void
//
//	Parameters	
//			pField	
//					Pointer to a link of the field information 
//					structure.
//
//
//			once	= 1 to release one node only
//					= 0 to release all the nodes in field link
//
/////////////////////////////////////////////////////////////////////////

EXPORT  void HC_freeBField(BEngine *pEngine, BField *pfield, Int once);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_Gray2BW(BEngine *pEngine, 
//							BImage **ppImage, 
//							BConvert *pConvert,
//							Int width, 
//                          Int height,
//							Char *pBufLine, int row)
//
//			Convert gray (256 color) image into black/white image.
//			It is called by main routine to convert image line by line.
//
//	Return Value		
//			1 - if successful.  
//			2 - if blur image detected.  
//			0 - if fail.
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			ppImage	
//					Pointer to a BImage pointer, which is initialized as
//					NULL.  It is to receive the converted black/white 
//					image.
//
//			pConvert 
//					Pointer to a BConvert structure, which takes the 
//					temp calues of convertion.
//
//			width
//					width of gray image
//
//			height
//					height of gray image
//
//			pBufLine
//					Input image data (one line).
//	
//			row
//					specifies which line the image data (pBufLine) is.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_Gray2BW(BEngine *pEngine, 
					   BImage **ppImage, 
					   BConvert *pConvert,
					   Int width, 
					   Int height, 
					   UChar *pBufLine,
					   Int row);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_ImageConvert(BEngine *pEngine, 
//			                    BImage **ppImage, 
//			                    int nLanguage)
//
//			Convert gray image into BW image.
//
//	Return Value		
//			1 - if successful.  
//			0 - if fail.
//
//	Parameters	
//			pEngine
//					A pointer to the engine.
//
//			ppImage	
//					Pointer to a BImage pointer, the gray image.  The converted 
//					BW image will overwite the gray image.
//
//			nLanguage 
//					BCR language.
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_ImageConvert(BEngine *pEngine, BImage *pImage, Int nLanguage);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_ImageChecking(BEngine *pEngine, 
//			                     BImage *ppImage, 
//			                     Int level)
//
//			Blur image detection.
//
//	Return Value		
//			2 - if blur image detected.  
//          1 - image is ok.
//			0 - if fail.
//
//	Parameters	
//			pEngine
//					A pointer to the engine.
//
//			pImage	
//					Pointer to a gray image.
//
//			level 
//					Level of blur detection. It can be 0, 1 or 2. 
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_ImageChecking(BEngine *pEngine, BImage *pImage, Int level);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_CodeConvert(BEngine *pEngine, Char *text, Int key)
//
//			Convert text into other code format
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			text - String to be converted
//
//			key -  OCR_CODE_GB: for GB Unicode
//				   OCR_CODE_B5: for Big5 code
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_CodeConvert(BEngine *pEngine, Char *text, Int key);

EXPORT  Int HC_CodeConvertEx(BEngine **ppEngine, Char *pDataPath, Char *pConfigFile,
							Char *text, Int key);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_SetProgressFunc(BEngine *pEngine, int (*func)(int progress, int relative))
//
//			Set progress function for the engine. The application 
//			defines the progres function (show progress bar) and 
//			set it for engine. 
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			func	Provided progress function in the format of
//					int (*f_progress)(int progress, int relative).
//					Here:
//						progress:  progress value in 0 to 100
//						relative:  = 0  - "progress" is the real value;
//						             1  - "progress" is step to incress;	
//						If return value is 0, it means to stop the engine.
//
/////////////////////////////////////////////////////////////////////////

typedef	Int (*f_progress_func)(Int progress, Int relative);
EXPORT  Int HC_SetProgressFunc(BEngine *pEngine, Int (*func)(Int progress, Int relative));

////////////////////////////////////////////////////////////////////////////////////////////
//
//	Function	
//			HC_GetLanSupport(BEngine *pEngine, char *libpath, unsigned int *lan)
//
//			To retrieve the supported language by Engine.
//
//	Return Value
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			libpath
//					path to the library (data). 
//
//			lan
//					pointer of a variable to receive the languages. The 
//					bit settings indicate the languages supported.
//
//					0x00000001 - English
//					0x00000010 - Chinese
//					0x00000100 - European.
//					0x00001000 - Russian.

/////////////////////////////////////////////////////////////////////////////

EXPORT Int HC_GetLanSupport(BEngine *pEngine, Char *libpath, UInt *lan);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_GetLastErr(BEngine *pEngine, Char *msg, Int msgsize)
//
//			Get the last error happened in the engine. 
//
//	Return Value
//			The error code. Refer to defination of ERR_Code
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			msg   - Buffer to receive error message
//
//			msgsize - size of buffer msg
//
/////////////////////////////////////////////////////////////////////////

EXPORT Int HC_GetLastErr(BEngine *pEngine, Char *msg, Int msgsize);

/*
/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_Init(BEngine *pEngine, void *pbuffer, unsigned int size)
//
//			HCBCR initialization. It should be called before the calling
//			of any other API functions.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			pbuffer
//					The memory privided for the engine. For the default,
//					pass NULL to it.
//	
//			size
//					Size of the memory provided (pbuffer).
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_Init(BEngine *pEngine, void *pbuffer, UInt size);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_Close(BEngine *pEngine)
//
//			HCBCR Clearing. It should be called when application exit.
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters
//			pEngine
//					A pointer to BEngine. 
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int HC_Close(BEngine *pEngine);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_MemInit(BEngine *pEngine, void *pbuffer, UInt size)
//
//			Initialize the engine to use provided memory space. 
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters
//			pEngine
//					A pointer to BEngine. 
//
//			pbuffer
//					The memory privided for the engine.
//	
//			size
//					Size of the memory provided (pbuffer).
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int  HC_MemInit(BEngine *pEngine, void *pbuffer, UInt size);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_MemClose(BEngine *pEngine)
//
//			Terminate the usage of memory space. 
//
//	Return Value		
//			0 - Fail;
//			1 - Success. 
//
//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
/////////////////////////////////////////////////////////////////////////

EXPORT  Int  HC_MemClose(BEngine *pEngine);
*/

EXPORT Int HC_EnableMultiLine(BEngine *pEngine,Int mode);
EXPORT Int HC_EnableRotate(BEngine *pEngine,Int mode);
EXPORT Int HC_SetImgType(BEngine *pEngine,Int m_SmallImage);
EXPORT Int HC_RemoveUnderLine(BEngine *pEngine,Int m_RMoveLine);

/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			int HC_SetOption(BEngine *pEngine, char *pKey, char *pContent)
//
//			Set options for BCR/OCR. 
//
//	Return Value
//			1     - Set the option successful;
//			2     - Fail to set the option;
//
//	Parameters	
//			pEnginee 
//					A pointer to BEngine. 
//
//			pKey     - Key for the option.
//
//			pContent - Optional content for some keys.
//
//                List of options:
//
//                Key          Content     Description
//
//               -imgfile      filename    Set image file name 
//               -320x240mode  NULL        Set video OCR mode
//               -mline        NULL        Set multi lines OCR mode
//               -fmt          NULL        Set format tel in BCR mode
//               -NAT_         NULL        set national code. (_NAT_FR, _NAT_DE,_NAT_IT,
//                                         _NAT_ES,_NAT_PT,_NAT_SE,_NAT_DA,_NAT_FI,_NAT_NO,_NAT_NL)
//                      
/////////////////////////////////////////////////////////////////////////
EXPORT Int HC_SetOption(BEngine *pEngine, Char *pKey, Char *pContent);


/////////////////////////////////////////////////////////////////////////
//
//	Function	
//			Int HC_GetCardType(BEngine *pEngine, BImage *pImage)
//
//			Get ID card type
//
//	Return Value		
//			CARD_TYPE value
//          typedef enum
//          {
//          	TUNKNOW           = 0x00,
//          	TIDCARD       = 0x10,   //身份证
//	          	TIDCARD2      = 0x11,   //二代证
//	          	TIDCARD1      = 0x12,   //一代证
//	          	TIDCARDBACK   = 0x14,   //二代证背面   
//	          	TIDCARDTEMP   = 0x18,   //临时身份证
//	          	TPASSCARD     = 0x20,   //护照
//	          	TPASSCARDINTR = 0x21,   //国际护照
//	          	TPASSCARDCHN  = 0x22,   //中国护照
//	          	TPASSCARDHK   = 0x24,   //港澳通行证 
//	          	TPASSCARDTW   = 0x28,   //台胞证
//	          	TDRIVERCARD   = 0x40,   //驾照
//	          	TOTHERCARD    = 0X80,   //其它证件   
//	          	TMILITARYCARD = 0x81,   //士兵证
//	          	THOUSEHOLDBOOK = 0x81   //户口本
//          } CARD_TYPE;

//	Parameters	
//			pEngine
//					A pointer to BEngine. 
//
//			pImage	
//					Pointer to a gray image.

/////////////////////////////////////////////////////////////////////////
EXPORT  Int HC_GetCardType(BEngine *pEngine, BImage *pImage);
EXPORT BImage *HC_GetBcrBinaryImage(BEngine *pEngine, BImage *pImage);

EXPORT Int YM_SaveImage(BImage *pImage, Char *pFileName);
#if defined(__cplusplus)
}
#endif

#endif