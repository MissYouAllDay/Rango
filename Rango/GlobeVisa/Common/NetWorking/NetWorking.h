//
//  NetWorking.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/4/10.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorking : NSObject

//
+ (void)getRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;
// url 为绝对路径
+ (void)getHUDRequestwithURL:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide withHUD:(BOOL)needHUD success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;
+ (void)postRequest:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;


// - - - - - - - - - - - - - - 以上内容 后期 可以删除  - - - - - - - - - - - - - - -

/**
 上传图片

 @param url url
 @param param 请求体
 @param imageArr 图片数组 @[image,image]
 @param succeedBlock 成功回调
 @param failBlock 失败回调
 */
// 身份证
+ (void)postImagewithURL:(NSString *)url withParam:(NSDictionary *)param Images:(NSArray *)imageArr success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;
// 多张
+ (void)postMultipleImagewithURL:(NSString *)url withParam:(NSDictionary *)param Images:(NSArray *)imageArr success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;
// 单张
+ (void)postImageOnlywithURL:(NSString *)url withParam:(NSDictionary *)param Images:(NSArray *)imageArr success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;
/**
 POST 请求数据

 @param url url
 @param param 参数
 @param hide    外部是否需要  error
 @param needHUD 外部是否需要  hud
 @param succeedBlock 成功返回
 @param failBlock 失败返回
 */
+ (void)postHUDRequest:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide withHUD:(BOOL)needHUD success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock ;
/**
 GET 请求数据
 
 @param url url
 @param param 参数
 @param hide    外部是否需要  error
 @param needHUD 外部是否需要  hud
 @param succeedBlock 成功返回
 @param failBlock 失败返回
 */
+ (void)getHUDRequest:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide withHUD:(BOOL)needHUD success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock;


// - - - - - - - - - - - - - - 以下内容  可以删除 - - - - - - - - - - - - - - -



#pragma mark - POST
//获取验证码 注册 验证手机号是否可以注册
+ (void)postCheckPhoneNum:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock;

// 不带有  HUD
//  带有   做errorCode 判断
//+ (void)postRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock;

// 带有  hud
// 带有  errorCode 判断
+ (void)postHUDRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock;


@end








