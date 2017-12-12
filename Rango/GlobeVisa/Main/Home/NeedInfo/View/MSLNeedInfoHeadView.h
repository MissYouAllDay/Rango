//
//  MSLNeedInfoHeadView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLProductModel.h"

@interface MSLNeedInfoHeadView : UIView
@property (nonatomic, strong) MSLProductModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *detalLab;
@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UILabel *staicLab;
@property (weak, nonatomic) IBOutlet UILabel *validityTime;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
