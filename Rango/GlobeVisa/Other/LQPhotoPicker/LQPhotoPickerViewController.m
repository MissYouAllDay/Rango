//
//  LQPhotoPickerViewController.m
//  LQPhotoPicker
//
//  Created by lawchat on 15/9/22.
//  Copyright (c) 2015年 Fillinse. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "LQPhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LQImgPickerActionSheet.h"
#import "JJPhotoManeger.h"

#import "FootView.h"

@interface LQPhotoPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LQImgPickerActionSheetDelegate,JJPhotoDelegate>
{
    NSString *pushImgName;
    
    //添加图片提示
    UILabel *addImgStrLabel;
    NSInteger _index;
    BOOL _isDelegate;       //是否删除
    NSMutableArray *_markImageArr; // _LQPhotoPicker_selectedAssetArray 为空的时候替换使用此数组
    NSMutableArray *_imgArr;        //
}

@property(nonatomic,strong) LQImgPickerActionSheet *imgPickerActionSheet;

@property(nonatomic,strong) UICollectionView *pickerCollectionView;
@property(nonatomic,assign) CGFloat collectionFrameY;

//图片选择器
@property(nonatomic,strong) UIViewController *showActionSheetViewController;

@end

@implementation LQPhotoPickerViewController

static NSString * const reuseIdentifier = @"LQPhotoViewCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_245;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTap:)];
//    [self.view addGestureRecognizer:tap];
    
    if (@available(iOS 11.0, *)) {
        self.pickerCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setSelectArr:(NSMutableArray *)selectArr {
    
    _selectArr = selectArr;
    
    _LQPhotoPicker_smallImageArray = _selectArr;
    _index = _LQPhotoPicker_smallImageArray.count;
    [self.pickerCollectionView reloadData];
}

- (void)LQPhotoPicker_initPickerView{
    _showActionSheetViewController = self;
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.pickerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 45 - 44) collectionViewLayout:layout];
    
    if (_LQPhotoPicker_superView) {
        [_LQPhotoPicker_superView addSubview:self.pickerCollectionView];
    }
    else{
        [self.view addSubview:self.pickerCollectionView];
    }
    
    [self.pickerCollectionView registerClass:[FootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusable"];
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    if(_LQPhotoPicker_smallImageArray.count == 0)
    {
        _LQPhotoPicker_smallImageArray = [NSMutableArray array];
    }
    pushImgName = @"add1";
    
    _pickerCollectionView.scrollEnabled = YES;
    
    if (_LQPhotoPicker_imgMaxCount <= 0) {
        _LQPhotoPicker_imgMaxCount = 10;
    }
    [self changeCollectionViewHeight];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _LQPhotoPicker_smallImageArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"LQPhotoViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"LQPhotoViewCell"];
    // Set up the reuse identifier
    LQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"LQPhotoViewCell" forIndexPath:indexPath];

    if (indexPath.row == _LQPhotoPicker_smallImageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImgName]];
//        cell.closeButton.hidden = YES;
//        [cell.closeButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        //没有任何图片
        addImgStrLabel.hidden = _LQPhotoPicker_smallImageArray.count != 0;
        cell.closeButton.hidden = YES;
    }else{
        
        if ([_LQPhotoPicker_smallImageArray[indexPath.item] isKindOfClass:[NSString class]]) {
            
            [cell.profilePhoto sd_setImageWithURL:[NSURL URLWithString:_LQPhotoPicker_smallImageArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"hukou_fail"]];
            
        }else {
            
            [cell.profilePhoto setImage:_LQPhotoPicker_smallImageArray[indexPath.item]];
        }
        cell.closeButton.hidden = NO;
    }
    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
//    if (_isDelegate) {
    
//        cell.isDelegate = indexPath.row != _LQPhotoPicker_smallImageArray.count ? YES : NO;
        //添加图片cell点击事件e
        cell.closeButton.tag = indexPath.item;
        [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        
//    }else {
//
//        cell.isDelegate = NO;
//    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didDelegateAction:)];
//    [cell addGestureRecognizer:longPress];
    
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
    NSInteger index = tableGridImage.tag;
    
    [self.view endEditing:YES];
    
    // 添加
    if (index == _LQPhotoPicker_smallImageArray.count) {
        self.LQPhotoPicker_imgMaxCount = 10;
        _index = _LQPhotoPicker_smallImageArray.count;
        [self addNewImg:NO];
    }else {
        // 修改
        self.LQPhotoPicker_imgMaxCount = 1 ;
        _index = index;
        [self addNewImg:YES];
    }
//    self.LQPhotoPicker_imgMaxCount = index == (_LQPhotoPicker_smallImageArray.count)?10:1;
//        _index = index == _LQPhotoPicker_smallImageArray.count?_LQPhotoPicker_smallImageArray.count:index;
//    [self addNewImg:(index == (_LQPhotoPicker_smallImageArray.count)?NO:YES)];
}

