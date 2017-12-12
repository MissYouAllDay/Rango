//
//  EFViewController.m
//  mugshot
//
//  Created by EyreFree on 15/11/17.
//  Copyright (c) 2015年 junyu. All rights reserved.
//


#import "EFViewController.h"

@implementation UIViewController (EFViewController)

//寻找当前 UIViewController 的顶层 UIView
- (UIView*)topViewEF {
    UIViewController* recentView = self;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

@end