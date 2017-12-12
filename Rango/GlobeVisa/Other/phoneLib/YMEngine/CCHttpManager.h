//
//  CCHttpManager.h
//  AFNDemo
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//定义请求成功和失败模块
typedef void (^SuccessBlock)(NSString *retStr, BOOL isSuccess);
typedef void (^ErrorBlock)(NSError *error);


@interface CCHttpManager : NSObject


+ (void)httpManagerPostRequestUrl:(NSString *)url xml:(NSData *)postdata Success:(SuccessBlock)success Fail:(ErrorBlock)fail;

@end
