#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MSJYManager_OC.h"
#import "JY_IDPhoto.h"
#import "CAMBuffer.h"
#import "CAMPicContext.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "LLSimpleCamera.h"
#import "UIImage+FixOrientation.h"
#import "NSDictionary+Get.h"
#import "NSMutableDictionary+Set.h"
#import "UIImage+RGBAConv.h"
#import "EFViewController.h"
#import "UILoadingView.h"
#import "Safelight.h"

FOUNDATION_EXPORT double SafelightVersionNumber;
FOUNDATION_EXPORT const unsigned char SafelightVersionString[];

