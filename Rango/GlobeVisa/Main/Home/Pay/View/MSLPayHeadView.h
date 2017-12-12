//
//  MSLPayHeadView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLPayHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *money;  // 金额
@property (weak, nonatomic) IBOutlet UIButton *togetherBtn; // 陪签

@property (weak, nonatomic) IBOutlet UIImageView *togetherImg; // 陪签图片
@property (weak, nonatomic) IBOutlet UILabel *togetherMoney; // 陪签价格

@end
