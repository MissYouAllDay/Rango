//
//  UIImage+RGBAConv.h
//  junyucamera
//
//  Created by dexter on 12-11-20.
//  Copyright (c) 2012年 junyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RGBAConv)

- (void)getRGBA:(uint8_t*) buf alpha:(BOOL) alpha;
+ (UIImage*)getImageFromRGBA:(uint8_t*) buf width:(int) width height:(int)height alpha:(BOOL) alpha;
- (UIImage*)fixOrientationWithSize:(CGSize)newSize;// flip:(BOOL)flip;
- (UIImage*)circleImage:(CGFloat)inset;
- (unsigned char *)requestImagePixelData;
- (UIImage*)cropImageWithRect:(CGRect)cropRect;
- (UIImage*)resizeWith:(CGSize)newSize InRect:(CGRect)inRect;
- (UIImage*)resizeWith:(CGSize)newSize InRect:(CGRect)inRect withColor:(UIColor*)blankColor;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

//拉伸到指定尺寸
- (UIImage *)scalingToSize:(CGSize)targetSize;

//修改dpi
- (UIImage *)setDPI:(double)DPI;

//填充数据
- (NSData *)addUserComment:(int)length;

@end
