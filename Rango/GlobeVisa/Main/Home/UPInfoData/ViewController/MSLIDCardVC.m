//
//  MSLIDCardVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/8.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLIDCardVC.h"
#import "DefaultCell.h"
#import "IDCardHeadView.h"
#import "MSLContactModel.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "NSData+Base64.h"   // 计算图片大小使用
#import "DJCameraViewController.h"  //相机
//#import "DJCameraManager.h"   //相机

#import "DatePicker.h"
#import "MSLIDRecognitionModel.h"

@interface MSLIDCardVC ()<UITableViewDataSource,UITableViewDelegate,DJCameraViewControllerDeletate,UITextFieldDelegate,DatePickerDelegate>
{
    UITableView *_tableView;
    UIView *_footView;          //  温馨提示

    IDCardHeadView *_headView;      // 头视图
    DefaultCell *_sexCell;          //  性别
    DefaultCell *_dateCell;         //  日期
    MBProgressHUD *_proHUD;      // 小菊花
    
    UIButton *_nextBtn;         // 确定按钮

    UIImage *_defaImg;           // 相机图片
    UIImage *_fontImg;      //第一张图骗
    UIImage *_backImg;      //第二张图骗
    UITextField *_markTF;        // 替代品  用来释放键盘
    MSLIDRecognitionModel *_IDCradModel; // 身份证model

    NSArray *_titleArr;         //  名称数组
    NSString *_birthday;        //  出生日期
    NSInteger _selectIndex;     //  防止重复点击按钮
    NSInteger _biaoshi;         //  判断 点击的哪一个 照片按钮   0: 正面   1 是反面
    
    NSString *_issue_authority; // 签发机关
    NSString *_valid_period;      // 有效日期
  
//    BOOL _fontChange;           // 正面是否修改
//    BOOL _backChange;           // 反面是否修改
    
    BOOL _isChange;             //  判断文本是否修改
    BOOL isCancel;              //  是否取消拍照
    NSDictionary *_param;  // 上传的数据

    
    
}

@property (nonatomic, strong)  DatePicker *datepic;          //日期选择
@property (nonatomic, strong)  UIView *markView;          //遮罩视图
@property (nonatomic, strong)   PackageAPI *package;
@property (nonatomic,copy) NSString *eleString;
@property (nonatomic, strong)  MSLContactModel *contactModel;//联系人model

@end

@implementation MSLIDCardVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _tableView.userInteractionEnabled = YES;
    _isChange = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _issue_authority = @"";
    _valid_period = @"";
    _biaoshi = 0;
    _defaImg = [UIImage imageNamed:@"photo"];
    
    self.view.backgroundColor = COLOR_247;
    self.title = @"身份证";
    _titleArr = @[@"姓名",@"性别",@"民族",@"出生日期",@"地址",@"身份证号",@"签发机关",@"有限期限"];

    [self creatTableView];
    [self createTableViewFoot];
    [self createNextBtn];
    [self loadData];
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)fontImgTap:(UITapGestureRecognizer *)tap {
    
    _biaoshi = tap.view.tag;
    [self getIntoCamera];
}

#pragma mark - - - - - - - - - - UITableViewDataSource - - - - - - - - - - -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return !_IDCradModel ? 0 : _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        _sexCell = [tableView dequeueReusableCellWithIdentifier:@"sexCell"];
        if (!_sexCell) {
            _sexCell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:nil options:nil] objectAtIndex:1];
        }
        _sexCell.sexTitleLab.text = _titleArr[indexPath.row];
        _sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _sexCell.sex = [NSString stringWithFormat:@"%@",_IDCradModel.sex];
        return _sexCell;
    }
    
    if (indexPath.row == 3) {
        
        _dateCell = [tableView dequeueReusableCellWithIdentifier:@"dateCell"];
        if (!_dateCell) {
            _dateCell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:nil options:nil] objectAtIndex:2];
        }
        _dateCell.dateTitleLab.text = _titleArr[indexPath.row];
        _dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _dateCell.dateTextLab.text = [NSString stringWithFormat:@"%@",_IDCradModel.birthday];
        
        return _dateCell;
    }
    
    DefaultCell *defaCell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!defaCell) {
        defaCell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    defaCell.valueTF.tag = 1000 + indexPath.row;
    defaCell.valueTF.delegate = self;
    defaCell.titleLab.text = _titleArr[indexPath.row];
    defaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0: defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_IDCradModel.name];            break;
        case 2: defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_IDCradModel.folk];            break;
        case 4: defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_IDCradModel.address];         break;
        case 5: defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_IDCradModel.cardno];          break;
        case 6: defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_issue_authority]; break;
        case 7: defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_valid_period];    break;
        default: break;
    }

    if (indexPath.row == _titleArr.count - 1) {
        defaCell.isLast = YES;
    }
    return defaCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 39 * WIDTH / 375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3 && _selectIndex != indexPath.row) {
        
        _selectIndex = indexPath.row;
        [self addDateSelectView];
    }
}

