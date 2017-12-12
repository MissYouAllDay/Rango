//
//  MSLVisaFormVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/6.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLVisaFormVC.h"
#import "MSLPayVC.h"
@interface MSLVisaFormVC ()<UIWebViewDelegate,IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,UIGestureRecognizerDelegate>
{
    NSString *_urlLast;
    UILabel * labelName;
    NSString * userLisenStr;//返回的
    
    NSString * WebPageID;
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;   //语音合成
    NSString* _token;
    UIButton * yuYinBtn;
    
    UIView * view ;
    UIView * myView;
    
    NSString * home;
    NSInteger number;
    
    BOOL _isAVA;
}

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) IFlySpeechRecognizer * iFlySpeechRecognizer;//语音识别
@property (nonatomic,strong) UIImageView *speakView;//话筒界面
@property (nonatomic,strong) UIView *markView;//遮罩视图

@property WebViewJavascriptBridge* bridge;

@end

@implementation MSLVisaFormVC

- (void)viewDidLoad {
    home = [[NSString alloc]init];
    WebPageID = [[NSString alloc]init];
    [super viewDidLoad];
    [self loadHTMLspeed];
//    [self speechRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
}

-(void)applicationWillResignActive{
    home = @"home";
    [self OCCallJS];
}
- (void)loadHTMLspeed{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    order_id=70450
    [NetWorking getHUDRequest:HTML_FORM_URL withParam:@{@"token":TOKEN_VALUE,@"order_id":_orderID} withErrorCode:NO withHUD:YES success:^(id responseObjc) {
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
        NSDictionary *dic = responseObjc[@"result"];
        if ([errorCode isEqualToString:@"0"]) {
            labelName.text = [NSString stringWithFormat:@"%@签证表格",dic[@"country_name"]];
            //H5借口
            //            _urlLast = [[NSString stringWithFormat:@"%@",dic[@"is_show"]] isEqualToString:@"1"]?[NSString stringWithFormat:@"%@?ORDERID=%@",dic[@"form_url"],_usa_Order_ID]:dic[@"request_url"];
            
            _urlLast = [[NSString stringWithFormat:@"%@",dic[@"is_show"]] isEqualToString:@"1"] ? [NSString stringWithFormat:@"%@",dic[@"form_url"]]:dic[@"request_url"];
            
            [self createWeb];
        }
    } failBlock:^(NSError *error) {  }];
    
}

