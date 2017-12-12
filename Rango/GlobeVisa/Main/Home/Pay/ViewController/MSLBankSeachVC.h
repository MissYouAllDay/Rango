//
//  MSLBankSeachVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
#import "MSLBankModel.h"

@protocol CXBankSearchVCDelegate <NSObject>

- (void)bankSearchwithModel:(MSLBankModel *)model;

@end

@interface MSLBankSeachVC : RootViewController

@property (nonatomic, weak) id<CXBankSearchVCDelegate> delegate;

@end
