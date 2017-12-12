//
//  MSLNeedInfoHeadView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNeedInfoHeadView.h"

@implementation MSLNeedInfoHeadView

- (void)setModel:(MSLProductModel *)model {
    
    _model = model;
    
    _detalLab.text = _model.range_desc;
    _dayLab.text = _model.plan_weekday;
    _staicLab.text = _model.is_stop_set;
    _validityTime.text = _model.validity_time;
    _number.text = _model.visa_number;
    
//    [_bgImg sd_setImageWithURL:[NSURL URLWithString:_model.region_url] placeholderImage:[UIImage imageNamed:@"needInfo_fail"]];
    
    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_model.preferential_price] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [priceStr addAttribute:NSFontAttributeName value:FONT_SIZE_19 range:NSMakeRange(0, 1)];
    
    _priceLab.attributedText = priceStr;
    
//    NSMutableAttributedString *dayStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天",_model.plan_weekday] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [dayStr addAttribute:NSFontAttributeName value:FONT_SIZE_12 range:NSMakeRange(dayStr.length - 1, 1)];
//
//    _dayLab.attributedText = dayStr;
//
//    NSMutableAttributedString *staticDay = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天",_model.is_stop_set] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [staticDay addAttribute:NSFontAttributeName value:FONT_SIZE_12 range:NSMakeRange(staticDay.length - 1, 1)];
//
//    _staicLab.attributedText = staticDay;
//
//    NSMutableAttributedString *validityTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_model.validity_time] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [validityTime addAttribute:NSFontAttributeName value:FONT_SIZE_12 range:NSMakeRange(validityTime.length - 1, 1)];
//
//    _validityTime.attributedText = validityTime;
//
//    NSMutableAttributedString *numberStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次",_model.visa_number] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [numberStr addAttribute:NSFontAttributeName value:FONT_SIZE_12 range:NSMakeRange(numberStr.length - 1, 1)];
//
//    _number.attributedText = numberStr;
}

@end
