//
//  UIBarButtonItem+Extension.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/12.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