#pragma mark - 日期选择
- (DatePicker *)datepic {
    
    if (!_datepic) {
        
        //选择预约面试时间
        _datepic = [[DatePicker alloc]initWithFrame:CGRectMake(0, (HEIGHT - 64)/5 * 3, WIDTH,(HEIGHT - 64)/5*2)];
        _datepic.delegate = self;
        _datepic.datePicker.maximumDate = [NSDate date];
        _datepic.backgroundColor = COLOR_247;
        [self.view addSubview:_datepic];
        [_datepic becomeFirstResponder];
    }
    return _datepic;
}

- (UIView *)markView {
    
    if (!_markView) {
        _markView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markViewTapAction:)];
        [_markView addGestureRecognizer:tap];
        [self.view addSubview:_markView];
    }
    return _markView;
}
//  日期选择
- (void)addDateSelectView {
    
    _tableView.userInteractionEnabled = NO;
    self.markView.hidden = NO;
    self.datepic.frame = CGRectMake(0, (HEIGHT - 64)/5 * 3, WIDTH,(HEIGHT - 64)/5*2);
}

- (void)markViewTapAction:(UITapGestureRecognizer *)tap {
    _tableView.userInteractionEnabled = YES;
    [_datepic dismiss];
    _markView.hidden = YES;
    _selectIndex = 0;
}

- (void)datePickerView:(DatePicker *)datePickerView didClickSureBtnWithSelectDate:(NSString *)date{
    
    _isChange = YES;
    _tableView.userInteractionEnabled = YES;
    _IDCradModel.birthday = date;
    _selectIndex = 0;
    _markView.hidden = YES;
    [_tableView reloadData];
}

