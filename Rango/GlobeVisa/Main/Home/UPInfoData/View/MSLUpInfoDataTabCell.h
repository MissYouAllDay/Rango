//
//  MSLUpInfoDataTabCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/7.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MSLUpInfoDataTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *statueImg;
@property (weak, nonatomic) IBOutlet UILabel *titler;
@property (weak, nonatomic) IBOutlet UILabel *statueName;


- (void)shouldUpData;
- (void)didUpData;
@end
