//
//  MSLFoundVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/26.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLFoundVC.h"
#import "MSLHotTabCell.h"
#import "MSLFoundHeadView.h"
#import "MSLFoundCell.h"
#import "MSLPlatModel.h"

#import "MSLNounAnalyVC.h"
#import "MSLVisaConsultVC.h"
#import "MSLNewsVC.h"
#import "MSLNeedInfoVC.h"
#import "MSLPrivacyVC.h"
@interface MSLFoundVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSMutableArray *_hotArr;
    NSMutableArray *_platformArr;// 平台咨询
}

@end

@implementation MSLFoundVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"17080053635" forKey:TEL_KEY];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"百变蜥蜴";
    [self createTab];
    [self loadData];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 44 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_245;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 110)];
    head.backgroundColor = COLOR_245;
    
    MSLFoundHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"MSLFoundHeadView" owner:nil options:nil] lastObject];
    headView .frame = CGRectMake(0, 0, WIDTH, 100);
    
    [head addSubview:headView];
    _tableView.tableHeaderView = head;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushVisaQuestion)];
    [headView.firstImg addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushNounAnaly)];
    [headView.secondimg addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAboutOur)];
    [headView.threeImg addGestureRecognizer:tap3];
}

- (void)pushVisaQuestion {
    MSLVisaConsultVC *vc = [[MSLVisaConsultVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushNounAnaly{
    
    MSLNounAnalyVC *vc = [[MSLNounAnalyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushAboutOur {
    
    MSLPrivacyVC *vc = [[MSLPrivacyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _dataArr[section];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? 44 : WIDTH / 375 * 194;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *view = [UIView new];
    view.backgroundColor =  section == 0 ? COLOR_245 : [UIColor whiteColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH, 44)];
    la.text = section == 0 ? @"平台咨询" : @"热门推荐";
    la.font = FONT_SIZE_15;
    [bgView addSubview:la];
    bgView.backgroundColor = [UIColor whiteColor];
    return bgView;
}
#pragma mark - - - - - - - - - - c创建cell - - - - - - - - - - -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MSLFoundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foundCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLFoundCell" owner:nil options:nil] lastObject];
        }
        MSLPlatModel *model = _platformArr[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    MSLHotTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotTabCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLHotTabCell" owner:nil options:nil] lastObject];
    }
    MSLProductModel *model =_hotArr[indexPath.row];
    cell.proModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MSLNewsVC *vc = [[MSLNewsVC alloc] init];
        vc.model = _dataArr[0][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        MSLNeedInfoVC *vc = [[MSLNeedInfoVC alloc] init];
        vc.merModel = _dataArr[1][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}
#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -
//  创建群组
- (void)loadData{
    
    [CXUtils createHUB];
    
    dispatch_group_t group =dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{ [self loadPlatform:group]; });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{  [self loadHotData:group]; });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        _dataArr = [[NSMutableArray alloc] init];
        [_dataArr addObject:_platformArr];
        [_dataArr addObject:_hotArr];
        [_tableView reloadData];
        [CXUtils hideHUD];

    });
}

// 热门
- (void)loadHotData:(dispatch_group_t)group  {
    
    _hotArr = nil;
    _hotArr = [[NSMutableArray alloc] init];
    [NetWorking getRequest:HOT_URL withParam:@{APP_COMPANY_ID:APP_COMPANY_IDNUM} success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLProductModel *model = [[MSLProductModel alloc] initWithDictionary:dic];
            [_hotArr addObject:model];
        }
        dispatch_group_leave(group);
        
    } failBlock:^(NSError *error) {  dispatch_group_leave(group); }];
}

- (void)loadPlatform:(dispatch_group_t)group {
    
//    http://139.196.136.150:8080/VisaInterface/app/index/informationList?app_company_id=2
    _platformArr = nil;
    _platformArr = [[NSMutableArray alloc] init];
    [NetWorking getRequest:PLATFORM_URL withParam:@{APP_COMPANY_ID:APP_COMPANY_IDNUM} success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLPlatModel *model = [[MSLPlatModel alloc] initWithDictionary:dic];
            [_platformArr addObject:model];
        }
        dispatch_group_leave(group);
        
    } failBlock:^(NSError *error) {  dispatch_group_leave(group); }];
}

@end
