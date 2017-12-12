//
//  MSLBankSearchCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLBankSearchCell.h"

@implementation MSLBankSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MSLBankModel *)model {
    
    _model = model;
    
    _name.text = _model.name;
    _adress.text = [NSString stringWithFormat:@"地址    %@",_model.address];
    _tel.text = [NSString stringWithFormat:@"电话    %@",_model.fixed_line];;
}

@end
