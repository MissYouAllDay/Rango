//
//  MSLLoginView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLLoginView : UIView<UITextFieldDelegate>


@property (nonatomic, assign) BOOL isShow;
// 0 : push  1: 模态
@property (nonatomic, assign) int  animation;

@property (weak, nonatomic) IBOutlet UIView *barView;

@property (weak, nonatomic) IBOutlet UIView *wholeView;

@property (weak, nonatomic) IBOutlet UILabel *title;

// 返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

//密码登录
@property (weak, nonatomic) IBOutlet UIButton *passwordLogin;
//验证码登录
@property (weak, nonatomic) IBOutlet UIButton *markLogin;

@property (weak, nonatomic) IBOutlet UIView *numberBgView;
@property (weak, nonatomic) IBOutlet UIView *passWordBgView;

//  获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getMark;

@property (weak, nonatomic) IBOutlet UIImageView *pwImg;
// 密码 输入框
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;

//  倒计时
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


// 登录
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
// 注册
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
// 忘记密码
@property (weak, nonatomic) IBOutlet UIButton *forgetPW;

@property (weak, nonatomic) IBOutlet UIImageView *WXLogin;
@property (weak, nonatomic) IBOutlet UIImageView *QQLogin;
///  密码登录 验证码登录背景图
@property (weak, nonatomic) IBOutlet UIView *loginType;
// 第三方登录背景
@property (weak, nonatomic) IBOutlet UIView *otherLoginBg;
//免费注册   找回密码北京图
@property (weak, nonatomic) IBOutlet UIView *regBgView;

// 密码登录
- (IBAction)passWordLoginAction:(UIButton *)sender;
//验证码登录
- (IBAction)markLoginAction:(UIButton *)sender;

// 密码是否可视
- (IBAction)seeAction:(UIButton *)sender;

// 开始登录
- (IBAction)startLoginAction:(UIButton *)sender;

// 注册
- (IBAction)regisBtnAction:(UIButton *)sender;

// 忘记密码
- (IBAction)forgetPWAction:(UIButton *)sender;

// 获取验证码
- (IBAction)getMarkAction:(UIButton *)sender;


// 释放键盘
- (void)reginFirst ;

// 验证码登录
- (void)markLoginViewState;

@end
