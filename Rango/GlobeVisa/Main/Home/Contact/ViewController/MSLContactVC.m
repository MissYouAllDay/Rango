
//
//  MSLContactVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/2.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLContactVC.h"
#import "MSLContactCell.h"
#import "MSLContactAddView.h"
#import "SelectDateVC.h"
#import "MSLContactModel.h"
#import "MSLUpInfoDataVC.h"
@interface MSLContactVC ()<UITableViewDelegate,UITableViewDataSource,CXDateSelectDelegate>
{
    
    UITableView *_tableView;
//    UIView *_addBgView;     // 新增联系人底层视图
    MSLContactAddView *_addView;    // 新增联系人视图
    UIButton *_nextBtn;         //下一步

    NSMutableArray *_dataArr;   // lianxiren 数据
    NSMutableArray *_jobArr;        // 人员类型

    CGFloat _sectionZeroHei;     // sectionOneHead的高度
    CGFloat _sectionOneHei;     // sectionOneHead的高度

    NSInteger _jobSelect;   // 选定的人员类型的位置
    
    NSInteger _dateIndex;      // 判断选择的是返回时间还是出发时间 1400 出发时间  1401 返回时间
    
    NSString *_outDate;      //出发日期
    
    NSString *_returnDate;  // 返回时间
    
    NSInteger _contactSelectIndex;   // 刚刚选择的联系人位置
    NSInteger _contactOldSeleIndex;  //  以前 选择的联系人 位置
    
    NSInteger _doType;      // 操作类型哦那个   从下个界面返回：99   新增： 0  修改 ：1
}
@property (strong, nonatomic) UIView *addBackGroundView;
@end

@implementation MSLContactVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请人";
//    _dataArr = [[NSMutableArray alloc] initWithObjects:@"不打野",@"不清兵",@"不带线",@"不杀人",@"只管送", nil];
//    [_dataArr removeAllObjects];
    _doType = -1;
    _jobSelect = -1;
    _contactSelectIndex = -1;
    _sectionZeroHei = 0.01;
    _sectionOneHei = 44;
    self.addBackGroundView.backgroundColor = COLOR_245;
    [self createTab];
    [self createNextBtn];
    [self loadData];
    [self loadJobData];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    } else {

        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)createTab {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 45 - [CXUtils statueBarHeight] - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_245;
}

#pragma mark - - - - - - - - - - 下一步  - - - - - - - - - - -
- (void)createNextBtn {
    
    _nextBtn = [super createDownNextBtn];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}

- (void)nextBtnAction:(UIButton *)sender {
    
//     如果第一次进入没有数据时 或者 使用新的联系人 的时候进行下一步的操作
    if (_contactSelectIndex == -1 && (_dataArr.count == 0 || _dataArr == nil) ) {
        
        // 新增并下单
        [self checkAddContactInfoData:sender];
    }else {
        if (_contactSelectIndex == -1) {
            
            [CXUtils createAllTextHUB:@"请选择联系人"];
            return;
        }else {
            [self addOrder];
        }
    }
}

#pragma mark - - - - - - - - - - UITableviewDelegate - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return section == 0  && _sectionZeroHei != 0.01  ? _dataArr.count : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? _sectionZeroHei : _sectionOneHei;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == 0 ? 20 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_245;
   return nil;
}

