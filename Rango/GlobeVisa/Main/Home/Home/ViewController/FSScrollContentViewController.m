//
//  FSScrollContentViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSScrollContentViewController.h"

#import "MSLHotTabCell.h"

#import "MSLBannerModel.h"
#import "MSLProductModel.h"
#import "MSLCountryModel.h"

#import "MSLAreaVC.h"
#import "MSLNeedInfoVC.h"


#import "MSLMarkViewController.h"
@interface FSScrollContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    
}
@property (nonatomic, assign) BOOL fingerIsTouch;
/** 用来显示的假数据 */
@property (strong, nonatomic) NSArray *showData;

@end

@implementation FSScrollContentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_245;
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), HEIGHT - 49 - 97 - [CXUtils statueBarHeight]) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}


#pragma mark Setter
- (void)setSelectIndex:(NSInteger)selectIndex {

    _selectIndex = selectIndex;
    
    _showData = _dataArr[_selectIndex];
    [_tableView reloadData];
}

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _showData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WIDTH / 375 * 194;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLHotTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotTabCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLHotTabCell" owner:nil options:nil] lastObject];
    }

    _selectIndex == 0 ? (cell.proModel = _showData[indexPath.item]) :(cell.counModel = _showData[indexPath.item]);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_selectIndex ==0) {
        
        MSLNeedInfoVC *vc = [[MSLNeedInfoVC alloc] init];
        MSLProductModel *model = _showData[indexPath.row];
        vc.merModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",model.photo_format] forKey:PHOTO_FORMEAT];
        return;
    }
    MSLAreaVC *vc = [[MSLAreaVC alloc] init];
    MSLCountryModel *model = _showData[indexPath.row];
    vc.countryModel = model;
    vc.locaName = _localName;
    [self.navigationController pushViewController:vc animated:YES];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",model.photo_format] forKey:PHOTO_FORMEAT];

}


#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {

        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollViewScroll" object:@{@"offset":@(scrollView.contentOffset.y)}];//到顶通知父视图改变状态

        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
    
}



@end
