//
//  MSLPaySuccessVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/23.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"

@interface MSLPaySuccessVC : RootViewController

@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, copy) NSString *localName;

@end
