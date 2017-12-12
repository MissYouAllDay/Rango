//
//  MSLNeedInfoVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLNeedInfoVC.h"
#import "MSLNeedInfoModel.h"
//#import "MSLNeedInfoTab.h"
#import "MSLNeedInfoScrollView.h"
#import "MSLNeedInfoHeadView.h"
#import "NeedInfoDownView.h"
#import "MSLContactVC.h"
#import "MSLLoginVC.h"
@interface MSLNeedInfoVC ()<UITableViewDelegate,UITableViewDataSource,CXNeedInfoDelegate>
{
    UITableView *_tableView;         // tab
    UITextView *_needInfoTextView;  //  所需资料
    UITextView *_baseInfoTextView;  //  基本信息
    UIView *_stepView;              //  办理流程
    MSLNeedInfoHeadView *_head;     // toushitu
    UIView *_barView;                // 导航栏
    
    NSMutableArray *_titleArr;  // 索引
    NSMutableArray *_dataArr;   // 数据
    NSMutableArray *_baseInfoHeiArr;    //基本信息的高度
    NSMutableArray *_needInfoHeiArr;    //所需资料的高度
    NSMutableArray *_imageArr;          //未选中图片数组
    NSInteger _selectIndex;             // 选中的位置

    
}

@property (nonatomic, strong) MSLNeedInfoScrollView *meunScroller;    // 索引视图

@end

@implementation MSLNeedInfoVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _merModel.visa_name;
    _titleArr = [[NSMutableArray alloc] init];

    [self createTab];
    [self createDownView];
    [self loadData];
    _barView = [super createNavigationBar];
    [self.view addSubview:_barView];
    self.barName.text = _merModel.visa_name;
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - - - - - - - - - - 创建视图  - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - [CXUtils statueBarHeight], WIDTH, HEIGHT - 45 + [CXUtils statueBarHeight]) style:UITableViewStyleGrouped];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _head = [[[NSBundle mainBundle] loadNibNamed:@"MSLNeedInfoHeadView" owner:nil options:nil] lastObject];
    _head.frame = CGRectMake(0, 0, WIDTH, Line(320));
    _head.model = _merModel;
    _tableView.tableHeaderView = _head;
    _tableView.tableFooterView = [UIView new];
}

