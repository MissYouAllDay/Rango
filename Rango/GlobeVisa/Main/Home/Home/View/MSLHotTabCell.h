//
//  MSLHotTabCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLProductModel.h"
#import "MSLCountryModel.h"
@interface MSLHotTabCell : UITableViewCell

// 产品  model
@property (nonatomic, strong) MSLProductModel *proModel;

// 国家 model
@property (nonatomic, strong) MSLCountryModel *counModel;


//背景图
@property (weak, nonatomic) IBOutlet UIView *bgView;

//国旗
@property (weak, nonatomic) IBOutlet UIImageView *nationalFlag;

//名称
@property (weak, nonatomic) IBOutlet UILabel *name;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *price;

// 大图
@property (weak, nonatomic) IBOutlet UIImageView *symbolize;

@end
