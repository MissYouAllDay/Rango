//
//  StatusWindow.h
//  xinchengShop
//
//  Created by 周荣硕 on 16/3/22.
//  Copyright © 2016年 com.banksoft. All rights reserved.
//

#import "StatusWindow.h"
#import "AppDelegate.h"
#import "MSLLoginVC.h"

UIWindow *_statusWindow;
UIImageView *_imageView;
BOOL _isLogin; //是否是登录

#define selfHei  44
#define LabHei   44
#define ImgHei   30

#define XWWindowHeight 20
// 动画的执行时间
#define XWDuration 0.5
// 窗口的停留时间
#define XWDelay 1.5
// 字体大小
#define XWFont [UIFont systemFontOfSize:12]

@interface StatusWindow ()<UIAlertViewDelegate>
{
    
}
@end
@implementation StatusWindow

- (void)creatLoginAlert {

    _statusWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _statusWindow.windowLevel = UIWindowLevelAlert;
    _statusWindow.hidden = NO;
  
    UIView *bgView = [[UIView alloc] initWithFrame:_statusWindow.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .5;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"  message:@"检测到您的账户已在其他手机登录，如非本人操作请修改密码，防止财产流失" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *changePW = [UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _isLogin = NO;
        [StatusWindow hiddenTopWindow];
    }];
    UIAlertAction *login= [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _isLogin = YES;
        [StatusWindow hiddenTopWindow];
    }];
    [alert addAction:changePW];
    [alert addAction:login];
    UIViewController *vc = [[UIViewController alloc] init];
    _statusWindow.rootViewController = vc;
    [vc presentViewController:alert animated:YES completion:^{}];
}

//隐藏window
+ (void)hiddenTopWindow {
    
    [UIView animateWithDuration:.35 animations:^{
        
        _statusWindow.frame = CGRectMake(0, 0, 0, 0);
        _statusWindow.clipsToBounds = YES;
        _statusWindow = nil;
    }];
    
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    MSLLoginVC *log = [[MSLLoginVC alloc] init];

    log.titleName = @"登录";
    log.animation = 1;
    log.viewType = 1;
    BaseNavigationVC *nc = [[BaseNavigationVC alloc] initWithRootViewController:log];
    [window.rootViewController presentViewController:nc animated:YES completion:^{}];
    if (!_isLogin) {
        
        MSLLoginVC *log1 = [[MSLLoginVC alloc] init];
        log1.titleName = @"找回密码";
        log1.viewType = 2;
        [log.navigationController pushViewController:log1 animated:NO];
        return;
    }
}


@end
