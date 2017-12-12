//
//  MSLNeedInfoScrollItem.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNeedInfoScrollItem.h"

@implementation MSLNeedInfoScrollItem

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _scroll.bounces = NO;
    _scroll.minimumZoomScale = 1.2;
    _scroll.maximumZoomScale = 1.2;
}

@end
