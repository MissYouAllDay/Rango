//
//  MSLFoundCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/23.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLFoundCell.h"

@implementation MSLFoundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MSLPlatModel *)model {
    
    _model = model;
    
    self.name.text = model.title;
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.create_time]];
    
    NSString *timeStr = [str substringToIndex:10];
    NSTimeInterval timeInter = [timeStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInter];
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"yyyy-MM-dd";
    self.time.text = [matter stringFromDate:date];
}

@end