#pragma mark - - - - - - - - - - 图片识别 - - - - - - - - - - -
// 底部显示动画
- (void)presentIDCardSheet
{
    if (_biaoshi == 1000) { _birthday = @""; }
    
    if (!progressSheet) {
        progressSheet = [[UIActionSheet alloc] initWithTitle:@"识别中,请稍后⋯⋯" delegate: self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
        progressSheet.actionSheetStyle =  UIActionSheetStyleAutomatic;
        progressBar = [[UIProgressView alloc] initWithFrame: CGRectZero];
        [progressBar setProgressViewStyle: UIProgressViewStyleBar];
        [progressSheet addSubview: progressBar];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [progressSheet addSubview: activityView];
        [activityView startAnimating];
    }
    
    progressBar.frame = CGRectMake(30.0f, 45.0f, 320 - 60.0f, 9.0f);
    activityView.frame = CGRectMake(320 / 2 - 20.0f, -120.0f, 40.0f, 40.0f);
    
    [progressBar setProgress:0.0f];
    [progressSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)startRec {
    
    NSString *docs2 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/aa.jpg"] ;
    //
    YM_SaveImage(_bImage,(char*)[docs2 UTF8String]);
  
    idCardImage = _biaoshi == 1000 ? _headView.fontImg.image : _headView.backImg.image;
    NSData *sendImageData = UIImageJPEGRepresentation(idCardImage, 0.1f);
    
    NSUInteger sizeOrigin = [sendImageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > 5*1024) {
        
        [progressSheet dismissWithClickedButtonIndex:0 animated:YES];
        [CXUtils createAllTextHUB:@"图片大小超过5M，请重试"];
        return;
    }
    
    self.package = [[PackageAPI alloc]init];
    __block typeof(MSLIDCardVC *)weakSelf = self;
    //数据请求  上传数据包
    [_package AFNuploadPackage:sendImageData Success:^(NSString *retStr, BOOL isSuccess) {
        [progressSheet dismissWithClickedButtonIndex:0 animated:YES];
        
//        if (isCancel == YES) { isCancel = NO; return ; }
       
        if (isSuccess) {
           
            [weakSelf recongnitionResult:retStr];
        } else{
            
            [weakSelf recongnitionResult:nil];
            [CXUtils createAllTextHUB:@"解析出错，请稍后尝试"];
        }
        
    } Fail:^(NSError *error) {
        [progressSheet dismissWithClickedButtonIndex:0 animated:YES];
//        if (isCancel == YES) {
//            isCancel = NO;
//            return ;
//        }
        [weakSelf recongnitionResult:ERROR_SERVER];
    }];
}

//身份识别 回调结果
-(void)recongnitionResult:(id)sender {
    
    _dataStr= sender;
    
    NSArray *errorArr = @[ERROR_SERVER,ERROR_TIMEOUT,ERROR_NULL,ERROR_NotReachable];

    if ([errorArr containsObject:_dataStr]) {
        [self alertShow:_dataStr];
        return;
    }
    
    if ([_dataStr length]) {
        
        [self xmlResult:_dataStr];
        _IDCradModel.name = _contactModel.contact_name;
        [_tableView reloadData];
    }
}

- (NSString *)makeCardResultWithStr:(NSString*)dataStr {
    
    if (!dataStr.length) return nil;
    return dataStr;
}

// 获取识别结果
-(void)xmlResult:(NSString *)fanhuiData {
    
    NSDictionary *param = [BaseModel dictionaryWithJsonString:fanhuiData];
    
    if (_biaoshi == 1000) {
        _IDCradModel = [[MSLIDRecognitionModel alloc] initWithDictionary:param[@"data"][@"item"]];
        [self changeReconFormat];
 
    }else {
    
        NSString *issue_authority = [NSString stringWithFormat:@"%@",param[@"data"][@"item"][@"issue_authority"]];
        NSString *valid_period = [NSString stringWithFormat:@"%@",param[@"data"][@"item"][@"valid_period"]];
        
        if (issue_authority.length > 4) {_issue_authority = issue_authority; }
        if (valid_period.length > 4) { _valid_period = valid_period ; }
    }
}
// 身份证正面
- (void)changeReconFormat {
    //修改时间格式
    NSString *birthday = [NSString stringWithFormat:@"%@",_IDCradModel.birthday];
    NSString *address = [NSString stringWithFormat:@"%@",_IDCradModel.address];
    NSString *cardno = [NSString stringWithFormat:@"%@",_IDCradModel.cardno];

    if ([birthday containsString:@"年"] && [birthday containsString:@"月"] && [birthday containsString:@"日"]) {
        _IDCradModel.birthday =  [_IDCradModel.birthday stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
        _IDCradModel.birthday =  [_IDCradModel.birthday stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        _IDCradModel.birthday =  [_IDCradModel.birthday stringByReplacingOccurrencesOfString:@"日" withString:@""];
    }
    
    if (birthday.length < 4) { _IDCradModel.birthday = @""; }
    if (address.length < 4) { _IDCradModel.address = @""; }
    if (cardno.length < 4) { _IDCradModel.cardno = @"";
    }else if(cardno.length > 18) {
        _IDCradModel.cardno = [cardno substringToIndex:18];
    }
    //删除签发机关和有限期限
//    _IDCradModel.issue_authority = @"";
//    _IDCradModel.valid_period = @"";
}
#pragma mark - - - - - - - - - - -  解析结束 - - - - - - - - - - -

#pragma mark - - - - - - - - - - textfield代理 - - - - - - - - - - -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _markTF = textField;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _isChange = YES;
    
    switch (textField.tag - 1000) {
        case 0: _IDCradModel.name = textField.text;             break;
        case 2: _IDCradModel.folk = textField.text;             break;
        case 4: _IDCradModel.address = textField.text;          break;
        case 5: _IDCradModel.cardno = textField.text;           break;
        case 6: _issue_authority = textField.text;  break;
        case 7: _valid_period = textField.text;     break;
        default: break;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    return YES;
}

#pragma mark - - - - - - - - - - 提示框 - - - - - - - - - - -
//当遇到识别信息解析 遇到 info 标签 调用
- (void)alertShow:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {  }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, WIDTH - 10, HEIGHT - 45 - [CXUtils statueBarHeight] - 44 - 5) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 10;
    _tableView.backgroundColor = COLOR_247;
    _tableView.showsVerticalScrollIndicator = NO;
    
    //head
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"IDCardHeadView" owner:nil options:nil] lastObject];
    _headView.clipsToBounds = YES;
    _headView.fontImg.tag = 1000;
    _headView.backImg.tag = 1001;
    UITapGestureRecognizer *fontTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontImgTap:)];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fontImgTap:)];
    [_headView.fontImg addGestureRecognizer:fontTap];
    [_headView.backImg addGestureRecognizer:backTap];
    
    _headView.fontImg.image = _defaImg;
    _headView.backImg.image = _defaImg;
    for (MSLOrderDatumModel *model in _imageArr) {
        
        if (model.path_name.length > 1 && [model.show_order intValue] == 1) {
            NSString *name = [NSString stringWithFormat:@"%@",model.path_name];
            [_headView.fontImg sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"id_fail"]];
            _headView.fontImg.contentMode = UIViewContentModeScaleToFill;
        }
        if (model.path_name.length > 1 && [model.show_order intValue] == 2) {
            [_headView.backImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.path_name]] placeholderImage:[UIImage imageNamed:@"id_fail"]];
            _headView.backImg.contentMode = UIViewContentModeScaleToFill;
        }else {
            
        }
    }
    _headView.heightCX = HEIGHT * 190/667;
    _tableView.tableHeaderView = _headView;
}

