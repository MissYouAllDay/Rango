//
//  CountrySearchVC.m
//  GlobeVisa
//
//  Created by MSLiOS on 2016/12/27.
//  Copyright © 2016年 MSLiOS. All rights reserved.
//

#import "CountrySearchVC.h"
#import "MSLAreaVC.h"
#import <iflyMSC/iflyMSC.h>
#import "MSLCountryModel.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface CountrySearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,IFlySpeechRecognizerDelegate>
{
    UIView * _navViewCoun;
}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UISearchBar * search;
@property (nonatomic,strong)  NSMutableArray *indexArray;
@property (nonatomic,strong)  NSMutableArray *letterResultArr;
@property (nonatomic,strong) UITextField * searchField;
@property (nonatomic,strong) NSMutableDictionary *countryID_dic;
@property (nonatomic) BOOL isSearching;
@property (nonatomic,strong) NSString *searchTerm;
@property (nonatomic,strong) UIImageView *speakView;//话筒界面
@property (nonatomic,strong) UIView *markView;//遮罩视图
@property (nonatomic,strong) IFlySpeechRecognizer * iFlySpeechRecognizer;       //语音识别
@property (nonatomic,strong)  NSMutableArray *dataArr;//装载model的数据

@end

@implementation CountrySearchVC


#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签证国家";
    self.view.backgroundColor = COLOR_245;
    
    [self createSearchBar];
    [self createTableView];
    [self loadData];//获取网络数据
    [self speechRecognizer];//设置语音听写参数
}

#pragma mark -----------数据-----
-(void)loadData {
    
    _countryID_dic = nil;
    _countryID_dic = [[NSMutableDictionary alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:URL_CITY_SEARCH withParam:nil withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        NSArray * dataArr = responseObjc[@"result"];
        
        for (NSDictionary *dic in dataArr) {
            
            MSLCountryModel *model = [[MSLCountryModel alloc] initWithDictionary:dic];
            [self.dataArray addObject:[NSString stringWithFormat:@"%@",model.country_name]];
            
            NSString * countryId = [NSString stringWithFormat:@"%@",model.country_id];
            [self.countryID_dic setObject:countryId forKey:model.country_name];
            [_dataArr addObject:model];
        }
        
        self.indexArray = [ChineseString IndexArray:_dataArray];
        self.letterResultArr = [ChineseString LetterSortArray:_dataArray];
        [_tableView reloadData];
        [self createSuoYinButton];
    } failBlock:^(NSError *error) {  }];
}
#pragma mark tableView    ------表格------
-(void)createTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_navViewCoun.heightCX, WIDTH, HEIGHT-44 - [CXUtils statueBarHeight] - _navViewCoun.heightCX) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    //隐藏表格cell分割线
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.letterResultArr objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }

//    UILabel * lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, WIDTH > 375 ? 30*1.2: 30, WIDTH, 1)];
//    lineLabel2.backgroundColor = COLOR_230;
//    [cell addSubview:lineLabel2];
    cell.textLabel.font = FONT_SIZE_12;
    cell.textLabel.text = [[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - cell didSelect
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *countryID = [_countryID_dic objectForKey:[[self.letterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    MSLCountryModel *seleModel = nil;
    for (MSLCountryModel *model in _dataArr) {
        if ([[NSString stringWithFormat:@"%@",model.country_id] isEqualToString:countryID]) {
            seleModel = model;
            break;
        }
    }
    
    MSLAreaVC * area = [[MSLAreaVC alloc]init];
    area.countryModel = seleModel;
    area.locaName = _localName;
    [self.navigationController pushViewController:area animated:YES];
   
    //取消cell的点击高亮效果
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_search resignFirstResponder];
}

//索引
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WIDTH > 375 ? 35*1.2 : 35 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WIDTH > 375 ? 20*1.2 : 20 ;
}
// 设置分区头的内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 15, backView.heightCX)];
    textLabel.text = [self.indexArray objectAtIndex:section];
    textLabel.font = FONT_SIZE_14;
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:textLabel];
    
    // 下线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, backView.bottomCX - 0.5, WIDTH, 0.5)];
    line.backgroundColor =COLOR_230;
    [backView addSubview:line];
    
    // 上线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line1.backgroundColor =COLOR_230;
    [backView addSubview:line1];
    return backView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 自定义表格索引视图  右侧索引
-(void)createSuoYinButton {
    
    UIView * suoYinButtonView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - (WIDTH > 375 ? 41*1.2:41),64,WIDTH > 375 ? 41*1.2:41, HEIGHT-64)];
    [self.view addSubview:suoYinButtonView];
    
    for (int i = 0; i < _indexArray.count; i++) {
        
        UIButton * suoYinBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,WIDTH/2-(_indexArray.count*22/2)+i*(WIDTH > 375 ? 22*1.2 : 22), WIDTH > 375 ? 41*1.2:41, WIDTH > 375 ? 22*1.2 : 22)];
        [suoYinBtn setTitle:_indexArray[i] forState:UIControlStateNormal];
        [suoYinBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        suoYinBtn.titleLabel.font = FONT_SIZE_11;
        suoYinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        suoYinBtn.contentMode = UIViewContentModeCenter;
        [suoYinBtn addTarget:self action:@selector(suoYinButton:) forControlEvents:UIControlEventTouchUpInside];
        [suoYinButtonView addSubview:suoYinBtn];
    }
}

