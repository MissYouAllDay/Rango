//
//  PassportHeadView.h
//  GlobeVisa
//
//  Created by MSLiOS on 2017/6/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassportHeadView : UIView

@property (nonatomic, strong) UIImage *image;   //相机图片

@property (weak, nonatomic) IBOutlet UIImageView *passportImagheView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
