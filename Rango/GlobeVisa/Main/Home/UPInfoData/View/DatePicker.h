//
//  DatePicker.h
//  DateSelect
//
//  Created by MSLiOS on 2017/3/8.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class DatePicker;

@protocol DatePickerDelegate <NSObject>

/**
 *  DatePicker确定按钮点击代理事件
 *
 *  @param datePickerView DatePicker
 *  @param date           选中的日期
 */
- (void)datePickerView:(DatePicker *)datePickerView didClickSureBtnWithSelectDate:(NSString *)date;

@end

@interface DatePicker : UIView

@property (nonatomic, weak) id<DatePickerDelegate> delegate;
@property (nonatomic, strong) UIDatePicker *datePicker;
- (void)show;
- (void)dismiss;

@end
