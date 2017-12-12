//
//  CAMPicContext.m
//  mugshot
//
//  Created by dexter on 15/4/29.
//  Copyright (c) 2015年 dexter. All rights reserved.
//

#import "CAMPicContext.h"
#import "NSMutableDictionary+Set.h"
#import "NSDictionary+Get.h"
#import "CAMBuffer.h"

#define PREBUF_BACKUP_NAME @"pre.bin"

@implementation CAMPicContext

-(instancetype)initWithImg:(UIImage *)img
{
	if(self=[super init])
	{
		_oriImg=img;
		
		_oriBuf=[CAMBuffer new];
		_preBuf=[CAMBuffer new];
		_destBuf=[CAMBuffer new];
		_tmpBuf=[CAMBuffer new];
		
		_param=[NSMutableDictionary dictionary];
		
		_mode=0;
	}
	return self;
}
-(void)dealloc
{
	NSLog(@"CAMPicContext free");
	
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)initOriBuf
{
	//自己定义一个32
	_oriBuf.ext32=YES;
	[_oriBuf putImage:_oriImg];
}
-(void)initExtBuf
{
	[_preBuf cap:_oriBuf];
	[_destBuf cap:_oriBuf];
	[_tmpBuf cap:_oriBuf];
}

-(int)intForKey:(NSString*)key
{
	return (int)[_param intValueForKey:key];
}
-(void)setInt:(int) value ForKey:(NSString*)key
{
	[_param setValue:value forkey:key];
}
-(void)mergeParam:(NSDictionary*) param
{
	if(param!=nil)
		[_param addEntriesFromDictionary:param];
	
	//这里可以加些很脏的参数定义
}

-(void)savePre
{
	[_preBuf save:PREBUF_BACKUP_NAME];
}
-(void)back
{
	//只保存预处理内存
	_preBuf.tmpSave=YES;
	//其他都清除
	[_preBuf clear];
	[_oriBuf clear];
	[_destBuf clear];
	[_tmpBuf clear];
}
- (void)applicationDidEnterBackground:(NSNotification *)notify
{
	__block UIBackgroundTaskIdentifier back=[[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
		[[UIApplication sharedApplication] endBackgroundTask:back];
		back=UIBackgroundTaskInvalid;
	}];
	
	__weak id weakSelf=self;
	dispatch_async(_queue, ^{
		[weakSelf back];
		
		[[UIApplication sharedApplication] endBackgroundTask:back];
		back=UIBackgroundTaskInvalid;
	});
}
-(void)fore
{
	//恢复扩展信息
	_oriBuf.ext32=YES;
	_preBuf.ext32=NO;
	_destBuf.ext32=NO;
	_tmpBuf.ext32=NO;
	
	[_preBuf load:PREBUF_BACKUP_NAME];
	if(_oriImg!=nil)
		[_oriBuf putImage:_oriImg];
	else
		[_oriBuf cap:_preBuf];
}
- (void)applicationWillEnterForeground:(NSNotification *)notify
{
	__weak id weakSelf=self;
	dispatch_sync(_queue, ^{
		[weakSelf fore];
	});
}
@end