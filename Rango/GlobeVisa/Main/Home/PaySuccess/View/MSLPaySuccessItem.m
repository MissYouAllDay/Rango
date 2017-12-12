
//
//  MSLPaySuccessItem.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/23.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLPaySuccessItem.h"

@implementation MSLPaySuccessItem

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _visaImg.layer.cornerRadius = 10;
    _visaImg.clipsToBounds = YES;
}

@end
