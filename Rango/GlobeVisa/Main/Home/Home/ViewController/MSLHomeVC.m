//
//  MSLHomeVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/26.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLHomeVC.h"
#import "SDCycleScrollView.h"
#import "MSLIndexView.h"
#import "MSLHotTabCell.h"

#import "MSLBannerModel.h"
#import "MSLProductModel.h"
#import "MSLCountryModel.h"

#import "FSBaseViewController.h"
@interface MSLHomeVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,CXIndexViewDelegate>
{
    
    MSLIndexView *_indexView;       //   索引
    
    NSMutableArray *_bannerArr;      // banner 数据
    
    NSMutableArray *_hotArr;             // 热门 数据
    
    NSMutableArray *_countryListArr;     // 国家列表 数据
    NSMutableArray *_continentArr;        // 洲  的名称集合
    
    NSInteger _selectIndex;         // 洲  点击的位置
    
    double _oldHeight;          // 记录以前的foot高度
    double _newHeight;          // 记录将要展示的foot的高度
}
@property (nonatomic, strong) UITableView *tableView; // 整体 Tab
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView; // 轮播图
@property (nonatomic, strong) UITableView *mainTab;     // 顶层tab
@property (nonatomic, assign) CGFloat headHeight;       // banner的高度
@property (nonatomic, strong) UIView *bgView;           // 搜索框底层视图
@property (nonatomic, strong) UIView *navigationbar;    // navigationBar

@property (nonatomic, strong) MSLIndexView *navigationIndexView;

@property (nonatomic,strong) UIScrollView *scrollView;      // 整体的

@property (nonatomic, strong) UITableView *markTab;     // 替代品


@end

@implementation MSLHomeVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, WIDTH, 200);
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (_bannerArr.count == 0 || _hotArr.count == 0 || _countryListArr.count == 0  ) {
        
        [self loadData];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectIndex = 0;
    _headHeight = 515;
    
    [self createScrollerView];
    [self createTab];
    
//    _navigationIndexView = [[MSLIndexView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, 37)];
//    _navigationIndexView.delegate = self;
//
//    [self createTab];
//    _navigationbar = [self createBgView];
//
//    _navigationbar.frame = CGRectMake(0, [super statueBarHeight], WIDTH, 97);
//    _navigationbar.hidden = YES;
//
//
//    _navigationIndexView.tag = 1100;
//    [_navigationbar addSubview:_navigationIndexView];
//    [self.view addSubview:_navigationbar];
    
  
}

- (void)createScrollerView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49)];
    
    [_scrollView addSubview:self.cycleScrollView];

    _scrollView.tag = 1002;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - 49 + _headHeight - 97);
    
}

- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headHeight - 97, WIDTH, HEIGHT - 49) ];
    
    if ([super statueBarHeight] != 20) { _tableView.heightCX = HEIGHT - 49 - [super statueBarHeight]; }
    
    _tableView.tag = 1000;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
//    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_tableView];
    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 97)];

}

#pragma mark - - - - - - - - - - 索引代理 - - - - - - - - - - -
- (void)indexView:(NSInteger)tag withSelectIndex:(NSInteger)inidex {

    tag == 1100 ? (_indexView.selectIndex = inidex) : (_navigationIndexView.selectIndex = inidex);

    _selectIndex = inidex;
    
    CGFloat hei = 0;
    if (inidex == 0) {
        
        hei = _hotArr.count * (WIDTH / 375 * 194);
    }else {
        
        NSArray *arr = _countryListArr[inidex - 1];
        hei = arr.count * (WIDTH / 375 * 194);
    }
    
    _tableView.heightCX = hei + 97;
    _scrollView.contentSize = CGSizeMake(WIDTH, hei + _headHeight);
    
//    CGFloat statueH = [super statueBarHeight];
//    NSArray *arr = inidex == 0 ? _hotArr : _countryListArr[inidex - 1];
//
//    if ((WIDTH / 375 * 194) * arr.count < HEIGHT - 97  - 49) {
//
//        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.1)];
//        foot.heightCX = HEIGHT - 97 - (WIDTH / 375 * 194) * arr.count - 49 - statueH;
//
//        _newHeight = HEIGHT - 97 - (WIDTH / 375 * 194) * arr.count - 49 - statueH;
//
//        _tableView.tableFooterView = foot;
//    }else {
//
//        _tableView.tableFooterView = [UIView new];
//        [_tableView scrollsToTop];
//    }

    [_tableView reloadData];

}

