//
//  MSLIndexView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLIndexView.h"
#import "MSLItemView.h"

@implementation MSLIndexView
{
    UICollectionView *_meunCollectView;
    NSIndexPath *_oldIndexPath;
}

+ (id)shareIndexView {
    
    static MSLIndexView *mslindexView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mslindexView = [[MSLIndexView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, 37)];
    });
    return mslindexView;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.selectIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        [self createCollectView];
    }
    return self;
}

- (void)createCollectView {
    
    CGFloat itemW = (WIDTH - 60)/5;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.footerReferenceSize = CGSizeZero;
    _meunCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, itemW) collectionViewLayout:layout];
    
    _meunCollectView.tag = 1001;
    _meunCollectView.delegate = self;
    _meunCollectView.dataSource = self;
    _meunCollectView.contentSize = CGSizeMake(itemW * _itemArr.count, itemW);
    _meunCollectView.showsVerticalScrollIndicator = NO;
    _meunCollectView.showsHorizontalScrollIndicator = NO;
    _meunCollectView.backgroundColor = [UIColor clearColor];
    [_meunCollectView registerClass:[MSLItemView class] forCellWithReuseIdentifier:@"HomeMenuCell"];
    [self addSubview: _meunCollectView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _itemArr.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    // 导航
    MSLItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeMenuCell" forIndexPath:indexPath];

    cell.title.textColor = indexPath.item == _selectIndex ? HWColor(255, 247, 15) : [UIColor whiteColor];
    cell.title.text = _itemArr[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectIndex == indexPath.item) { return;  }
//
//    NSIndexPath *indexP =  _oldIndexPath ? _oldIndexPath : [NSIndexPath indexPathForItem:0 inSection:0];
//
//    MSLItemView *oldCell = (MSLItemView *)[collectionView cellForItemAtIndexPath:indexP];
//    oldCell.title.textColor = [UIColor whiteColor];
//
//    MSLItemView *cell = (MSLItemView *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.title.textColor = HWColor(255, 247, 15);
//
//    _oldIndexPath = indexPath;
//    _selectIndex = indexPath.item;

    _selectIndex = indexPath.item;
    [_meunCollectView reloadData];
    [self.delegate indexView:self.tag withSelectIndex:indexPath.item];
}

- (void)setItemArr:(NSArray *)itemArr {
    
    _itemArr = itemArr;
    
    [_meunCollectView reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    _selectIndex = selectIndex;
    
    [_meunCollectView reloadData];
}
@end
