//
//  MSLOrderListCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/21.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLOrderModel.h"
@interface MSLOrderListCell : UITableViewCell

@property (nonatomic, strong) MSLOrderModel *model;
@property (nonatomic, assign) NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;

@property (weak, nonatomic) IBOutlet UILabel *upInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sendRightImg;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UILabel *okLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendType;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *contineBtn;


@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fifView;




@end