- (void)createTableViewFoot {
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0,  0, _tableView.widthCX,200)];
    _footView.backgroundColor = COLOR_247;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, _footView.widthCX, 30)];
    title.text = @"温馨提示";
    title.font = FONT_SIZE_14;
    
    UITextView *textLab = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, _footView.widthCX, 160)];
    textLab.text = @"· 如有错误可点击修改\n· 拍摄字体清晰可见不要反光";
    textLab.textColor = HWColor(153, 153, 153);
    textLab.font = FONT_SIZE_12;
    textLab.editable = NO;
    textLab.backgroundColor = [UIColor clearColor];
    [_footView addSubview:title];
    [_footView addSubview:textLab];
    _tableView.tableFooterView = _footView;
}
#pragma mark - - - - - - - - - - 下一步 - - - - - - - - - - -
- (void)createNextBtn {
    
    _nextBtn = [super createDownNextBtn];
    [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}

// 下一步
- (void)nextBtnAction:(UIButton *)sender {
    
    if ([_headView.fontImg.image isEqual: _defaImg] || [_headView.backImg.image isEqual:_defaImg]) {
        [CXUtils createAllTextHUB:@"请上传图片"];
        return;
    }
  
    if (!_IDCradModel) {  [CXUtils createAllTextHUB:@"请完善用户信息"]; return;  }
   
    if (![self checkData]) {  return; }
    
    // 修改联系人信息
    if (_contactChange) {
        if (_fontImg || _backImg) {
            
            [self upImage];
            
        }else if (_isChange) {
            
            [self changeContact];
        } else {
            [CXUtils createAllTextHUB:@"请先修改过信息"];
        }
    
    }else {
        if (_fontImg || _backImg) {
            
            [self upImage];
            
        }else if (_isChange) {
            
            [self changeContact];
        }else {
            [CXUtils createAllTextHUB:@"请先修改过信息"];

        }
        
    }
}

#pragma mark - - - - - - - - - - 请求身份证信息数据 - - - - - - - - - - -
- (void)loadData {
    
    [NetWorking getHUDRequest:CONTACTINFO_URL withParam:@{@"contact_id":_contactID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSDictionary *dic = responseObjc[@"result"];
        _contactModel = [[MSLContactModel alloc] initWithDictionary:dic];
        
        if (_contactModel.id_place_issuse.length < 2 ) {
            
            [_tableView reloadData];
            return;
        }
        _IDCradModel = [[MSLIDRecognitionModel alloc] init];
        _IDCradModel.name =_contactModel.contact_name;
        _IDCradModel.folk =_contactModel.nationality;
        _IDCradModel.sex =_contactModel.contact_sex;
        _IDCradModel.birthday =_contactModel.contact_birth;
        _IDCradModel.address =_contactModel.address;
        _IDCradModel.cardno = _contactModel.contact_number;
        _issue_authority =_contactModel.id_place_issuse;
        _valid_period =_contactModel.id_validity;
        
        [_tableView reloadData];
    } failBlock:^(NSError *error) { }];
}

//上传图片
- (void)upImage {
    NSString *showOrder;
    NSArray *upImgArr ;
    if (_fontImg && _backImg) {
        showOrder = @"1,2";
        upImgArr = @[_fontImg,_backImg];
    }else if (_backImg){
        showOrder = @"2";
        upImgArr = @[_backImg];
    }else {
        showOrder = @"1";
        upImgArr = @[_fontImg];
    }
    
    //    attachment_id visa_datum_type order_id detail_id is_del order_datum_id
    MSLOrderDatumModel *model = _imageArr[0];
    
    if (_contactChange) {
        NSDictionary *changeParam = @{@"attachment_id":model.attachment_id,@"visa_datum_type":@"1",@"contact_id":_contactID,@"detail_id":showOrder,@"is_del":@"0",@"visa_datum_id":model.visa_datum_id};
        [self contactChangeUpImage:changeParam withImage:upImgArr];
        return;
    }
    NSDictionary *orderParam = @{@"attachment_id":model.attachment_id,@"visa_datum_type":@"1",@"order_id":_orderID,@"detail_id":showOrder,@"is_del":@"0",@"order_datum_id":model.order_datum_id};

    [self orderUpImage:orderParam withImage:upImgArr];
}
// 申请人 修改 信息    上传图片
- (void)contactChangeUpImage:(NSDictionary *)param withImage:(NSArray *)upImgArr{
    
    [NetWorking postImagewithURL:UPIMG_CONTACR_URL withParam:param Images:upImgArr success:^(id responseObjc) {
        
        [self changeContact];
        
    } failBlock:^(NSError *error) { }];
}

// 订单流程  上传tu'pian
- (void)orderUpImage:(NSDictionary *)param withImage:(NSArray *)upImgArr{
    
    [NetWorking postImagewithURL:UPIMG_URL withParam:param Images:upImgArr success:^(id responseObjc) {
        
        [self changeContact];
        
    } failBlock:^(NSError *error) { }];
}
//修改联系人
- (void)changeContact {

    [NetWorking postHUDRequest:CHANGE_CONTACT_URL withParam:_param withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpInfoReLoadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactReLoadData" object:nil];
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) { }];
}

