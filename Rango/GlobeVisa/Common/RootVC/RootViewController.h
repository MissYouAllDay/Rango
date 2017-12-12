//
//  RootViewController.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/12.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, strong) UILabel *barName; // 导航栏名称

// 自定义状态栏
- (UIView *)createNavigationBar;
//判断用户是否登录
- (void)userHave:(NSString *)viewController;

//登录调用的方法
- (void)haveLogin;

//未登录调用的方法
- (void)unLogin:(NSString *)viewcontroller;

//登录成功
- (void)loadSuccess;

//手机号验证
- (BOOL)checkTelNumber:(NSString *)telNumber;

//邮箱验证
- (BOOL)checkEmail:(NSString *)email;

//日期验证
- (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;

//判断是否为数字
- (BOOL)isNum:(NSString *)checkedNumString;

//登录初始化  模态
- (BaseNavigationVC *)loginVC;

//验证身份证号码是否符合要求
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard;

// 登录密码判断  数字和字符  最少6位  最多15位
-(BOOL)checkPassWord:(NSString *)passWord ;

// 手机验证码
-(BOOL)checkMessageCode:(NSString *)messageCode;

#pragma mark - - - - - - - - - - NEW - - - - - - - - - - -
// 返回状态栏的高度
- (CGFloat)statueBarHeight;
- (void)selfBackBtnAction;

// 下一步  确定按钮   默认为确定
- (UIButton *)createDownNextBtn;


@end
