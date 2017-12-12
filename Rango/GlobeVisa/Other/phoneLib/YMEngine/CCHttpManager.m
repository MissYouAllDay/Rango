//
//  CCHttpManager.m
//  AFNDemo
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 lcc. All rights reserved.
//

#import "CCHttpManager.h"


//请求超时时间
#define HttpTimeOutInterval   30

@implementation CCHttpManager

#pragma mark - 创建请求者
+(AFHTTPSessionManager *)manager
{
//    // 先导入证书 证书由服务端生成，具体由服务端人员操作
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    
//    // AFSSLPinningModeCertificate 使用证书验证模式
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//    // 如果是需要验证自建证书，需要设置为YES
//    securityPolicy.allowInvalidCertificates = NO;
//    
//    //validatesDomainName 是否需要验证域名，默认为YES;
//    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//    //如置为NO，建议自己添加对应域名的校验逻辑。
//    securityPolicy.validatesDomainName = NO;
//    
//    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData,nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = HttpTimeOutInterval;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}

+ (void)httpManagerPostRequestUrl:(NSString *)url xml:(NSData *)postdata Success:(SuccessBlock)success Fail:(ErrorBlock)fail
{
    AFHTTPSessionManager *manager = [self manager];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postdata;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            fail(error);
        }else{
            if (responseObject) {
                NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                success(str,YES);
            }else{
                success(@"返回为空",NO);
            }
        }
    }];
    [dataTask resume];
  
}

@end
