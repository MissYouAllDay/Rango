//
//  MSLOrderVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/7.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLOrderVC.h"
#import "MSLOrderListCell.h"
#import "MSLUpInfoDataVC.h"
#import "MSLUpInfoDataVC.h"
#import "MSLPayVC.h"
#import "MSLSendTypeVC.h"

#import "MSLPaySuccessVC.h"
#import "MSLVisaFormVC.h"
@interface MSLOrderVC ()<UITableViewDelegate,UITableViewDataSource,CXMSLSendTypeDelegate>
{
    UITableView *_tableView;
}

@end

@implementation MSLOrderVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单管理";
    [self createTab];
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_245;
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}
#pragma mark - - - - - - - - - - 创建cell - - - - - - - - - - -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MSLOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myOrderCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLOrderListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataArr[indexPath.section];
    cell.contineBtn.tag = 3000 + indexPath.section;
    cell.cancelBtn.tag = 4000 + indexPath.section;
    cell.sendType.tag = 5000 + indexPath.section;
    [cell.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contineBtn addTarget:self action:@selector(contineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSendType:)];
    [cell.sendType addGestureRecognizer:tap];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - - - - - - - - - - 寄送方式 - - - - - - - - - - -
- (void)changeSendType:(UITapGestureRecognizer *)tap {
    
    MSLSendTypeVC *vc = [[MSLSendTypeVC alloc] init];
    vc.delegate = self;
    vc.index = tap.view.tag - 5000;
    MSLOrderModel *model = _dataArr[tap.view.tag - 5000];
    vc.orderID = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendType:(NSString *)type withIndex:(NSInteger)index {
    
    MSLOrderModel *model = _dataArr[index];
    model.file_mail_type = type;
    _dataArr[index] = model;

    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:index]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - - - - - - - - - - 继续 - - - - - - - - - - -
- (void)contineBtnAction:(UIButton *)sender {

    NSInteger index = sender.tag - 3000;
    MSLOrderListCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    MSLOrderModel *model = _dataArr[index];
    if (cell.cancelBtn.hidden == YES) {
        [self showAlert:@"\n您是否要删除订单!" withDelegate:YES withModel:model withIndex:index];
        return;
    }
    NSString *status = [NSString stringWithFormat:@"%@",model.order_status];

    // 订单：上传资料--支付--寄送材料--审核并送签--办理中（申请成功/申请失败）
    // 0  - 0.5：上传资料  1:支付  2：寄送材料  3-4-5：审核并送签  6-7-8 办理中  9：签证成功   大与9 失败
    // evus  2----8  办理中
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",model.photo_format] forKey:PHOTO_FORMEAT];

    if ([status isEqualToString:@"0"]) {
        
        [self pushUpInfoVC:model];
        return;
    }
    if ([status isEqualToString:@"0.5"] ) {
        [self pushVisaForm:model];
    }
    
    if ([status isEqualToString:@"1"] ) {
        [self pushPayVC:model];
    }
}

// HTML
- (void)pushVisaForm:(MSLOrderModel *)model {
    
    MSLVisaFormVC *vc = [[MSLVisaFormVC alloc] init];
    vc.contactID = model.contact_id;
    vc.orderID = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}

// 上传资料
- (void)pushUpInfoVC:(MSLOrderModel *)model {
    
    MSLUpInfoDataVC *vc = [[MSLUpInfoDataVC alloc] init];
    vc.orderID = model.order_id;
    vc.contactID = model.contact_id;
    [self.navigationController pushViewController:vc animated:YES];
}

// 支付
- (void)pushPayVC:(MSLOrderModel *)model {
    
    MSLPayVC *vc = [[MSLPayVC alloc] init];
    vc.orderID = model.order_id;
    vc.contactID = model.contact_id;
    [self.navigationController pushViewController:vc animated:YES];
}

// 取消
- (void)cancelBtnAction:(UIButton *)sender {
    NSInteger index = sender.tag - 4000;
    MSLOrderModel *model = _dataArr[index];
    [self showAlert:@"\n您是否要取消订单!" withDelegate:NO withModel:model withIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    MSLOrderModel *model = _dataArr[indexPath.row];
    MSLUpInfoDataVC *vc = [[MSLUpInfoDataVC alloc] init];
    vc.orderID = model.order_id;
    vc.contactID = model.contact_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - - - - - - - - - - 取消订单 - - - - - - - - - - -
- (void)cancelOrder:(MSLOrderModel *)model withIndex:(NSInteger)index{
    
    [NetWorking postHUDRequest:CANCEL_ORDER_URL withParam:@{@"order_id":model.order_id} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [_dataArr removeObjectAtIndex:index];
        [_tableView reloadData];
        
    } failBlock:^(NSError *error) { }];
}

#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -
- (void)loadData {
    
    _dataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:ORDER_LIST_URL withParam:@{TOKEN_KEY:TOKEN_VALUE} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLOrderModel *model = [[MSLOrderModel alloc] initWithDictionary:dic];
            [_dataArr addObject:model];
        }
        //http://139.196.136.150:8080/VisaInterface/app/japan/japan.html?order_id=79530&token=1b1f6a31cdc7f8412dcbe64a1aafbd990d1c58d7
        [_tableView reloadData];
        
    } failBlock:^(NSError *error) { }];
}

- (void)showAlert:(NSString *)message withDelegate:(BOOL)delegate withModel:(MSLOrderModel *)model withIndex:(NSInteger)index{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂时收监" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"午时抄斩" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self cancelOrder:model withIndex:index];
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:^{ }];
}

@end
