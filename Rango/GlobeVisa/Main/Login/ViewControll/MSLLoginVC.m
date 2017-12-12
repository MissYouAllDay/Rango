//
//  MSLLoginVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLLoginVC.h"
#import "MSLLoginView.h"

#import "MSLRegisView.h"
#import "JPUSHService.h"
@interface MSLLoginVC ()
{
    MSLLoginView *_loginView;
    MSLRegisView *_regisView;
    
    
}
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MSLLoginVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _loginView.animation = _animation;
}

- (void)loadView {
    
    UIScrollView*scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view= scrollView;
}

- (void)setViewType:(int)viewType {
    
    [self createView];
    
    // 0 : 注册   1 ： 登录   2 ： 找回密码
    switch (viewType) {
        case 0:
            _regisView.title.text = _titleName;
            [_regisView.loginBtn setTitle:[_titleName isEqualToString:@"注册"]?@"注册":@"确定" forState:UIControlStateNormal];
            _regisView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            [self.view addSubview: _regisView];
            break;
        case 1:
            _loginView.title.text = _titleName;
            [_loginView.loginBtn setTitle:_titleName forState:UIControlStateNormal];
            _loginView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            [self.view addSubview: _loginView];
            break;
        case 2:
            _regisView.title.text = _titleName;
            [_regisView.loginBtn setTitle:@"修改密码" forState:UIControlStateNormal];
            _regisView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            [self.view addSubview: _regisView];
            break;

        default:
            break;
    }
}

// 创建视图
- (void)createView {
    _loginView = [[[NSBundle mainBundle] loadNibNamed:@"MSLLoginView" owner:nil options:nil] lastObject];
    _regisView = [[[NSBundle mainBundle] loadNibNamed:@"MSLRegisView" owner:nil options:nil] lastObject];
    
    _loginView.isShow = YES;
    _regisView.isShow = YES;

    [_loginView.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_regisView.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
  
    [_loginView.loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_regisView.loginBtn addTarget:self action:@selector(reginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_loginView.getMark addTarget:self action:@selector(getMarkCode:) forControlEvents:UIControlEventTouchUpInside];
    [_regisView.getMark addTarget:self action:@selector(getMarkCode:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reginViewRegFirstAction)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginViewRegFirstAction)];
    [_loginView.wholeView addGestureRecognizer:tap1];
    [_regisView.wholeView addGestureRecognizer:tap];
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
        [self loginwithMessageCode:@{@"cust_phone":_loginView.numberTF.text,@"code":_loginView.pwTF.text,@"logn_app_type":@"0",APP_COMPANY_ID:APP_COMPANY_IDNUM}];
        return ;
    }
//     密码登录
    if (![super checkPassWord:_loginView.pwTF.text]) {
        [CXUtils createAllTextHUB:@"密码必须为6-15位字母或数字"];
        return ;
    }
    
    [self loginAction:@{@"cust_phone":_loginView.numberTF.text,@"cust_password":_loginView.pwTF.text,@"logn_app_type":@"0",APP_COMPANY_ID:APP_COMPANY_IDNUM}];
}

