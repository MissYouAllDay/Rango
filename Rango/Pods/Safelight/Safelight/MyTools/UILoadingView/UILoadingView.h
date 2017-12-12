//
//  UILoadingView.h
//  duolaimeifa
//
//  Created by EyreFree on 15/7/22.
//  Copyright (c) 2015年 leqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILoadingView : UIView
- (BOOL)Show:(UIViewController *)tar WithString:(NSString *)title;
- (BOOL)ShowAt:(UIViewController *)tar WithString:(NSString *)title;
- (void)Hide:(NSString *)title;
@end
