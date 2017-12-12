//
//  selectDateVC.h
//  GlobeVisa
//
//  Created by MSLiOS on 2016/12/30.
//  Copyright © 2016年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
#import "ZYCalendarView.h"

@protocol CXDateSelectDelegate <NSObject>

- (void)calendarDateSelect:(NSString *)date;

@end

@interface SelectDateVC : RootViewController

@property (nonatomic, weak) id<CXDateSelectDelegate> delegate;

@property(nonatomic,copy) NSString * order_ID;

@property (nonatomic,strong)  NSMutableArray * dateArr;
@property (nonatomic,strong) ZYCalendarView * zyView;

@property (nonatomic, copy) NSString *startDate;    //开始日期
@property (nonatomic, copy) NSString *endDate;      //结束日期   日期
@property (nonatomic, assign) BOOL threeDate;       //是否选择三天日期

@property (nonatomic, assign) BOOL canSelectPastDays; //过去的日期 是否可以 选择

@property (nonatomic, copy) NSString * yuJiChuxingDate;    //预计出行日期

@property (nonatomic, copy) NSString * traveOrReturnTag;    //进来时的 tag

@end