#pragma mark - - - - - - - - - - 创建cell - - - - - - - - - - -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLContactCell" owner:nil options:nil] lastObject];
    }
    
    cell.contentView.backgroundColor = COLOR_245;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.frame = CGRectMake(20, 0, WIDTH, cell.heightCX);
    
    if (_contactSelectIndex == indexPath.row) {
        
        cell.rightImg.image = [UIImage imageNamed: @"proposer_sele"];
        
    }else {
        cell.rightImg.image = [UIImage imageNamed:@"proposer_unsele"];
        
    }
    //如果只有一个数据的时候
    if (_dataArr.count != 0) {
        
        MSLContactModel *model = _dataArr[indexPath.row];
        cell.name.text = model.contact_name;
        if (_dataArr.count == 1) {
            
            cell.bgImg.image = [[UIImage imageNamed:@"whiteR"] stretchableImageWithLeftCapWidth:20 topCapHeight:2];
            [cell normalView];
            return cell;
        }
    }

    if (indexPath.row == 0) {
        [cell upView];
    }else if (indexPath.row == _dataArr.count -1 ) {
        [cell bottomView];
    }else {
        [cell normalView];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _sectionZeroHei = 0.01;
    _sectionOneHei = 440;
    
    _addView.addBtn.selected = YES;
    _contactSelectIndex = indexPath.row;
    
    MSLContactModel *model = _dataArr[indexPath.row];
    _addView.nameTF.text = model.contact_name;
    _addView.telTF.text = model.contact_phone;
    _addView.messageTF.text = model.e_mail;
    _addView.nameTF.userInteractionEnabled = NO;

    int i = 0;
    for (NSDictionary *dic in _jobArr) {

        if ([dic[@"cust_type"] intValue] == [model.cust_type intValue]) {
            _jobSelect = i;
            _addView.jobLab.text = dic[@"cust_type_name"];
            [_addView.jobBtn setTitle:nil forState:UIControlStateNormal];
        }
        i ++;
    }

    [_addView.addBtn setTitle:model.contact_name forState:UIControlStateSelected];
    [_addView.addBtn setImage:[UIImage new] forState:UIControlStateSelected];
    _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:1];
    _nextBtn.userInteractionEnabled = NO;
    [_addView returnOldStatue:_addView.outBtn];
    [_addView returnOldStatue:_addView.returnBtn];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];

}

#pragma mark - - - - - - - - - - 创建头视图- - - - - - - - - - -
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) { return [self sectionZeroView];  }
    
    if (section == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _sectionOneHei)];
        [bgView addSubview:self.addBackGroundView];
        [UIView animateWithDuration:0.35 animations:^{
            self.addBackGroundView.heightCX = _sectionOneHei;
            _addView.heightCX = _sectionOneHei;
        }];
        if (_dataArr.count == 0 || _dataArr == nil) {
            _addView.cancelBtn.hidden = YES;
            _addView.sureBtn.hidden = YES;
        }else {
            _addView.cancelBtn.hidden = NO;
            _addView.sureBtn.hidden = NO;
        }
        
        return bgView;
    }
    return nil;
}

