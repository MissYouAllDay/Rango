
//
//  MSLPaySuccessHead.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/23.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLPaySuccessHead.h"

@implementation MSLPaySuccessHead

- (void)awakeFromNib {
    
    [super awakeFromNib];

    _errorLab.text = @"已收到您的订单，请时刻关注平台查看进度\n如有其他问题请联系客服：400-006-6518";
}

@end
