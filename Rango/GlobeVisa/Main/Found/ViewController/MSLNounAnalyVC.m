//
//  MSLNounAnalyVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNounAnalyVC.h"
#import "MSLNounAnalyCell.h"
@interface MSLNounAnalyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSIndexPath *_selectIndexP;      // 曾经选过的
    NSIndexPath *_nowSelectIndexP;
    CGFloat _cellHei;       // 展示的cell的高度
    NSString *_answer;          // 回答
    NSString *_problem;         // 问题
    UILabel *_cellLab;
    BOOL _tap;  // 是否点击  为了防止_selectIndexP== 0-0
}

@end

@implementation MSLNounAnalyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"名词解析";
    _problem = @"problem";
    _answer = @"answer";
    [self createTab];
    [self loadData];
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
    
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath == _selectIndexP  && _tap? _cellHei : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == _selectIndexP.section && _tap ? 10 : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 45, 44)];
    la.text = _dataArr[section][_problem];
    la.font = FONT_SIZE_15;
    [bgView addSubview:la];
    bgView.backgroundColor = [UIColor whiteColor];
    la.userInteractionEnabled = YES;
    la.tag = 2000 + section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [la addGestureRecognizer:tap];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - 30, 0, 30, bgView.heightCX)];
    leftImg.image = [UIImage imageNamed:@"my_right"];
    leftImg.contentMode = UIViewContentModeCenter;
    [bgView addSubview:leftImg];
    if (section == _selectIndexP.section && _tap) {
        
        [UIView animateWithDuration:0.35 animations:^{
            
            leftImg.transform = CGAffineTransformMakeRotation(M_PI/2);
        } completion:^(BOOL finished) { }];
    }
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLNounAnalyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nounAnCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLNounAnalyCell" owner:nil options:nil] lastObject];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:_dataArr[indexPath.section][_answer] attributes:@{NSFontAttributeName:FONT_SIZE_13}];
    [attText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attText.length)];
    cell.name.attributedText = attText;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath == _selectIndexP) {
        [UIView animateWithDuration:0.35 animations:^{

            cell.heightCX = _cellHei;
            _cellLab.heightCX = _cellHei - 10;
        } completion:^(BOOL finished) {


        }];
    }
 
}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    UIView *view = tap.view;
    _tap = YES;
    NSInteger index = view.tag - 2000;
   
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndex:index];
    if (_selectIndexP) {
        if (_selectIndexP.section == index) { return; }
        [indexSet addIndex:_selectIndexP.section];
    }
    _selectIndexP = [NSIndexPath indexPathForRow:0 inSection:index];
     _cellHei = [CXUtils labelHei:_dataArr[_selectIndexP.section][_answer] withWidth:WIDTH - 40 withFont:FONT_SIZE_13] + 30;
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)loadData {
    
    _dataArr = nil;
    [NetWorking postHUDRequest:NOUNAN_URL withParam:@{@"problem":@"签证"} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        _dataArr = [[NSMutableArray alloc] initWithArray:result];
        [_tableView reloadData];
    } failBlock:^(NSError *error) { }];
}

@end