-(void)createWeb
{
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64, WIDTH, HEIGHT-64)];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [self.view addSubview:webView];
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    [self loadHtmlWeb:webView];
}
-(void)loadHtmlWeb:(UIWebView*)webView{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?order_id=%@&token=%@&contact_id=%@&date=1234567890",_urlLast,_orderID,_token,_contactID];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http://139.196.136.150:8080/GlobalVisa/application" withString:@"http://www.usamsl.com/newlizard/application"];
    
    if (_payChange) {
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http://139.196.136.150:8080/GlobalVisa/application" withString:@"http://www.usamsl.com/newlizard/application/application"];
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    //返回
    [_bridge registerHandler:@"popBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //提交按钮 保存点击事件
    [_bridge registerHandler:@"submitAction" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString * str =[NSString stringWithFormat:@"%@",data];
        
        if ([str isEqualToString:@"2"] ) {
       
            MSLPayVC *vc = [[MSLPayVC alloc] init];
            vc.orderID = _orderID;
            vc.contactID = _contactID;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            [CXUtils createAllTextHUB:@"提交失败"];
        }
    }];
    
    //pageID  用于语音
    [_bridge registerHandler:@"changePageId" handler:^(id data, WVJBResponseCallback responseCallback) {
        WebPageID = data;
        if ([WebPageID isEqualToString:@"0"]) {
            yuYinBtn.userInteractionEnabled = NO;
            [yuYinBtn setTitleColor:GRAY_126 forState:UIControlStateNormal];
        }else{
            yuYinBtn.userInteractionEnabled = YES;
            [yuYinBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }];
}

// 提交保存的订单
- (void)updateInfo {
    

}

#pragma mark  OC 调 JS
// 保存  的  调用
-(void)OCCallJS {
    
    if ([home isEqualToString:@"home"]) {
        //功能：保存表格
        [_bridge callHandler:@"submitForm" data:@"1" responseCallback:^(id responseData) {
        }];
        home = nil;
    }else{
        //功能：保存表格
        [_bridge callHandler:@"submitForm" data:@"3" responseCallback:^(id responseData) {
            //js提供保存的接口 submitForm       保存并返回参数3 只保存1,备用 2备用
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
}

- (NSString *)changeDateType:(NSMutableString *)date {
    
    [date insertString:@"." atIndex:10];
    NSDate *dateDate = [NSDate dateWithTimeIntervalSince1970:[date integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:dateDate];
}

#pragma mark Nav
-(void)createNav {
    
    UIView * navViewWeb = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44 + [CXUtils statueBarHeight])];
    navViewWeb.backgroundColor = COLOR_NAVIBAR;
    [self.view addSubview:navViewWeb];
    UILabel * lin = [[UILabel alloc]initWithFrame:CGRectMake(0, navViewWeb.heightCX - 0.3, WIDTH, 0.3)];
    lin.backgroundColor = COLOR_230;
    [navViewWeb addSubview:lin];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, [CXUtils statueBarHeight], 40,44);
    [backBtn setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 15, 13, 15);
    [backBtn addTarget:self action:@selector(backTooBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navViewWeb addSubview:backBtn];
    
    labelName = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.rightCX, [CXUtils statueBarHeight], WIDTH - backBtn.widthCX * 2 , 44)];
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.textColor = [UIColor whiteColor];
    labelName.font = FONT_SIZE_16;
    [navViewWeb addSubview:labelName];
    
    yuYinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yuYinBtn.frame = CGRectMake(WIDTH-95,[CXUtils statueBarHeight], 80, 44);
    [yuYinBtn setTitle:@"语音输入" forState:UIControlStateNormal];
    yuYinBtn.userInteractionEnabled = NO;
    yuYinBtn.titleLabel.font = FONT_SIZE_15;
    [yuYinBtn setTitleColor:GRAY_126 forState:UIControlStateNormal];
    yuYinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [yuYinBtn addTarget:self action:@selector(yuYinRightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [navViewWeb addSubview:yuYinBtn];
}

-(void)backTooBtn:(UIButton *)btn
{
    [_bridge callHandler:@"isInputed" data:nil responseCallback:^(id responseData) {
        //        0表示未修改  1表示修改
        NSString * str = [NSString stringWithFormat:@"%@",responseData];
        if ([str isEqualToString:@"1"]) {
            [self alertView];
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self createNav];
    
    _token = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN_KEY];
    [IQKeyboardManager sharedManager].enable = NO;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [IQKeyboardManager sharedManager].enable = YES;

    [_iFlySpeechSynthesizer stopSpeaking];
    [_iFlySpeechRecognizer stopListening];
    _iFlySpeechRecognizer.delegate = nil;
    _iFlySpeechSynthesizer.delegate = nil;
}

//help
-(void)yuYinRightBtn:(UIButton *)btn {
    
    btn.selected = YES;
    self.markView.hidden = NO;
    self.speakView.hidden = NO;
    
    if (_iFlySpeechSynthesizer && [_iFlySpeechSynthesizer isSpeaking]) {
        
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    
    [self iFlyVoiceDictationListen];
}

#pragma mark - 语音听写 模块
-(void)iFlyVoiceDictationListen
{
    _iFlySpeechRecognizer.delegate = self;
    
    [_iFlySpeechRecognizer startListening];
    
    return;
}

//设置听写参数
- (void)speechRecognizer {
    
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    [_iFlySpeechRecognizer setParameter:@"sms"forKey:@"domain"];
    [_iFlySpeechRecognizer setParameter:@"16000" forKey:@"sample_rate"];
    [_iFlySpeechRecognizer setParameter:@"0" forKey:@"plain_result"];
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iFlySpeechRecognizer setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    
}

- (void) onVolumeChanged: (int)volume {
    
    if (volume>=0 &&volume<=1) {
        self.speakView.image = [UIImage imageNamed:@"talk"];
    }else if(volume>1 && volume<=5){
        self.speakView.image = [UIImage imageNamed:@"talk1"];
    }else if (volume>5&& volume<=10){
        self.speakView.image=[UIImage imageNamed:@"talk2"];
    }else if (volume>10&& volume<=15) {
        self.speakView.image = [UIImage imageNamed:@"talk3"];
    }else if (volume>20&& volume<=25) {
        self.speakView.image = [UIImage imageNamed:@"talk4"];
    }else {
        self.speakView.image = [UIImage imageNamed:@"talk5"];
    }
}

- (void) onError:(IFlySpeechError *) error {
    
    [_iFlySpeechRecognizer setDelegate:nil];
    self.speakView.hidden = YES;
    self.markView.hidden = YES;
    [self.iFlySpeechRecognizer stopListening];
    
    if (error.errorCode != 0) {
        yuYinBtn.selected = NO;
        [_iFlySpeechSynthesizer startSpeaking: @"小Ava没有听清你的问题，请你再说一遍"];
    }
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast {
    
    NSString *result1 = [NSString new];
    NSDictionary *dic = [results objectAtIndex:0];
    if (!isLast) {
        NSArray *keys = [dic allKeys];
        result1 = [keys componentsJoinedByString:@","];
        yuYinBtn.selected = NO;
        [_iFlySpeechRecognizer stopListening];
        
        _isAVA = NO;
        [self showAlert:result1 withTitle:@""];
        //        [self getAVAData:result1];
    }
}

#pragma mark - 获取AVA语音数据
-(void)getAVAData:(NSString *)text {
    
    NSDictionary * body = @{@"input_text":@{@"text":text},@"user_id":_token,@"page_id":WebPageID};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://139.224.227.86/cgi-bin/ask_ava.py" parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dic = responseObject[@"output_text"];
                if ([dic isKindOfClass:[NSNull class]]) {
                    userLisenStr = @"对不起，AVA没听清楚，请再说一遍";
                    [self iFlySpeak];
                    
                }else{
                    
                    NSDictionary *control = dic[@"control"];
                    if ([control isKindOfClass:[NSNull class]]) {
                        userLisenStr = @"对不起，AVA没听清楚，请再说一遍";
                        [self iFlySpeak];
                        
                    }else{
                        
                        NSString * str = [NSString stringWithFormat:@"%@",dic[@"text"]];
                        if ([str isEqualToString:@""] || [str isEqualToString:@"NULL"] || [str isEqualToString:@"(null)"]) {
                            userLisenStr = [NSString stringWithFormat:@"对不起，AVA没听清楚，请再说一遍"];
                            
                        }else{
                            userLisenStr = str;
                        }
                        
                        //重复点击语音助手处理
                        if (yuYinBtn.selected) { return ; }
                        [self iFlySpeak];
                        
                        //功能：H5判断表格数据是否更改
                        [_bridge callHandler:@"avaAnswer" data:@{@"inputKey":[NSString stringWithFormat:@"%@",control[@"input"]],@"inputValue":[NSString stringWithFormat:@"%@",control[@"value"]]} responseCallback:^(id responseData) {
                            
                        }];
                    }
                }
                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            [CXUtils createAllTextHUB:@"发生错误"];
        }
    }] resume];
}

#pragma mark ---触发语音合成
-(void)iFlySpeak {
    
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    _isAVA = YES;
    [self showAlert:userLisenStr withTitle:@"AVA"];
}

//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{}
//合成开始
- (void) onSpeakBegin{}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{}
//合成播放进度
- (void) onSpeakProgress:(int) progress{}


#pragma mark - 语音听写视图
- (UIImageView *)speakView {
    
    if (!_speakView) {
        
        UIImage *image = [UIImage imageNamed:@"talk"];
        CGSize size = image.size;
        _speakView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - size.width)/2, (HEIGHT - size.height)/2 , size.width , size.height)];
        _speakView.contentMode = UIViewContentModeCenter;
        _speakView.backgroundColor = [UIColor blackColor];
        _speakView.layer.cornerRadius = 5;
        [self.view addSubview:_speakView];
        _speakView.image = [UIImage imageNamed:@"talk"];
        _speakView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSpeckView)];
        [_markView addGestureRecognizer:tap];
    }
    return _speakView;
}
- (UIView *)markView {
    if (!_markView) {
        
        _markView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        _markView.hidden = YES;
        _markView.backgroundColor = [UIColor clearColor];
        _markView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSpeckView)];
        [_markView addGestureRecognizer:tap];
        [self.view addSubview:_markView];
    }
    
    return _markView;
}

