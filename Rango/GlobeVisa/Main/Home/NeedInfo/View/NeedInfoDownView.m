//
//  NeedInfoDownView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/7/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "NeedInfoDownView.h"

@implementation NeedInfoDownView

- (void)awakeFromNib {
    
    [super awakeFromNib];
 
    [_phoneBtn addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loveBtn addTarget:self action:@selector(loveAction:) forControlEvents:UIControlEventTouchUpInside];

}


- (void)startVisaAction:(UIButton *)sender {
    
    NSLog(@"1234567890");
}

- (IBAction)phoneAction:(UIButton *)sender {
    
    [CXUtils phoneAction:self.viewController];
    return;
    NSMutableString *phone = [[NSMutableString alloc] initWithString:SERVICEMAN_PHONE];
    [phone insertString:@"-" atIndex:6];
    [phone insertString:@"-" atIndex:3];
    
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"人工客服" message:[NSString stringWithFormat:@"%@\n09:30 - 18:30",phone] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIWebView *phoneCallWebView = [[UIWebView alloc] init];
        [self addSubview:phoneCallWebView];
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",SERVICEMAN_PHONE]];
        if ( !phoneCallWebView ) {phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];}
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }];

    [cancel setValue:[UIColor colorWithHexString:@"#808080" alpha:1] forKey:@"_titleTextColor"];
    [sure setValue:COLOR_BUTTON_BLUE forKey:@"_titleTextColor"];

    [alert addAction:cancel];
    [alert addAction:sure];

    [self.viewController presentViewController:alert animated:YES completion:^{}];
}

- (IBAction)loveAction:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    self.isLove = sender.selected ? @"0" : @"1";
}

- (void)setIsLove:(NSString *)isLove {
    
    _isLove = isLove;
    
    if ([_isLove isEqualToString:@"0"]) {
        
        _loveImg.image = [UIImage imageNamed:@"star1"];
        _loveLab.text = @"已收藏";
        _loveLab.textColor = COLOR_FONT_BLUE;
        [CXUtils createAllTextHUB:@"已收藏"];
        
    }else {
        
        _loveImg.image = [UIImage imageNamed:@"star"];
        _loveLab.text = @"收藏";
        _loveLab.textColor = COLOR_FONT_BLUE;
        [CXUtils createAllTextHUB:@"已取消收藏"];
    }
}



@end
