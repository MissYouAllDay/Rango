//
//  RootViewController.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/12.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
//#import "LoginViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = COLOR_245;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)createNavigationBar {
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [CXUtils statueBarHeight] + 44)];

    UIButton *pop = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pop.frame = CGRectMake(0, [self statueBarHeight], 60, 44);
    [pop setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateNormal];
    [pop addTarget:self action:@selector(selfBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:pop];
    
    _barName = [[UILabel alloc] initWithFrame:CGRectMake(pop.rightCX,[CXUtils statueBarHeight] , WIDTH - pop.widthCX * 2, 44)];
    [barView addSubview:_barName];
    _barName.textColor = [UIColor whiteColor];
    _barName.textAlignment = NSTextAlignmentCenter;
    _barName.font = FONT_SIZE_17;
    return barView;
}

- (void)selfBackBtnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//手机号验证
- (BOOL)checkTelNumber:(NSString *)telNumber {
    
    NSString *pattern = @"^1+[34578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

//邮箱验证
- (BOOL)checkEmail:(NSString *)email {
    
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:email];
    return isMatch;
}

//日期验证
- (int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay {
    
    //0 时间一样  1.后来的时间大  -1 前面时间小
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];

    if (result == NSOrderedAscending) {
        return 1;   // a > b
    }
    else if (result == NSOrderedDescending){
        return -1; // a < b
    }
    return 0;
}

//判断是否为纯数字
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

//身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard {
    
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

// 登录密码判断  数字和字符  最少6位  最多15位
-(BOOL)checkPassWord:(NSString *)passWord {
    
    NSString *pattern = @"^[a-zA-Z0-9]{6,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:passWord];
    return isMatch;
}

-(BOOL)checkMessageCode:(NSString *)messageCode {
    
    NSString *pattern = @"^[0-9]{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:messageCode];
    return isMatch;
}

//下一步  确定按钮
- (UIButton *)createDownNextBtn {
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, HEIGHT - 45 - [CXUtils statueBarHeight] - 44, WIDTH, 45);
    nextBtn.backgroundColor = COLOR_BUTTON_BLUE;
    nextBtn.titleLabel.font = FONT_SIZE_15;
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    return nextBtn;
}

#pragma mark - - - - - - - - - - NEW - - - - - - - - - - -
//返回 状态栏的高度
- (CGFloat)statueBarHeight {
    
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
