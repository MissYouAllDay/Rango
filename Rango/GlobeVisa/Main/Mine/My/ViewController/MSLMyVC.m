//
//  MSLMyVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/26.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLMyVC.h"
#import "MSLLoginVC.h"
#import "MSLMyHeadView.h"
#import "MSLOrderModel.h"
#import "MSLOrderVC.h"
#import <UShareUI/UShareUI.h>

#import "MSLSendTypeVC.h"
#import "MSLPaySuccessVC.h"
#import "MSLUserManageVC.h"
#import "MSLMyContactVC.h"
#import "MSLContactModel.h"
@interface MSLMyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSArray *_titleArr;
    MSLMyHeadView *_tabHead;
    NSMutableArray *_orderDataArr;
    NSString *_orderStutes;//订单状态
    BOOL _haveOrder; // 是否有订单
    NSMutableArray *_dataArr; // 联系人数据
    
}

@end

@implementation MSLMyVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    NSLog(@"-----账户:%@\ntoken：%@",NAME_VALUE,TOKEN_VALUE);
    NSString *token = TOKEN_VALUE;
    if (token.length > 1) {
       
        [self loadData];
        [self loadContactData];
        _tabHead.name.text = NAME_VALUE;

    }else {
        
        _orderStutes = nil;
        _orderDataArr = nil;
        _tabHead.name.text = @"登录/注册";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleArr = @[@[@"我的订单"],@[@"申请人信息",@"账户管理"],@[@"分享给好友",@"联系客服"]];
    [self createTab];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    
    btn.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    
    _tabHead = [[[NSBundle mainBundle] loadNibNamed:@"MSLMyHeadView" owner:nil options:nil] lastObject];
    _tabHead.frame =  CGRectMake(0, 0, WIDTH, 145);
    _tableView.tableHeaderView = _tabHead;
    _tableView.backgroundColor = COLOR_245;
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 1 : 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view= [UIView new];
    view.backgroundColor = COLOR_245;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myZeroZero"];
        cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
        cell.textLabel.font = FONT_SIZE_13;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = _orderStutes;
        cell.detailTextLabel.textColor = HWColor(255, 84, 0);
        cell.detailTextLabel.font = FONT_SIZE_13;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myDefaCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myDefaCell"];
    }
    
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    cell.textLabel.font = FONT_SIZE_13;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)changeSendType:(UITapGestureRecognizer *)tap {
    
    MSLSendTypeVC *vc = [[MSLSendTypeVC alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // 分享
    if (indexPath.section == 2 && indexPath.row == 0) { [self shareToOtherAPP]; return;     }
    
    // 联系客服
    if (indexPath.section == 2 && indexPath.row == 1) { [CXUtils phoneAction:self];  return; }
    
    // 判断是否登录
    NSString *token = TOKEN_VALUE;
    if (token.length < 1) { [self push]; return; }
   
    // 我的订单
    if (indexPath.section == 0) {
        _haveOrder ?  [self pushOrderList] : [CXUtils createAllTextHUB:@"暂时没有订单"];
        return;
    }
    
    // 申请人信息
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        (_dataArr && _dataArr.count != 0) ? [self pushContactVC] : [CXUtils createAllTextHUB:@"您还没有添加联系人"];
        return;
    }

    //  账号管理
    if (indexPath.section == 1 && indexPath.row == 1) {  [self pushUserManageVC];  return;  }

}

// 登录
- (void)push {
    
    MSLLoginVC *vc = [[MSLLoginVC alloc] init];
    vc.titleName = @"登录";
    vc.viewType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

// 订单列表
- (void)pushOrderList {
    
    MSLOrderVC *vc = [[MSLOrderVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 申请人
- (void)pushContactVC {
    
    MSLMyContactVC *vc = [[MSLMyContactVC alloc] init];
    vc.dataArr = _dataArr;
    [self.navigationController pushViewController:vc animated:YES];
}

//  账号管理
- (void)pushUserManageVC {
    
    MSLUserManageVC *vc = [[MSLUserManageVC alloc] init];
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

#pragma mark - - - - - - - - - - 分享 - - - - - - - - - - -
- (void)shareToOtherAPP {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:SHARE_TITLE descr:SHARE_DETAIL thumImage:[UIImage imageNamed:@"logo1"]];
    //设置网页地址
    shareObject.webpageUrl = SHARE_URL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {}];
    }];
}

#pragma mark - - - - - - - - - -  获取订单数据 - - - - - - - - - - -
- (void)loadData {
    
    _orderDataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:ORDER_LIST_URL withParam:@{TOKEN_KEY:TOKEN_VALUE} withErrorCode:NO withHUD:YES success:^(id responseObjc) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
        
        if (![errorCode isEqualToString:@"0"]) {  return ; }
       
        _haveOrder = YES;

        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLOrderModel *model = [[MSLOrderModel alloc] initWithDictionary:dic];
            [_orderDataArr addObject:model];
            
            if ([model.order_status intValue] <= 7) {
                
                _orderStutes = @"您有未完成的订单";
            }
        }
        [_tableView reloadData];
    } failBlock:^(NSError *error) { }];
}

//联系人数据
- (void)loadContactData {

    _dataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:CONTACT_QUERY withParam:@{TOKEN_KEY:TOKEN_VALUE} withErrorCode:NO withHUD:YES success:^(id responseObjc) {
        
        NSArray *dataArr = responseObjc[@"result"];
        
        if (dataArr == nil || dataArr.count == 0 ) {
     
            _dataArr = nil;
            return ;
        }
        
        for (NSDictionary *dic in dataArr) {
            
            MSLContactModel *model = [[MSLContactModel alloc] initWithDictionary:dic];
            [_dataArr addObject:model];
        }

        
    } failBlock:^(NSError *error) { }];
}

@end
