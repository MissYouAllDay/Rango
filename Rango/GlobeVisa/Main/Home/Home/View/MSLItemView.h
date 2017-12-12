//
//  MSLItemView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

// 首页 索引  item
#import <UIKit/UIKit.h>

@interface MSLItemView : UICollectionViewCell

@property (nonatomic, strong) UIImageView *meunImg;

@property (nonatomic, strong) UILabel *title;

- (void)changeColor:(UIColor *)color;
@end
