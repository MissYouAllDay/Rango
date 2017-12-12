//
//  NetWorking.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/4/10.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "NetWorking.h"
#import "AFNetworking.h"
@implementation NetWorking


+ (void)getRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    
    NSString *getUrl = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        failBlock(error);
    }];
}

+ (void)getHUDRequest:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide withHUD:(BOOL)needHUD success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    if (!needHUD) { [CXUtils createHUB]; }
    NSString *getUrl = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (!needHUD) { [CXUtils hideHUD]; }
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (hide) {
            succeedBlock(responsObj);
            return ;
        }
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];

        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
            
            return ;
        }
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!needHUD) { [CXUtils hideHUD]; }
        
        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}


+ (void)getHUDRequestwithURL:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide withHUD:(BOOL)needHUD success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    if (!needHUD) { [CXUtils createHUB]; }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (!needHUD) { [CXUtils hideHUD]; }
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (hide) {
            succeedBlock(responsObj);
            return ;
        }
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
            
            return ;
        }
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!needHUD) { [CXUtils hideHUD]; }
        
        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}


+ (void)postRequest:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    
 
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
        if (hide) {
            succeedBlock(responseObject);
            return ;
        }
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responseObject[@"reason"]];
            
            return ;
        }
        
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}

+ (void)postHUDRequest:(NSString *)url withParam:(NSDictionary *)param withErrorCode:(BOOL)hide withHUD:(BOOL)needHUD success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    
    if (!needHUD) { [CXUtils createHUB]; }
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (!needHUD) { [CXUtils hideHUD]; }

        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
        if (hide) {
            succeedBlock(responseObject);
            return ;
        }
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responseObject[@"reason"]];
            
            return ;
        }
        
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        if (!needHUD) { [CXUtils hideHUD]; }

        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}

#pragma mark - - - - - - 上传图片 - - -- - -- - -
// 上传图片    身份证
+ (void)postImagewithURL:(NSString *)url withParam:(NSDictionary *)param Images:(NSArray *)imageArr success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    
    [CXUtils createHUB];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    [manager POST:postURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *showOrderArr  = [param[@"detail_id"] componentsSeparatedByString:@","];
        for (int i = 0; i < imageArr.count; i ++ ) {
            UIImage *image = imageArr[i];
            NSData *data1 = UIImageJPEGRepresentation(image, 0.6);
            NSString *name = [NSString stringWithFormat:@"%@.jpg",showOrderArr[i]];
            [formData appendPartWithFileData:data1 name:name fileName:name mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) { } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [CXUtils hideHUD];
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        
        if ([errorCode isEqualToString:@"0"]) {
            
            succeedBlock(responsObj);
        }else {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CXUtils hideHUD];
        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
        NSLog(@"---照片提交HTTP出错");
    }];
}
// 上传图片   多张
+ (void)postMultipleImagewithURL:(NSString *)url withParam:(NSDictionary *)param Images:(NSArray *)imageArr success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    
    [CXUtils createHUB];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    [manager POST:postURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *showOrderArr  = [param[@"detail_id"] componentsSeparatedByString:@","];
        for (int i = 0; i < imageArr.count; i ++ ) {
            UIImage *image = imageArr[i];
            NSData *data1 = UIImageJPEGRepresentation(image, 0.6);
            NSString *name = [NSString stringWithFormat:@"%d.jpg",i];
            [formData appendPartWithFileData:data1 name:name fileName:name mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) { } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [CXUtils hideHUD];
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        
        if ([errorCode isEqualToString:@"0"]) {
            
            succeedBlock(responsObj);
        }else {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CXUtils hideHUD];
        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
        NSLog(@"---照片提交HTTP出错");
    }];
}

