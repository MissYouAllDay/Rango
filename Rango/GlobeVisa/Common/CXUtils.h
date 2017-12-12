//
//  CXUtils.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/4/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface CXUtils : NSObject

+ (MBProgressHUD *)createHUB;

+ (void)hideHUD;

+ (void)createAllTextHUB:(NSString *) alert;

//计算某个时间后的日期
+ (NSDate *)datewithEndDay:(NSString *)dayNUm withStartDate:(NSDate *)startDate;

//计算2个日期之间 相差的天数
+ (NSInteger)daysFromBeginDate:(NSDate *)beginDate endDate:(NSString *)endDate;

//人员类型界面 textview的高度
+ (NSDictionary *)heightofPersonTypeTextViewfwithText:(NSArray *)dataDic;

// 计算人员中 基本信息 的高度
+ (NSDictionary *)heightofBaseInfoTextViewfwithText:(NSArray *)dataDic;

// label 的高度  
/**
 label 宽固定   返回label的高度

 @param text label 的 text
 @param width label 固定的 宽度
 @param font label  的字体大小  UIFont 格式
 @return label 的高度
 */
+ (CGFloat)labelHei:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont *)font;
// labelsize
+ (CGSize)labelSize:(NSMutableAttributedString *)text withWidth:(CGFloat)width withFont:(UIFont *)font;
// 颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

// 返回状态栏的高度
+ (CGFloat)statueBarHeight;

//判断摄像头 权限
+ (BOOL)passportGetIntoCamera:(UIViewController *)viewController;
// 判断相册权限
+ (BOOL)album:(UIButton*)albumbtn:(UIViewController *)viewController;

// 拨打电话
+ (void)phoneAction:(UIViewController *)viewController;
@end
