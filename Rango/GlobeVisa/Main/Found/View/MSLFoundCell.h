//
//  MSLFoundCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/23.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLPlatModel.h"
@interface MSLFoundCell : UITableViewCell
@property (nonatomic, strong) MSLPlatModel *model;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
