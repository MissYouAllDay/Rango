//
//  AppDelegate.m
//  GlobeVisa
//
//  Created by MSLiOS on 2016/12/16.
//  Copyright © 2016年 MSLiOS. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import <iflyMSC/iflyMSC.h>
#import <AlipaySDK/AlipaySDK.h>

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>
#import <UMSocialCore/UMSocialCore.h>

#endif


//推送的响声震动
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "StatusWindow.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    NSArray * arrCon;
    NSMutableArray * Arr;
}
@property (strong, nonatomic) NSDictionary *launchOptions;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
 
    BaseTabBarController *tabBar = [[BaseTabBarController alloc] init];
    self.window.rootViewController = tabBar;
    
    [self.window makeKeyAndVisible];
  
    [self createKey];
   
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [self iflyID];
    
    _launchOptions = launchOptions;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSetJPush) name:@"NotificationLogin" object:nil];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    
    if (userID || userID.length > 1) {
        
        [self loginSetJPush];
    }
    
    [self loadUMeng];

    return YES;
   
}

- (void)loadUMeng {
    
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_APPKEY];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPKEY appSecret:WX_APPSECRET redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPKEY/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = YES;
}

- (void)loginSetJPush {
    
//    //判断是否是第一次登陆
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"HOMEFIRST"]) { return; }
//    
    //JPush
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *JPappKey = JPUSH_APPKEY;
    NSString *JPchannel = @"App Store";
    [JPUSHService setupWithOption:_launchOptions appKey:JPappKey
                          channel:JPchannel
                 apsForProduction:0
            advertisingIdentifier:nil];
}

#pragma mark - 极光推送处理
//注册APNs成功并上报DeviceToken
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
    //极光详情
    [self JpushDetailMessageFor:application UserInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    [self JpushDetailMessageFor:application UserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"%@",error);
}

- (void)JpushDetailMessageFor:(UIApplication *)application  UserInfo:(NSDictionary *)userInfo{
 
    if (application.applicationState == UIApplicationStateActive) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlayAlertSound(1106);
    }else{
        //解析数据
        [self JpushDetailMessage:userInfo];
    }
}

//应用程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

//应用程序进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if (application.applicationIconBadgeNumber != 0) {
        [self JpushDetailMessage:nil];
    }
    
    
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

//APP在前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self JpushDetailMessage:userInfo];
    }
    else {
        // 判断为本地通知
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//APP在后台进入前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
//        LFLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
        [self JpushDetailMessage:userInfo];
        
    }
    else {
        // 判断为本地通知
    }
    
    completionHandler();  // 系统要求执行这个方法
}

// 消息推送处理
- (void)JpushDetailMessage:(NSDictionary *)userInfo{

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NAME_KEY];

//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cust_email"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"path_name"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cust_photo"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cust_type"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sex"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cust_phone"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cust_tel"];
    
    StatusWindow *wind = [[StatusWindow alloc] init];
    [wind creatLoginAlert];
}

#pragma mark - 讯飞语音
// 科大讯飞
-(void)iflyID {
    //  MSL：58fd911e
    NSString *appid = @"58fd911e";
    NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
    [IFlySpeechUtility createUtility:initString];
}

#pragma mark - Map -Key
-(void)createKey {
    
    //地图功能
    [AMapServices sharedServices].apiKey = @"4c9a4a966e289b402ab7a7dfa9e698d4";
    //HTTPS
    [[AMapServices sharedServices]setEnableHTTPS:YES];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"PAYOVER" object:resultDic userInfo:nil];
        }];
    }else if([[UMSocialManager defaultManager]  handleOpenURL:url options:options]) {
        
        
        return YES;
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
