//
//  BaseModel.h
//  GlobeVisa
//
//  Created by MSLiOS on 2017/2/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property(nonatomic,strong) NSDictionary *map;

-(id)initWithDictionary:(NSDictionary *)dic;

- (void)setAttribute:(NSDictionary *)dic;

//model u转字符串
- (NSDictionary *)dictionaryFromModel;

//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
