//
//  MSLHotTabCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLHotTabCell.h"

@implementation MSLHotTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bgView.layer.cornerRadius = 3;
    _bgView.layer.borderColor = COLOR_230.CGColor;
    _bgView.layer.borderWidth = 0.5;
    _bgView.clipsToBounds = YES;
    
    _price.textColor = HWColor(251, 13, 27);
    
}

- (void)setProModel:(MSLProductModel *)proModel {
    
    _proModel = proModel;
    
    [_symbolize sd_setImageWithURL:[NSURL URLWithString:_proModel.logo_url_plus] placeholderImage:[UIImage imageNamed:@"fail2"]];
    
    _name.text = _proModel.country_name;
    
    NSString *price = [NSString stringWithFormat:@"￥%@",_proModel.preferential_price];
    
    NSMutableAttributedString *priceAtt = [[NSMutableAttributedString alloc] initWithString:price attributes:@{}];
    
    [priceAtt setAttributes:@{NSFontAttributeName:FONT_SIZE_13} range:NSMakeRange(0, 1)];
    
    _price.attributedText = priceAtt;
    
    [_nationalFlag sd_setImageWithURL:[NSURL URLWithString:_proModel.ensign_url] placeholderImage:[UIImage new]];
}

- (void)setCounModel:(MSLCountryModel *)counModel {
    
    _counModel = counModel;
    
    [_symbolize sd_setImageWithURL:[NSURL URLWithString:_counModel.logo_url_plus] placeholderImage:[UIImage imageNamed:@"fail2"]];
    
    _name.text = _counModel.country_name;
    
    [_nationalFlag sd_setImageWithURL:[NSURL URLWithString:_counModel.ensign_url] placeholderImage:[UIImage new]];
}

@end
