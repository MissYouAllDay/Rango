//
//  selectDateVC.m
//  GlobeVisa
//
//  Created by MSLiOS on 2016/12/30.
//  Copyright © 2016年 MSLiOS. All rights reserved.
//

/*
 日历包括 ------------------ 预约面试时间 --------------- 和 ---------------预计出行时间
                            加急---------------------------------------------非加急
                            7天---------------------不可点击---------------------15天
 */

#import "SelectDateVC.h"

#import "ZYCalendarManager.h"

@interface SelectDateVC ()
{
    NSMutableArray * orderID_DataSource;//
    NSMutableArray * chuXingRIQIDataSource;//
    NSString *_selectDate;
}
@property(nonatomic,strong) NSMutableArray * arr;

@end

@implementation SelectDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self week];
    [self createNav];

    self.title = _threeDate ? @"预约面试时间" : @"选择时间";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT_SIZE_16,NSForegroundColorAttributeName:[UIColor blackColor]}];
    if (_threeDate) {
        //预约面试
        [self alertInfo];
        
        if (_startDate.length == 0 || _endDate.length == 0) {
            
            [CXUtils createAllTextHUB:@"数据错误，请从订单详情界面进入继续完成订单"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.tabBarController.selectedIndex = 1;
                return;
            });
        }
        _zyView.manager.maxSelectNum = 3;
        _zyView.date = [NSDate date];
        _zyView.manager.startDay = [_startDate integerValue];
        _zyView.manager.endDay = _endDate;

    }else {
    //其他情况
        
        NSDateFormatter *matter = [[NSDateFormatter alloc] init];
        matter.dateFormat = @"yyyy-MM-dd";

        if ([_yuJiChuxingDate isEqualToString:@"(null)"]|| [_traveOrReturnTag isEqualToString:@"0"]) {

            _zyView.date = [CXUtils datewithEndDay:_startDate withStartDate:[NSDate date]];
            _zyView.manager.startDay = [_startDate integerValue];
            _zyView.manager.endDay = _endDate;
        }else {
            NSDate *date = [matter dateFromString:[NSString stringWithFormat:@"%@",_yuJiChuxingDate]];;
            _zyView.date = [CXUtils datewithEndDay:@"1" withStartDate:date];
        }
        _zyView.manager.selectionType = ZYCalendarSelectionTypeSingle;
    }
    
    if (@available(iOS 11.0, *)) {
        _zyView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//提示信息
- (void)alertInfo {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请任意选择三天做为预约面试时间（灰色时间不可选）" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)week {
    UIView *weekTitlesView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WIDTH, 30)];
    weekTitlesView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:weekTitlesView];
    
    CGFloat weekW = WIDTH/7;
    NSArray *titles = @[@"日", @"一", @"二", @"三",
                        @"四", @"五", @"六"];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(i*weekW, 0, weekW, 30)];
        week.textAlignment = NSTextAlignmentCenter;
        week.textColor = [UIColor blackColor];
        week.font = [UIFont systemFontOfSize:16];
        [weekTitlesView addSubview:week];
        week.text = titles[i];
    }
    
    _zyView = [[ZYCalendarView alloc] initWithFrame:CGRectMake(0,30, WIDTH, HEIGHT - 50 - 44 - [CXUtils statueBarHeight] - 30)];
    // 不可以点击已经过去的日期
    _zyView.manager.canSelectPastDays = _canSelectPastDays;
   
    // 可以选择时间段
    _zyView.manager.selectionType = ZYCalendarSelectionTypeMultiple;
    
    __block NSString *selectDate = _selectDate;
    _zyView.dayViewBlock = ^(ZYCalendarManager *manager, NSDate *dayDate) {
        
        if (_zyView.manager.selectionType == ZYCalendarSelectionTypeMultiple) {
            
            for (NSDate *date in manager.selectedDateArray) {
                NSLog(@"%@", [manager.dateFormatter stringFromDate:date]);
            }
            printf("\n");
        }else {
            
            //单选
            NSDate *date = manager.selectedDateArray[0];
            NSString *dateStr = [manager.dateFormatter stringFromDate:date];
            if ([dateStr isEqualToString:selectDate]) {
                
                _selectDate = nil;
                selectDate = nil;
            }else {
                
                _selectDate = dateStr;
                selectDate = dateStr;
            }
            
            NSLog(@"你选择的日期为：%@",selectDate);
        }
    };
    [self.view addSubview:_zyView];
}
#pragma mark 导航栏
-(void)createNav {
  
    UIButton * cerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cerButton.frame = CGRectMake(WIDTH/2-50, HEIGHT - 50 - 44 - [CXUtils statueBarHeight], 100, 40);

    cerButton.clipsToBounds = YES;
    cerButton.layer.cornerRadius = 20;
    cerButton.titleLabel.font = FONT_SIZE_14;
    cerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cerButton setTitle:@"确 定" forState:UIControlStateNormal];
    [cerButton addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
    cerButton.backgroundColor = COLOR_BUTTON_BLUE;

    [self.view addSubview:cerButton];
}
#pragma mark - 确定按钮响应事件
-(void)okBtn:(UIButton *)sender
{
    if (!_threeDate) {
        
        if (_zyView.manager.selectedDateArray.count < 1)
        {
            UIAlertController * AlertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有选择日期" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * alert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [AlertCon addAction:alert];
            [self presentViewController:AlertCon animated:YES completion:nil];
        }else {
            [_delegate calendarDateSelect: _selectDate];
            [self backBtn:nil];
        }
        return;
    }
 
    if (_zyView.manager.selectedDateArray.count < 3)
    {
        UIAlertController * AlertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"必须选择3个预约面试日期" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [AlertCon addAction:alert];
        [self presentViewController:AlertCon animated:YES completion:nil];
    }
    else
    {
        _arr = [[NSMutableArray alloc]init];

        for (int i = 0; i < _zyView.manager.selectedDateArray.count; i++)
        {
            [_arr  addObject:[self data1day:_zyView.manager.selectedDateArray[i]]];
        }
        
        
        [self tijiaoDate];
       
    }
}
-(void)tijiaoDate {

    UIAlertController * yuTimeAlertCon = [UIAlertController alertControllerWithTitle:@"您选择的预约面试时间为" message:[NSString stringWithFormat:@"%@\n%@\n%@",_arr[0],_arr[1],_arr[2]]  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * quxiaoAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
    [yuTimeAlertCon addAction:quxiaoAlert];
    
    UIAlertAction * queDingAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self postaData];
    }];
    [yuTimeAlertCon addAction:queDingAlert];
    [self presentViewController:yuTimeAlertCon animated:YES completion:nil];
}

