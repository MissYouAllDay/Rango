//
//  ZYDayView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYDayView.h"
#import "JTDateHelper.h"
#import "ZYMonthView.h"

@implementation ZYDayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setTitleColor:COLOR_204 forState:UIControlStateDisabled];
        [self setImage:[UIImage imageNamed:@"dayimageselect"] forState:UIControlStateSelected];
        [self setImage:nil forState:UIControlStateNormal];
      
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:@"changeState" object:nil];
    }
    return self;
}

- (void)changeState {
    if (_manager.selectedStartDay && _manager.selectedEndDay) {
        
        if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedStartDay.date]) {
            [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"]
                            forState:UIControlStateSelected];
        } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedEndDay.date]) {
            [self setBackgroundImage:[UIImage imageNamed:@"backImg_end"]
                            forState:UIControlStateSelected];
        } else {
            [self setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        [self setSelectColor];
        
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
    }
}

- (void)setSelectColor {
    if ([_manager.helper date:_date isEqualOrAfter:_manager.selectedStartDay.date andEqualOrBefore:_manager.selectedEndDay.date]) {
        
        // 同一个月
        if ([_manager.helper date:_manager.selectedStartDay.date isTheSameMonthThan:_manager.selectedEndDay.date]) {
            if (self.enabled) {
//                self.backgroundColor = SelectedBgColor;
                self.backgroundColor = COLOR_BUTTON_BLUE;

                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
            }
        }
        
        // 不同
        else {
//            self.backgroundColor = SelectedBgColor;
            self.backgroundColor = COLOR_BUTTON_BLUE;
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            // 开始的是一个月的第一天
            if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper firstDayOfMonth:_manager.selectedStartDay.date]]) {
                if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper firstDayOfMonth:_manager.selectedStartDay.date]] && !self.enabled) {
                    self.backgroundColor = [UIColor clearColor];
                    [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
                }
            }
            
            // 结束是一个月最后一天
            if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper lastDayOfMonth:_manager.selectedEndDay.date]]) {
                if ([_manager.helper date:_date isTheSameDayThan:[_manager.helper lastDayOfMonth:_manager.selectedEndDay.date]] && !self.enabled) {
                    self.backgroundColor = [UIColor clearColor];
                    [self setTitleColor:defaultTextColor forState:UIControlStateNormal];
                }
            }
        }
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:defaultTextColor forState:UIControlStateNormal];

    }

}

- (void)setDate:(NSDate *)date {
    _date = date;
    
    if (self.enabled) {
        
        // 过去的时间能否点击
        if (!_manager.canSelectPastDays &&
            ![_manager.helper date:_date isTheSameDayThan:_manager.date] &&
            [_date compare:_manager.date] == NSOrderedAscending) {
            self.enabled = false;
        } else if ([_manager.helper date:_date isAfter:[self datewithEndDay]] && ![_manager.helper date:[self datewithEndDay] isTheSameDayThan:_manager.date]){
            
        
            // n 天之后的不可选择
            self.enabled = false;
            
        } else if ([_manager.helper date:[self datewithStartDay] isAfter:_date]){
            
            // n 天之前的不可选择
            self.enabled = false;
        }
        
        [self setTitle:[_manager.dayDateFormatter stringFromDate:_date] forState:UIControlStateNormal];
        
        // 当前时间
        if ([_manager.helper date:_date isTheSameDayThan:[NSDate date]]) {
            [self setTitle:@"今天" forState:UIControlStateNormal];
            [self setTitleColor:COLOR_BUTTON_BLUE forState:UIControlStateNormal];
        }
        
        // 多选状态设置
        if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            for (NSDate *date in _manager.selectedDateArray) {
                self.selected = [_manager.helper date:_date isTheSameDayThan:date];
                if (self.selected) {
                    break;
                }
            }
            return;
        }
        
        return;
        // 开始
        if (_manager.selectedStartDay) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedStartDay.date]) {
                self.manager.selectedStartDay.selected = false;
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
            }
        }
        // 结束
        if (_manager.selectedEndDay) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedEndDay.date]) {
                self.manager.selectedEndDay.selected = false;
                self.manager.selectedEndDay = self;
                self.manager.selectedEndDay.selected = true;
            }
        }
        
        // 其他
        if (_manager.selectedStartDay && _manager.selectedEndDay) {
            if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedStartDay.date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_start"]
                                forState:UIControlStateSelected];
            } else if ([_manager.helper date:_date isTheSameDayThan:_manager.selectedEndDay.date]) {
                [self setBackgroundImage:[UIImage imageNamed:@"backImg_end"]
                                forState:UIControlStateSelected];
            } else {
                [self setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }
    [self setSelectColor];
}
//开始日期
-(NSDate *)datewithStartDay
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //  NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    // DebugLog(@"---当前的时间的字符串 =%@",currentDateStr);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:self.manager.date];
    NSDateComponents* adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:_manager.startDay];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    //  NSString *beforDate = [dateFormatter stringFromDate:newdate];
    //  NSLog(@"---hou 7天 =%@  data=%@",beforDate,newdate);
    return newdate;
}

