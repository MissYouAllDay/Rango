//
//  PassportHeadView.m
//  GlobeVisa
//
//  Created by MSLiOS on 2017/6/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "PassportHeadView.h"

@implementation PassportHeadView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    _passportImagheView.layer.borderColor = COLOR_230.CGColor;
    
    _passportImagheView.layer.borderWidth = .5;
    _passportImagheView.clipsToBounds = YES;
    _passportImagheView.layer.cornerRadius = 5 ;
//    _passportImagheView.image = [UIImage imageNamed:@"camera"];
//    _passportImagheView.contentMode =  UIViewContentModeCenter;
    _passportImagheView.userInteractionEnabled = YES;
    _image = [UIImage imageNamed:@"photo"];
    _passportImagheView.image = _image;
    _passportImagheView.contentMode = UIViewContentModeCenter;
}


@end
