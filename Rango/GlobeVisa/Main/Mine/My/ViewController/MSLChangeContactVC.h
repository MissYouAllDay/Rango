//
//  MSLChangeContactVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/4.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"

@interface MSLChangeContactVC : RootViewController

@property (nonatomic, assign) BOOL isContact;  // 是否是有联系人中进入

@property (nonatomic, copy) NSString *contactID;

@property (nonatomic, copy) NSString *orderID;
@end
