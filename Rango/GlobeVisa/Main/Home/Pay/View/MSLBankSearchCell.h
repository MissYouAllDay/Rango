//
//  MSLBankSearchCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLBankModel.h"
@interface MSLBankSearchCell : UITableViewCell

@property (nonatomic, strong) MSLBankModel *model;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *tel;

@end
