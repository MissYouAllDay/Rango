//
//  MSLAreaVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/30.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLCountryModel.h"
@interface MSLAreaVC : RootViewController

@property (nonatomic, strong) MSLCountryModel *countryModel;

@property (nonatomic, copy) NSString *locaName;  // 省份

@end
