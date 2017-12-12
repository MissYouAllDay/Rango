
//
//  MSLContactAddView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/3.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLContactAddView.h"

@implementation MSLContactAddView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    NSArray *arr = @[_cancelBtn,_sureBtn,_nameBgView,_telBgView,_jobBgView,_outBgView,_returnBgView,_messageBgView];
    for (UIView *view in arr) {
        
        view.layer.borderColor = COLOR_231.CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius = 5;
        view.clipsToBounds = YES;
    }
    _cancelBtn.layer.borderColor = HWColor(230, 230, 230).CGColor;
    _sureBtn.layer.borderColor = COLOR_FONT_BLUE.CGColor;

    [_jobBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_outBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_returnBtn setTitle:@"请选择" forState:UIControlStateNormal];
    
    [_jobBtn setTitleColor:COLOR_211 forState:UIControlStateNormal];
    [_outBtn setTitleColor:COLOR_211 forState:UIControlStateNormal];
    [_returnBtn setTitleColor:COLOR_211 forState:UIControlStateNormal];
    
    _nameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名"attributes:@{NSForegroundColorAttributeName:COLOR_211}];
    _telTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入常用手机号码"attributes:@{NSForegroundColorAttributeName:COLOR_211}];
    _messageTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入常用邮箱"attributes:@{NSForegroundColorAttributeName:COLOR_211}];
    
    [_addBtn setTitle:@"新建联系人" forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    _nameTF.returnKeyType = UIReturnKeyDone;
    _telTF.returnKeyType = UIReturnKeyDone;
    _messageTF.returnKeyType = UIReturnKeyDone;
    
    _nameTF.delegate = self;
    _telTF.delegate = self;
    _messageTF.delegate = self;
    
    _outBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _outBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    _returnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _returnBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    _telTF.keyboardType = UIKeyboardTypeNumberPad;

}

- (void)returnOldStatue:(UIButton *)sender {
    
    [sender setTitle:@"请选择" forState:UIControlStateNormal];
    [sender setTitleColor:COLOR_211 forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