//取消回话
- (void)hideSpeckView {
    
    self.markView.hidden = YES;
    self.speakView.hidden = YES;
    [self.iFlySpeechRecognizer cancel];
}
#pragma mark 修改信息后是否选择保存的提示
-(void)alertView {
    myView = [[UIView alloc]initWithFrame:SCREEN_FRAME];
    myView.backgroundColor = [UIColor blackColor];
    myView.alpha = 0.5;
    [self.view addSubview:myView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myViewAction:)];
    tap.delegate=self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [myView addGestureRecognizer:tap];
    view = [[UIView alloc]initWithFrame:CGRectMake(40, HEIGHT/2 - 75, WIDTH - 80, 150)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 5.0 ;
    [self.view addSubview:view];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, view.bounds.size.width-40, 20)];
    label.text = @"申请表";
    label.font = FONT_17;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UILabel * labelText = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, view.bounds.size.width-40, 40)];
    labelText.text = @"申请表内容已经更新，是否提交最新内容？";
    labelText.numberOfLines = 2;
    labelText.font = FONT_SIZE_13;
    labelText.textColor = COLOR_153;
    labelText.textAlignment = NSTextAlignmentLeft;
    [view addSubview:labelText];
    
    NSArray * yesArr = @[@"否",@"是"];
    for (int i = 0; i < 2; i++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(20 + i * (WIDTH/2-70+20) ,90,WIDTH/2-70, 40)];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        [btn setTitle:yesArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = GRAY_126.CGColor;
            btn.backgroundColor = COLOR_WHITE;
            [btn setTitleColor:GRAY_126 forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = COLOR_BUTTON_BLUE;
            [btn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(yesOrNo:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
}
-(void)myViewAction:(UITapGestureRecognizer *)GestureRecognizer{
    view.hidden = YES;
    myView.hidden = YES;
}

//是否保存
-(void)yesOrNo:(UIButton*)sender {
    
    sender.tag == 200 ? [self.navigationController popViewControllerAnimated:YES] : [self OCCallJS] ;
    
    view.hidden = YES;
    myView.hidden = YES;
}


- (void)showAlert:(NSString *)message withTitle:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (!_isAVA) {
            [self getAVAData:message];
        }else {
            [_iFlySpeechSynthesizer startSpeaking: [NSString stringWithFormat:@"%@",userLisenStr]];
        }
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

@end
