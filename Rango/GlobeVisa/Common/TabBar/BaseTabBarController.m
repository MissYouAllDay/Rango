//
//  BaseTabBarController.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/12.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseTabBarController.h"
#import "MSLHomeVC.h"
#import "MSLFoundVC.h"
#import "MSLMyVC.h"
#import "FSBaseViewController.h"
#import "MSLLoginVC.h"
@interface BaseTabBarController ()<UITabBarControllerDelegate>
{
    NSArray *arrImageSelect;
    NSArray *arrImage;
    NSArray *arrTitle;
    BOOL _isLogin;
}
@property (nonatomic,assign) NSInteger  indexFlag;

@end

@implementation BaseTabBarController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.indexFlag = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //按钮
    arrImage = [[NSArray alloc]initWithObjects:@"home",@"found",@"user", nil];
    // 点击
    arrImageSelect = [[NSArray alloc]initWithObjects:@"home1",@"found1",@"user1", nil];
    
    arrTitle = @[@"首页",@"发现",@"账户"];

//    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab"]];
    [self loadSubViewe];
    self.delegate = self;
}

- (void)loadSubViewe {

    [self addChildViewController:[[FSBaseViewController alloc] init] withImage:arrImage[0] withSelectImg:arrImageSelect[0] withTitle:arrTitle[0]];
    [self addChildViewController:[[MSLFoundVC alloc] init] withImage:arrImage[1] withSelectImg:arrImageSelect[1] withTitle:arrTitle[1]];
    [self addChildViewController:[[MSLMyVC alloc] init] withImage:arrImage[2] withSelectImg:arrImageSelect[2] withTitle:arrTitle[2]];
}

- (void)addChildViewController:(UIViewController *)childController withImage:(NSString *)image withSelectImg:(NSString *)selectImg withTitle:(NSString *)title {
    
    childController.tabBarItem.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateSelected];

    BaseNavigationVC *na= [[BaseNavigationVC alloc] initWithRootViewController:childController];
    [self addChildViewController:na];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    BaseNavigationVC *na = (BaseNavigationVC *)viewController;
//
//    for (UIViewController *vc in na.childViewControllers) {
//
//        [vc.navigationController popToRootViewControllerAnimated:NO];
//    }
//
    UIViewController *rootVC = na.childViewControllers[0];
//    //ava语音
//    if ([rootVC isKindOfClass:[AVAVC class]]) {
//
//        AVAVC *ava = [[AVAVC alloc] init];
//        UIWindow *window =[UIApplication sharedApplication].keyWindow;
//        BaseNavigationVC *na = [[BaseNavigationVC alloc] initWithRootViewController:ava];
//        [window.rootViewController presentViewController:na animated:YES completion:^{}];
//        return NO;
//    }
//    //订单
    if ([rootVC isKindOfClass:[MSLMyVC class]]) {

        NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
        if (token == nil || token.length < 1 || [token isEqualToString:@""]) {

            UIWindow *window =[UIApplication sharedApplication].keyWindow;
            MSLLoginVC *log = [[MSLLoginVC alloc] init];
            log.animation = 1;
            log.titleName = @"登录";
            log.viewType = 1;
            BaseNavigationVC *nc = [[BaseNavigationVC alloc] initWithRootViewController:log];
            [window.rootViewController presentViewController:nc animated:YES completion:^{}];
            return NO;
        }
    }
    return YES;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (index == 2 && ![self haveLogin]) {
        
        return;
    }
    if (index != self.indexFlag) {
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.2;
        animation.repeatCount = 1;
        animation.autoreverses = YES;
        animation.fromValue = [NSNumber numberWithFloat:0.7];
        animation.toValue = [NSNumber numberWithFloat:1.3];
        [[arry[index] layer] addAnimation:animation forKey:nil];
        
        self.indexFlag = index;
    }
}

// 是否登录
- (BOOL)haveLogin {
   
    NSString *token = TOKEN_VALUE;

    if (token.length > 1) {
        
        return YES;
    }
    return NO;
}
@end
