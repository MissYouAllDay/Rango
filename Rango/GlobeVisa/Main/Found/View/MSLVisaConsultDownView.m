//
//  MSLVisaConsultDownView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLVisaConsultDownView.h"

@implementation MSLVisaConsultDownView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = COLOR_245;
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.backgroundColor = COLOR_BUTTON_BLUE;
    
    _textFBgView.layer.borderColor = COLOR_230.CGColor;
    _textFBgView.layer.borderWidth = 0.5;
    
    _searchTF.placeholder = @"请输入文字";
    _telImg.image = [UIImage imageNamed:@"service"];
    
    [_telImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction:)]];

}

- (void)phoneAction:(UITapGestureRecognizer *)sender {
    
    [CXUtils phoneAction:self.viewController];
}
@end
