//
//  MSLUpInfoDataHeadView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/7.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLUpInfoDataHeadView : UIView

//进度条的值
@property (nonatomic, copy) NSString *slideValue;

@property (weak, nonatomic) IBOutlet UILabel *blueLab;
@property (weak, nonatomic) IBOutlet UILabel *grayLine;
@property (weak, nonatomic) IBOutlet UILabel *speedLab;

@end
