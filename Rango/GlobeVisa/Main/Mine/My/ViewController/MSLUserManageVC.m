//
//  MSLUserManageVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/12/4.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLUserManageVC.h"
#import "JPUSHService.h"
#import "MSLLoginVC.h"
#import "MSLAddTelVC.h"
@interface MSLUserManageVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    BOOL _haveTel;  // 1 :  手机号denglu  0： 第三方登录
}

@property(nonatomic,strong)UIView * shaowLargeImage;
@property(nonatomic,strong)UIImageView * smallImageView;
@property(nonatomic,strong)UIImageView * imageVPic;
@property(nonatomic,strong)UILabel * label;
@end

@implementation MSLUserManageVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
//    if (self.tabBarController.selectedIndex == 0) {
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账号管理";
    NSString *name = TEL_VALUE;
    _haveTel = name.length > 1 ;
   
    [self createTab];
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_245;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 110)];
    head.backgroundColor = COLOR_245;
    
    _tableView.tableFooterView = [UIView new];
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0  ? 2 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1 && !_haveTel) { return 0; }
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userManagerLoginOut"];
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        la.text = @"退出登录";
        la.font = FONT_SIZE_13;
        la.textAlignment = NSTextAlignmentCenter;
        la.userInteractionEnabled = YES;
        [cell.contentView addSubview:la];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userManager"];
    cell.clipsToBounds = YES;
    cell.textLabel.text = indexPath.row == 0? @"绑定手机":@"更改密码";
    cell.textLabel.font = FONT_SIZE_13;
    
    if (indexPath.row == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, WIDTH, 0.5)];
        view.backgroundColor = COLOR_230;
        [cell.contentView addSubview:view];
    }
 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // 注销
    if (indexPath.section == 1) {
        [self showAlertView];
        return;
    }
    
    // 修改密码
    if (indexPath.row == 1) {
        MSLLoginVC *login = [[MSLLoginVC alloc] init];
        login.titleName = @"更改密码";
        login.viewType = 2;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }

    if (_haveTel) {
        
        MSLAddTelVC *vc = [[MSLAddTelVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    MSLLoginVC *login = [[MSLLoginVC alloc] init];
    login.titleName = @"绑定手机" ;
    login.viewType =  0 ;
    [self.navigationController pushViewController:login animated:YES];
}

- (void)showAlertView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要注销登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //token 有值   注销成功
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:NAME_KEY];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TEL_KEY];
        
        [JPUSHService setTags:nil aliasInbackground:@""];
        [CXUtils createAllTextHUB:@"您已成功退出"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:YES];

        });
//        [self lunchViewController:self withText:@"成功" withSure:YES];
    }];
    
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:^{ }];
}
//注销阴影层
-(void)lunchViewController:(UIViewController *)vc withText:(NSString *)title withSure:(BOOL)isSure {
    
    
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        //大一
        _shaowLargeImage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        
        _shaowLargeImage.backgroundColor = [UIColor grayColor];
        _shaowLargeImage.alpha = 0.2;
        [self.view addSubview:_shaowLargeImage];
        //大二
        _smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-115)/2, 247,115, 110)];
        //圆角
        _smallImageView.layer.cornerRadius = 10;
        _smallImageView.clipsToBounds = YES;
        
        _smallImageView.backgroundColor = [UIColor blackColor];
        _smallImageView.alpha = 0.8;
        
        [self.view addSubview:_smallImageView];
        
        _imageVPic = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-50)/2, 260, 50, 50)];
        [vc.view addSubview:_imageVPic];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 76, 115, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [_smallImageView addSubview:_label];
        
        _imageVPic.image = [UIImage imageNamed:isSure ? @"yes" : @"no"];
        
        if (title != nil) {
            
            _label.text = title;
        }
        
    } completion:^(BOOL finished) {
        
        [_shaowLargeImage removeFromSuperview];
        [_smallImageView removeFromSuperview];
        [_imageVPic removeFromSuperview];
        [_label removeFromSuperview];
        //用户登录成功 完成请求数据 开启其他线程 执行
        dispatch_async(dispatch_get_main_queue(),^
                       {
                           //更新界面
                           [self.navigationController popViewControllerAnimated:YES];
                           
                       });
    }];
}


@end
