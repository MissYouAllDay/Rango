//
//  MSLAddTelVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/4.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLAddTelVC.h"
#import "MSLLoginView.h"
@interface MSLAddTelVC ()
{
    MSLLoginView *_loginView;

}

@end

@implementation MSLAddTelVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createView];
    
    _loginView.title.text = @"绑定手机号";
    [_loginView.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    _loginView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview: _loginView];

}

- (void)loadView {
    
    UIScrollView*scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view= scrollView;
}

// 创建视图
- (void)createView {
    _loginView = [[[NSBundle mainBundle] loadNibNamed:@"MSLLoginView" owner:nil options:nil] lastObject];
    
    _loginView.loginType.hidden = YES;
    _loginView.otherLoginBg.hidden = YES;
    _loginView.regBgView.hidden = YES;
    _loginView.numberTF.keyboardType = UIKeyboardTypeNumberPad;

    [_loginView.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.getMark addTarget:self action:@selector(getMarkCode:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginViewRegFirstAction)];
    [_loginView.wholeView addGestureRecognizer:tap1];
    
    [_loginView markLoginViewState];
}

#pragma mark - - - - - - - - - - 登录点击事件 - - - - - - - - - - -
-  (void)loginBtnAction {
    
    [_loginView reginFirst];
    
    if (![super checkTelNumber:_loginView.numberTF.text]) {
        
        [CXUtils createAllTextHUB:@"请填写正确的手机号"];
        return ;
    }
    
    //     验证码登录
    if (_loginView.markLogin.selected) {
        
        if (![super checkMessageCode:_loginView.pwTF.text]) {
            
            [CXUtils createAllTextHUB:@"请填写正确的验证码"];
            return ;
        }
    }
    
    [self addTelPhone:@{@"phone":_loginView.numberTF.text,@"code":_loginView.pwTF.text,APP_COMPANY_ID:APP_COMPANY_IDNUM,TOKEN_KEY:TOKEN_VALUE}];
}

// 绑定手机号
- (void)addTelPhone:(NSDictionary *)param {

    [NetWorking postHUDRequest:CHANGE_TEL_URL withParam:param withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:_loginView.numberTF.text forKey:TEL_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:_loginView.numberTF.text forKey:NAME_KEY];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSError *error) { }];
}

#pragma mark - - - - - - - - - - 获取验证码 - - - - - - - - - - -
- (void)getMarkCode:(UIButton *)sender {
    
    [_loginView reginFirst];
    
    if (![super checkTelNumber:_loginView.numberTF.text]) {
        
        [CXUtils createAllTextHUB:@"请填写正确的手机号"];
        return ;
    }
    [self postMessageWithCode:_loginView.numberTF.text];
}

// 发送验证码
- (void)postMessageWithCode:(NSString *)text {
    
    [NetWorking postRequest:MESAGE_URL withParam:@{@"phone":text} withErrorCode:YES success:^(id responseObjc) {
        
        NSDictionary *dict = responseObjc;
        int error = [dict[@"error_code"] intValue];
        [CXUtils createAllTextHUB: dict[@"reason"]];
        
        if (error == 0) {   [self startTime];  }
        
    } failBlock:^(NSError *error) {}];
}

// 倒计时
- (void)startTime {
    
    __block NSInteger time = 59;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_loginView.getMark setTitle:@"重新发送" forState:UIControlStateNormal];
                _loginView.getMark.hidden = NO;
                _loginView.timeLab.hidden = YES;
                
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _loginView.timeLab.text = [NSString stringWithFormat:@"%.2d", seconds];
                _loginView.timeLab.hidden = NO;
                _loginView.getMark.hidden = YES;
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - - - - - - - - - - 释放键盘 - - - - - - - - - - -
- (void)loginViewRegFirstAction {
    
    [_loginView reginFirst];
}

// 返回上一页
- (void)backAction:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
