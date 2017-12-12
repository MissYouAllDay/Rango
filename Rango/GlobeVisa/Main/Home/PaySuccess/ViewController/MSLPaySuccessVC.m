//
//  MSLPaySuccessVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/23.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLPaySuccessVC.h"
#import "MSLPaySuccessItem.h"
#import "MSLSendTypeView.h"
#import "MSLPaySuccessHead.h"

#import "MSLAreaVC.h"
@interface MSLPaySuccessVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
    UICollectionView *_collectionView;
    UIButton *_nextBtn;
    MSLSendTypeView *_sendType;
}

@end

@implementation MSLPaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";
    [self createCollectView];
    [self createNextBtn];
    [self loadData];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)createCollectView {
    
    UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((WIDTH - 30)/2, 134 * WIDTH/375);
    layout.headerReferenceSize = CGSizeMake(WIDTH, 517);
    layout.footerReferenceSize = CGSizeMake(0, 0 );
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 45 - [CXUtils statueBarHeight] - 44) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MSLPaySuccessItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"paySuccessItem"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"paySuccessHead"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"paySuccessFoot"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLPaySuccessItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"paySuccessItem" forIndexPath:indexPath];

    MSLCountryModel *model = _dataArr[indexPath.row];
    cell.name.text = model.rm_url;
    [cell.visaImg sd_setImageWithURL:[NSURL URLWithString:model.rm_img_url] placeholderImage:[UIImage imageNamed:@"pay_fail"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLAreaVC *vc = [[MSLAreaVC alloc] init];
    vc.countryModel = _dataArr[indexPath.row];
    vc.locaName = _localName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionFooter) {

        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"paySuccessFoot" forIndexPath:indexPath];

        foot.backgroundColor = COLOR_245;
        return foot;
    }
    
    UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"paySuccessHead" forIndexPath:indexPath];
    head.backgroundColor = COLOR_245;
    
    MSLPaySuccessHead *succHead = [[[NSBundle mainBundle] loadNibNamed:@"MSLPaySuccessHead" owner:nil options:nil] lastObject];
    _sendType = [[[NSBundle mainBundle] loadNibNamed:@"MSLSendTypeView" owner:nil options:nil] lastObject];
    
    succHead.frame = CGRectMake(0, 0, WIDTH, 220);
    _sendType.frame = CGRectMake(0, succHead.bottomCX, WIDTH, 247);
    
    [head addSubview:succHead];
    [head addSubview:_sendType];
    
    UILabel *headLa = [[UILabel alloc] initWithFrame:CGRectMake(15, _sendType.bottomCX + 10, WIDTH, 40)];
    headLa.text = @"您只需补充极少资料就可以办理以下签证";
    headLa.font = FONT_SIZE_15;
    [head addSubview:headLa];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, WIDTH - 40, 40, headLa.heightCX)];
    head.backgroundColor = [UIColor whiteColor];
    
    return head;
}

#pragma mark - - - - - - - - - -  下一步 - - - - - - - - - - -
- (void)createNextBtn {
    
    _nextBtn = [super createDownNextBtn];
    [_nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}
- (void)nextBtnAction:(UIButton *)sender {
    
    if (_sendType.index == 2 && _sendType.address.length == 0) {
        
        [CXUtils createAllTextHUB:@"请填写您的详细地址"];
        return;
    }
    if (_sendType.index == 3 && _sendType.address.length == 0 ){
        
        [CXUtils createAllTextHUB:@"请选择银行网点"];
        return;
    }
    NSDictionary *param = @{@"file_mail_type":[NSString stringWithFormat:@"%ld",_sendType.index],@"mail_address":_sendType.address,@"token":TOKEN_VALUE,@"order_id":_orderID};
    [NetWorking postHUDRequest:URL_ORDER_UPDATE withParam:param withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failBlock:^(NSError *error) {}];
}

#pragma mark - - - - - - - - - - 获取数据 - - - - - - - - - - -
- (void)loadData {
    
    _dataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:PAYEND_URL withParam:@{@"order_id":_orderID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLCountryModel *model = [[MSLCountryModel alloc] initWithDictionary:dic];
            [_dataArr addObject:model];
        }
        [_collectionView reloadData];
    } failBlock:^(NSError *error) { }];
}

@end
