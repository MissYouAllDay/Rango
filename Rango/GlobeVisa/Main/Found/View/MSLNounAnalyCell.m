//
//  MSLNounAnalyCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNounAnalyCell.h"

@implementation MSLNounAnalyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _name.font = FONT_SIZE_13;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
