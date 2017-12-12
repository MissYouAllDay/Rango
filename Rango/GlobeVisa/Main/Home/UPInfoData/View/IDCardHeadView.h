//
//  IDCardHeadView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCardHeadView : UIView

@property (nonatomic, strong) UIImage *image; // 小相机图片

@property (weak, nonatomic) IBOutlet UIImageView *fontImg;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@end
