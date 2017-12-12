//
//  MSLChangeInfoVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLChangeInfoVC.h"
#import "MSLOrderDatumModel.h"

#import "MSLIDCardVC.h"
#import "PassportViewController.h"
#import "MSLVisaPhotoVC.h"
#import "MSLHuKouBenVC.h"
#import "MSLSinglePictureVC.h"
@interface MSLChangeInfoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSString *_orderID;
    NSMutableArray *_dataArr; // 数据
    NSArray *_keyArr;   // @【@【order_datum_id，order_datum_id，order_datum_id】，@【】】
    
}

@end

@implementation MSLChangeInfoVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.tabBarController.selectedIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请人信息";
    
    [self createTab];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ContactReLoadData" object:nil];
    
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_245;
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 110)];
    head.backgroundColor = COLOR_245;
    
    _tableView.tableFooterView = [UIView new];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyContactCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyContactCell"];
        cell.textLabel.font = FONT_SIZE_13;
        cell.detailTextLabel.font = FONT_SIZE_13;
    }
    NSArray *arr = _dataArr[indexPath.row];
    MSLOrderDatumModel *model = arr[0];
    cell.textLabel.text = model.visa_datum_name;
    cell.detailTextLabel.text = [model.attachment_id integerValue] == 0 ? @"未完成" : @"已完成";
    cell.detailTextLabel.textColor = [model.attachment_id integerValue] == 0 ? HWColor(255, 84, 0) : COLOR_52;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = _dataArr[indexPath.row];
    MSLOrderDatumModel *model = arr[0];
    switch ([model.visa_datum_type intValue]) {
        case 1: [self pushIDCardVC:model withImageArr:arr]; break;
        case 2: [self pushPassportVC:model withImageArr:arr];break;
        case 4: [self pushSinglePic:model];break;
        case 5: [self pushHuKouBenVC:model withImageArr:arr]; break;
        default: break;
    }
}

- (void)pushIDCardVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    MSLIDCardVC *vc = [[MSLIDCardVC alloc] init];
    vc.contactID = _contactID;
    vc.imageArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushPassportVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    PassportViewController *pass = [[PassportViewController alloc] init];
    pass.contactID = _contactID;
    pass.datumModel = model;
    [self.navigationController pushViewController:pass animated:YES];
}

- (void)pushHuKouBenVC:(MSLOrderDatumModel *)model withImageArr:(NSArray *)arr{
    MSLHuKouBenVC *vc = [[MSLHuKouBenVC alloc] init];
    vc.contactID = _contactID;
    vc.accBookArr = arr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSinglePic:(MSLOrderDatumModel *)model{
    MSLSinglePictureVC *vc = [[MSLSinglePictureVC alloc] init];
    vc.contactChange = YES;
    vc.contactID = _contactID;
    vc.datumModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


//tableView的代理方法
-  (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -
- (void)loadData {
    
    _dataArr = [[NSMutableArray alloc] init];
    
    [NetWorking getHUDRequest:CONTACT_INFO_URL withParam:@{@"contact_id":_contactID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        for (NSDictionary *dic in result) {
            
            MSLOrderDatumModel *model = [[MSLOrderDatumModel alloc] initWithDictionary:dic];
            if ([model.visa_datum_type intValue] == 11) { continue; }
            dataDic = [self changeDataWithType: dataDic withModel:model];
        }
        
        for (NSString *key in dataDic) { [_dataArr addObject:dataDic[key]]; }
        
        [_tableView reloadData];
        
    } failBlock:^(NSError *error) {  }];
    
}

// 整理不同的数据放入不同的字典中
- (NSMutableDictionary *)changeDataWithType:(NSMutableDictionary *)param withModel:(MSLOrderDatumModel *)model {
    
    if ([[param allKeys] containsObject:[NSString stringWithFormat:@"%@",model.visa_datum_id]]) {
        
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithArray:param[[NSString stringWithFormat:@"%@",model.visa_datum_id]]];
        [modelArr addObject:model];
        param[[NSString stringWithFormat:@"%@",model.visa_datum_id]] = modelArr;
    }else {
        
        [param setObject:@[model] forKey:[NSString stringWithFormat:@"%@",model.visa_datum_id]];
    }
    return param;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
