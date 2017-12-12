//
//  MSLVisaPhotoVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/15.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
#import "MSLOrderDatumModel.h"
@interface MSLVisaPhotoVC : RootViewController
@property (nonatomic, copy) NSString *contactID;

@property (nonatomic, strong) MSLOrderDatumModel *model;

@property (nonatomic, copy) NSString *orderID;  // 订单id

@end
