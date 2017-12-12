//
//  MSLSinglePictureVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLSinglePictureVC.h"
#import "PassportHeadView.h"
#import "DJCameraViewController.h"
@interface MSLSinglePictureVC ()<DJCameraViewControllerDeletate>
{
    
    UIButton *_nextBtn;
    PassportHeadView *_head;
    BOOL _haveImg;  //是否有或者替换图片
}

@end

@implementation MSLSinglePictureVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _datumModel.visa_datum_name;
    [self createHead];
    [self createNextBtn];
    if (_datumModel.path_name.length > 1) {
        [_head.passportImagheView sd_setImageWithURL:[NSURL URLWithString:_datumModel.path_name] placeholderImage:[UIImage imageNamed:@"photo_fail"]];
    }
}

- (void)createHead {
    
    _head = [[[NSBundle mainBundle] loadNibNamed:@"PassportHeadView" owner:nil options:nil] lastObject];
    _head.frame = CGRectMake(0, 0, WIDTH, 320);
    _head.titleLab.text = _datumModel.visa_datum_name;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCamera)];
    [_head.passportImagheView addGestureRecognizer:tap];
    [self.view addSubview:_head];
    
    if (_datumModel.path_name.length > 1) {
        
        [_head.passportImagheView sd_setImageWithURL:[NSURL URLWithString:_datumModel.path_name] placeholderImage:[UIImage imageNamed:@"fail"]];
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,  320, WIDTH,200)];
    footView.backgroundColor = COLOR_247;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, footView.widthCX, 30)];
    title.text = @"温馨提示";
    title.font = FONT_SIZE_14;
    
    UITextView *textLab = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, footView.widthCX, 160)];
    textLab.text = @"· 如有错误可点击修改\n· 拍摄字体清晰可见不要反光";
    textLab.textColor =  HWColor(153, 153, 153);
    textLab.font = FONT_SIZE_12;
    textLab.editable = NO;
    textLab.backgroundColor = [UIColor clearColor];
    [footView addSubview:title];
    [footView addSubview:textLab];
    [self.view addSubview:footView];
}

- (void)getCamera {
    
    DJCameraViewController *VC = [[DJCameraViewController alloc]init];
    VC.delegateMy = self;
    VC.markImg.image =[[UIImage imageNamed:@"passport"] stretchableImageWithLeftCapWidth:WIDTH topCapHeight:HEIGHT - 139];
    [self presentViewController:VC animated:YES completion:nil];
}

//图片数组
- (void)selectPaiShePhotos:(UIImage *)photosMy {
    [self getUserSelectImage:photosMy];
}

- (void)selectAlbumPhotos:(UIImage *)photosAlbum {
    [self getUserSelectImage:photosAlbum];
}

- (void)getUserSelectImage:(UIImage *)photoArr {
    
    if (photoArr == nil) { return;  }
    
    _haveImg = YES;
    UIImage *image = photoArr;
    _head.passportImagheView.contentMode = UIViewContentModeScaleToFill;
    [_head.passportImagheView setImage:image];
}

#pragma mark - - - - - - - - - - 下一步 - - - - - - - - - - -
- (void)createNextBtn {
    
    _nextBtn = [super createDownNextBtn];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}

- (void)nextBtnAction:(UIButton *)sender {
    
    if (!_haveImg) {  return; }
    
    
    if (_contactChange) {
         NSDictionary *changeParam = @{@"attachment_id":_datumModel.attachment_id,@"visa_datum_type":@"4",@"contact_id":_contactID,@"detail_id":_datumModel.detail_id,@"is_del":@"0",@"visa_datum_id":_datumModel.visa_datum_id};
        [self contactChangeUpImage:changeParam] ;
        return;
    }
    
    NSDictionary *orderParam = @{@"attachment_id":_datumModel.attachment_id,@"visa_datum_type":@"4",@"order_id":_orderID,@"detail_id":_datumModel.detail_id,@"is_del":@"0",@"order_datum_id":_datumModel.order_datum_id};
    
    [self orderUpImagewithParam:orderParam];
}

// 申请人 修改 信息    上传图片
- (void)contactChangeUpImage:(NSDictionary *)param{
    
    [NetWorking postImageOnlywithURL:UPIMG_CONTACR_URL withParam:param Images:@[_head.passportImagheView.image] success:^(id responseObjc) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactReLoadData" object:nil];

        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) { }];
}

//上传图片
- (void)orderUpImagewithParam:(NSDictionary *)param {

    [NetWorking postImageOnlywithURL:UPIMG_URL withParam:param Images:@[_head.passportImagheView.image] success:^(id responseObjc) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpInfoReLoadData" object:nil];
        
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) { }];
}

@end