- (void)postaData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order_id"] = [NSString stringWithFormat:@"%@",_order_ID];
    params[@"bespeak_time1"] = [NSString stringWithFormat:@"%@",_arr[0]];
    params[@"bespeak_time2"] = [NSString stringWithFormat:@"%@",_arr[1]];
    params[@"bespeak_time3"] = [NSString stringWithFormat:@"%@",_arr[2]];
    
//    [NetWorking postHUDRequest:URL_APPOINTMENT_INTERVIEW_TIME withParam:params success:^(id responseObjc) {
//
//        UIAlertController * xianxiaAlertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的预约面试时间已经提交，请等待具体面试时间" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction * tongguoAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //返回首页
//            [self.navigationController popToRootViewControllerAnimated:YES];
//
//        }];
//        [xianxiaAlertCon addAction:tongguoAlert];
//        [self presentViewController:xianxiaAlertCon animated:YES completion:nil];
//
//    } failBlock:^(NSHTTPURLResponse *responseObjc) {  }];
//
}
#pragma mark - 计算后一天的时间
-(NSData *)data1day:(NSData *)data
{
    //获取当前时间后1天月的时间Date
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:data];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:data options:0];
    NSString * new = [dateFormatter stringFromDate:newdate];

    return new;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
-(void)backBtn:(UIButton*)btn
{

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 查询支付完成是否是加急或免面签的产品
//-(void)queryIsUrgentOrFreefaceSelectDate{
//        
//    NSMutableDictionary * params = [NSMutableDictionary new];
//    params[@"order_id"] = [NSString stringWithFormat:@"%@",_order_ID];
//    
//    [NetWorking getRequest:URL_QURENT_OR_FREEFACE withParam:params success:^(id responseObjc) {
//        
//        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
//        if (![errorCode isEqualToString:@"0"]) {
//            
//            [CXUtils createAllTextHUB:responseObjc[@"reason"]];
//            return ;
//        }
//        
//        orderID_DataSource = [[NSMutableArray alloc]initWithArray:responseObjc[@"result"]];
//        _startDate = [NSString stringWithFormat:@"%@",orderID_DataSource[0][@"plan_weekday"]];
//        [self setDate];
//    } failBlock:^(NSHTTPURLResponse *responseObjc) { }];
//
//    //获取出行日期  URL_ORDER_ASK
//    [NetWorking getRequest:URL_ORDER_SEACH withParam:params success:^(id responseObjc) {
//        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
//        if (![errorCode isEqualToString:@"0"]) {
//            
//            [CXUtils createAllTextHUB:responseObjc[@"reason"]];
//            return ;
//        }
//        
//        chuXingRIQIDataSource = [[NSMutableArray alloc]initWithArray:responseObjc[@"result"]];
//
//        _endDate = chuXingRIQIDataSource[0][@"depart_time1"];
//        [self setDate];
//        
//    } failBlock:^(NSHTTPURLResponse *responseObjc) { }];
//}
//
//- (void)setDate {
//    
//    if (_startDate.length > 0 &&  _endDate.length > 0) {
//        
//        _zyView.date = [NSDate date];
//        _zyView.manager.endDay = _endDate;
//        _zyView.manager.startDay = [_startDate integerValue];
//    }
//    
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