-(void)suoYinButton:(UIButton *)sender {
    
    NSIndexPath *scollIndex = [NSIndexPath indexPathForRow:0 inSection:[_indexArray indexOfObject:sender.titleLabel.text]];
    [_tableView scrollToRowAtIndexPath:scollIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark - ----------搜索框---------
-(void)createSearchBar {
    
    _navViewCoun = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 57)];
    _navViewCoun.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navViewCoun];
  
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(15,10,WIDTH-30,_navViewCoun.heightCX - 20)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    searchView.layer.borderColor = [UIColor grayColor].CGColor;
    searchView.layer.borderWidth = 0.5;
    searchView.layer.cornerRadius = searchView.heightCX/2;
    searchView.layer.masksToBounds = YES;
    [_navViewCoun addSubview:searchView];
    
    _search = [[UISearchBar alloc] init];
    [searchView addSubview:_search];
    _search.delegate = self;
    _search.frame = CGRectMake(0, 0, searchView.widthCX, searchView.heightCX);
    for (UIView * view in _search.subviews) {
        //b7
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        //l7
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count>0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    _search.layer.cornerRadius = _search.heightCX/2;
    _search.layer.masksToBounds = YES;
    _search.text = @"签证国家";
    _search.tintColor = COLOR_211;
    _searchField=[_search valueForKey:@"_searchField"];
    _searchField.textColor=[UIColor grayColor];//searchbar文本输入框字体颜色
    
    
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, WIDTH,44)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 60, 7,50, 30)];
    [button setTitle:@"收起"forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonHiddenKey:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_245 forState:UIControlStateNormal];
    
    [bar addSubview:button];
    
    _searchField.inputAccessoryView = bar;
}
-(void)buttonHiddenKey:(UIButton*)btn{
    if ([_searchField.text isEqualToString:@""]) {
        _searchField.text = @"签证国家";
    }
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}

// 返回按钮响应事件
-(void)backCountryBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘点击搜索按钮的实现
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{   //   键盘点击搜索按钮的实现
    self.searchTerm = [searchBar text];
    
}
//点击 searchBar 调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //点击searchBar调用
    _isSearching = YES;
    [_tableView reloadData];
    if ([_search.text isEqualToString:@"签证国家"])  {
        
        _search.text = @"";
    }
}

// searchBar 开始编辑
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
    
    if ([searchTerm length] == 0) {
        
        self.indexArray = [ChineseString IndexArray:self.dataArray];
        self.letterResultArr = [ChineseString LetterSortArray:_dataArray];
        [_tableView reloadData];
        [self createSuoYinButton];
        
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}
- (void)handleSearchForTerm:(NSString *)searchTerm {
    
    NSMutableArray *NewsArr = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i ++) {
        
        if ([_dataArray[i] rangeOfString:searchTerm].location !=NSNotFound) {
            
            [NewsArr addObject:_dataArray[i]];
        }
    }
    self.indexArray = [ChineseString IndexArray:NewsArr];
    self.letterResultArr = [ChineseString LetterSortArray:NewsArr];
    [_tableView reloadData];
    
}


#pragma mark - 语音听写   语音
-(void)micTapSlect:(UITapGestureRecognizer *)tap{
    
    self.markView.hidden = NO;
    self.speakView.hidden = NO;
    
    _iFlySpeechRecognizer.delegate = self;
    
    [_iFlySpeechRecognizer startListening];
    
}
- (UIImageView *)speakView {
    
    if (!_speakView) {
        
        UIImage *image = [UIImage imageNamed:@"talk"];
        CGSize size = image.size;
        _speakView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - size.width)/2, (HEIGHT - size.height)/2 , size.width , size.height)];
        _speakView.contentMode = UIViewContentModeCenter;
        _speakView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_speakView];
        _speakView.image = [UIImage imageNamed:@"talk"];
    }
    return _speakView;
}
- (UIView *)markView {
    
    if (!_markView) {
        
        _markView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        _markView.hidden = YES;
        _markView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_markView];
    }
    
    return _markView;
}

//设置听写参数
- (void)speechRecognizer {
    
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    
    [_iFlySpeechRecognizer setParameter:@"sms"forKey:@"domain"];
    [_iFlySpeechRecognizer setParameter:@"16000" forKey:@"sample_rate"];
    [_iFlySpeechRecognizer setParameter:@"0" forKey:@"plain_result"];
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    [_iFlySpeechRecognizer setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
}
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"RecognizerView error : %@",error);
    
    [_iFlySpeechRecognizer setDelegate:nil];
    _speakView.hidden = YES;
    self.markView.hidden = YES;
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSString *result1 = [NSString new];
    NSDictionary *dic = [results objectAtIndex:0];
    
    if (!isLast) {
        NSArray *keys = [dic allKeys];
        result1 = [keys componentsJoinedByString:@","];
        //将语音听写的赋值给搜索框
        _search.text = result1;
        [_search becomeFirstResponder];
        [self handleSearchForTerm:result1];
    }
    
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer stopListening];
    
    _speakView.hidden = YES;
    self.markView.hidden = YES;
}

#pragma mark - 懒加载
-(NSMutableArray *)dataArray {
    
    if (!_dataArray)  {
        
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
