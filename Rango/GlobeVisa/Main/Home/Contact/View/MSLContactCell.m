//
//  MSLContactCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/2.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLContactCell.h"

@implementation MSLContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)upView {
   
    self.bgImg.image = [[UIImage imageNamed:@"downW"] stretchableImageWithLeftCapWidth:20 topCapHeight:1];
    self.bgImg.transform = CGAffineTransformMakeRotation(M_PI);
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    _downView.hidden = NO;
}
- (void)bottomView {
   
    self.bgImg.image = [[UIImage imageNamed:@"downW"] stretchableImageWithLeftCapWidth:20 topCapHeight:1];
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    _downView.hidden = YES;
}
- (void)normalView {
    
    self.leftView.hidden = NO;
    self.rightView.hidden = NO;
    _downView.hidden = NO;
    self.bgImg.image = [UIImage new];
    self.bgImg.backgroundColor = [UIColor whiteColor];
}
@end
