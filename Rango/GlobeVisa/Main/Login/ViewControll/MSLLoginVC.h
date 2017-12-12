//
//  MSLLoginVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLLoginVC : RootViewController

@property (nonatomic, copy) NSString *titleName;

// 0 : 注册   1 ： 登录   2 ： 找回密码  3 : 修改密码   4 ： 绑定手机号
@property (nonatomic, assign) int  viewType;

// 0 : push  1: 模态
@property (nonatomic, assign) int  animation;


@end
