//
//  FSBaseViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSBaseTableView.h"
//#import "FSBaseTopTableViewCell.h"
//#import "FSBaselineTableViewCell.h"
#import "FSScrollContentView.h"
#import "FSScrollContentViewController.h"
#import "FSBottomTableViewCell.h"
#import "AppDelegate.h"

#import "MSLBannerModel.h"
#import "MSLProductModel.h"
#import "MSLCountryModel.h"
#import "SDCycleScrollView.h"

#import "MSLAreaVC.h"
#import "MSLNeedInfoVC.h"
#import "CountrySearchVC.h"
@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate,SDCycleScrollViewDelegate,CLLocationManagerDelegate>

{
    NSMutableArray *_bannerArr;      // banner 数据
    
    NSMutableArray *_hotArr;             // 热门 数据
    
    NSMutableArray *_countryListArr;     // 国家列表 数据
    NSMutableArray *_continentArr;        // 洲  的名称集合
    
    CGFloat _headHeight;
    
    UIColor *starColor;     // 状态栏的颜色
}
@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView; // 轮播图

@property (nonatomic, strong) UIView *bgView;           // 搜索框底层视图
@property (nonatomic, strong) UIView *colorView;        // 搜索框底层 颜色 变换 视图
@property (nonatomic, strong) FSScrollContentViewController *scrollView;
@property(nonatomic,strong)CLLocationManager * locationManager; //定位


@end

@implementation FSBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

        statusBar.backgroundColor = starColor;
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (_bannerArr.count == 0 || _hotArr.count == 0 || _countryListArr.count == 0  ) {
        
        [self loadData];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {

        statusBar.backgroundColor = [UIColor clearColor];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _headHeight = 515 * HEIGHT/667;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBgViewColor:) name:@"scrollViewScroll" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
    [self startLocation];
}

- (void)changeBgViewColor:(NSNotification *)info {
    
    
//    NSLog(@"----%@",info);
}

- (void)setupSubViews
{
    self.canScroll = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    NSArray *sortTitles = @[@"全部"];
    self.contentCell.currentTagStr = sortTitles[self.titleView.selectIndex];
    self.contentCell.isRefresh = YES;
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark notify
//改变主视图的状态
- (void)changeScrollStatus{

    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return _headHeight - 97 - [CXUtils statueBarHeight] ;
        }
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) { return 0; }
    
    return 97;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _bgView = [self createBgView];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 55, CGRectGetWidth(self.view.bounds), 37) titles:_continentArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.titleSelectColor = HWColor(255, 247, 15);
    self.titleView.titleFont = FONT_SIZE_14;
    self.titleView.titleSelectFont = FONT_SIZE_14;
    self.titleView.indicatorColor = [UIColor clearColor];
    self.titleView.titleNormalColor = [UIColor whiteColor];
    self.titleView.itemMargin =  43;
    [_bgView addSubview:self.titleView];
    return _bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!_contentCell) {
            _contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
            _scrollView = [[FSScrollContentViewController alloc]init];
            NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:_scrollView, nil];
            _contentCell.viewControllers = arr;
            _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) childVCs:arr parentVC:self delegate:self];
            [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cycleScrollViewCell"];
    [cell.contentView addSubview:self.cycleScrollView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    return nil;
}



// 轮播图代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    
    
}


#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

//索引点击事件
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    
    _scrollView.selectIndex = endIndex;
//    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress {

    _tableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y >=  0) {
   
        _colorView.backgroundColor = RGBColor(20, 30, 71, (scrollView.contentOffset.y + [CXUtils statueBarHeight])/(_headHeight- 97));
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            
            starColor = RGBColor(20, 30, 71, (scrollView.contentOffset.y + [CXUtils statueBarHeight])/(_headHeight- 97));
            statusBar.backgroundColor = starColor;
        }
    }

    if (scrollView.contentOffset.y < 97) {
        
        _colorView.backgroundColor = RGBColor(20, 30, 71, 0);
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            starColor = RGBColor(20, 30, 71, (scrollView.contentOffset.y)/(_headHeight- 97));
            statusBar.backgroundColor = starColor;
        }
    }
    CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y;
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}

#pragma mark LazyLoad
- (FSBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0,[CXUtils statueBarHeight], CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = NO;
        [self.view addSubview:_tableView];
        _tableView.clipsToBounds = NO;
    }
    return _tableView;
}

#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -
// 数据整理
- (void)markData {
    
    [CXUtils hideHUD];
    
    if (_bannerArr.count != 0 && _hotArr.count != 0 && _countryListArr.count != 0  ) {
        
        // 轮播图
        NSMutableArray *imageArr = [[NSMutableArray alloc] init];
        for (MSLBannerModel *model in _bannerArr) { [imageArr addObject:model.img_url]; }
        
        self.cycleScrollView.imageURLStringsGroup = imageArr;
        self.cycleScrollView.autoScroll = YES;
        
        //  索引
        [_countryListArr insertObject:_hotArr atIndex:0];
        [_continentArr insertObject:@"热门" atIndex:0];
        
        _scrollView.dataArr = _countryListArr;
        _scrollView.selectIndex = 0;
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

// 轮播图
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, - [CXUtils statueBarHeight], WIDTH, _headHeight) shouldInfiniteLoop:YES imageNamesGroup:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"fail1"];
    }
    return _cycleScrollView;
}

- (UIView *)createBgView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 97)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    _colorView = [[UIView alloc] initWithFrame:bgView.bounds];
    _colorView.backgroundColor = RGBColor(20, 30, 71, 0);
    [bgView addSubview:_colorView];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 12, WIDTH - 20, 37);
    [searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索您想要办理的国家名称" forState:UIControlStateNormal];
    searchBtn.titleLabel.font = FONT_SIZE_14;
    [searchBtn addTarget:self action:@selector(pushCountrySearchVC) forControlEvents:UIControlEventTouchUpInside];
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

- (void)pushCountrySearchVC {
    
    CountrySearchVC *vc = [[CountrySearchVC alloc] init];
    vc.localName = _scrollView.localName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  开始定位
-(void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 100.0f;//过滤距离
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0) {
            //            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始实现定位
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder =[[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary * test = [placemark addressDictionary];
            
            NSMutableString *name = [[NSMutableString alloc] initWithString:[test objectForKey:@"State"]];
            
            NSString *localName = [name substringToIndex:name.length - 1];
            // 省份
            _scrollView.localName = localName;
        }
        
    }];
}

@end
