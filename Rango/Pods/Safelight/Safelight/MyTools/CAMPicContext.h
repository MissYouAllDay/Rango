//
//  CAMPicContext.h
//  mugshot
//
//  Created by dexter on 15/4/29.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger,CAMPicMode) {
	CAMPicModeNone					= 0,
	CAMPicModeFirst                 = 1 << 0,
	CAMPicModeMeiyan				= 1 << 1,
};

//这个类的创建和销毁都要在线程里
@class CAMBuffer;
@class CAMPicFilter;
@interface CAMPicContext : NSObject

//队列
@property(weak,nonatomic) dispatch_queue_t queue;

//缓存
@property(strong,nonatomic) UIImage* oriImg;
@property(strong,nonatomic) CAMBuffer* oriBuf;
@property(strong,nonatomic) CAMBuffer* preBuf;
@property(strong,nonatomic) CAMBuffer* destBuf;
@property(strong,nonatomic) CAMBuffer* tmpBuf;

//参数集
@property(strong,nonatomic) NSMutableDictionary* param;

//美化相关
@property(weak,nonatomic) CAMPicFilter* lastFilter;
@property(nonatomic) CAMPicMode mode;

@property(strong,nonatomic) UIImage* lastImgFix;

-(instancetype)initWithImg:(UIImage*) img;
-(void)initOriBuf;
//给美化用的扩展缓存
-(void)initExtBuf;

//参数相关
-(int)intForKey:(NSString*)key;
-(void)setInt:(int) value ForKey:(NSString*)key;
-(void)mergeParam:(NSDictionary*) param;

//待机用
-(void)savePre;

@end
