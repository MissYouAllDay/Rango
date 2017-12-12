//
//  MSJYShell.h
//  mugshot
//
//  Created by EyreFree on 15/9/6.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAMPicContext.h"
#import "CAMBuffer.h"

@interface MSJYManager_OC : NSObject
+ (id)sharedInstance;

-(void)setMode:(BOOL)isMulti;

-(void)chuShiHua;
-(CAMPicContext *)renLianShu:(UIImage*)image;
-(void)jiSuanKuang;
-(void)sheZhiTuPian:(UIImage*)extImage;
-(void)daFeng;

@end
