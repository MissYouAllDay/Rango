//
//  MSLVisaPhotoVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/15.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLVisaPhotoVC.h"

@interface MSLVisaPhotoVC ()

@property (strong, nonatomic) UISegmentedControl *specSegment;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIImageView * smallCameraImage;
@end

@implementation MSLVisaPhotoVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self createZhengJian];、
    self.title = @"证件拍摄页面";
    [self imageUI];
    
    if (_model.path_name.length > 1) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.path_name] placeholderImage:[UIImage imageNamed:@"post_fail"]];
        self.smallCameraImage.hidden = YES;
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark 图片UI
-(void)imageUI {
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, WIDTH-10, 300)];
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    bgView.backgroundColor = COLOR_WHITE;
    [self.view addSubview:bgView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-100, 50, 200, 200)];
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = COLOR_230.CGColor;

    [bgView addSubview:self.imageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoUserZJ:)];
    [self.imageView addGestureRecognizer:tap];
    self.imageView.userInteractionEnabled = YES;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,  bgView.bottomCX + 5, bgView.widthCX,200)];
    footView.backgroundColor = COLOR_247;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, footView.widthCX, 30)];
    title.text = @"温馨提示";
    title.font = FONT_SIZE_14;
    
    UITextView *textLab = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, footView.widthCX, 160)];
    textLab.text = @"· 如有错误可点击修改\n· 拍摄字体清晰可见不要反光";
    textLab.textColor = HWColor(153, 153, 153);
    textLab.font = FONT_SIZE_12;
    textLab.editable = NO;
    textLab.backgroundColor = [UIColor clearColor];
    [footView addSubview:title];
    [footView addSubview:textLab];
    [self.view addSubview:footView];
    
    UIButton * sureBtn = [super createDownNextBtn];
    [sureBtn addTarget:self action:@selector(queRen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    self.smallCameraImage = [[UIImageView alloc]init];
    self.smallCameraImage.image = [UIImage imageNamed:@"photo"];
    [self.imageView addSubview:self.smallCameraImage];
    
    [self.smallCameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.imageView);
        make.width.equalTo(self.smallCameraImage.image.size.width);
        make.height.equalTo(self.smallCameraImage.image.size.height);
    }];
}
#pragma mark - 上传照片
-(void)queRen:(UIButton*)btntt {
    
    if (self.imageView.image == nil) {

        [CXUtils createAllTextHUB:@"请上传照片"];
        return;
    }

    if (!_contactID) {

        [CXUtils createAllTextHUB:@"上传失败,稍后重试"];
        return;
    }
    
    NSDictionary *param = @{@"attachment_id":_model.attachment_id,@"visa_datum_type":@"3",@"order_id":_orderID,@"detail_id":_model.detail_id,@"is_del":@"0",@"order_datum_id":_model.order_datum_id};

    [NetWorking postImageOnlywithURL:UPIMG_URL withParam:param Images:@[self.imageView.image] success:^(id responseObjc) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpInfoReLoadData" object:nil];
        
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) { }];
}

#pragma mark 照相代理
-(void)photoUserZJ:(UITapGestureRecognizer*)tap
{
    /*
     参数说明：
     beginColor、endColor同时传nil则表示使用原背景（请在证件照规格列表中查找 SPEC_KEY参数,请在背景色列表中查找 begin_color以及end_color 参数）；APP_KEY、APP_SECRET可以去证件照SDK官网获取。
     
     @"774fc5348ae0419ca5328c4a0446c46b" //usaVisa
     */
    self.imageView.image = nil;

    UIColor * beginColor = [UIColor whiteColor];
    UIColor * endColor = [UIColor whiteColor];
    NSString *specKey = [[NSUserDefaults standardUserDefaults] objectForKey:PHOTO_FORMEAT];
    
    [Safelight makeWithKey:SAFELIGHT_KEY
                    secret:SAFELIGHT_SECRET
                   specKey:specKey
                beginColor:beginColor
                  endColor:endColor
            viewController:self
                  delegate:self];
    
}
/*
 参数说明：
 若回调该方法则表示证件照任务已完成，image为最终处理生成的图片，score为证件照对传入照片的综合打分。
 */
-(void)safelightFinishedWithImage:(UIImage *)image score:(NSInteger)score
{
    NSLog(@"Success");
    NSLog(@"平均得分===%ld",(long)score);
    self.smallCameraImage.hidden = YES;
    
    self.imageView.image = image;
    [self saveImage:self.imageView.image withName:@"21.jpg"];
}

#pragma mark --保存图片到沙盒
-(void)saveImage:(UIImage *)currentImage withName:(NSString *) imageName{
    
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);
    
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingString:@"/Documents"]stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
}
/*
 参数说明：
 若回调该方法则表示证件照任务发生错误，error为证件照返回的错误信息。当[error.domain isEqualToString:[Safelight errorDomain]]为YES并且error.code也同时为－1001时，表示该错误是由于用户主动取消了操作导致；其它错误信息可以根据[error localizedDescription]来查看。
 */
-(void)safelightFinishedWithError:(NSError *)error
{
    NSLog(@"失败回调");
    BOOL isSafelightError = [error.domain isEqualToString:[Safelight errorDomain]];
    if (isSafelightError && error.code == -1001) {
        NSLog(@"用户主动取消了操作");
    } else {
        NSLog(@"Failed %ld: %@", (long)error.code, [error localizedDescription]);
    }
}

#pragma mark 导航
//-(void)createZhengJian
//{
//    self.view.backgroundColor = COLOR_247;
//    UIView * navViewZj = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
//    navViewZj.backgroundColor = COLOR_NAVIBAR;
//    [self.view addSubview:navViewZj];
//    UILabel * lin = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.7, WIDTH, 0.3)];
//    lin.backgroundColor = COLOR_231;
//    [navViewZj addSubview:lin];
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 20, 70, 44);
//    [backBtn setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateNormal];
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 15, 13, 45);
//    [backBtn addTarget:self action:@selector(backTossMateri:) forControlEvents:UIControlEventTouchUpInside];
//    [navViewZj addSubview:backBtn];
//
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-50, 20, 100, 44)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"证件拍摄页面";
//    label.font = FONT_SIZE_16;
//    label.textColor = [UIColor whiteColor];
//    [navViewZj addSubview:label];
//
//}
#pragma mark 返回按钮
-(void)backTossMateri:(UIButton *)zjBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
