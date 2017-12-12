//
//  BaseNavigationVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/12.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationVC : UINavigationController

- (void)backAction:(UIButton *)sender;
//返回按钮
+ (UIButton *)popBtn;
@end