// 咨询开始签证
- (void)createDownView {

    NeedInfoDownView *downView = [[[NSBundle mainBundle] loadNibNamed:@"NeedInfoDownView" owner:nil options:nil] lastObject];
    
    downView.frame = CGRectMake(0, HEIGHT - 45, WIDTH, 45);
    [self.view addSubview:downView];
    [downView.startVisa addTarget:self action:@selector(startVisaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startVisaBtnClick:(UIButton *)sender {
    
    NSString *name = TOKEN_VALUE;
    
    if (name.length < 1) {
        
        MSLLoginVC *vc = [[MSLLoginVC alloc] init];
        vc.titleName = @"登录";
        vc.viewType = 1;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    MSLContactVC *vc = [[MSLContactVC alloc] init];
    vc.merModel = _merModel;
    [self.navigationController pushViewController:vc animated:YES];

}

// 索引
- (MSLNeedInfoScrollView *)meunScroller {
    
    if (!_meunScroller) {
        _meunScroller = [[MSLNeedInfoScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 89)];
        
        _meunScroller.delegate = self;
        _meunScroller.selectIndex = (int)_selectIndex;
    }
    if (_meunScroller.titleArr.count == 0 && _titleArr.count != 0 && _imageArr.count != 0) {
        _meunScroller.titleArr = _titleArr;
        _meunScroller.imageArr = _imageArr;
    }
    
    
    return _meunScroller;
}


#pragma mark - - - - - - - - - - 索引点击代理 - - - - - - - - - - -
- (void)needInfoScrollViewSelectIndex:(NSInteger)index {
    
    _selectIndex = index;
    NSIndexSet *sectionSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(1, 2)];
#warning CX ---- 下面不需要备注  为方便测试才备注上
    [_tableView reloadSections:sectionSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _barView.backgroundColor = RGBColor(2, 167, 255, scrollView.contentOffset.y/100);
}

#pragma mark - - - - - - - - - - UITableVIewDelegate - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section == 0 ? 0 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == 0 ? 0.01 : 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  section == 0 ? 89 : 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
       
        case 0: return 0;
        case 1:  return _baseInfoHeiArr.count != 0 ? [_baseInfoHeiArr[_selectIndex][@"height"] floatValue] + 10 : 0;
        case 2: return _needInfoHeiArr.count != 0 ? [_needInfoHeiArr[_selectIndex][@"height"] floatValue] + 10 : 0;
        case 3: return 250;
        default: break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personTypeTableViewCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personTypeTableViewCell"];
    }
    // 基本资料
    if (indexPath.section == 1) {
       
        UITableViewCell *cell1 = [self tableView:tableView baseInfoCellForRowAtIndexPath:indexPath];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    // 所需资料
    if (indexPath.section == 2) {
        
        UITableViewCell *cell1 = [self tableView:tableView needInfoCellForRowAtIndexPath:indexPath];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    // 流程
    if (indexPath.section == 3) {
        
        UITableViewCell *cell1 = [self tableView:tableView stepCellForRowAtIndexPath:indexPath];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) { return [self meunScroller]; }
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    la.backgroundColor = COLOR_WHITE;
    la.textAlignment = NSTextAlignmentCenter;
    la.font = FONT_SIZE_14;
    
    switch (section) {
        case 1: la.text = @"基本信息"; break;
        case 2: la.text = @"所需资料"; break;
        case 3: la.text = @"办理流程"; break;
        default: break;
    }
    return la;
}

#pragma mark - - - - - - - - - - 创建cell - - - - - - - - - - -
// 所需资料
- (UITableViewCell *)tableView:(UITableView *)tableView needInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personTypeNeedTableViewCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personTypeNeedTableViewCell"];
    }
    if (!_needInfoTextView) {
        _needInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, WIDTH - 30, 1)];
    }
    _needInfoTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置页边距
    _needInfoTextView.showsVerticalScrollIndicator = NO;
    _needInfoTextView.showsHorizontalScrollIndicator = NO;

    if (_needInfoHeiArr.count != 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        
        NSDictionary *needInfoDic = _needInfoHeiArr[_selectIndex];
        _needInfoTextView.attributedText = needInfoDic[@"text"];
        _needInfoTextView.editable = NO;
        _needInfoTextView.scrollEnabled = NO;
        _needInfoTextView.heightCX = [needInfoDic[@"height"] floatValue];
    }
    if (!(_needInfoTextView.superview == cell.contentView)) {
        [cell.contentView addSubview:_needInfoTextView];
    }
    cell.clipsToBounds = YES;
    return cell;
}

// 基本信息
- (UITableViewCell *)tableView:(UITableView *)tableView baseInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personTypeBaseTableViewCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personTypeBaseTableViewCell"];
    }
    if (!_baseInfoTextView) {
        _baseInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 10, WIDTH - 30, 1)];
    }
    
    _baseInfoTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置页边距
    _baseInfoTextView.showsVerticalScrollIndicator = NO;
    _baseInfoTextView.showsHorizontalScrollIndicator = NO;
    
    if (_baseInfoHeiArr.count != 0) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        
        NSDictionary *baseInfoDic = _baseInfoHeiArr[_selectIndex];
        NSMutableAttributedString *text = baseInfoDic[@"text"];
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        _baseInfoTextView.attributedText = text;
        _baseInfoTextView.editable = NO;
        _baseInfoTextView.scrollEnabled = NO;
        _baseInfoTextView.heightCX = [baseInfoDic[@"height"] floatValue];
    }
    if (!(_baseInfoTextView.superview == cell.contentView)) {
        
        [cell.contentView addSubview:_baseInfoTextView];
    }
    return cell;
}