// 上传图片    单张
+ (void)postImageOnlywithURL:(NSString *)url withParam:(NSDictionary *)param Images:(NSArray *)imageArr success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSError *error))failBlock {
    
    [CXUtils createHUB];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    [manager POST:postURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = imageArr[0];
        NSData *data1 = UIImageJPEGRepresentation(image, 0.6);
        NSString *name = [NSString stringWithFormat:@"1.jpg"];
        [formData appendPartWithFileData:data1 name:name fileName:name mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) { } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [CXUtils hideHUD];
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        
        if ([errorCode isEqualToString:@"0"]) {
            
            succeedBlock(responsObj);
        }else {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CXUtils hideHUD];
        failBlock(error);
        [CXUtils createAllTextHUB:@"请检查网络连接"];
        NSLog(@"---照片提交HTTP出错");
    }];
}
#pragma mark - - - - - - - - - - 以前的方法  弃用 - - - - - - - - - - -
#pragma mark - old

//带有 HUD  errorCode 判断
+ (void)getHUDRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {
    
    [CXUtils createHUB];

    NSString *getUrl = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [CXUtils hideHUD];
        
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
            
            return ;
        }
        
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [CXUtils hideHUD];
        [CXUtils createAllTextHUB:@"请检查网络连接"];
        
    }];
}
//带有 HUD  errorCode 判断
+ (void)getShowHUDRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {
    
    [CXUtils createHUB];
    
    NSString *getUrl = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils hideHUD];
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
            return ;
        }
        
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CXUtils hideHUD];
        [CXUtils createAllTextHUB:@"请检查网络连接"];
        
    }];
}


+ (void)getErrorRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock Error:(void(^)())Error {
    
    NSString *getUrl = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    [CXUtils createHUB];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [CXUtils hideHUD];
        
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responsObj[@"error_code"]];
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responsObj[@"reason"]];
            
            return ;
        }
    
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        [CXUtils hideHUD];

        [CXUtils createAllTextHUB:@"请检查网络连接"];
        
    }];
}


+ (void)getErrorRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)())failBlock {
    
    NSString *getUrl = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id responsObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        succeedBlock(responsObj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock();
//        [CXUtils hideHUD];
//        
//        [CXUtils createAllTextHUB:@"请检查网络连接"];
        
    }];
}



#pragma mark - - - - -- - - - - - POST - - - - - - - - - - -- - - - -- - - - -
//不带有HUD 
//+ (void)postRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {
//
//    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
//        if (![errorCode isEqualToString:@"0"]) {
//
//            [CXUtils createAllTextHUB:responseObject[@"reason"]];
//
//            return ;
//        }
//
//        succeedBlock(responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        [CXUtils hideHUD];
//        [CXUtils createAllTextHUB:@"请检查网络连接"];
//    }];
//}

//带有HUD post请求
+ (void)postHUDRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {
    
    [CXUtils createHUB];

    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
   
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [CXUtils hideHUD];
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responseObject[@"reason"]];
            
            return ;
        }
        
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        [CXUtils hideHUD];

        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}
//带有HUD 数据成功后不隐藏    post请求
+ (void)postShowHUDRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {
    
    [CXUtils createHUB];
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils hideHUD];
            [CXUtils createAllTextHUB:responseObject[@"reason"]];
            return ;
        }
        
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CXUtils hideHUD];
        
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}
//手机号验证  验证是否已有账号  如果已有则不允许重复注册
+ (void)postCheckPhoneNum:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
        if (![errorCode isEqualToString:@"1"]) {
            
            [CXUtils createAllTextHUB:responseObject[@"reason"]];
            return ;
        }
        
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
        [CXUtils hideHUD];
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];
}

// 不带有 hud  不带有 error 判断 
+ (void)postNomalRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)(NSHTTPURLResponse *responseObjc))failBlock {

    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CXUtils hideHUD];
        
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }];

}

// 不带有 hud  不带有 error 判断
+ (void)postERRORRequest:(NSString *)url withParam:(NSDictionary *)param success:(void(^)(id responseObjc))succeedBlock failBlock:(void(^)( NSError *error))failBlock {
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@",ROOTURL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:postURL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succeedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock(error);

    }];
    
}

@end