#pragma mark - - - - - - - - - - UITableViewDataSource - - - - - - - - - - -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_countryListArr.count > 0) {
        
        if (_selectIndex == 0) { return _hotArr.count; }
        
        NSArray *arr = _countryListArr[_selectIndex - 1];
        return arr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (tableView.tag == 1000) {
    
    MSLHotTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeBackCell"];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLHotTabCell" owner:nil options:nil] firstObject];
    }
    
    if (_selectIndex == 0) {
        
        cell.proModel = _hotArr[indexPath.item];
    }else {
        cell.counModel = _countryListArr[_selectIndex - 1][indexPath.item];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSBaseViewController *vc = [[FSBaseViewController alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WIDTH / 375 * 194;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 97;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    _bgView = [self createBgView];
    _bgView.frame = CGRectMake(0, 0, WIDTH, 97);
    
    _indexView = [MSLIndexView shareIndexView];
    _indexView.delegate = self;
    _indexView.tag = 1101;
    
    [_bgView addSubview:_indexView];
    
    return _bgView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 1000) {
        if (scrollView.contentOffset.y <= _headHeight - 97) {
            
            _scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            
        }
    }
    
    
    return;
    if (scrollView.tag == 1000) {
        
        if (scrollView.contentOffset.y <= _headHeight - 97 - [super statueBarHeight] - 10) {
            
            _tableView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
            _navigationbar.hidden = YES;
//            [self.navigationController setNavigationBarHidden:YES animated:NO];
            self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            
            UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                statusBar.backgroundColor = [UIColor clearColor];
            }
            
            if (scrollView.contentOffset.y <= 5 ) {
                
                _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                
            }else {
                
                _bgView.backgroundColor = RGBColor(20, 30, 71, 0.8);
            }
       
        }else {
            
            _navigationbar.hidden = NO;
            UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                statusBar.backgroundColor = HWColor(20, 30, 71);
            }
            _bgView.backgroundColor = HWColor(20, 30, 71);
            _navigationbar.backgroundColor = HWColor(20, 30, 71);

        }
    }
}

#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -
// 数据整理
- (void)markData {
    
    [CXUtils hideHUD];
    
    if (_bannerArr.count != 0 && _hotArr.count != 0 && _countryListArr.count != 0  ) {
        
        NSMutableArray *imageArr = [[NSMutableArray alloc] init];
        for (MSLBannerModel *model in _bannerArr) { [imageArr addObject:model.img_url]; }
        
        self.cycleScrollView.imageURLStringsGroup = imageArr;
        self.cycleScrollView.autoScroll = YES;
        
        if (_continentArr.count != 0) {
            [_continentArr insertObject:@"热门" atIndex:0];
            _indexView.itemArr = _continentArr;
            _navigationIndexView.itemArr = _continentArr;
        }
        
        CGFloat hei = _hotArr.count * (WIDTH / 375 * 194);
        _tableView.heightCX = hei + 97;
        _scrollView.contentSize = CGSizeMake(WIDTH, hei + _headHeight);
        [_tableView reloadData];
        
    }else {
        
        [CXUtils createAllTextHUB:@"请检查网络连接"];
    }
}

//  创建群组
- (void)loadData{
    
    [CXUtils createHUB];
    
    dispatch_group_t group =dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{ [self loadBannerData:group]; });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{  [self loadHotData:group]; });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{ [self loadCountryData:group]; });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self markData];
    });
}