// 使用已有联系人
- (UIView *)sectionZeroView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _sectionZeroHei == 0.01?0:_sectionZeroHei)];
    UILabel *sectionZero = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH, view.heightCX)];
    sectionZero.text = @"使用已有联系人";
    sectionZero.textColor = [UIColor colorWithHexString:@"#414141" alpha:1];
    sectionZero.backgroundColor = [UIColor clearColor];
    sectionZero.font = FONT_SIZE_14;
    [view addSubview:sectionZero];
    return view;
}
// 新建联系人
- (UIView *)addBackGroundView {
    
    if (!_addBackGroundView) {
        _addBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _sectionOneHei)];
        
        _addView = [[[NSBundle mainBundle] loadNibNamed:@"MSLContactAddView" owner:nil options:nil] lastObject];
        _addView.frame = CGRectMake(10, 0, WIDTH - 20, 440);
        _addView.layer.cornerRadius = 5;
        _addView.layer.borderWidth = 1;
        _addView.clipsToBounds = YES;
        _addView.layer.borderColor = HWColor(240, 240, 240).CGColor;
        _addView.backgroundColor = [UIColor whiteColor];
        [_addView.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _addView.clipsToBounds = YES;
        [_addBackGroundView addSubview:_addView];
        _addBackGroundView.clipsToBounds = YES;
        [_addView.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.sureBtn addTarget:self action:@selector(checkAddContactInfoData:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.jobBtn addTarget:self action:@selector(jobBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_addView.outBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.returnBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addBackGroundView;
}

//  新增联系人  点击事件
- (void)addBtnAction:(UIButton *)sender {
    
    if (sender.selected) { return; }
    _addView.jobLab.text = nil;
    [_addView.jobBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_addView.jobBtn setTitleColor:COLOR_211 forState:UIControlStateNormal];

    [_addView returnOldStatue:_addView.jobBtn];
    [_addView returnOldStatue:_addView.outBtn];
    [_addView returnOldStatue:_addView.returnBtn];

    sender.selected = YES;
    [_addView.addBtn setTitle:@"新增联系人" forState:UIControlStateSelected];
    [_addView.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateSelected];
    _contactSelectIndex = -1;
    
    _addView.nameTF.text = nil;
    _addView.telTF.text = nil;
    _addView.messageTF.text = nil;
    _addView.nameTF.userInteractionEnabled = YES;
    
    [_addView.jobBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_addView.jobBtn setTitleColor:COLOR_211 forState:UIControlStateNormal];
    
    _sectionZeroHei = 0.01;
    _sectionOneHei = 440;
    
    _nextBtn.backgroundColor = [UIColor colorWithHexString:@"#cccccc" alpha:1];
    _nextBtn.userInteractionEnabled = NO;

    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
}


// 取消anniu
- (void)cancelBtnAction:(UIButton *)sender {
    
    _contactSelectIndex = -1;
   
    [self changeStaues];
}

- (void)changeStaues {
    
    _addView.addBtn.selected = NO;
    
    _sectionZeroHei = 44;
    _sectionOneHei = 44;
    
    _nextBtn.backgroundColor = COLOR_BUTTON_BLUE;
    _nextBtn.userInteractionEnabled = YES;
    [_addView.addBtn setTitle:@"新建联系人" forState:UIControlStateNormal];
    [_addView.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
//    [_tableView reloadData];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

// 校验 数据是否准确   确定按钮 相应事件
- (void)checkAddContactInfoData:(UIButton *)sender {
    
    if (_addView.telTF.text.length == 0) {
        [CXUtils createAllTextHUB:@"请填写姓名"];
        return ;
    }
    if (![super checkTelNumber:_addView.telTF.text]) {
        [CXUtils createAllTextHUB:@"请填写正确的手机号"];
        return ;
    }
    if ([_addView.jobLab.text isEqualToString:@"请选择"]) {
        [CXUtils createAllTextHUB:@"请选择职业"];
        return;
    }
    if ([_addView.outBtn.titleLabel.text isEqualToString:@"请选择"]) {
        [CXUtils createAllTextHUB:@"请选择出行时间"];
        return;
    }
    if ([_addView.returnBtn.titleLabel.text isEqualToString:@"请选择"]) {
        [CXUtils createAllTextHUB:@"请选择返回时间"];
        return;
    }
    
    if (![super checkEmail:_addView.messageTF.text]) {
        [CXUtils createAllTextHUB:@"请填写正确的邮箱"];
        return;
    }
    
    if ([super compareOneDay:_addView.outBtn.currentTitle withAnotherDay:_addView.returnBtn.currentTitle] != 1) {
        [CXUtils createAllTextHUB:@"返回时间必须晚于出行时间"];
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_addView.nameTF.text forKey:@"contact_name"];
    [param setObject:_addView.telTF.text forKey:@"contact_phone"];
    [param setObject:_addView.messageTF.text forKey:@"e_mail"];
    [param setObject:[NSString stringWithFormat:@"%@",_jobArr[_jobSelect][@"cust_type"]] forKey:@"cust_type"];

    [param setObject:TOKEN_VALUE forKey:@"token"];

    // 创建并下单
    if (_dataArr.count == 0 || _dataArr == nil) {
        
        [param setObject:[NSString stringWithFormat:@"%@",_merModel.visa_id] forKey:@"visa_id"];
        [param setObject:_addView.outBtn.titleLabel.text forKey:@"depart_time"];
        [param setObject:_addView.returnBtn.titleLabel.text forKey:@"return_time"];
        [param setObject:@"0" forKey:@"contact_id"];
        [param setObject:@"1" forKey:@"is_app"];
        [param setObject:TOKEN_VALUE forKey:TOKEN_KEY];
        [self addNewContactAndPostContactInfoData:[NSMutableDictionary dictionaryWithDictionary:param]];
    }else {
        
        _doType = _contactSelectIndex == -1 ? 0 : 1;
        [self postContactInfoData:[NSMutableDictionary dictionaryWithDictionary:param] reloadData:_contactSelectIndex == -1];
    }
}


#pragma mark - - - - - - - - - - 发送数据 - - - - - - - - - - -
// 下单
- (void)addOrder {
    
    if (_outDate.length < 1) {
        [CXUtils createAllTextHUB:@"请选择出行时间"];
        return;
    }
    if (_returnDate.length < 1) {
        [CXUtils createAllTextHUB:@"请选择返回时间"];
        return;
    }
    MSLContactModel *model = _dataArr[_contactSelectIndex];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:model.cust_type forKey:@"cust_type"];
    [param setObject:_merModel.visa_id forKey:@"visa_id"];
    [param setObject:model.contact_id forKey:@"contact_id"];
    [param setObject:TOKEN_VALUE forKey:TOKEN_KEY];
    [param setObject:_returnDate forKey:@"return_time"];
    [param setObject:_outDate forKey:@"depart_time"];
    [NetWorking postHUDRequest:ADD_ORDER_URL withParam:param withErrorCode:YES withHUD:NO success:^(id responseObjc) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
        
        if ([errorCode isEqualToString:@"3"]) {
            
            [self showAlert:responseObjc[@"reason"] withParam:responseObjc[@"listOrder"][0]];
            return ;
        }
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responseObjc[@"reason"]];
            
            return ;
        }
        MSLUpInfoDataVC * vc = [[MSLUpInfoDataVC alloc] init];
        vc.orderID = responseObjc[@"reason_id"];
        vc.contactID = model.contact_id;
        [self.navigationController pushViewController:vc animated:YES];
    } failBlock:^(NSError *error) {
        
        
    }];
}
// 新增联系人并发布
- (void)addNewContactAndPostContactInfoData:(NSMutableDictionary *)param {
    
    [NetWorking postHUDRequest:ADD_POSTORDER_URL withParam:param withErrorCode:YES withHUD:NO success:^(id responseObjc) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
        
        if (![errorCode isEqualToString:@"0"]) {
            
            [CXUtils createAllTextHUB:responseObjc[@"reason"]];
            return ;
        }
        
        _doType = 99;
        MSLUpInfoDataVC *vc = [[MSLUpInfoDataVC alloc] init];
        vc.orderID = responseObjc[@"reason_id"];
        vc.contactID = responseObjc[@"contact_id"];
        [self.navigationController pushViewController:vc animated:YES];
        
        _contactSelectIndex = 0;
        [self loadData];
        
    } failBlock:^(NSError *error) {  }];
}

