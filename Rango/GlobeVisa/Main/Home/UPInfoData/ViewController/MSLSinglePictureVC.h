//
//  MSLSinglePictureVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
#import "MSLOrderDatumModel.h"
@interface MSLSinglePictureVC : RootViewController
@property (nonatomic, copy) NSString *contactID; //联系人ID  必传

@property (nonatomic, strong) MSLOrderDatumModel *datumModel;
@property (nonatomic, copy) NSString *orderID;

// 是否是从联系人中进行修改
@property (nonatomic, assign) BOOL contactChange;
@end
