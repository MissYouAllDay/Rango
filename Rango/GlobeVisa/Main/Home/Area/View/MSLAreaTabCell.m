//
//  MSLAreaTabCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/30.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLAreaTabCell.h"

@implementation MSLAreaTabCell
{
    
    UIImageView *_imageV;
    UILabel *_tagLab;
    UILabel *_markLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = COLOR_245;
//    self.contentView.backgroundColor = COLOR_245;
    _downView.backgroundColor = COLOR_245;
    _bgView.backgroundColor = [UIColor whiteColor];
    _doBtn.widthCX = _doBtn.heightCX;
    
    _doBtn.layer.cornerRadius = _doBtn.widthCX/2;
    _doBtn.clipsToBounds = YES;
    
    UIImage *image = [CXUtils imageWithColor:HWColor(249, 72, 90)];
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 16, 0, 20)];
    _imageV.image = image;
    
    _imageV.layer.cornerRadius = _imageV.heightCX/2;
    _imageV.layer.masksToBounds = YES;
    [self addSubview:_imageV];
    
    _tagLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 20)];
    _tagLab.textColor = [UIColor whiteColor];
    _tagLab.textAlignment = NSTextAlignmentCenter;
    _tagLab.font = FONT_SIZE_10;
    [_imageV addSubview:_tagLab];
    
    _markLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, WIDTH - _areaName.widthCX, 32)];
    _markLab.textColor = COLOR_52;
    _markLab.font = FONT_SIZE_13;
    [self addSubview:_markLab];
}

- (void)setModel:(MSLProductModel *)model {
    
    _model = model;
    
    _areaName.text = [NSString stringWithFormat:@"@%@领区",_model.visa_area_name];
    _dayLab.text = _model.plan_weekday;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_model.preferential_price] attributes:@{NSForegroundColorAttributeName:HWColor(51, 51, 51)}];
    [att addAttribute:NSFontAttributeName value:FONT_SIZE_12 range:NSMakeRange(0, 1)];
    
    _moneyLab.attributedText = att;
    _markLab.text = _model.visa_name;
    [self setNeedsLayout];
    
}

- (void)layoutSubviews {
    
    if (_model.visa_label.length < 1) {
        
        _imageV.hidden = YES;
        return;
    }
    _tagLab.text = _model.visa_label;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_tagLab.text attributes:@{}];
    CGSize attSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;

    _tagLab.widthCX = attSize.width + 10;
    
    _imageV.widthCX = _tagLab.widthCX + 10;
    
//    _proName.rightCX = _areaName.leftCX;
    _markLab.frame = CGRectMake(_imageV.widthCX, 10, WIDTH - _imageV.widthCX - _areaName.widthCX, 32);
    
}

@end
