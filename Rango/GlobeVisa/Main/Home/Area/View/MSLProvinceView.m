//
//  MSLProvinceView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/31.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//


// - - - - - - - - - - - - - - 省份 请选择长期居住地点击后弹出的界面  - - - - - - - - - - - - - - -

#import "MSLProvinceView.h"
#import "MSLProvinceItem.h"
@interface MSLProvinceView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end


@implementation MSLProvinceView
{
    UICollectionView *_collectionView;
    
    UILabel *_provinceLab;
    NSIndexPath *_oldIndexPath;
}


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createTab];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)createTab {
    
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, self.widthCX + 2, 43)];
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = HWColor(230, 230, 230).CGColor;
    [self addSubview:topView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, topView.heightCX)];
    title.center = topView.center;
    title.text = @"长期居住地";
    title.font = FONT_SIZE_14;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = COLOR_52;
    [topView addSubview:title];
    
     _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(0, 0, 56, topView.heightCX);
    _closeBtn.rightCX = topView.rightCX;
    [_closeBtn setImage:[UIImage imageNamed:@"district_close"] forState:UIControlStateNormal];
    [topView addSubview:_closeBtn];
    
    
    UICollectionViewFlowLayout *layou = [[UICollectionViewFlowLayout alloc] init];
    
    layou.sectionInset = UIEdgeInsetsMake(13, 10, 13, 10);
    layou.itemSize = CGSizeMake(Line(85), Line(35));
    layou.minimumLineSpacing = 7;
    layou.minimumInteritemSpacing = 13;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topView.heightCX, self.widthCX, self.heightCX - topView.heightCX) collectionViewLayout:layou];
    [self addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    UINib *nib = [UINib nibWithNibName:@"MSLProvinceItem" bundle: [NSBundle mainBundle]];

    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"provinceItem"];}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLProvinceItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"provinceItem" forIndexPath:indexPath];

    if (_dataArr.count != 0) {
        
        NSDictionary *dic = _dataArr[indexPath.item];
        cell.name.text =  dic[@"area_name"];
    }
    
    if (!_oldIndexPath && indexPath.item == 0) {
       
        _oldIndexPath = indexPath;
    }
    
    if (_oldIndexPath == indexPath) {
        cell.name.layer.borderColor = HWColor(77, 186, 244).CGColor;
        cell.name.textColor = HWColor(77, 186, 244);
    } else {
        
        [cell reduction];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    MSLProvinceItem *item1 = (MSLProvinceItem *)[collectionView cellForItemAtIndexPath:_oldIndexPath];
    [item1 reduction];
    
    MSLProvinceItem *item = (MSLProvinceItem *)[collectionView cellForItemAtIndexPath:indexPath];
    [item selectItem];
    
    _oldIndexPath = indexPath;
    
    [self.delegate provinceSelectIndex:indexPath.item];
    [self closeSelf];
}

- (void)show {
    
    self.hidden = NO;
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);

    [UIView animateWithDuration:0.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        self.hidden = NO;
    }];
}

- (void)closeSelf {
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;

    } completion:^(BOOL finished) {
        
        self.hidden = YES;

    }];
}


- (void)setDataArr:(NSArray *)dataArr {
    
    _dataArr = dataArr;
    [_collectionView reloadData];
}



@end
