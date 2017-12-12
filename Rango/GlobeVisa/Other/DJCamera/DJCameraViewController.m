//
//  ViewController.m
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "DJCameraViewController.h"
#import "UIButton+DJBlock.h"
#import "DJCameraManager.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define AppWidth [[UIScreen mainScreen] bounds].size.width
#define AppHeigt [[UIScreen mainScreen] bounds].size.height
#define ww [UIScreen mainScreen].bounds.size.width
#define hh [UIScreen mainScreen].bounds.size.height
@interface DJCameraViewController () <DJCameraManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    UIView *pickView;
    UIImageView *imageView;
    UIButton *paiZhaoButton;
    UIButton *backButton;
    UIButton *yesBtn;
    UIButton *noBtn;
}
@property (nonatomic,strong)DJCameraManager *manager;
@property(nonatomic,strong )UIButton *flashBtn;
@property(strong,nonatomic) UIButton * albumBtn;

//
@property (nonatomic,strong) NSMutableArray * imageArr;

@end

@implementation DJCameraViewController
/**
 *  在页面结束或出现记得开启／停止摄像
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.manager.session isRunning]) {
        [self.manager.session startRunning];
    }
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;

}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.manager.session isRunning]) {
        [self.manager.session stopRunning];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;

}


- (void)dealloc
{
    NSLog(@"照相机释放了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLayout];
    [self initPickButton];
    [self initPhotoAlbum];
    [self initFlashButton];
    [self initDismissButton];
    [self.view addSubview:self.markImg];
    self.view.clipsToBounds = YES;
}

- (UIImageView *)markImg {
    
    if (!_markImg) {
    
        _markImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,43, ww, hh-43-96)];

    }
    return _markImg;
}
- (void)initLayout
{
    self.view.backgroundColor = [UIColor blackColor];
    
    pickView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ww,hh-139)];

    
    [self.view addSubview:pickView];
    // 传入View的frame 就是摄像的范围
    DJCameraManager *manager = [[DJCameraManager alloc] initWithParentView:pickView];
    manager.delegate = self;
    manager.canFaceRecognition = YES;
    [manager setFaceRecognitonCallBack:^(CGRect faceFrame) {
//        NSLog(@"你的脸在%@",NSStringFromCGRect(faceFrame));
    }];
    
    self.manager = manager;
}

/**
 *  拍照按钮
 */