// 密码 登录
- (void)loginAction:(NSDictionary *)param {
    
    [NetWorking getRequest:LOGIN_URL withParam:param success:^(id responseObjc) {
        
        NSDictionary *dict = responseObjc;
        int errorCode = [dict[@"error_code"] intValue];
        
        if (errorCode != 0) {
            [CXUtils createAllTextHUB:dict[@"reason"]];
            return ;
        }
    // add 登录方式
        NSString *token = [NSString stringWithFormat:@"%@",[dict[@"result"] objectForKey:TOKEN_KEY]];
        NSString *name = [NSString stringWithFormat:@"%@",[dict[@"result"] objectForKey:NAME_KEY]];
        NSString *telName = [NSString stringWithFormat:@"%@",[dict[@"result"] objectForKey:TEL_KEY]];

        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:NAME_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:telName forKey:TEL_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:@"tel" forKey:LOGINTYPE_KEY]; // 登录方式
        [JPUSHService setTags:nil aliasInbackground:token];

        [self viewDisapperAnimation];

        // 数据存储
    } failBlock:^(NSError *error) {}];
}
// 验证码登录
- (void)loginwithMessageCode:(NSDictionary *)param {
    
    [CXUtils createHUB];
    [NetWorking getRequest:MESLOGIN_URL withParam:param success:^(id responseObjc) {
        
        [CXUtils hideHUD];
        NSDictionary *dict = responseObjc;
        int errorCode = [dict[@"error_code"] intValue];
        
        if (errorCode != 0) {
            [CXUtils createAllTextHUB:dict[@"reason"]];
            return ;
        }

        NSString * token = [NSString stringWithFormat:@"%@",[dict[@"result"] objectForKey:TOKEN_KEY]];
        NSString *name = [NSString stringWithFormat:@"%@",[dict[@"result"] objectForKey:NAME_KEY]];

        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:NAME_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:@"tel" forKey:LOGINTYPE_KEY]; // 登录方式

        [JPUSHService setTags:nil aliasInbackground:token];

        [self viewDisapperAnimation];

    } failBlock:^(NSError *error) {
        
        [CXUtils hideHUD];
    }];
}
#pragma mark - - - - - - - - - - 注册  找回密码 - - - - - - - - - - -
// 注册  找回密码 点击事件
- (void)reginAction:(UIButton *)sender {
    
    [_regisView reginFirst];
//    注册
    NSDictionary *dic = [self reginCheckData];
    
    if (dic.count != 0 || dic != nil) {
        
        if ([_titleName isEqualToString:@"注册"]) {
            [self reginNumber:dic];
            return;
        }
       
        // 绑定手机
        if ([_titleName isEqualToString:@"绑定手机"]) {
            [self addTelPhone:dic];
            return;
        }
        //  修改密码
        [self forgetPassWord:dic];
    }
}

// check 信息
- (NSDictionary *)reginCheckData {
    
    if (![super checkTelNumber:_regisView.numberTF.text]) {
        [CXUtils createAllTextHUB:@"请输入正确的手机号"];
        return nil;
    }
    if (_regisView.markTF.text.length != 6) {
        [CXUtils createAllTextHUB:@"请输入正确的验证码"];
        return nil;
    }
    if (![super checkPassWord:_regisView.pwTF.text]) {
        [CXUtils createAllTextHUB:@"密码必须为6-15位字母或数字"];
        return nil;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    param[@"phone"] = _regisView.numberTF.text;
    param[@"code"] = _regisView.markTF.text;
    param[@"cust_password"] = _regisView.pwTF.text;
    param[APP_COMPANY_ID] = APP_COMPANY_IDNUM;
    
    return param;
}

// 修改密码
- (void)forgetPassWord:(NSDictionary *)param {
    
    [CXUtils createHUB];
    [NetWorking postRequest:CHANGEPW_URL withParam:param withErrorCode:YES success:^(id responseObjc) {
        [CXUtils hideHUD];
        [self viewDisapperAnimation];
    } failBlock:^(NSError *error) {
        [CXUtils hideHUD];
    }];
}

// 核对 手机号是否注册
- (void)checkTelNunberWithNet:(NSString *)text {
    
    [CXUtils createHUB];
    if (_viewType == 0 || _viewType == 2) {
        _regisView.getMark.userInteractionEnabled = NO;
    }else {
        _loginView.getMark.userInteractionEnabled = NO;
    }
    [NetWorking postRequest:TEL_URL withParam:@{@"phone":text}  withErrorCode:YES success:^(id responseObjc) {
        
        [CXUtils hideHUD];
        if (_viewType == 0 || _viewType == 2) {
            _regisView.getMark.userInteractionEnabled = YES;
        }else {
            _loginView.getMark.userInteractionEnabled = YES;
        }
        
        NSDictionary *dict = responseObjc;
        int error = [dict[@"error_code"] intValue];
        
        // 注册  zhaohuimima
        if (_viewType == 0) {
            
            error == 0 ? [CXUtils createAllTextHUB:dict[@"reason"]] : [self postMessageWithCode:text];
        }
        // 验证码登录
        if (_viewType == 1 || _viewType == 2) {
            
            error == 0 ? [self postMessageWithCode:text] : [CXUtils createAllTextHUB:dict[@"reason"]];
        }
        
    } failBlock:^(NSError *error) {
        [CXUtils hideHUD];
        if (_viewType == 0 || _viewType == 2) {
            _regisView.getMark.userInteractionEnabled = YES;
        }else {
            _loginView.getMark.userInteractionEnabled = YES;
        }    }];
}

// 注册
- (void)reginNumber:(NSDictionary *)param {

    [CXUtils createHUB];
    [NetWorking postRequest:REG_URL withParam:param withErrorCode:YES success:^(id responseObjc) {
      
        [CXUtils hideHUD];
      
        NSDictionary *dict = responseObjc;
     
        int error = [dict[@"error_code"] intValue];
        
        [CXUtils createAllTextHUB:dict[@"reason"]];

        if (error == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self viewDisapperAnimation];
          });
      }
        
    } failBlock:^(NSError *error) {  [CXUtils hideHUD]; }];
}

