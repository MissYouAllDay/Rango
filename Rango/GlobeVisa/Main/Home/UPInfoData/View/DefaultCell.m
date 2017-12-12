//
//  DefaultCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "DefaultCell.h"

@implementation DefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    self.backgroundColor = COLOR_WHITE;
    _bgView.backgroundColor = COLOR_WHITE;
}
- (void)setIsLast:(BOOL)isLast {
    
    _isLast = isLast;
    
    _bgView.hidden = NO;
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    _bgView.clipsToBounds = YES;
    _lineView.hidden = YES;
    self.backgroundColor = COLOR_247;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)manBtn:(UIButton *)sender {
   
    _changed = YES;
    [self selectMan];
}

- (IBAction)girlBtn:(UIButton *)sender {
   
    _changed = YES;
    [self selectGirl];
}

- (void)setSex:(NSString *)sex {
    
    _sex = sex;
    [_sex isEqualToString:@"女"] ? [self selectGirl] : [self selectMan];
}

- (void)selectMan {
    _girlBtn.selected = NO;
    _manBtn.selected = YES;
    _manImg.image = [UIImage imageNamed:@"round2_selection"];
    _girlImg.image = [UIImage imageNamed:@"round2"];
}

- (void)selectGirl {
    _girlBtn.selected = YES;
    _manBtn.selected = NO;
    _manImg.image = [UIImage imageNamed:@"round2"];
    _girlImg.image = [UIImage imageNamed:@"round2_selection"];
}

- (void)selectNO {
    _girlBtn.selected = NO;
    _manBtn.selected = NO;
    _manImg.image = [UIImage imageNamed:@"round2"];
    _girlImg.image = [UIImage imageNamed:@"round2"];
}


@end
