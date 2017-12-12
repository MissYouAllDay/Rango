//
//  StatusWindow.h
//  xinchengShop
//
//  Created by 周荣硕 on 16/3/22.
//  Copyright © 2016年 com.banksoft. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface StatusWindow : NSObject

//多设备登录时给出的提示
- (void)creatLoginAlert;


//仅在提示框中使用
@property (strong, nonatomic) UIButton *clickBtn;
@property (strong, nonatomic) UIWindow *window;



//显示提示信息
- (void)creatTopAlert:(NSString *)titler withText:(NSString *)contentText withImageName:(NSString *)imageName withtype:(int)type withSendId:(NSString *)sendId;


@end
