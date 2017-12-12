//
//  MSLNeedInfoScrollItem.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLNeedInfoScrollItem : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIView *markView;

@end
