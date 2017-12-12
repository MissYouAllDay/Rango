//
//  MSLPayTabCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLPayTabCell.h"

@implementation MSLPayTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _seachBgView.layer.cornerRadius = 5;
    _searchTF.placeholder = @"根据位置推荐银行，您也可以手动搜索更换银行";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)weixinAction:(UIButton *)sender {
    
    _weixin.image = [UIImage imageNamed:@"weixin"];
    _aliPay.image = [UIImage imageNamed:@"alipay1"];
    _moneyBoth.image = [UIImage imageNamed:@"unron1"];
    _payType = 0;
}

- (IBAction)aliPayAction:(UIButton *)sender {
    _weixin.image = [UIImage imageNamed:@"weixin1"];
    _aliPay.image = [UIImage imageNamed:@"alipay"];
    _moneyBoth.image = [UIImage imageNamed:@"unron1"];
    _payType = 1;
}

- (IBAction)moneyBothAction:(UIButton *)sender {
    _weixin.image = [UIImage imageNamed:@"weixin1"];
    _aliPay.image = [UIImage imageNamed:@"alipay1"];
    _moneyBoth.image = [UIImage imageNamed:@"unron"];
    _payType = 2;
}
@end