- (void)initPickButton
{//119 119    179 179
  
        paiZhaoButton = [self buildButton:CGRectMake(ww/2-119/2/2,hh-119/2-(96-119/2)/2,119/2, 119/2)
                             normalImgStr:@"shutter"
                          highlightImgStr:@""
                           selectedImgStr:@""
                               parentView:self.view];
    
  
    WS(weak);
    [paiZhaoButton addActionBlock:^(id sender) {
        [weak.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *scaledImage, UIImage *croppedImage) {
            if (croppedImage) {
                pickView.hidden = YES;
                _markImg.hidden = YES;
                _albumBtn.hidden = YES;
                paiZhaoButton.hidden = YES;
                _flashBtn.hidden = YES;
                backButton.hidden = YES;
                [self canLookImage];
                imageView.image = croppedImage;
            }
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}

//相册
-(void)initPhotoAlbum
{
    _albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _albumBtn.frame = CGRectMake(28, hh-69/2-(96-69/2)/2, 73/2, 69/2);//73 69
    [_albumBtn setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    [_albumBtn addTarget:self action:@selector(album:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_albumBtn];
}
//跳转相册
-(void)album:(UIButton*)albumbtn
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        //无权限
        UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，您没有开启调用相册权限，是否前往 设置-隐私-相册 中设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * quxiaoBtn = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [quxiaoBtn setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        
        [alertTip addAction:quxiaoBtn];
        
        UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
            
        }];
        [queRenAlert setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        
        [alertTip addAction:queRenAlert];
        [self presentViewController:alertTip animated:YES completion:nil];
        

    }else{
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        pickerImage.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:pickerImage animated:YES completion:^{}];

    }
}
/**
 *  切换闪光灯按钮
 */
- (void)initFlashButton
{
    _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flashBtn setImage:[UIImage imageNamed:@"flash1"] forState:UIControlStateNormal];//UIControlStateNormal
    [_flashBtn addTarget:self action:@selector(flashBtnAction) forControlEvents:UIControlEventTouchUpInside];
   
        _flashBtn.frame = CGRectMake(AppWidth-100,0,100, 43);//24 39
        _flashBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 67, 0, 15);
        
    
    [self.view addSubview:_flashBtn];
}
//返回按钮
- (void)initDismissButton
{
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backW"] forState:UIControlStateNormal];
   
        backButton.frame = CGRectMake(0,0, 100, 43);//17 30
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 70);

    
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    WS(weak);
    [backButton addActionBlock:^(id sender) {
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}
/**
 *  点击对焦
 *
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [self.manager focusInPoint:point];
}
#pragma mark - 闪光灯按钮
-(void)flashBtnAction
{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        
        if (device.flashMode == AVCaptureFlashModeOff) {
            
            device.flashMode = AVCaptureFlashModeOn;
            //开
            [_flashBtn setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
            
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            
            device.flashMode = AVCaptureFlashModeOff;
            //
            [_flashBtn setImage:[UIImage imageNamed:@"flash1"] forState:UIControlStateNormal];
            
        }
        
    } else {
        
        NSLog(@"设备不支持闪光灯");
        
    }
    
    [device unlockForConfiguration];
    
}
- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
              parentView:(UIView*)parentView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [parentView addSubview:btn];
    return btn;
}

#pragma -mark DJCameraDelegate
- (void)cameraDidFinishFocus
{
    NSLog(@"对焦结束了");
}
- (void)cameraDidStareFocus
{
    NSLog(@"开始对焦");
}
-(void)canLookImage
{
    imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesBtn setImage:[UIImage imageNamed:@"yes1"] forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];

    [yesBtn addTarget:self action:@selector(yesBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesBtn];
    
    noBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [noBtn setImage:[UIImage imageNamed:@"no1"] forState:UIControlStateNormal];

    [noBtn addTarget:self action:@selector(noBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noBtn];
    
  
        imageView.frame = CGRectMake(0,43, AppWidth, AppHeigt-96-43);
        
        yesBtn.frame = CGRectMake(33,AppHeigt-41/2-(96-41/2)/2, 100, 41/2);
        yesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 100-59/2);
        
        noBtn.frame = CGRectMake(AppWidth-100,AppHeigt-21-(96-21)/2, 100, 21);
        noBtn.imageEdgeInsets = UIEdgeInsetsMake(0,25,0,0);

}
-(void)yesBtn:(UIButton*)btnYes
{
    [self saveImageToPhotoAlbum:imageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


// 指定回调方法  相机拍摄
-(void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
    }else{
        [_delegateMy selectPaiShePhotos:image];
      
//        [_delegateAlbum selectAlbumPhotos:image];
    }
}
#pragma mark UIImagePickerControllerDelegate
//相册回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //保存原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageArr = [[NSMutableArray alloc]init];
    if (image != nil)
    {
        [_imageArr addObject:image];
//        [_delegateMy selectPaiShePhotos:image];
        [_delegateMy selectAlbumPhotos:image];
        
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }];

}

-(void)noBtn:(UIButton*)btnNo
{
    [CXUtils createAllTextHUB:@"照片未保存"];
    [self photoUIUpdate];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 拍摄图片完毕后选择图片的操作
-(void)photoUIUpdate
{
    [imageView removeFromSuperview];
    [yesBtn removeFromSuperview];
    [noBtn removeFromSuperview];
    
    yesBtn.hidden = YES;
    noBtn.hidden = YES;
    pickView.hidden = NO;
    _markImg.hidden = NO;
    backButton.hidden = NO;
    _albumBtn.hidden = NO;
    _flashBtn.hidden = NO;
    paiZhaoButton.hidden = NO;
}
@end
