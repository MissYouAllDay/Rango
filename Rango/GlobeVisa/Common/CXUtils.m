//
//  CXUtils.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/4/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "CXUtils.h"
//#import "PersonTypeModel.h"
#import "MSLNeedInfoModel.h"

@implementation CXUtils

+(MBProgressHUD *) createHUB {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    return HUD;
}

+ (void)hideHUD {

    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];

//    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication].windows lastObject] animated:YES];
}

+(void)createAllTextHUB:(NSString *)alert {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.labelText = alert;
    HUD.mode = MBProgressHUDModeText;
    
    HUD.yOffset = 200.0f;
    [window addSubview:HUD];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

//计算某个时间后的日期
+ (NSDate *)datewithEndDay:(NSString *)dayNUm withStartDate:(NSDate *)startDate {

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:startDate];
    NSDateComponents* adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    int intString = [dayNUm intValue];
    [adcomps setDay:intString];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:startDate options:0];

    return newdate;
}

+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

//计算两个日期之间的天数
+ (NSInteger)daysFromBeginDate:(NSDate *)beginDate endDate:(NSString *)endDate {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *end = [dateFormatter dateFromString:endDate];

    NSTimeInterval time=[end timeIntervalSinceDate:beginDate];
    
    return ((int)time)/(3600*24);
}

/// 颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//返回 状态栏的高度
+ (CGFloat)statueBarHeight {
    
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

// s所需资料
+ (NSDictionary *)heightofPersonTypeTextViewfwithText:(NSArray *)dataDic {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FONT_14}];
    for (MSLNeedInfoModel *model in dataDic) {
        
        NSAttributedString *keyStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",model.visa_datum_name] attributes:@{NSFontAttributeName:FONT_13,NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        [text appendAttributedString:keyStr];
        
        NSArray *explainArr = [model.explain_desc componentsSeparatedByString:@"#"];
        
        for (NSString *textValue in explainArr) {
            
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"point"];
            attch.bounds = CGRectMake(0, 4, 4, 4);
            NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
            
            CGSize sizeC = CGSizeMake(MAXFLOAT ,17);
            
            NSMutableString *endText = [[NSMutableString alloc] initWithString:textValue];
            int fre = 0;
            NSInteger startIndex = 0;
            for (NSInteger i = 0; i < textValue.length; i++) {
                
                NSString * s = [textValue substringWithRange:NSMakeRange(startIndex, i - startIndex)];
                
                CGSize size = [s boundingRectWithSize:sizeC options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_14} context:nil].size;
                
                if (size.width > WIDTH - 35) {
                    
                    [endText insertString:@"\n  " atIndex:fre * 3 + i];
                    startIndex = i;
                    fre ++;
                }
            }
            
            NSMutableAttributedString *valueStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@\n",endText] attributes:@{NSFontAttributeName:FONT_13,NSForegroundColorAttributeName:RGBColor(128, 128, 128, 1)}];
            
            [text appendAttributedString:imageStr];
            [text appendAttributedString:valueStr];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    CGSize attSize = [text boundingRectWithSize:CGSizeMake(WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return @{@"height":[NSString stringWithFormat:@"%f",attSize.height],@"text":text};
}


// 基本信息
+ (NSDictionary *)heightofBaseInfoTextViewfwithText:(NSArray *)dataDic {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FONT_14}];
    for (NSDictionary *model in dataDic) {
        
        NSAttributedString *keyStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",model[@"visa_basis_name"]] attributes:@{NSFontAttributeName:FONT_13,NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        [text appendAttributedString:keyStr];
        
        NSArray *explainArr = [model[@"visa_basis_name"] componentsSeparatedByString:@"#"];
        
        for (NSString *textValue in explainArr) {
            
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"point"];
            attch.bounds = CGRectMake(0, 4, 4, 4);
            NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
            
            CGSize sizeC = CGSizeMake(MAXFLOAT ,17);
            
            NSMutableString *endText = [[NSMutableString alloc] initWithString:textValue];
            int fre = 0;
            NSInteger startIndex = 0;
            for (NSInteger i = 0; i < textValue.length; i++) {
                
                NSString * s = [textValue substringWithRange:NSMakeRange(startIndex, i - startIndex)];
                
                CGSize size = [s boundingRectWithSize:sizeC options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_14} context:nil].size;
                
                if (size.width > WIDTH - 35) {
                    
                    [endText insertString:@"\n  " atIndex:fre * 3 + i];
                    startIndex = i;
                    fre ++;
                }
            }
            
            NSMutableAttributedString *valueStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@\n",endText] attributes:@{NSFontAttributeName:FONT_13,NSForegroundColorAttributeName:RGBColor(128, 128, 128, 1)}];
            
            [text appendAttributedString:imageStr];
            [text appendAttributedString:valueStr];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    CGSize attSize = [text boundingRectWithSize:CGSizeMake(WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return @{@"height":[NSString stringWithFormat:@"%f",attSize.height],@"text":text};
}

// label 的高度
+ (CGFloat)labelHei:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];

    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attText.length)];
   CGSize attSize = [attText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return attSize.height;
}


#pragma mark- 拍照导入图片
+ (BOOL)passportGetIntoCamera:(UIViewController *)viewController{

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，您没有开启调用相机权限，是否前往 设置-隐私-相机 中设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * quxiaoBtn = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [quxiaoBtn setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        [alertTip addAction:quxiaoBtn];
        
        UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
        [queRenAlert setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        [alertTip addAction:queRenAlert];
        [viewController.navigationController presentViewController:alertTip animated:YES completion:nil];
        return  NO;
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            return YES;
        }else {
            UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于您的设备暂不支持摄像头，您无法使用该功能!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
            [alertTip addAction:queRenAlert];
            [viewController.navigationController presentViewController:alertTip animated:YES completion:nil];
            return NO;
        }
    }
}

//跳转相册
+ (BOOL)album:(UIButton*)albumbtn:(UIViewController *)viewController {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限
        UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，您没有开启调用相册权限，是否前往 设置-隐私-相册 中设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * quxiaoBtn = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [quxiaoBtn setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        
        [alertTip addAction:quxiaoBtn];
        
        UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
        [queRenAlert setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        
        [alertTip addAction:queRenAlert];
        [viewController presentViewController:alertTip animated:YES completion:nil];
        
        return NO;
    }else{
       
        return YES;
    }
}


+ (void)phoneAction:(UIViewController *)viewController {
    
    NSMutableString *phone = [[NSMutableString alloc] initWithString:SERVICEMAN_PHONE];
    [phone insertString:@"-" atIndex:6];
    [phone insertString:@"-" atIndex:3];
    
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"人工客服" message:[NSString stringWithFormat:@"%@\n09:30 - 18:30",phone] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIWebView *phoneCallWebView = [[UIWebView alloc] init];
        [viewController.view addSubview:phoneCallWebView];
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",SERVICEMAN_PHONE]];
        if ( !phoneCallWebView ) {phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];}
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    }];
    
    [cancel setValue:[UIColor colorWithHexString:@"#808080" alpha:1] forKey:@"_titleTextColor"];
    [sure setValue:COLOR_BUTTON_BLUE forKey:@"_titleTextColor"];
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [viewController presentViewController:alert animated:YES completion:^{}];
}

@end
