//
//  MSLContactAddView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/3.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLContactAddView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UIView *telBgView;
@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (weak, nonatomic) IBOutlet UIView *jobBgView;
@property (weak, nonatomic) IBOutlet UIButton *jobBtn;
@property (weak, nonatomic) IBOutlet UILabel *jobLab;
@property (weak, nonatomic) IBOutlet UIView *outBgView;
@property (weak, nonatomic) IBOutlet UIButton *outBtn;
@property (weak, nonatomic) IBOutlet UIView *returnBgView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@property (weak, nonatomic) IBOutlet UIView *messageBgView;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

// 还原
- (void)returnOldStatue:(UIButton *)sender;
@end
