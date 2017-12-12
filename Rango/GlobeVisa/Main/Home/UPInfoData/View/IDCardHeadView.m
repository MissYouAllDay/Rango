//
//  IDCardHeadView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "IDCardHeadView.h"

@implementation IDCardHeadView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _fontImg.layer.borderColor = COLOR_230.CGColor;
    _fontImg.clipsToBounds = YES;
    _fontImg.layer.borderWidth = .5;
    _image = [UIImage imageNamed:@"photo"];
    _fontImg.image = _image;
    _fontImg.layer.cornerRadius = 5;
    
    _backImg.layer.borderColor = COLOR_230.CGColor;
    _backImg.layer.borderWidth = .5;
    _backImg.image = _image;
    _backImg.layer.cornerRadius = 5;
    _backImg.clipsToBounds = YES;
    

    
}

@end
