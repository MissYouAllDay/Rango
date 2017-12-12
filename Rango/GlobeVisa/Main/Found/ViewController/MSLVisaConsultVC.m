//
//  MSLVisaConsultVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/29.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLVisaConsultVC.h"
#import "MessageCell.h"
#import "MSLVisaConsultDownView.h"
typedef enum {
    
    AVAType,
    NumType,
    QuesType
}AnswerType;
@interface MSLVisaConsultVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_scroller;
    UITableView *_tableView;
    MSLVisaConsultDownView *_searchBar;

    NSMutableArray *_dataArr;
    // type : _ava  _problem  _user  _aboutQues
    //_problem : 后台问题  _answer： 后台问题的回答
    NSString *_ava;         // ava
    NSString *_problem;     // 相关问题  || 问题
    NSString *_user;        // 用户
    NSString *_aboutQues;     // 相关问题字样

    NSString *_answer;      // 回答的问题

    // 相关问题上下线
    NSString *_topLine; // 相关问题上面横线
    NSString *_bottomLine;  // 相关问题下面横线
    
    NSString *_lineType; // 线的位置
    
    NSInteger _selectIndex;     // 相关问题点击的位置
    
    UIView *_markView;
}

@end

@implementation MSLVisaConsultVC
-(void)loadView{
    UIScrollView*scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view= scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签证咨询";

    _ava = @"ava";
    _user = @"user";
    _problem = @"problem";
    _answer = @"answer";
    _aboutQues = @"aboutQues";
    _lineType = @"lineType";
    _topLine = @"topLine";
    _bottomLine = @"bottomLine";
    _selectIndex = -1;
    NSDictionary *dic = @{@"type":_ava,_problem:@"AVA",_answer:@"您好！有什么可以帮您的吗？"};
    _dataArr = [[NSMutableArray alloc] initWithObjects:dic, nil];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    [self createTab];
    [self createDownView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - - - - - - - - - - 键盘隐藏和展示 - - - - - - - - - - -
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    _markView.frame = CGRectMake(0, HEIGHT-49-keyBoardFrame.size.height - [CXUtils statueBarHeight] - 44, WIDTH, 49);
    _tableView.topCX = 0;
    _tableView.heightCX = HEIGHT - [CXUtils statueBarHeight] - 44 - 49-keyBoardFrame.size.height;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArr.count-1]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    _markView.frame = CGRectMake(0, HEIGHT - 49 - [CXUtils statueBarHeight] - 44, WIDTH , 49);
    _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-45-64);
    [_tableView reloadData];
    
}
#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] - 44 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)createDownView {

    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 49 - [CXUtils statueBarHeight] - 44, WIDTH , 49)];
    _searchBar = [[[NSBundle mainBundle] loadNibNamed: @"MSLVisaConsultDownView" owner:nil options:nil] lastObject];
    _searchBar.frame = _markView.bounds;
    [_markView addSubview:_searchBar];
    [self.view addSubview: _markView];
    [_searchBar.nextBtn addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - - - - - - - - - - 设置高度和数量 - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = _dataArr[indexPath.section];
    // 相关问题不展开
    if ([dic[@"type"] isEqualToString:_aboutQues]) { return 0; }

    //用户
    if ([dic[@"type"] isEqualToString:_user]) {
        
        return [CXUtils labelHei:dic[_problem] withWidth:WIDTH - 80 withFont:FONT_SIZE_13] + 35;
    }
    
    //相关 问题
    if ([dic[@"type"] isEqualToString:_problem] ) {
        if ( _selectIndex != indexPath.section) { return 0; }
        return [CXUtils labelHei:dic[_answer] withWidth:WIDTH - 80 withFont:FONT_SIZE_13] + 35;
    }
    // ava
    return [CXUtils labelHei:dic[_answer] withWidth:WIDTH - 80 withFont:FONT_SIZE_13] + 35;
}

