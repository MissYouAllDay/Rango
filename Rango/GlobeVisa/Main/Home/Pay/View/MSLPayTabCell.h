//
//  MSLPayTabCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLPayTabCell : UITableViewCell

// 0 ： 微信   1 ： 支付宝   3： 银联
@property (nonatomic, assign) NSInteger payType;



@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *weixin;
@property (weak, nonatomic) IBOutlet UIImageView *aliPay;
@property (weak, nonatomic) IBOutlet UIImageView *moneyBoth;
- (IBAction)weixinAction:(UIButton *)sender;
- (IBAction)aliPayAction:(UIButton *)sender;
- (IBAction)moneyBothAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UIView *seachBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end