//办理流程 a
- (UITableViewCell *)tableView:(UITableView *)tableView stepCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personTypeStepTableViewCell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"personTypeStepTableViewCell"];
    }
    NSArray *titlerArr = @[@"准备并上传资料",@"下单支付",@"寄送资料",@"资料审核并送签",@"出签并配送"];
    _stepView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 30, 250)];
    
    for (int i = 0; i < titlerArr.count; i ++) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 50, _stepView.widthCX,50)];
        
        UILabel *stepla = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
        stepla.text = [NSString stringWithFormat:@"0%d",i + 1];
        stepla.textColor = COLOR_BUTTON_BLUE;
        stepla.textAlignment = NSTextAlignmentLeft;
        stepla.font = FONT_13;
        [bgView addSubview:stepla];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(stepla.rightCX, 0, 25, 25)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"step"];
        [bgView addSubview:imageView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightCX + 10, 0, bgView.widthCX - imageView.widthCX - 10 - stepla.widthCX, stepla.heightCX)];
        title.text = titlerArr[i];
        title.textColor = COLOR_BUTTON_BLUE;
        [bgView addSubview:title];
        title.font = FONT_13;
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.leftCX + (imageView.rightCX - imageView.leftCX - 1)/2, imageView.bottomCX, 1, bgView.heightCX - imageView.heightCX)];
        lineImg.image = [UIImage imageNamed:@"line"];
        if (i != titlerArr.count - 1) {
            
            [bgView addSubview:lineImg];
        }
        
        [_stepView addSubview:bgView];
    }
    if (!(_stepView.superview == cell.contentView)) {

        [cell.contentView addSubview:_stepView];
    }
    cell.clipsToBounds = YES;
    return cell;
}

#pragma mark - - - - - - - - - -  获取数据 ji 数据 整理 - - - - - - - - - - -
- (void)loadData {

    _imageArr = nil;
    _imageArr = nil;
    _needInfoHeiArr = nil;
    _baseInfoHeiArr = nil;
    
    _dataArr = [[NSMutableArray alloc] init];
    _imageArr = [[NSMutableArray alloc] init];
    _needInfoHeiArr = [[NSMutableArray alloc] init];
    _baseInfoHeiArr = [[NSMutableArray alloc] init];

    NSArray *imageArr = @[@"child",@"free",@"worker",@"student",@"rutire"];

    [NetWorking getHUDRequest:NEEDINFO_URL withParam:@{@"visa_id":[NSString stringWithFormat:@"%@",_merModel.visa_id]} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *dataArr = responseObjc[@"result"];
    //  所需材料
        for (NSDictionary *dic in dataArr) {
            
            NSArray *datumList = dic[@"datumList"];
            NSMutableArray *datumArr = [[NSMutableArray alloc] init];
            for (NSDictionary *datum in datumList) {
                
                MSLNeedInfoModel *model = [[MSLNeedInfoModel alloc] initWithDictionary:datum];
                
                [datumArr addObject:model];
            }
            NSString *title = nil;
            int a = 0;
            switch ([dic[@"cust_type"] intValue]) {
                case 1: title =  @"在职人员";  a = 2;    break;
                case 2: title = @"自由职业者";  a = 1;    break;
                case 3: title = @"学龄前儿童";  a = 0;    break;
                case 4: title = @"在校学生";    a = 3;    break;
                case 5: title = @"退休人员";    a = 4;    break;
                default: break;
            }
            
            [_imageArr addObject:imageArr[a]];
            [_titleArr addObject:title];

            NSArray *basisList = dic[@"basisList"];
            
            // 【{type1},{type2}....】 // type1  {学生：所需资料，id：基本信息}
            [_dataArr addObject:@{title:datumArr,[NSString stringWithFormat:@"%@",dic[@"cust_type"]]:basisList}];
        }
        // 基本信息
        for (NSDictionary *dic in _dataArr) {
            
            for (NSString *key in dic) {
                
                // 基本信息
                if (key.length < 2) {
                    NSDictionary *baseInfoDic = [CXUtils heightofBaseInfoTextViewfwithText:dic[key]];
                    [_baseInfoHeiArr addObject:baseInfoDic];
                }else {
                    NSDictionary *needInfoDic = [CXUtils heightofPersonTypeTextViewfwithText:dic[key]];
                    [_needInfoHeiArr addObject:needInfoDic];
                }
            }
        }
        _selectIndex = [_titleArr indexOfObject:@"在职人员"];
        [_head.bgImg sd_setImageWithURL:responseObjc[@"visa"][@"region_url"] placeholderImage:[UIImage imageNamed:@"needInfo_fail"]];

        [_tableView reloadData];
        
    } failBlock:^(NSError *error) { }];
}


@end