#pragma mark - - - - - - - - - - Head - - - - - - - - - - -
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) { return 60; }
    NSDictionary *dic = _dataArr[section];
    if ([dic[@"type"] isEqualToString:_problem] || [dic[@"type"] isEqualToString:_aboutQues]) {
        
        return 44;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        
        UIImageView *avaImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 40, bgView.heightCX)];
        avaImg.contentMode = UIViewContentModeBottom;
        avaImg.image = [UIImage imageNamed:@"found_ava"];
        
        UILabel *avaLa = [[UILabel alloc] initWithFrame:CGRectMake(avaImg.rightCX + 8, 20, WIDTH, 40)];
        avaLa.text = @"AVA";
        [bgView addSubview:avaImg];
        [bgView addSubview:avaLa];
        return bgView;
    }
    NSDictionary *dic = _dataArr[section];
    if ([dic[@"type"] isEqualToString:_ava] ||[dic[@"type"] isEqualToString:_user]) {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    UILabel *avaLa = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH - 30, bgView.heightCX)];
    avaLa.text = _dataArr[section][_problem];
    [bgView addSubview:avaLa];
    avaLa.font = FONT_SIZE_15;
    avaLa.userInteractionEnabled = YES;
    //设置分割线
    if ([[dic allKeys] containsObject:_lineType]) {
        if ([dic[@"type"] isEqualToString:_aboutQues]) {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
            line.backgroundColor = COLOR_231;
            [bgView addSubview: line];
        }else {
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bgView.heightCX - 1, WIDTH, 0.5)];
            line.backgroundColor = COLOR_231;
            [bgView addSubview: line];
        }
    }
    if (![dic[@"type"] isEqualToString:_aboutQues]) {
        
        avaLa.tag = 3000 + section;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutQuestionTapAction:)];
        [avaLa addGestureRecognizer:tap];
        
    }

    return bgView;
}
- (void)aboutQuestionTapAction:(UITapGestureRecognizer *)tap {
    
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    NSInteger index = tap.view.tag - 3000;

    if (_selectIndex > -1) { [indexSet addIndex:_selectIndex]; }
    
    // 重复点击同一个时候关闭
    if (_selectIndex == index) {
        _selectIndex = -1;
        [indexSet addIndex:index];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

        return;
    }
    
    _selectIndex = index;
    [indexSet addIndex:index];
    
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

#pragma mark - - - - - - - - - - Foot - - - - - - - - - - -
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}
#pragma mark - - - - - - - - - - CELL - - - - - - - - - - -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mesaageCell"];
    
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mesaageCell"];
    }
    cell.message = _dataArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clipsToBounds = YES;
    return cell;
}

- (void)loadData {
    NSString *text = nil;
    text = [_searchBar.searchTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (text.length < 1) { return; }
    
    [_dataArr addObject:@{@"type":_user,_problem:text}];
    _searchBar.searchTF.text = nil;
    [_searchBar.searchTF resignFirstResponder];

    [NetWorking postHUDRequest:NOUNAN_URL withParam:@{@"problem":text,@"page":@"0",@"num":@4} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        int i = 0;
        int m = (int)result.count - 1;
        for (NSDictionary *dic in result) {
            
            if (i == 0) {
                // i== 0 的时候默认为后台回答用户的问题
                [_dataArr addObject:@{@"type":_ava,_answer:dic[_answer],_problem:dic[_problem]}];
            }else if (i == 1 && i == m) {
                //  返回的数据只有2个的时候，相关问题上下线
                [_dataArr addObject:@{@"type":_aboutQues,_problem:@"相关问题",_lineType:_topLine}];
                [_dataArr addObject:@{@"type":_problem,_problem:dic[_problem],_answer:dic[_answer],_lineType:_bottomLine}];
                
            }else if (i == 1){
                // 返回的数据 超过2个  设置上线
                [_dataArr addObject:@{@"type":_aboutQues,_problem:@"相关问题",_lineType:_topLine}];
                [_dataArr addObject:@{@"type":_problem,_problem:dic[_problem],_answer:dic[_answer]}];
                
            }else if (i == m) {
                // 返回的数据 超过2个  设置下线
                [_dataArr addObject:@{@"type":_problem,_problem:dic[_problem],_answer:dic[_answer],_lineType:_bottomLine}];
            }else {
                 // 返回的数据 超过2个  设置问题
                [_dataArr addObject:@{@"type":_problem,_problem:dic[_problem],_answer:dic[_answer]}];
            }
            i ++;
        }
        
        // 将展开的部分合并
        _selectIndex = -1;
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArr.count-1]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    } failBlock:^(NSError *error) { }];
}


@end
