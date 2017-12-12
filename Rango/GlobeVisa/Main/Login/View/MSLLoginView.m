//
//  MSLLoginView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLLoginView.h"

#import "MSLLoginVC.h"
#import "JPUSHService.h"
#import <UMSocialCore/UMSocialCore.h>
@implementation MSLLoginView
{
    UITextField *_replaceTF;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
 
    [self changeView];
    
    _getMark.tag = 4000;
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;

    [self addTap];
}

- (void)addTap {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_WXLogin addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_QQLogin addGestureRecognizer:tap1];
    
}
// 规范view  符合 项目要求
- (void)changeView {
    
    if (@available(ios 11.0,*)) {
        
        _barView.frame = CGRectMake(0, 0, WIDTH, 44);
    }else {
        
        _barView.frame = CGRectMake(0, 20, WIDTH, 44);
    }
    _numberBgView.layer.cornerRadius = _numberBgView.heightCX/2;
    _numberBgView.clipsToBounds = YES;
    
    _passWordBgView.layer.cornerRadius = _passWordBgView.heightCX/2;
    _passWordBgView.clipsToBounds = YES;
    
    _loginBtn.layer.cornerRadius = _loginBtn.heightCX/2;
    _loginBtn.clipsToBounds = YES;
    
    _getMark.layer.cornerRadius = _getMark.heightCX/2;
    _getMark.layer.borderColor = [UIColor whiteColor].CGColor;
    _getMark.layer.borderWidth = 1;
    _getMark.clipsToBounds = YES;
    
    _timeLab.widthCX = _timeLab.heightCX;
    _timeLab.layer.cornerRadius = _timeLab.heightCX/2;
    _timeLab.layer.borderColor = [UIColor whiteColor].CGColor;
    _timeLab.layer.borderWidth = 1;
    _timeLab.clipsToBounds = YES;
    _timeLab.hidden = YES;
    
    _pwTF.secureTextEntry = YES;
    _pwTF.placeholder = @"6-15位字母或数字";
    _numberTF.placeholder = @"请输入您的手机号";
    _passwordLogin.selected = YES;
    
    _timeLab.hidden = YES;
    _getMark.hidden = YES;
    
    [_pwTF setValue:RGBColor(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
    [_numberTF setValue:RGBColor(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
    
}

- (void)reginFirst {
    
    [_replaceTF resignFirstResponder];
}

// 密码登录
- (IBAction)passWordLoginAction:(UIButton *)sender {
    
    if (sender.selected) {  return;  }
    
    sender.selected = !sender.selected;
    _pwTF.keyboardType = UIKeyboardTypeDefault;
    _pwImg.image = [UIImage imageNamed:@"lock"];
    _markLogin.selected = !_markLogin.selected;
    _pwTF.placeholder = @"6-15位字母或数字";
    _seeBtn.hidden = NO;
    _timeLab.hidden = YES;
    _getMark.hidden = YES;
    _pwTF.text = nil;
}

//验证码登录
- (IBAction)markLoginAction:(UIButton *)sender {
    
    if (sender.selected) {  return;  }

    sender.selected = !sender.selected;
    _passwordLogin.selected = !_passwordLogin.selected;
    _pwTF.keyboardType = UIKeyboardTypeNumberPad;

    [self markLoginViewState];
}

- (void)markLoginViewState {
    
    _pwImg.image = [UIImage imageNamed:@"key"];
    
    _pwTF.placeholder = @"验证码";
    _seeBtn.hidden = YES;
    _timeLab.hidden = YES;
    _getMark.hidden = NO;
    _pwTF.text = nil;
}

// 密码是否可视
- (IBAction)seeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    _pwTF.secureTextEntry =  !sender.selected;
}

// 开始登录
- (IBAction)startLoginAction:(UIButton *)sender {
}
// 注册
- (IBAction)regisBtnAction:(UIButton *)sender {
    
    MSLLoginVC *reg = [[MSLLoginVC alloc] init];
    reg.titleName = @"注册";
    reg.viewType = 0;
    [self.viewController.navigationController pushViewController:reg animated:YES];
}

// 忘记密码
- (IBAction)forgetPWAction:(UIButton *)sender {
    
    MSLLoginVC *reg = [[MSLLoginVC alloc] init];
    reg.titleName = @"忘记密码";
    reg.viewType = 2;
    [self.viewController.navigationController pushViewController:reg animated:YES];
}

// 获取验证码
- (IBAction)getMarkAction:(UIButton *)sender {
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _replaceTF = textField;
    return YES;
}


// 第三方登录  tap 事件
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    if (tap.view.tag == 4000) {
        
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error) {
            [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
        }];
    }else {
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_QQ completion:^(id result, NSError *error) {
            [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
        }];
    }
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self.viewController completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        if (resp == nil) {
            
            [CXUtils createAllTextHUB:@"授权失败"];
            return ;
        }
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        if (platformType == UMSocialPlatformType_QQ) {
            [self threeLogin:@{@"qq_code_id":resp.openid,@"logn_app_type":@"0",APP_COMPANY_ID:APP_COMPANY_IDNUM} withName:resp.name];
        }else {
            [self threeLogin:@{@"wx_code_id":resp.openid,@"logn_app_type":@"0",APP_COMPANY_ID:APP_COMPANY_IDNUM} withName:resp.name];
        }
    }];
}

- (void)threeLogin:(NSDictionary *)param withName:(NSString *)name{
    
    [NetWorking getHUDRequest:OTHER_LOGIN withParam:param withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSDictionary *result = responseObjc[@"result"];
        [[NSUserDefaults standardUserDefaults] setObject:result[@"token"] forKey:TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:NAME_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:@"other" forKey:LOGINTYPE_KEY];
        [JPUSHService setTags:nil aliasInbackground:result[@"token"]];

        [self viewDisapperAnimation];
    } failBlock:^(NSError *error) { }];
  
}
- (void)viewDisapperAnimation {

    if (_animation == 1) {
        [self.viewController dismissViewControllerAnimated:YES completion:^{ }];
        return ;
    }
    [self.viewController.navigationController popViewControllerAnimated:YES];
}
@end
