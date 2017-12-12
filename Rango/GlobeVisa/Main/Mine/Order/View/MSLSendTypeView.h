//
//  MSLSendTypeView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLBankSeachVC.h"

@interface MSLSendTypeView : UIView<UITextFieldDelegate,CXBankSearchVCDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *address;


@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UITextField *secondTF;
@property (weak, nonatomic) IBOutlet UIView *secondBgView;

@property (weak, nonatomic) IBOutlet UILabel *threeLab;


@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeImg;

- (void)firstBtn:(UIButton *)sender;

- (void)secondBtn:(UIButton *)sender;

- (void)threeBtn:(UIButton *)sender;

@end
