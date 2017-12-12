
//
//  MSLUpInfoDataVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/6.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLUpInfoDataVC.h"
#import "MSLUpInfoDataHeadView.h"
#import "MSLUpInfoDataTabCell.h"

#import "MSLIDCardVC.h"
#import "PassportViewController.h"
#import "MSLVisaPhotoVC.h"
#import "MSLHuKouBenVC.h"
#import "MSLSinglePictureVC.h"
#import "MSLVisaFormVC.h"

#import "MSLHuKouVC.h"
@interface MSLUpInfoDataVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableView;
    MSLUpInfoDataHeadView *_tabHead;
    UIButton *_nextBtn; //下一步
    
    NSMutableArray *_dataArr; // 数据
    NSArray *_keyArr;   // @【@【order_datum_id，order_datum_id，order_datum_id】，@【】】
}
@end

@implementation MSLUpInfoDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料上传";
    [self createTab];
    [self createNextBtn];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"UpInfoReLoadData" object:nil];
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 45 - [CXUtils statueBarHeight] - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    _tabHead = [[[NSBundle mainBundle] loadNibNamed:@"MSLUpInfoDataHeadView" owner:nil options:nil] lastObject];
    _tabHead.frame =  CGRectMake(0, 0, WIDTH, 165);
    _tableView.tableHeaderView = _tabHead;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (void)createNextBtn {
    _nextBtn = [super createDownNextBtn];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}

// 下一步
- (void)nextBtnAction:(UIButton *)sender {
     
    [NetWorking postHUDRequest:UPINFO_URL  withParam:@{@"order_id":_orderID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
      
        MSLVisaFormVC *vc = [[MSLVisaFormVC alloc] init];
        vc.contactID = _contactID;
        vc.orderID = _orderID;
        [self.navigationController pushViewController:vc animated:YES];

    } failBlock:^(NSError *error) { }];
}

#pragma mark - - - - - - - - - - UITableViewDelegate - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = _dataArr[section];
    return dic.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

#pragma mark - - - - - - - - - - 创建头视图 足视图 - - - - - - - - - - -
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = FONT_SIZE_14;
    if (_dataArr.count == 0 || _dataArr == nil) { return title; }
    
    NSDictionary *dic = _dataArr[section];
    for (NSString *key in dic) {
        
        NSArray *arr = dic[key];
        MSLOrderDatumModel *model = arr[0];
        title.text = [model.is_must intValue] == 1 ? @"必备资料" : @"其他资料";
        return title;
    }
    return title;
}

#pragma mark - - - - - - - - - - 创建cell - - - - - - - - - - -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MSLUpInfoDataTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myDefaCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLUpInfoDataTabCell" owner:nil options:nil] lastObject];
    }
    if (_dataArr.count != 0 || _dataArr != nil) {
       
        NSDictionary *visaName = _dataArr[indexPath.section];
        NSArray *keyArr = _keyArr[indexPath.section];
        NSArray *arr = visaName[keyArr[indexPath.row]];
        MSLOrderDatumModel *model = arr[0];
        cell.titler.text = model.visa_datum_name;
        model.path_name.length > 1 ? [cell didUpData] : [cell shouldUpData];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *visaName = _dataArr[indexPath.section];
    NSArray *keyArr = _keyArr[indexPath.section];
    NSArray *arr = visaName[keyArr[indexPath.row]];
    MSLOrderDatumModel *model = arr[0];
    
    switch ([model.visa_datum_type intValue]) {
        case 1: [self pushIDCardVC:model withImageArr:arr]; break;
        case 2: [self pushPassportVC:model withImageArr:arr];break;
        case 3: [self pushVisaPhotoVC:model withImageArr:arr]; break;
        case 4: [self pushSinglePic:model];break;
        case 5: [self pushHuKouBenVC:model withImageArr:arr]; break;

        default: break;
    }
}

