//
//  MSLUpInfoDataHeadView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/7.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLUpInfoDataHeadView.h"

@implementation MSLUpInfoDataHeadView

- (void)setSlideValue:(NSString *)slideValue {
    
    _slideValue = slideValue;
    _speedLab.text = [NSString stringWithFormat:@"%@%%",_slideValue];
    
    _blueLab.frame = CGRectMake(_grayLine.leftCX, _grayLine.topCX,_grayLine.widthCX * [slideValue intValue] / 100, _grayLine.heightCX);
}

@end