//结束时间
-(NSDate *)datewithEndDay
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
    NSDate * yujiDate = [dateFormatter dateFromString:_manager.endDay];
    
    NSDate * nowDate = [NSDate date];
    
    NSTimeInterval time = [yujiDate timeIntervalSinceDate:nowDate];
    
    int days;
    days = ((int)time)/(3600*24);
    NSString * dateValue = [NSString stringWithFormat:@"%i",days];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:self.manager.date];
    NSDateComponents* adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    
    int intString = [dateValue intValue];
    [adcomps setDay:intString];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self.manager.date options:0];
    //  NSString *beforDate = [dateFormatter stringFromDate:newdate];
    //  NSLog(@"---hou 7天 =%@  data=%@",beforDate,newdate);
    return newdate;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
    
    // 多选
    if (_manager.selectionType == ZYCalendarSelectionTypeMultiple) {
        self.selected = !self.selected;
        if (self.selected) {
            if (_manager.selectDayView.count == _manager.maxSelectNum) {
                
                ZYDayView *day = _manager.selectDayView[0];
                day.selected = !day.selected;
                [_manager.selectDayView removeObjectAtIndex:0];
                [_manager.selectedDateArray removeObjectAtIndex:0];

            }
            [_manager.selectedDateArray addObject:self.date];
            [_manager.selectDayView addObject:self];
        } else {
            [_manager.selectedDateArray enumerateObjectsUsingBlock:^(NSDate *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_manager.helper date:_date isTheSameDayThan:obj]) {
                    [_manager.selectedDateArray removeObjectAtIndex:idx];
                    [_manager.selectDayView removeObjectAtIndex:idx];
                }
            }];
        }
    } else {
        if (_manager.selectionType == ZYCalendarSelectionTypeSingle) {
            
            NSDate *date = nil;
            self.selected = !self.selected;
            if (self.selected) {
                self.manager.selectedStartDay.selected = false;
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
                date = _date;
            }else {
                self.manager.selectedStartDay.selected = false;
                date = nil;
            }
            if (self.manager.dayViewBlock) {
                self.manager.dayViewBlock(_manager, date);
            }
            return;
        }
        
        if (_manager.selectedStartDay && !_manager.selectedEndDay) {
            if (self == _manager.selectedStartDay) {
                return;
            }
            if ([_manager.helper date:_date isBefore:_manager.selectedStartDay.date]) {
                self.manager.selectedStartDay.selected = false;
                self.manager.selectedStartDay = self;
                self.manager.selectedStartDay.selected = true;
            } else {
                
                // 如果不能选择时间段(单选)
                if (_manager.selectionType == ZYCalendarSelectionTypeSingle) {
                    self.manager.selectedStartDay.selected = false;
                    self.manager.selectedStartDay = self;
                    self.manager.selectedStartDay.selected = true;
                } else {
                    // 多选
                    self.manager.selectedEndDay.selected = false;
                    self.manager.selectedEndDay = self;
                    self.manager.selectedEndDay.selected = true;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
                }
            }
        } else if (_manager.selectedStartDay && _manager.selectedEndDay) {
            self.manager.selectedStartDay.selected = false;
            self.manager.selectedEndDay.selected = false;
            
            self.manager.selectedStartDay = self;
            self.manager.selectedStartDay.selected = true;
            self.manager.selectedEndDay = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeState" object:nil];
        } else if (!_manager.selectedStartDay && !_manager.selectedEndDay) {
            self.manager.selectedStartDay.selected = false;
            self.manager.selectedStartDay = self;
            self.manager.selectedStartDay.selected = true;
        }
    }
    
    if (self.manager.dayViewBlock) {
        self.manager.dayViewBlock(_manager, _date);
    }
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.frame.size;
    return frame;
}

@end
