//
//  MSLHuKouVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLHuKouVC.h"
#import "FootView.h"
#import "LQPhotoViewCell.h"
#import "MSLOrderDatumModel.h"
#import "DJCameraViewController.h"
@interface MSLHuKouVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DJCameraViewControllerDeletate>
{
    NSString *pushImgName;
    
    //添加图片提示
    UILabel *addImgStrLabel;
    NSInteger _index;
    BOOL _isDelegate;       //是否删除
    NSMutableArray *_markImageArr; // _LQPhotoPicker_selectedAssetArray 为空的时候替换使用此数组
    NSMutableArray *_imgArr;        //
    UIButton *_nextBtn;
}

@property(nonatomic,strong) UICollectionView *pickerCollectionView;
@property(nonatomic,assign) CGFloat collectionFrameY;
@property(nonatomic,strong) NSMutableArray * selectArr;

@end

@implementation MSLHuKouVC


static NSString * const reuseIdentifier = @"LQPhotoViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_245;
    [self loadData];
    [self createCollectionView];
    [self createNextBtn];
    if (@available(iOS 11.0, *)) {
        self.pickerCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)createCollectionView{
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.pickerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 45 - 44) collectionViewLayout:layout];
    
    [self.view addSubview:self.pickerCollectionView];

    [self.pickerCollectionView registerClass:[FootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusable"];
    UINib *nib = [UINib nibWithNibName:@"LQPhotoViewCell" bundle: [NSBundle mainBundle]];
    [self.pickerCollectionView registerNib:nib forCellWithReuseIdentifier:@"LQPhotoViewCell"];
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    pushImgName = @"add1";
    
    _pickerCollectionView.scrollEnabled = YES;

    [self changeCollectionViewHeight];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"LQPhotoViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == _selectArr.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImgName]];
       
        //没有任何图片
        addImgStrLabel.hidden = _selectArr.count != 0;
        cell.closeButton.hidden = YES;
    }else{
        
        if ([_selectArr[indexPath.item] isKindOfClass:[NSString class]]) {
            
            [cell.profilePhoto sd_setImageWithURL:[NSURL URLWithString:_selectArr[indexPath.item]] placeholderImage:[UIImage imageNamed:@"hukou_fail"]];
            
        }else {
            
            [cell.profilePhoto setImage:_selectArr[indexPath.item]];
        }
        cell.closeButton.hidden = NO;
    }
//    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item] + 1000;

    //添加图片cell点击事件e
    cell.closeButton.tag = indexPath.item;
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto.userInteractionEnabled = YES;
    [cell.profilePhoto addGestureRecognizer:singleTap];

    return cell;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((WIDTH - 40)/3 , (WIDTH - 40)/3 + 30);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 8, 20, 8);
}
//设置头脚视图的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(WIDTH, 200);
}

//脚标
//为collectionView添加头脚视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    FootView * Footer = (FootView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"reusable" forIndexPath:indexPath];
    
    if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        Footer.backgroundColor = COLOR_245;
        Footer.nameLabel.text = @"温馨提示";
        Footer.fLabel.text = @"· 拍摄字体清晰可见不要反光";
        Footer.tLabel.text = @"· 如有错误可点击修改";
        Footer.thLabel.text = @"· 点击可删除照片";
    }
    
    return Footer;
}

#pragma mark - 图片cell点击事件
- (void)tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    
    //    [self collectionViewTap:gestureRecognizer];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    _index = tableGridImage.tag - 1000;
    
    [self.view endEditing:YES];
    
    [self addNewImg: _index != _selectArr.count];
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
   
    [_selectArr removeObjectAtIndex:sender.tag];
    
    [_pickerCollectionView reloadData];
    [self changeCollectionViewHeight];

}

#pragma mark - 选择图片
- (void)addNewImg:(BOOL)change{
    if (_selectArr.count == 10 && !change) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择图片数量已达上限" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    DJCameraViewController *VC = [[DJCameraViewController alloc]init];
    VC.delegateMy = self;
    VC.markImg.image =[[UIImage imageNamed:@"passport"] stretchableImageWithLeftCapWidth:WIDTH topCapHeight:HEIGHT - 139];
    [self presentViewController:VC animated:YES completion:nil];
    
}
#pragma  mark - 相机代理  获取图片
-(void)selectPaiShePhotos:(UIImage *)photosMy {
    
    [self getUserSelectImage:photosMy];
}

- (void)selectAlbumPhotos:(UIImage *)photosAlbum {
    
    [self getUserSelectImage:photosAlbum];
}
- (void)getUserSelectImage:(UIImage *)photoArr {
    
    if (photoArr == nil) { return;  }
    if (_index == _selectArr.count) {
        
        [_selectArr addObject:photoArr];
        
    }else {
        
        _selectArr[_index] = photoArr;
    }
    
    [_pickerCollectionView reloadData];
    [self changeCollectionViewHeight];
}


#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    
    int i = 0;
    if ((_selectArr.count + 1)%3 != 0) {
        i = 1;
    }
    CGFloat hei = ((WIDTH - 40)/3 + 30 + 10) * ((_selectArr.count + 1)/3 + i) + 200;
    if (hei >= HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ) {
        hei = HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ;
    }
    _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width,hei);
    
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

#pragma mark - - - - - - - - - - 数据 - - - - - - - - - - -
- (void)loadData {

    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (MSLOrderDatumModel *model in _accBookArr) {
        self.title = model.visa_datum_name;

        if (model.path_name.length > 1) {

            [images addObject:model.path_name];
        }
    }
    
    if (images.count > 1 || images.count == 1) {
        
        self.selectArr = [[NSMutableArray alloc] initWithArray:images];
        [_pickerCollectionView reloadData];
        [self changeCollectionViewHeight];
    }else {
        
        self.selectArr = [[NSMutableArray alloc] init];
    }
}



#pragma mark - 上传图片
- (void)submitToServer{
    
    NSMutableArray *samllImage = [[NSMutableArray alloc] initWithArray:_selectArr];
    
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





@end
