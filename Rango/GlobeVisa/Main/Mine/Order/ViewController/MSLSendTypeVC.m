//
//  MSLSendTypeVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLSendTypeVC.h"
#import "MSLSendTypeView.h"

@interface MSLSendTypeVC ()
{
    
    UIView *_bar;
    MSLSendTypeView *_mainView;
    UIButton *_nextBtn;
}
@end

@implementation MSLSendTypeVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"材料寄送方式";
    [self createMainView];
    [self createNextBtn];

}
- (void)createMainView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  WIDTH, 247)];
    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"MSLSendTypeView" owner:nil options:nil] lastObject];
    _mainView.frame = CGRectMake(0, 0,  WIDTH, 247);
    [view addSubview:_mainView];
    [self.view addSubview:view];
}

- (void)createNextBtn {
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(0, self.view.bottomCX - 45 - [CXUtils statueBarHeight] - 44, WIDTH, 45);
    
    _nextBtn.backgroundColor = COLOR_BUTTON_BLUE;
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextBtn];
}

- (void)nextBtnAction:(UIButton *)sender {
    

    if (_mainView.index == 2 && _mainView.address.length == 0) {
        
        [CXUtils createAllTextHUB:@"请填写您的详细地址"];
        return;
    }
    if (_mainView.index == 3 && _mainView.address.length == 0 ){
        
        [CXUtils createAllTextHUB:@"请选择银行网点"];
        return;
    }
    
    NSString *bankName = [_mainView.threeLab.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *param = @{@"file_mail_type":[NSString stringWithFormat:@"%ld",_mainView.index],@"mail_address":_mainView.address,@"token":TOKEN_VALUE,@"order_id":_orderID};
    [NetWorking postHUDRequest:URL_ORDER_UPDATE withParam:param withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [self.delegate sendType:[NSString stringWithFormat:@"%ld",_mainView.index] withIndex:_index];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failBlock:^(NSError *error) {}];
}




@end
