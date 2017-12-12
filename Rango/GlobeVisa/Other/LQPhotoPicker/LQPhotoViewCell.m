//
//  LQPhotoViewCell.m
//  LQPhotoPicker
//
//  Created by lawchat on 15/9/22.
//  Copyright (c) 2015年 Fillinse. All rights reserved.
//

#import "LQPhotoViewCell.h"

@implementation LQPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setBigImgViewWithImage:(UIImage *)img{
    if (_BigImgView) {
        _BigImgView.frame = _profilePhoto.frame;
        _BigImgView.image = img;
    }
    else{
        _BigImgView = [[UIImageView alloc]initWithImage:img];
        _BigImgView.frame = _profilePhoto.frame;
        [self insertSubview:_BigImgView atIndex:0];
    }
    _BigImgView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setIsDelegate:(BOOL)isDelegate {
    
    _isDelegate = isDelegate;
    
//    [self setNeedsLayout];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
//    if (_isDelegate) {
//
//        self.closeButton.hidden = NO;
//
//        CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
//        keyAnimaion.keyPath = @"transform.rotation";
//        keyAnimaion.values = @[@(-20 / 180.0 * M_PI),@(20 /180.0 * M_PI),@(-20/ 180.0 * M_PI)];//度数转弧度
//
//        keyAnimaion.removedOnCompletion = NO;
//        keyAnimaion.fillMode = kCAFillModeForwards;
//        keyAnimaion.duration = 0.3;
//        keyAnimaion.repeatCount = 3;
//        [self.closeButton.layer addAnimation:keyAnimaion forKey:nil];
//
//    }else {
//
//        self.closeButton.hidden = YES;
//    }
    
}

@end
