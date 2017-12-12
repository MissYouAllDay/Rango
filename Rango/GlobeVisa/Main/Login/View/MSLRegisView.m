//
//  MSLRegisView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLRegisView.h"

@implementation MSLRegisView
{
    UITextField *_replaceTF;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
   
    _timeLab.widthCX = _timeLab.heightCX;
    _pwTF.secureTextEntry = YES;

    _numberTF.keyboardType = UIKeyboardTypeNumberPad;
    _markTF.keyboardType = UIKeyboardTypeNumberPad;
    
    NSArray *arr = @[_nemberBgView,_pwBgView,_loginBtn,_markBgView,_getMark,_timeLab];
    
    for (UIView *view  in arr) {
        
        view.layer.cornerRadius = view.heightCX / 2;
        view.clipsToBounds = YES;
    }
    
    _getMark.layer.borderColor = [UIColor whiteColor].CGColor;
    _getMark.layer.borderWidth = 1;
    
    _timeLab.layer.borderColor = [UIColor whiteColor].CGColor;
    _timeLab.layer.borderWidth = 1;
    _timeLab.hidden = YES;
    
    _pwTF.placeholder = @"6-15位字母或数字";
    _markTF.placeholder = @"验证码";
    _numberTF.placeholder = @"请输入您的手机号";
    
    [_pwTF setValue:RGBColor(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
    [_markTF setValue:RGBColor(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
    [_numberTF setValue:RGBColor(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
    _getMark.tag = 4001;
}

- (void)reginFirst {
    
    if (_replaceTF) {
        [_replaceTF resignFirstResponder];
    }
}

- (IBAction)seeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    _pwTF.secureTextEntry = !sender.selected;
}

- (IBAction)getMarkBtnAction:(UIButton *)sender {
    
   
}

- (IBAction)startLoginAction:(UIButton *)sender {
    
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _replaceTF = textField;
    return YES;
}

- (void)setIsShow:(BOOL)isShow {
    
    _isShow = isShow;
    if (@available(ios 11.0,*)) {
        
        _barView.frame = CGRectMake(0, 0, WIDTH, 44);
    }else {
        
        _barView.frame = CGRectMake(0, 20, WIDTH, 44);
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (_isShow) {
        _barView.hidden = NO;
    }
}
@end