- (void)pushIDCardVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    MSLIDCardVC *vc = [[MSLIDCardVC alloc] init];
    vc.contactID = _contactID;
    vc.orderID = _orderID;
    vc.imageArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushPassportVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    PassportViewController *pass = [[PassportViewController alloc] init];
    pass.contactID = _contactID;
    pass.orderID = _orderID;
    pass.datumModel = model;
    [self.navigationController pushViewController:pass animated:YES];
}
- (void)pushVisaPhotoVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    MSLVisaPhotoVC *vc = [[MSLVisaPhotoVC alloc] init];
    vc.contactID = _contactID;
    vc.orderID = _orderID;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushHuKouBenVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    MSLHuKouVC *vc = [[MSLHuKouVC alloc] init];
    vc.contactID = _contactID;
    vc.orderID = _orderID;
    vc.accBookArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
//    MSLHuKouBenVC *vc = [[MSLHuKouBenVC alloc] init];
//    vc.contactID = _contactID;
//    vc.orderID = _orderID;
//    vc.accBookArr = arr;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSinglePic:(MSLOrderDatumModel *)model{
    MSLSinglePictureVC *vc = [[MSLSinglePictureVC alloc] init];
    vc.contactID = _contactID;
    vc.orderID = _orderID;
    vc.datumModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -
- (void)loadData {
    
    _dataArr = nil;
    _dataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:ORDERDATUM_URL withParam:@{@"order_id":_orderID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        NSMutableDictionary *isMust = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *optional = [[NSMutableDictionary alloc] init];

        // 数据整理
        /* @[
         @{"88115":@[model,model1],@[model], "88116":@[model]},
         @{"88115":@[model,model1],@[model],"88116":@[model]}]
         */
        NSMutableSet *isMustKeySet = [[NSMutableSet alloc] init];
        NSMutableSet *optionalKeySet = [[NSMutableSet alloc] init];

        for (NSDictionary *dic in result) {
       
            MSLOrderDatumModel *model = [[MSLOrderDatumModel alloc] initWithDictionary:dic];
            if ([model.visa_datum_type intValue] == 11) { continue; }
            
            if ([model.is_must intValue] == 1) {
                isMust = [self changeDataWithType: isMust withModel:model];
                [isMustKeySet addObject:[NSString stringWithFormat:@"%@",model.order_datum_id]];
            }else {
                optional = [self changeDataWithType: optional withModel:model];
                [optionalKeySet addObject:[NSString stringWithFormat:@"%@",model.order_datum_id]];
            }
        }
        if (isMust.count != 0) { [_dataArr addObject:isMust]; }
        if (optional.count != 0) { [_dataArr addObject:optional]; }
        
        _keyArr = @[[isMustKeySet allObjects],[optional allKeys]];
        _tabHead.slideValue = [NSString stringWithFormat:@"%@",responseObjc[@"percent"]];
        [_tableView reloadData];
        [_nextBtn setBackgroundColor:[responseObjc[@"percent"] intValue] == 100 ? COLOR_BUTTON_BLUE : [UIColor grayColor]];
        
        if ([responseObjc[@"percent"] intValue] == 100) {
            [_nextBtn setBackgroundColor:COLOR_BUTTON_BLUE];
//            _nextBtn.userInteractionEnabled = YES;
        }else {
            [_nextBtn setBackgroundColor:[UIColor grayColor]];
//            _nextBtn.userInteractionEnabled = NO;
        }

    } failBlock:^(NSError *error) { }];
}
// 整理不同的数据放入不同的字典中
- (NSMutableDictionary *)changeDataWithType:(NSMutableDictionary *)param withModel:(MSLOrderDatumModel *)model {
    
    if ([[param allKeys] containsObject:[NSString stringWithFormat:@"%@",model.order_datum_id]]) {
        
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithArray:param[[NSString stringWithFormat:@"%@",model.order_datum_id]]];
        [modelArr addObject:model];
        param[[NSString stringWithFormat:@"%@",model.order_datum_id]] = modelArr;
    }else {
        
        [param setObject:@[model] forKey:[NSString stringWithFormat:@"%@",model.order_datum_id]];
    }
    return param;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
