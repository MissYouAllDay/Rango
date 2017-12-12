//
//  MSLRegisView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLRegisView : UIView<UITextFieldDelegate>
@property (nonatomic, assign) BOOL isShow;

@property (weak, nonatomic) IBOutlet UIView *barView;

@property (weak, nonatomic) IBOutlet UIView *wholeView;


@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;


// 返回按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextField *markTF;


@property (weak, nonatomic) IBOutlet UIView *nemberBgView;


@property (weak, nonatomic) IBOutlet UIView *pwBgView;

@property (weak, nonatomic) IBOutlet UIView *markBgView;

// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//  获取验证那按钮
@property (weak, nonatomic) IBOutlet UIButton *getMark;


- (IBAction)seeAction:(UIButton *)sender;

- (IBAction)getMarkBtnAction:(UIButton *)sender;
- (IBAction)startLoginAction:(UIButton *)sender;

// 释放键盘
- (void)reginFirst;
@end