// 绑定手机号
- (void)addTelPhone:(NSDictionary *)param {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:param];
    [dic setObject:TOKEN_VALUE forKey:TOKEN_KEY];
    [NetWorking postHUDRequest:CHANGE_TEL_URL withParam:dic withErrorCode:NO withHUD:NO success:^(id responseObjc) {
    
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
       
        [[NSUserDefaults standardUserDefaults] setObject:_regisView.numberTF.text forKey:TEL_KEY];
        [[NSUserDefaults standardUserDefaults] setObject:_regisView.numberTF.text forKey:NAME_KEY];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self viewDisapperAnimation];
        });
    } failBlock:^(NSError *error) { }];
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

#pragma mark - - - - - - - - - - 获取验证码 - - - - - - - - - - -
- (void)getMarkCode:(UIButton *)sender {

    if (sender.tag == 4000) {
        _viewType = 1;
    }else {

        _viewType = ([_titleName isEqualToString:@"注册"] || [_titleName isEqualToString:@"绑定手机"])  ? 0 : 2;
    }

    if (_viewType == 0 || _viewType == 2) {
        
        [_regisView reginFirst];
        
        [super checkTelNumber:_regisView.numberTF.text] ?  [self checkTelNunberWithNet:_regisView.numberTF.text] : [CXUtils createAllTextHUB:@"请填写正确的手机号"];
    }
    
    if (_viewType == 1) {
        
        [_loginView reginFirst];
        
        if ([super checkTelNumber:_loginView.numberTF.text]) {
            
            [self postMessageWithCode:_loginView.numberTF.text];
            
        }else {
            
            [CXUtils createAllTextHUB:@"请填写正确的手机号"];
        }
    }
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
                
                if (_viewType == 0 || _viewType == 2) {
                    [_regisView.getMark setTitle:@"重新发送" forState:UIControlStateNormal];
                    _regisView.getMark.hidden = NO;
                    _regisView.timeLab.hidden = YES;
                }else {
                    [_loginView.getMark setTitle:@"重新发送" forState:UIControlStateNormal];
                    _loginView.getMark.hidden = NO;
                    _loginView.timeLab.hidden = YES;
                }
                
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_viewType == 0 || _viewType == 2) {
                    _regisView.timeLab.text = [NSString stringWithFormat:@"%.2d", seconds];
                    _regisView.timeLab.hidden = NO;
                    _regisView.getMark.hidden = YES;
                }else {
                    _loginView.timeLab.text = [NSString stringWithFormat:@"%.2d", seconds];
                    _loginView.timeLab.hidden = NO;
                    _loginView.getMark.hidden = YES;
                }
              
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - - - - - - - - - - 释放键盘 - - - - - - - - - - -
// 释放键盘
- (void)reginViewRegFirstAction {
    
    [_regisView reginFirst];
}
- (void)loginViewRegFirstAction {
    
    [_loginView reginFirst];
}

// 返回上一页
- (void)backAction:(UIButton *)sender {
    
    [self viewDisapperAnimation];
}
// 返回
- (void)viewDisapperAnimation {
    
    if (_animation == 1) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
        return ;
    }
    [self.navigationController popViewControllerAnimated:YES];
}



@end
