//
//  NSDictionary+Get.m
//  SafeLight
//
//  Created by jackSun on 16/5/30.
//  Copyright © 2016年 junyu. All rights reserved.
//

#import "NSDictionary+Get.h"

@implementation NSDictionary (Get)
- (int)intValueForKey:(NSString *)key {
    int ret = 0;
    if (ret == [[self objectForKey:key] intValue]) {
        ret = 0;
    } else {
        ret = [[self objectForKey:key] intValue];
    }
    return ret;
}
@end

