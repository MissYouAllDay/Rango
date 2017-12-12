//
//  MSLProvinceItem.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/31.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLProvinceItem.h"

@implementation MSLProvinceItem

- (void)awakeFromNib {
    [super awakeFromNib];

    _name.layer.borderColor = HWColor(230, 230, 230).CGColor;
    _name.layer.borderWidth = 1;
    _name.textColor = HWColor(153, 153, 153);

}

- (void)reduction {
    
    _name.layer.borderColor = HWColor(230, 230, 230).CGColor;
    _name.textColor = HWColor(153, 153, 153);
}

- (void)selectItem {
    
    _name.layer.borderColor = HWColor(77, 186, 244).CGColor;
    _name.textColor = HWColor(77, 186, 244);
}
@end