- (BOOL)checkData {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_issue_authority forKey:@"issue_authority"];
    [param setObject:_valid_period forKey:@"valid_period"];
    [param setObject:_contactID forKey:@"contact_id"];
    [param setObject:_IDCradModel.name forKey:@"contact_name"];
    [param setObject:_sexCell.manBtn.selected ? @"男":@"女" forKey:@"contact_sex"];
    [param setObject:_IDCradModel.folk forKey:@"nationality"];
    [param setObject:_IDCradModel.birthday forKey:@"contact_birth"];
    [param setObject:_IDCradModel.address forKey:@"address"];
    [param setObject:_IDCradModel.cardno forKey:@"contact_number"];
    [param setObject:_issue_authority forKey:@"id_place_issuse"];
    [param setObject:_valid_period forKey:@"id_validity"];
    
    for (NSString *key in param) {
        NSString *value = [NSString stringWithFormat:@"%@",param[key]];
        if (value.length == 0) {
            [CXUtils createAllTextHUB:@"请完善用户信息"];
            return NO;
        }
    }
    
    _param = param;
    return YES;
    
}
#pragma mark - - - - - - - - - - 进入相机 - - - - - - - - - - -
-(void)getIntoCamera{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，您没有开启调用相机权限，是否前往 设置-隐私-相机 中设置" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [queRenAlert setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        
        [alertTip addAction:queRenAlert];
        [self presentViewController:alertTip animated:YES completion:nil];
        
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            DJCameraViewController *VC = [[DJCameraViewController alloc]init];
            VC.delegateMy = self;
            VC.markImg.image =[[UIImage imageNamed:(_biaoshi == 1000 ? @"front":@"behind")] stretchableImageWithLeftCapWidth:WIDTH topCapHeight:HEIGHT - 139];
            [self presentViewController:VC animated:YES completion:nil];
        }
        else
        {
            UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于您的设备暂不支持摄像头，您无法使用该功能!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertTip addAction:queRenAlert];
            [self.navigationController presentViewController:alertTip animated:YES completion:nil];
        }
    }
}

-(void)selectPaiShePhotos:(UIImage *)photosMy {
    
    [self getUserSelectImage:photosMy];
}

-(void)selectAlbumPhotos:(UIImage *)photosAlbum{
    [self getUserSelectImage:photosAlbum];
}
//获取用户 选择 或者拍照的图片
- (void)getUserSelectImage:(UIImage *)photoArr {
    
    if (photoArr == nil) { return;  }
    
    UIImage *image = photoArr;
    
    if (_biaoshi == 1000) {
        
        _fontImg = image;
        [_headView.fontImg setImage:image];
        _headView.fontImg.contentMode = UIViewContentModeScaleToFill;
        
    } else if(_biaoshi == 1001) {
        
        _backImg = image;
        [_headView.backImg setImage:image];
        _headView.backImg.contentMode = UIViewContentModeScaleToFill;
    }
    
    [self presentIDCardSheet];
    [self startRec];
}


@end
