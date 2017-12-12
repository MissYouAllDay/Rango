
//
//  MSLAreaVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/30.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLAreaVC.h"
#import "MSLAreaTabCell.h"
#import "MSLProvinceView.h"
#import "MSLNeedInfoVC.h"
@interface MSLAreaVC ()<UITableViewDelegate,UITableViewDataSource,CXProvinceDelegate>
{
    UITableView *_tableView;

    UIImageView *_headImg;      //顶部视图
    
    UIButton *_searchBar;       // 搜索
    
    UIView *_markView;          // 灰色遮罩
    
    MSLProvinceView *_provinceView;     // 省份
    
     NSMutableArray *_dataArr;      // 整体数据
     NSMutableArray *_provinceData; // 省份数据
    NSInteger _selectIndex;        // 选择的省份
    
    UILabel *_localNameLab;   // 定位省份
    
    UIView *_barView;       // 导航栏
    
}
@property(nonatomic,strong)CLLocationManager * locationManager;

@end

@implementation MSLAreaVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];

    if (_provinceData.count < 1)  [self loadProvinceData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _countryModel.country_name;
    self.view.backgroundColor = COLOR_245;
  
    [self createTab];
    [self loadData];
    [self createProviceView];

    _barView = [super createNavigationBar];
    [self.view addSubview:_barView];
    self.barName.text = _countryModel.country_name;
}

#pragma mark - - - - - - - - - -  创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44 - [super statueBarHeight], WIDTH, HEIGHT + 44 + [super statueBarHeight]) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_245;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, Line(220))];
    _headImg.image = [UIImage imageNamed:@"areaHeadFail"];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_countryModel.bg_img_url] placeholderImage:[UIImage imageNamed:@"areaHeadFail"]];
    _headImg.userInteractionEnabled = YES;
    _tableView.tableHeaderView = _headImg;
    
    _localNameLab = [[UILabel alloc] initWithFrame:CGRectMake(20, Line(175), WIDTH-20, 35)];
    _localNameLab.text = _locaName.length < 1 ? @"请选择长期居住地" : _locaName ;
    _localNameLab.textColor = [UIColor whiteColor];
    _localNameLab.font = FONT_SIZE_14;
    _localNameLab.userInteractionEnabled = YES;
    [_headImg addSubview:_localNameLab];
    
    _searchBar = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBar.frame = CGRectMake(-10, 0, _localNameLab.widthCX, _localNameLab.heightCX);
    [_searchBar setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [_searchBar setTitleColor:HWColor(255, 255, 255) forState:UIControlStateNormal];
    _searchBar.titleLabel.font = FONT_SIZE_14;
    
    CGFloat imageW = CGRectGetWidth(_searchBar.imageView.frame);
    
    _searchBar.imageEdgeInsets = UIEdgeInsetsMake(0, _searchBar.widthCX - imageW - 15, 0, 15);
    
    [_searchBar setBackgroundColor:RGBColor(0, 0, 0, 0.5)];
    _searchBar.layer.cornerRadius = _searchBar.heightCX/2;
    _searchBar.clipsToBounds = YES;
    [_searchBar addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_localNameLab addSubview:_searchBar];
}

- (void)searchBtnAction:(UIButton *)sender {
    
    [_provinceView show];
    _markView.hidden = NO;
}

- (void)createProviceView {
    
    _markView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_markView];
    _markView.backgroundColor = RGBColor(0, 0, 0, 0.5);
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markViewTap)];
    [_markView addGestureRecognizer:tap];
    _markView.hidden = YES;
    _provinceView = [[MSLProvinceView alloc] initWithFrame:CGRectMake(0, 0, Line(300), Line(270))];
    _provinceView.center = self.view.center;
    _provinceView.delegate = self;
    _provinceView.hidden = YES;
    [self.view addSubview:_provinceView];
    [_provinceView.closeBtn addTarget:self action:@selector(markViewTap) forControlEvents:UIControlEventTouchUpInside];
}
- (void)provinceSelectIndex:(NSInteger)inidex {
    
    _selectIndex = inidex;
    _markView.hidden = YES;
    NSDictionary *dic = _provinceData[_selectIndex];
    _localNameLab.text = dic[@"area_name"];

}

- (void)markViewTap {
    
    _markView.hidden = YES;
    [_provinceView closeSelf];
}

#pragma mark - - - - - - - - - - UITabLeviewDataSource  - - - - - - - - - - -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return Line(100);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLAreaTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLAreaTabCell" owner:nil options:nil] lastObject];
    }
    
    cell.selectionStyle = UITableViewCellStyleDefault;
    
    if (_dataArr.count != 0 ) {
        
        cell.model = _dataArr[indexPath.row];
    }
    cell.doBtn.tag = 2000 + indexPath.row;
    [cell.doBtn addTarget:self action:@selector(pushNextVC:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    MSLNeedInfoVC *vc = [[MSLNeedInfoVC alloc] init];
    vc.merModel = _dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _barView.backgroundColor = RGBColor(2, 167, 255, scrollView.contentOffset.y/100);
}

- (void)pushNextVC:(UIButton *)sender {
    
    NSInteger index = sender.tag - 2000;
    MSLNeedInfoVC *vc = [[MSLNeedInfoVC alloc] init];
    vc.merModel = _dataArr[index];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - - - - - - - - - - 获取数据 - - - - - - - - - - -
- (void)loadData {
    
    _dataArr = nil;
    _dataArr = [[NSMutableArray alloc] init];
    if (_locaName == nil) { _locaName = @""; }

    NSDictionary *param = @{@"country_id":[NSString stringWithFormat:@"%@",_countryModel.country_id],@"area_name":_locaName,APP_COMPANY_ID:APP_COMPANY_IDNUM};
    [NetWorking postHUDRequest:AREA_URL withParam:param withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic  in result) {
            
            MSLProductModel *model =  [[MSLProductModel alloc] initWithDictionary:dic];
            [_dataArr addObject:model];
        }
        
        if (_dataArr.count == 0) {
            
            [CXUtils createAllTextHUB:@"暂时没有数据"];
            return ;
        }
        [_tableView reloadData];
        
    } failBlock:^(NSError *error) {
        
        
    }];
}

- (void)loadProvinceData {
    
    _provinceData = nil;
    _provinceData = [[NSMutableArray alloc] init];
    
    [NetWorking getHUDRequest:PROVICE_URL withParam:nil withErrorCode:YES withHUD:YES success:^(id responseObjc) {
        
        int errorCode = [responseObjc[@"error_code"] intValue];
        if (errorCode != 0) { return ; }
        
        _provinceData = [[NSMutableArray alloc] initWithArray:responseObjc[@"result"]];
        
        if (_locaName.length < 1) { return ; }
     
        NSArray *markArr = [NSArray arrayWithArray:_provinceData];
        
        for (int i = 0; i < markArr.count; i ++) {
            
            NSDictionary *dic = markArr[i];
            NSString *name = [NSString stringWithFormat:@"%@",dic[@"area_name"]];
            if ([name containsString:_locaName]) {
                
                [_provinceData removeObjectAtIndex:i];
                [_provinceData insertObject:dic atIndex:0];
                break;
            }
        }
        
        _provinceView.dataArr = _provinceData;
      
    } failBlock:^(NSError *error) {
        
    }];
}

@end
