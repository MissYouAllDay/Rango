//
//  MSLUpInfoDataTabCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/7.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLUpInfoDataTabCell.h"

@implementation MSLUpInfoDataTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.borderColor = COLOR_231.CGColor;
     _bgView.layer.borderWidth = 0.5;
    _bgView.layer.cornerRadius = 5;
    _bgView.clipsToBounds = YES;
}


- (void)shouldUpData {
    
    _statueImg.image = [UIImage imageNamed:@"wait"];
    _statueName.text = @"待上传";
    _statueName.textColor= HWColor(176, 176, 176);
}

- (void)didUpData {
    
    _statueImg.image = [UIImage imageNamed:@"ok"];
    _statueName.text = @"已上传";
    _statueName.textColor= COLOR_FONT_BLUE;
}

@end
