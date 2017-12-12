//
//  MSLAreaTabCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/30.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLMerchandiseModel.h"
#import "MSLProductModel.h"
@interface MSLAreaTabCell : UITableViewCell


@property (nonatomic, strong) MSLProductModel *model;

@property (weak, nonatomic) IBOutlet UIView *downView;        // 整体 背景图
@property (weak, nonatomic) IBOutlet UIView *bgView;         //  背景图

@property (weak, nonatomic) IBOutlet UILabel *areaName;     //领取
@property (weak, nonatomic) IBOutlet UILabel *proName;       // 产品名
@property (weak, nonatomic) IBOutlet UILabel *dayLab;       //时间
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;     // 金钱
@property (weak, nonatomic) IBOutlet UIButton *doBtn;       //办理

@end