// 新增 联系人           reloadData ： 是否重新请求数据
- (void)postContactInfoData:(NSMutableDictionary *)param reloadData:(BOOL)reloadData {
   
    [param removeObjectForKey:@"depart_time"];
    [param removeObjectForKey:@"return_time"];
    if (_contactSelectIndex != -1) {
        MSLContactModel *mode = _dataArr[_contactSelectIndex];
        [param setObject:[NSString stringWithFormat:@"%@",mode.contact_id] forKey:@"contact_id"];
    }else {
        [param setObject:@"0" forKey:@"contact_id"];
    }
    [NetWorking postHUDRequest:ADD_CONTACT_URL withParam:param withErrorCode:YES withHUD:NO success:^(id responseObjc) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",responseObjc[@"error_code"]];
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];

        if (![errorCode isEqualToString:@"0"]) { return ; }
        
        [self changeStaues];

        if (_contactSelectIndex == -1) {
            
            [self loadData];
        }
        
        // 请求联系人    新增的时候使用
      

    } failBlock:^(NSError *error) { }];
}

#pragma mark - - - - - - - - - -  获取数据 - - - - - - - - - - -
// 获取人员类型
- (void)loadJobData {
    
    [NetWorking getHUDRequest:JOB_URL withParam:@{@"visa_id":_merModel.visa_id} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        _jobArr = [[NSMutableArray alloc] initWithArray:responseObjc[@"result"]];
        
    } failBlock:^(NSError *error) { }];
}

