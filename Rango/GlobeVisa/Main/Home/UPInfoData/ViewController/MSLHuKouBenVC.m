//
//  MSLHuKouBenVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/15.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLHuKouBenVC.h"

@interface MSLHuKouBenVC ()<LQPhotoPickerViewDelegate>
{
    
    //备注文本View高度
    float noteTextHeight;
    
    float pickerViewHeight;
    float allViewHeight;
    UIButton *_nextBtn;
    MBProgressHUD *_proHUD;
}

@end

@implementation MSLHuKouBenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self createHuKouBen];
    MSLOrderDatumModel *model = _accBookArr[0];
    self.title = model.visa_datum_name;
    [self.navigationController.navigationBar setBackgroundColor:COLOR_NAVIBAR];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,WIDTH,  HEIGHT - 45 - [CXUtils statueBarHeight] - 44)];
    
    _scrollView.backgroundColor = [UIColor redColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 45 - [CXUtils statueBarHeight] - 44 )];
    [self.view addSubview:bgView];

    bgView.backgroundColor = COLOR_245;
    
    self.LQPhotoPicker_superView = bgView;
    
    self.LQPhotoPicker_imgMaxCount = 10;
    
    [self LQPhotoPicker_initPickerView];
    
    self.LQPhotoPicker_delegate = self;
    
    [self createNextBtn];
    
}

- (void)updateViewsFrame{
    
    if (!allViewHeight) { allViewHeight = 0; }
    if (!noteTextHeight) { noteTextHeight = 100; }
    
    allViewHeight =  [self LQPhotoPicker_getPickerViewFrame].size.height;
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight);
}

- (void)setAccBookArr:(NSArray *)accBookArr {
    
    _accBookArr = accBookArr;
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (MSLOrderDatumModel *model in _accBookArr) {
        
        if (model.path_name.length > 1) {
            
            [images addObject:model.path_name];
        }
    }
    
    if (images.count > 1 || images.count == 1) {
        
        self.selectArr = images;
    }
}

#pragma mark - 上传图片
- (void)submitToServer{
    
    NSMutableArray *samllImage = [self LQPhotoPicker_smallImageArray];
    
    MSLOrderDatumModel *model = _accBookArr[0];
    
    //获取添加的image  获取保留下的图片url
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *selectOrder = [[NSMutableArray alloc] init];
    for (int i = 0; i < samllImage.count; i ++) {
        
        if ([samllImage[i] isKindOfClass:[UIImage class]]) {
            
            [images addObject:samllImage[i]];
        }
        if ([samllImage[i] isKindOfClass:[NSString class]]) {
            
            [selectOrder addObject:samllImage[i]];
        }
    }
    
    //如果不做任何修改则不允许操作
    if (images.count == 0 && model.path_name.length < 1) {
        
        [CXUtils createAllTextHUB:@"请添加户口本照片"];
        return;
    }
    
    //保留下的图片MOdel
    NSMutableArray *outPathName = [[NSMutableArray alloc] init];
    for (NSString *str in selectOrder) {
        
        for (MSLOrderDatumModel *ordModel in _accBookArr) {
            
            if ([ordModel.path_name isEqualToString:str]) {
                
                [outPathName addObject:ordModel];
                
            }
        }
    }
    
    //删除的图片model
    NSMutableArray *oldArr = [NSMutableArray arrayWithArray:_accBookArr];
    [oldArr removeObjectsInArray:outPathName];
    
    //获取删除的showOrder
    NSString *showOrderStr = @"";
    for (int i = 0; i < oldArr.count; i ++ ) {
        
        MSLOrderDatumModel *model = oldArr[i];
        showOrderStr = (i == 0 ? [NSString stringWithFormat:@"%@",model.detail_id] : [showOrderStr stringByAppendingFormat:@",%@",model.detail_id]);
    }
    
    //防止不修改再提交
    if (images.count == 0 && oldArr.count == 0) { [CXUtils createAllTextHUB:@"您未做任何修改"]; return; }
    
    //新加
    if (images.count != 0 && model.path_name.length < 1) { showOrderStr = @"0"; }
    
    //如果仅仅是添加的话则将showorder设置为最大值
    if (oldArr.count == 0) {
        
        showOrderStr = [NSString stringWithFormat:@"0"];
    }
    
    NSString *attID = [NSString stringWithFormat:@"%@",model.attachment_id];
    NSString *isDelete = (images.count == 0 && model.path_name.length > 1)?@"1":@"0";
    
    if (_contactChange) {
         NSDictionary *changeParam = @{@"attachment_id":attID,@"visa_datum_type":@"5",@"contact_id":_contactID,@"detail_id":showOrderStr,@"is_del":@"0",@"visa_datum_id":model.visa_datum_id};
        [self contactChangeUpImage:changeParam withImage:images] ;
        return;
    }
    NSDictionary *orderParam = @{@"attachment_id":attID,@"visa_datum_type":@"5",@"order_id":_orderID,@"detail_id":showOrderStr,@"is_del":isDelete,@"order_datum_id":model.order_datum_id};

    [self orderUpImage:images withParam:orderParam];
}

// 申请人 修改 信息    上传图片
- (void)contactChangeUpImage:(NSDictionary *)param withImage:(NSArray *)upImgArr{
    
    [NetWorking postImagewithURL:UPIMG_CONTACR_URL withParam:param Images:upImgArr success:^(id responseObjc) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactReLoadData" object:nil];

        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) { }];
}

//上传图片
- (void)orderUpImage:(NSArray *)images withParam:(NSDictionary *)param {
    
    [NetWorking postMultipleImagewithURL:UPIMG_URL withParam:param Images:images success:^(id responseObjc) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpInfoReLoadData" object:nil];
        
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSError *error) { }];
}

- (void)LQPhotoPicker_pickerViewFrameChanged{
    [self updateViewsFrame];
}

#pragma mark 创建导航
- (void)createNextBtn {
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(0, HEIGHT - [CXUtils statueBarHeight] - 44 - 45, WIDTH, 45);
    _nextBtn.backgroundColor = COLOR_BUTTON_BLUE;
    _nextBtn.titleLabel.font = FONT_SIZE_15;
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(submitToServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}

@end
