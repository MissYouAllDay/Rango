//
//  MSLPrivacyVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLPrivacyVC.h"

@interface MSLPrivacyVC ()<UIWebViewDelegate>

@end

@implementation MSLPrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于平台";
    UIWebView * webUs = [[UIWebView alloc]initWithFrame:CGRectMake(15,0, WIDTH-20, HEIGHT-([CXUtils statueBarHeight] + 44))];
    webUs.opaque = NO;
    webUs.delegate = self;
    
    webUs.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    webUs.backgroundColor = [UIColor clearColor];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",URL_PRIVACY_WEB]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webUs loadRequest:request];
    [self.view addSubview:webUs];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [CXUtils createHUB];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [CXUtils hideHUD];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [CXUtils hideHUD];
    [CXUtils createAllTextHUB:@"加载失败"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
@end
