//
//  DatePicker.m
//  DateSelect
//
//  Created by MSLiOS on 2017/3/8.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker ()



@end

@implementation DatePicker

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        //背景框
        UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:back];
        
        //日期选择器
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(10, 10, self.frame.size.width - 20, 150);
        _datePicker.backgroundColor = [UIColor clearColor];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.locale = locale;
        
        NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
        [formatter_minDate setDateFormat:@"yyyy-MM-dd"];

        [self addSubview:_datePicker];
        
        //确定按钮
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - WIDTH * 0.36) * 0.5, self.frame.size.height - 100, WIDTH * 0.36, 70)];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [sureBtn setTitleColor:COLOR_BUTTON_BLUE forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
    }
    
    return self;
}

- (void)sureBtnOnClick
{
    [self dismiss];
    
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerView:didClickSureBtnWithSelectDate:)]) {
        [_delegate datePickerView:self didClickSureBtnWithSelectDate:[self getDateString]];
    }
   
}

- (NSString *)getDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:[self.datePicker date]];
    
    return date;
}

- (void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(WIDTH * 0.05, HEIGHT - WIDTH * 0.75, WIDTH * 0.9, WIDTH * 0.5);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(WIDTH * 0.05, HEIGHT, WIDTH * 0.9, WIDTH * 0.5);
    }];
}

@end
