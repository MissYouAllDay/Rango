//
//  BaseModel.m
//  GlobeVisa
//
//  Created by MSLiOS on 2017/2/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

-(id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init] ) {
        
        [self setAttribute:dic];
    }
    return self;
}

//为model中的属性赋值的方法 --> 设置set方法
-(void)setAttribute:(NSDictionary*)dic{
    
    for (NSString *key in dic) {
        NSString *a = [[key substringToIndex:1] uppercaseString];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:",a,[key substringFromIndex:1]];
        
        SEL method = NSSelectorFromString(methodName);
        
        if ([self respondsToSelector:method]) {
            
            [self performSelectorOnMainThread:method
                                   withObject:[dic objectForKey:key]
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
    
    for (NSString*key in _map) {
        
        NSString *value = [_map objectForKey:key];
        NSString *a = [[value substringToIndex:1] uppercaseString];
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:",a,[value substringFromIndex:1]];
        
        SEL method = NSSelectorFromString(methodName);
        
        if ([self respondsToSelector:method]) {
            
            [self performSelectorOnMainThread:method withObject:[dic objectForKey:key] waitUntilDone:[NSThread isMainThread]];
        }
    }
}


- (NSDictionary *)dictionaryFromModel
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]) {
                [dict setObject:value forKey:key];
            }
            else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]]) {
                [dict setObject:[self idFromObject:value] forKey:key];
            }
            else {
                [dict setObject:[value dictionaryFromModel] forKey:key];
            }
        } else if (key && value == nil) {
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    return dict;
}
- (id)idFromObject:(nonnull id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        if (object != nil && [object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [array addObject:obj];
                }
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }
                else {
                    [array addObject:[obj dictionaryFromModel]];
                }
            }
            return array;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]) {
                    [dic setObject:object[key] forKey:key];
                }
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                else {
                    [dic setObject:[object[key] dictionaryFromModel] forKey:key];
                }
            }
            return dic;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    
    return [NSNull null];
}

//字符串转字典 ----字符串转成 data 之后再转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