#pragma mark - 选择图片
- (void)addNewImg:(BOOL)change{
    if (_LQPhotoPicker_smallImageArray.count == 10 && !change) {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择图片数量已达上限" delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[LQImgPickerActionSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_markImageArr && !change) {
        _imgPickerActionSheet.arrSelected = _markImageArr;
    }
    if (change) {
        _imgPickerActionSheet.selectArr = _markImageArr;
        _imgPickerActionSheet.selectIndex = _index;
    }
    _imgPickerActionSheet.maxCount = _LQPhotoPicker_imgMaxCount;
    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController];
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    
    [_LQPhotoPicker_smallImageArray removeObjectAtIndex:sender.tag];
    NSLog(@"删除之前：%ld",_markImageArr.count);

    if (_selectArr.count > 0) {
        if (sender.tag > _selectArr.count - 1) {
            
            [_markImageArr removeObjectAtIndex:sender.tag - _selectArr.count];
        }
    }else {
        [_markImageArr removeObjectAtIndex:sender.tag ];
    }

    [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
    
    for (NSInteger item = sender.tag; item <= _LQPhotoPicker_smallImageArray.count; item++) {
        LQPhotoViewCell *cell = (LQPhotoViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    //没有任何图片
    addImgStrLabel.hidden = _LQPhotoPicker_smallImageArray.count == 0 ? NO : YES;

    [self changeCollectionViewHeight];
}

#pragma mark - LQImgPickerActionSheetDelegate (返回选择的图片：缩略图，压缩原长宽比例大图)
- (void)getSelectImgWithALAssetArray:(NSArray*)ALAssetArray thumbnailImgImageArray:(NSArray*)thumbnailImgArray{

    if (_index == _LQPhotoPicker_smallImageArray.count) {

        _LQPhotoPicker_smallImageArray = [NSMutableArray arrayWithArray:_selectArr];
        [_LQPhotoPicker_smallImageArray addObjectsFromArray:thumbnailImgArray];
//        if (!_LQPhotoPicker_selectedAssetArray) {
//            _LQPhotoPicker_selectedAssetArray = [[NSMutableArray alloc] init];
//        }
        
        _markImageArr = [[NSMutableArray alloc] initWithArray:ALAssetArray];

        NSLog(@"添加：%ld",_markImageArr.count);
        NSLog(@"添加：%ld",ALAssetArray.count);

    }else {
        if (ALAssetArray.count != 0) {
            _LQPhotoPicker_smallImageArray[_index] = thumbnailImgArray[0];
            
            _markImageArr = [[NSMutableArray alloc] initWithArray:ALAssetArray];
            NSLog(@"修改：%ld",_markImageArr.count);

        }
    }
    [self changeCollectionViewHeight];

    [self.pickerCollectionView reloadData];
}

#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    
    int i = 0;
    if ((_LQPhotoPicker_smallImageArray.count + 1)%3 != 0) {
        i = 1;
    }
    CGFloat hei = ((WIDTH - 40)/3 + 30 + 10) * ((_LQPhotoPicker_smallImageArray.count + 1)/3 + i) + 200;
    if (hei >= HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ) {
        hei = HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ;
    }
    _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width,hei);

    return;
    
    if (_collectionFrameY) {

        CGFloat hei = (((float)[UIScreen mainScreen].bounds.size.width-64.0)/3.0 +20.0)* ((int)(_LQPhotoPicker_smallImageArray.count + 1)/3+1)+200.0;
        if (hei >= HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ) {
            hei = HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ;
        }
        _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width,hei );
    }else{

        CGFloat hei = (((float)[UIScreen mainScreen].bounds.size.width-64.0)/3.0 +20.0)* ((int)(_LQPhotoPicker_smallImageArray.count + 1)/3+1)+200.0;
        if (hei >= HEIGHT - [CXUtils statueBarHeight] - 45 - 44 ) {
            hei = HEIGHT - [CXUtils statueBarHeight] - 45 - 44;
        }
        _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, hei);
    }
    if (_LQPhotoPicker_delegate && [_LQPhotoPicker_delegate respondsToSelector:@selector(LQPhotoPicker_pickerViewFrameChanged)]) {
        [_LQPhotoPicker_delegate LQPhotoPicker_pickerViewFrameChanged];
    }
}

- (void)LQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y{
    
    _collectionFrameY = Y;
    _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /3.0 +20.0)* ((int)(_LQPhotoPicker_smallImageArray.count)/3+1)+20.0);
}

#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex {
    
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

#pragma mark - 获得选中图片各个尺寸
- (NSMutableArray*)LQPhotoPicker_getSmallImageArray{
    return _LQPhotoPicker_smallImageArray;
}
- (CGRect)LQPhotoPicker_getPickerViewFrame{
    return self.pickerCollectionView.frame;
}
@end
