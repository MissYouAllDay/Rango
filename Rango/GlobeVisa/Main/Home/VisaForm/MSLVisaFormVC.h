//
//  MSLVisaFormVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/6.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"

@interface MSLVisaFormVC : RootViewController
{
    NSString * name;//
    
}

@property (nonatomic, assign) BOOL payChange;   // 是否是支付时订单修改

@property(nonatomic,copy) NSString * orderID;   //订单id     //必须传递此参数
@property(nonatomic,copy) NSString * contactID;   //联系人ID //必须传递此参数

@end
