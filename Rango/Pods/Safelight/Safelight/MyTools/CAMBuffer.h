//
//  CAMBuffer.h
//  junyucamera
//
//  Created by dexter on 14-7-9.
//  Copyright (c) 2014年 junyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMBuffer : NSObject

@property(readonly,nonatomic) uint8_t* buf;
@property(readonly,nonatomic) int width;
@property(readonly,nonatomic) int height;

@property(nonatomic) BOOL tmpSave;

@property(nonatomic) BOOL ext32;

-(void)cap:(CAMBuffer*) src;
-(void)from:(CAMBuffer*) src;
-(void)swap:(CAMBuffer*) src;

-(BOOL)isEmpty;
-(void)clear;
-(void)save:(NSString*) fname;
-(void)load:(NSString*) fname;

-(void)putBuf:(uint8_t*) newBuf width:(int)w height:(int)h;

-(void)putImage:(UIImage*) img;
-(UIImage*) getImage;

-(uint8_t*)getGray;
-(uint8_t*)getJYGray;

@end
