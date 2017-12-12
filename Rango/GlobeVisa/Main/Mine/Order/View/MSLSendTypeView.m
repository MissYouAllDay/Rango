//
//  MSLSendTypeView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLSendTypeView.h"
#import "MSLBankSeachVC.h"
@implementation MSLSendTypeView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _index = 1;
    _address = @"山东省济宁市任城区洸河街道金宇路52号";
    _firstLab.layer.cornerRadius = 5;
    _firstLab.layer.borderColor = COLOR_231.CGColor;
    _firstLab.layer.borderWidth = 0.5;
    
    _secondBgView.layer.cornerRadius = 5;
    _secondBgView.layer.borderColor = COLOR_231.CGColor;
    _secondBgView.layer.borderWidth = 0.5;

    _threeLab.layer.cornerRadius = 5;
    _threeLab.layer.borderColor = COLOR_231.CGColor;
    _threeLab.layer.borderWidth = 0.5;

    _secondTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写您的详细地址"attributes:@{NSForegroundColorAttributeName:COLOR_211}];
    _threeLab.textColor = COLOR_211;
    [self.firstBtn addTarget:self action:@selector(firstBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondBtn addTarget:self action:@selector(secondBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeBtn addTarget:self action:@selector(threeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _secondTF.delegate = self;
}

- (void)firstBtn:(UIButton *)sender {
    
    _index = 1;
    _firstImg.image = [UIImage imageNamed:@"pay_sele"];
    _secondImg.image = [UIImage imageNamed:@"pay_unsele"];
    _threeImg.image = [UIImage imageNamed:@"pay_unsele"];
    _address = [self.firstLab.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)secondBtn:(UIButton *)sender {
    
    _index = 2;
    _firstImg.image = [UIImage imageNamed:@"pay_unsele"];
    _secondImg.image = [UIImage imageNamed:@"pay_sele"];
    _threeImg.image = [UIImage imageNamed:@"pay_unsele"];
    _address = _secondTF.text;
}

- (void)threeBtn:(UIButton *)sender {
    
    _index = 3;
    _firstImg.image = [UIImage imageNamed:@"pay_unsele"];
    _secondImg.image = [UIImage imageNamed:@"pay_unsele"];
    _threeImg.image = [UIImage imageNamed:@"pay_sele"];
    
    MSLBankSeachVC *vc = [[MSLBankSeachVC alloc] init];
    vc.delegate = self;
    [self.viewController presentViewController:vc animated:YES completion:^{ }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self secondBtn:nil];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    _address = textField.text;
}

- (void)bankSearchwithModel:(MSLBankModel *)model {
    
    self.threeLab.text = [NSString stringWithFormat:@"    %@",model.name];
    self.threeLab.textColor = [UIColor blackColor];
    _address = model.name;

}


@end