// 轮播图
- (void)loadBannerData:(dispatch_group_t)group {
    
    _bannerArr = nil;
    _bannerArr = [[NSMutableArray alloc] init];
    [NetWorking getRequest:BANNER_URL withParam:@{APP_COMPANY_ID:APP_COMPANY_IDNUM} success:^(id responseObjc) {
        
        NSLog(@"你大爷的1");
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLBannerModel *model = [[MSLBannerModel alloc] initWithDictionary:dic];
            [_bannerArr addObject:model];
        }
        dispatch_group_leave(group);
        
    } failBlock:^(NSError *error) {  dispatch_group_leave(group); }];
}

// 热门
- (void)loadHotData:(dispatch_group_t)group  {
    
    _hotArr = nil;
    _hotArr = [[NSMutableArray alloc] init];
    [NetWorking getRequest:HOT_URL withParam:@{APP_COMPANY_ID:APP_COMPANY_IDNUM} success:^(id responseObjc) {
        
        NSLog(@"你大爷的2");
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLProductModel *model = [[MSLProductModel alloc] initWithDictionary:dic];
            [_hotArr addObject:model];
        }
        dispatch_group_leave(group);
        
    } failBlock:^(NSError *error) {  dispatch_group_leave(group); }];
}

// 国家
- (void)loadCountryData:(dispatch_group_t)group  {
    
    _continentArr = nil;
    _countryListArr = nil;
    _continentArr = [[NSMutableArray alloc] init];
    _countryListArr = [[NSMutableArray alloc] init];
    
    [NetWorking getRequest:COUNTRYLIST_URL withParam:nil success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            NSArray *datumList = dic[@"datumList"];
            NSMutableArray *data = [[NSMutableArray alloc] init];
            for (NSDictionary *diction in datumList) {
                
                MSLCountryModel *model = [[MSLCountryModel alloc] initWithDictionary:diction];
                [data addObject:model];
            }
            [_countryListArr addObject:data];
            [_continentArr addObject:dic[@"REGION_NAME"]];
        }
        dispatch_group_leave(group);
        
    } failBlock:^(NSError *error) {  dispatch_group_leave(group); }];
}
#pragma mark - - - - - - - - - - 初始化 - - - - - - - - - - -
// 轮播图
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, _headHeight) shouldInfiniteLoop:YES imageNamesGroup:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"fail"];
    }
    return _cycleScrollView;
}

- (UIView *)createBgView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 97)];
    
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 12, WIDTH - 20, 37);
    [searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索您想要办理的国家名称" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = FONT_SIZE_14;
    
    CGFloat imageW = CGRectGetWidth(searchBtn.imageView.frame);
    CGFloat titleW = CGRectGetWidth(searchBtn.titleLabel.frame);
    
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, searchBtn.widthCX - imageW - 20);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0 , imageW, 0, searchBtn.widthCX - 20 - imageW - titleW - 10 );
    
    [searchBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
    searchBtn.layer.cornerRadius = searchBtn.heightCX/2;
    searchBtn.clipsToBounds = YES;
    [bgView addSubview:searchBtn];

    return bgView;
}

- (UIView *)createNavigationBarIndexView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 97)];
    
    bgView.backgroundColor = HWColor(20, 30, 71);
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 12, WIDTH - 20, 37);
    [searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索您想要办理的国家名称" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = FONT_SIZE_14;
    
    CGFloat imageW = CGRectGetWidth(searchBtn.imageView.frame);
    CGFloat titleW = CGRectGetWidth(searchBtn.titleLabel.frame);
    
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, searchBtn.widthCX - imageW - 20);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0 , imageW, 0, searchBtn.widthCX - 20 - imageW - titleW - 10 );
    
    [searchBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.1]];
    searchBtn.layer.cornerRadius = searchBtn.heightCX/2;
    searchBtn.clipsToBounds = YES;
    [bgView addSubview:searchBtn];
    

    
    return bgView;
}


@end

