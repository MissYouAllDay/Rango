//
//  BaseNavigationVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/12.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseNavigationVC.h"
#import "UIBarButtonItem+Extension.h"
@interface BaseNavigationVC ()

@end

@implementation BaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WHITE;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

+(void)initialize{
    //默认图
    UIImage *naImg = [[UIImage imageNamed:@"bar_blue"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [[UINavigationBar appearance] setBackgroundImage:naImg forBarMetrics:UIBarMetricsDefault];
    
    if (WIDTH > 375 ) {
       [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_SIZE_17}];
        
    }else{
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_SIZE_17}];
        
    }
    //黑色字体
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FONT_15}];
    UIBarButtonItem *item = [UIBarButtonItem appearance];

    //item的字体和颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
   
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
       
//        viewController.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"backW"];

//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction:) image:@"backW" highImage:@"backW"];
//
//        viewController.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        
        　// 非根控制器才需要设置返回按钮
        // 设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateHighlighted];

        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        [backButton sizeToFit];
        backButton.frame = CGRectMake(0, 0, 44, 44);
        // 注意:一定要在按钮内容有尺寸的时候,设置才有效果
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backAction:(UIButton *)sender{
    [self popViewControllerAnimated:YES];
}


//返回按钮  如果需要返回按钮做特殊处理的时候 调用此方法创建  否则不需要对返回键做任何修改
+ (UIButton *)popBtn {
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 30, 30);
    [back setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateNormal];
    
    return back;
}

@end
