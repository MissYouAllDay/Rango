//
//  EFViewController.h
//  mugshot
//
//  Created by EyreFree on 15/11/17.
//  Copyright (c) 2015年 junyu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIViewController (EF_UIViewController)

//寻找当前 UIViewController 的顶层 UIView
- (UIView*)topViewEF;

@end