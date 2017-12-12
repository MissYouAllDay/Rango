
//
//  MSLMarkViewController.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/8.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLMarkViewController.h"

@interface MSLMarkViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    UICollectionView *_collectionView;
    UITableView *_tableView;
}

@end

@implementation MSLMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectView];
}

- (void)createCollectView {
    
    UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 134 * WIDTH/375);
    layout.headerReferenceSize = CGSizeMake(WIDTH, 44);
    layout.footerReferenceSize = CGSizeMake(0, 0 );
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 45 - [CXUtils statueBarHeight] - 44) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"paySuccessItem"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"paySuccessHead"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"paySuccessFoot"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return section == 0 ? 10 : 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"paySuccessItem" forIndexPath:indexPath];
    
    cell.backgroundColor = ARCColor;
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {
        
        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"paySuccessFoot" forIndexPath:indexPath];
        
        foot.backgroundColor = COLOR_245;
        return foot;
    }
    
    UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"paySuccessHead" forIndexPath:indexPath];
    head.backgroundColor = COLOR_245;
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, head.widthCX - 10, head.heightCX)];
    la.backgroundColor = [UIColor whiteColor];
    la.text = [NSString stringWithFormat:@"%ld.你大爷的",indexPath.section];
    [head addSubview:la];
    return head;
}


@end
