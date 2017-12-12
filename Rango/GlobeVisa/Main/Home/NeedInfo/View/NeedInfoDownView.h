//
//  NeedInfoDownView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/7/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedInfoDownView : UIView

// 是否收藏
@property (nonatomic, copy) NSString *isLove;

// 咨询
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

// 收藏
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;

//开始签证
@property (weak, nonatomic) IBOutlet UIButton *startVisa;


// 收藏  底层
@property (weak, nonatomic) IBOutlet UIView *loveBgView;
// 收藏   图片
@property (weak, nonatomic) IBOutlet UIImageView *loveImg;

// 收藏  文字
@property (weak, nonatomic) IBOutlet UILabel *loveLab;

// 咨询 事件
- (IBAction)phoneAction:(UIButton *)sender;

// 收藏事件
- (IBAction)loveAction:(UIButton *)sender;




@end
