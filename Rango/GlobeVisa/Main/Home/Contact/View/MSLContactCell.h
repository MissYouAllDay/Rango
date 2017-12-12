//
//  MSLContactCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/2.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *downView;


- (void)upView ;
- (void)bottomView ;
- (void)normalView ;
@end