//联系人数据
- (void)loadData {
    
    _dataArr = [[NSMutableArray alloc] init];
    [NetWorking getHUDRequest:CONTACT_QUERY withParam:@{TOKEN_KEY:TOKEN_VALUE} withErrorCode:YES withHUD:NO success:^(id responseObjc) {
        
        NSArray *dataArr = responseObjc[@"result"];

        if ([dataArr isKindOfClass:[NSNull class]]){
            
            _sectionZeroHei = 0.01;
            _sectionOneHei = 380;
            _addView.addBtn.selected = YES;
            _contactSelectIndex = -1;
            [CXUtils createAllTextHUB:responseObjc[@"reason"]];
            [_tableView reloadData];
            return ;
        }
        if (dataArr == nil || dataArr.count == 0 ) {
            _sectionZeroHei = 0.01;
            _sectionOneHei = 380;
            _addView.addBtn.selected = YES;
            _contactSelectIndex = -1;
            [CXUtils createAllTextHUB:responseObjc[@"reason"]];
            [_tableView reloadData];

            return ;
        }
       
        for (NSDictionary *dic in dataArr) {
            
            MSLContactModel *model = [[MSLContactModel alloc] initWithDictionary:dic];
            [_dataArr addObject:model];
        }
        _sectionZeroHei = 44;
        _sectionOneHei = 44;
        _addView.addBtn.selected = NO;
        
        // 新增
        if (_doType == 0) {
            
            _contactSelectIndex = _dataArr.count - 1;
        }
        [_tableView reloadData];

    } failBlock:^(NSError *error) { }];
}

- (void)showAlert:(NSString *)message withParam:(NSDictionary *)param{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MSLUpInfoDataVC *vc = [[MSLUpInfoDataVC alloc] init];
        vc.orderID = param[@"order_id"];
         MSLContactModel *model = _dataArr[_contactSelectIndex];
        vc.contactID = model.contact_id;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:^{ }];
}

// 选择job 弹窗
- (void)jobBtnAction {
    
    if (_jobArr == nil || _jobArr.count == 0) {
        [CXUtils createAllTextHUB:@"获取人员类型失败"];
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"职业类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < _jobArr.count ; i ++) {
        UIAlertAction *act = [UIAlertAction actionWithTitle:_jobArr[i][@"cust_type_name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _jobSelect = i;
            NSString *jobStr = _jobArr[i][@"cust_type_name"];
            _addView.jobLab.text = jobStr;
            [_addView.jobBtn setTitle:nil forState:UIControlStateNormal];
        }];
        [alert addAction:act];
    }
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
    [alert addAction:act1];
    
    [self presentViewController:alert animated:YES completion:^{ }];
}

#pragma mark - - - - - 选择日期 - - - - - -
- (void)selectDate:(UIButton *)sender {
    
    _dateIndex = sender.tag - 1400;
    
    NSInteger returnDate = 0;
    
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDate = [matter stringFromDate:[NSDate date]];
    if (_dateIndex == 1 && [_addView.outBtn.titleLabel.text isEqualToString:@"请选择"]) {
        
        [CXUtils createAllTextHUB:@"请先选择预计出行日期"];
    }else{
        //选择近期出行时间
        SelectDateVC * selectDate = [[SelectDateVC alloc]init];
        selectDate.startDate = _dateIndex == 0 ? [NSString stringWithFormat:@"%ld",(long)returnDate] : [NSString stringWithFormat:@"%ld",(long)[CXUtils daysFromBeginDate:[NSDate date] endDate:_outDate] + 2];
        selectDate.endDate = endDate;
        selectDate.delegate = self;
        selectDate.yuJiChuxingDate = [NSString stringWithFormat:@"%@",_addView.outBtn.titleLabel.text];
        selectDate.traveOrReturnTag = [NSString stringWithFormat:@"%ld",(long)_dateIndex];
        [self.navigationController pushViewController:selectDate animated:YES];
    }
}

// 日历 代理
- (void)calendarDateSelect:(NSString *)date {
    
    if (_dateIndex == 0) {
        _outDate = date;
        [_addView.outBtn setTitle:_outDate forState:UIControlStateNormal];
        [_addView.outBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else {
        _returnDate = date;
        [_addView.returnBtn setTitle:_returnDate forState:UIControlStateNormal];
        [_addView.returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end
