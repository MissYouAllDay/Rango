//
//  MSLHuKouVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"

@interface MSLHuKouVC : RootViewController
@property (nonatomic, copy) NSString *contactID; //联系人ID  必传
@property (nonatomic, copy) NSString *orderID;      // lianxiren
@property (nonatomic, strong) NSArray *accBookArr;//户口本信息-- 图片多张

// 是否是从联系人中进行修改
@property (nonatomic, assign) BOOL contactChange;
@end
