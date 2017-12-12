//
//  MSLBankSeachVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLBankSeachVC.h"
#import "MSLBankSearchCell.h"
#import "MSLPayTabCell.h"
@interface MSLBankSeachVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{UIView *_bar;
    NSMutableArray *_dataArr;
    NSArray *_allData;
    NSMutableArray *_nameArr;
    UITableView *_tableView;
}

@end

@implementation MSLBankSeachVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bar = [super createNavigationBar];
    self.barName.text = @"银行网点";
    UIImageView *image = [[UIImageView alloc] initWithFrame:_bar.bounds];
    image.userInteractionEnabled = YES;
    [_bar addSubview:image];
    [_bar insertSubview:image atIndex:0];
    image.image = [UIImage imageNamed:@"bar_blue"];
    [self.view addSubview:_bar];
    [self createTab];
    [self loadData];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)selfBackBtnAction {
    
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

- (void)createTab {

    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, _bar.heightCX, WIDTH, 50)];
    MSLPayTabCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLPayTabCell" owner:nil options:nil] objectAtIndex:2];
    
    cell.frame = head.bounds;
    cell.searchBtn.hidden = YES;
    cell.searchTF.delegate = self;
    cell.searchTF.userInteractionEnabled = YES;
    head.clipsToBounds = YES;
    [head addSubview:cell];
    [self.view addSubview:head];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _bar.heightCX + head.heightCX, WIDTH, HEIGHT- 50 - 44 - [CXUtils statueBarHeight]) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_245;
}
#pragma mark - - - - - - - - - - UITextFileDelegate - - - - - - - - - - -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    NSString *text =[str stringByReplacingCharactersInRange:range withString:string];

    [self  changeData:text];
    return YES;
}


#pragma mark - - - - - - - - - - UITableviewDelegate - - - - - - - - - - -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLBankSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankSearch"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLBankSearchCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate bankSearchwithModel:_dataArr[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

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
#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -

- (void)changeData:(NSString *)key {
    
    [_dataArr removeAllObjects];
    for (MSLBankModel *model in _allData) {
        
        if ([model.name containsString:key] || [model.address containsString:key]) {
            [_dataArr addObject:model];
        }
    }
    
    
    [_tableView reloadData];
}
- (void)loadData {
    
    _dataArr = [[NSMutableArray alloc] init];
    _nameArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:URL_BANK_DOT_CONTACTS withParam:nil withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSArray *result = responseObjc[@"result"];
        
        for (NSDictionary *dic in result) {
            
            MSLBankModel *model = [[MSLBankModel alloc] initWithDictionary:dic];
            [_nameArr addObject:model.name];
            [_dataArr addObject:model];
            
        }
        _allData = [[NSArray alloc] initWithArray:_dataArr];
        [_tableView reloadData];
    } failBlock:^(NSError *error) { }];
}

@end
