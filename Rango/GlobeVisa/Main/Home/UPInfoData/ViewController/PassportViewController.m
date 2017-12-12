//
//  PassportViewController.m
//  GlobeVisa
//
//  Created by MSLiOS on 2017/6/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "PassportViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "MSLContactModel.h"
#import "DJCameraViewController.h"
#import "DJCameraManager.h"
#import "PassportHeadView.h"
#import "DefaultCell.h"
#import "DatePicker.h"

@interface PassportViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,NSXMLParserDelegate,UITextFieldDelegate,DJCameraViewControllerDeletate,UITableViewDelegate,UITableViewDataSource,DatePickerDelegate>
{
    UITableView *_tableView;
    PassportHeadView *_headView;    //头视图
    UIView *_footView;
    
    UIButton *_nextBtn;         // queding
    
    NSArray *passportTitleArr;      //名称数组
    NSMutableArray *_dataArr;       //数据数组

    DefaultCell *_sexCell;          //性别
    DefaultCell *_dateCell;         //日期
    
    NSInteger _selectIndex;         //防止重复点击日期
    UIImage *_image;                //加载失败的图片
    UITextField *_markTF;           // 用来释放键盘

    
    BOOL _isChange;   //内容是否修改
    BOOL orderChange;//是否上传成功
    BOOL infoiChange;//是否上传成功
    BOOL _haveImg;                  //是否从手机获取到图片
}
@property (nonatomic, retain)   PackageAPI *package;

@property (nonatomic,copy) NSString * name;//姓名
@property (nonatomic,copy) NSString * nameCh;//中文姓名
@property (nonatomic,copy) NSString * cardno;//护照号
@property (nonatomic,copy) NSString * sex;//性别
@property (nonatomic,copy) NSString * sexCH;//中文性别
@property (nonatomic,copy) NSString * birthday;//出生日期
@property (nonatomic,copy) NSString * address;// 英文出生地址
@property (nonatomic,copy) NSString * addressCH;//中文出生地址
@property (nonatomic,copy) NSString * issueAuthority;//签发地址
@property (nonatomic,copy) NSString * issueAddressCH;//签发地址中文
@property (nonatomic,copy) NSString * issueDate;//发证日期
@property (nonatomic,copy) NSString * validPeriod;//有效期
@property (nonatomic,copy) NSString * nation;//国籍


@property (nonatomic,copy) NSString *eleString;
@property (nonatomic, strong)  DatePicker *datepic;          //日期选择
@property (nonatomic, strong)  UIView *markView;          //遮罩视图
@property (nonatomic, strong) MSLContactModel *contactModel;
@property (nonatomic, strong) NSXMLParser *parserXML;
-(void)parse;

@end


static BOOL isCancel;

@implementation PassportViewController
{
    UIView * tipView_My;
    MBProgressHUD *_proHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_247;
    self.title = @"护照信息";

    /*
     1、中文姓名 2、英文姓名 3、护照号码 4、国家码 5、中文性别 6、出生日期
     7、出生地点 8、英文出生地点 、签发日期 10、签发地点 11、英文签发地点
     12、国籍：由于识别不出来，默认填写中国，可修改  13、有效期至*/
    passportTitleArr = @[@"中文姓名",@"英文姓名",@"护照号码",@"国家码",@"中文性别",@"出生日期",@"出生地址",@"英文出生地址",@"签发日期",@"签发地点",@"英文签发地点",@"国籍",@"有限期至"];
    
    [self creatTableView];
    [self createNextBtn];

    [self loadData];
}
#pragma mark - 请求护照信息数据  进入页面时的请求
- (void)loadData {
    
    _dataArr = [[NSMutableArray alloc] init];
    
    [NetWorking getHUDRequest:CONTACTINFO_URL withParam:@{@"contact_id":_contactID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        NSDictionary *dic = responseObjc[@"result"];
        NSString *errorCode = [NSString stringWithFormat:@"%@",dic[@"error_code"]];
        if ([errorCode isEqualToString:@"1"]) { return ;  }
        
        _contactModel = [[MSLContactModel alloc] initWithDictionary:dic];
        if (_contactModel.passport_no.length < 1) {
            
            [_dataArr removeAllObjects];
            [_tableView reloadData];
            return;
        }
        [_dataArr addObject:_contactModel.contact_name];//中文名字
        [_dataArr addObject:_contactModel.e_contact_name];//英文名字
        [_dataArr addObject:_contactModel.passport_no];//护照编号  √
        [_dataArr addObject:_contactModel.now_nationality];//国家码
        [_dataArr addObject:_contactModel.contact_sex];//中文性别 √
        [_dataArr addObject:_contactModel.contact_birth];//出生日期  √
        [_dataArr addObject:_contactModel.passport_place_birth];//中文出生地址
        [_dataArr addObject:_contactModel.e_passport_place_birth];//英文出生地址
        [_dataArr addObject:_contactModel.passport_birth_time];//发证日期  √
        [_dataArr addObject:_contactModel.passport_place_issuse];//中文签发地址  √
        [_dataArr addObject:_contactModel.e_passport_place_issuse];//英文签发地址
        [_dataArr addObject:_contactModel.passport_nationality];//国籍
        [_dataArr addObject:_contactModel.passport_validity_time];//有限期  √
        
        [_tableView reloadData];
        
    } failBlock:^(NSError *error) { }];
}

#pragma mark - UITableView
- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, WIDTH - 10, HEIGHT - 45 - [CXUtils statueBarHeight] - 44 - 5) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.cornerRadius = 10;
    _tableView.backgroundColor = COLOR_247;
    _tableView.showsVerticalScrollIndicator = NO;
    
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"PassportHeadView" owner:nil options:nil] lastObject];
    
    UITapGestureRecognizer *passportTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passportTap:)];
    [_headView.passportImagheView addGestureRecognizer:passportTap];
    
    if (_datumModel.path_name.length > 1) {
        _headView.passportImagheView.contentMode = UIViewContentModeScaleToFill;
        [_headView.passportImagheView sd_setImageWithURL:[NSURL URLWithString: _datumModel.path_name] placeholderImage:[UIImage imageNamed:@"post_fail"]];
    }
    
    _headView.heightCX = 245;
    _tableView.tableHeaderView = _headView;

    
    // FOOT
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0,  0, _tableView.widthCX,200)];
    _footView.backgroundColor = COLOR_247;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, _footView.widthCX, 30)];
    title.text = @"温馨提示";
    title.font = FONT_SIZE_14;
    
    UITextView *textLab = [[UITextView alloc] initWithFrame:CGRectMake(15, 40, _footView.widthCX, 160)];
    textLab.text = @"· 如有错误可点击修改\n· 拍摄字体清晰可见不要反光";
    textLab.textColor =  HWColor(153, 153, 153);
    textLab.font = FONT_SIZE_12;
    textLab.editable = NO;
    textLab.backgroundColor = [UIColor clearColor];
    [_footView addSubview:title];
    [_footView addSubview:textLab];
    _tableView.tableFooterView = _footView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _markTF = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _dataArr[textField.tag - 2000] = textField.text;
}

- (void)passportTap:(UITapGestureRecognizer *)tap {
    
    [self passportGetIntoCamera];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArr.count == 0) {
        
        return 0;
    }
    NSString *number = [NSString stringWithFormat:@"%@",_dataArr[2]];
  
    return number.length > 1 || _haveImg ? passportTitleArr.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //性别
    if (indexPath.row == 4) {
        
        _sexCell = [tableView dequeueReusableCellWithIdentifier:@"sexCell"];
        if (!_sexCell) {
            _sexCell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:nil options:nil] objectAtIndex:1];
        }
        _sexCell.sexTitleLab.text = passportTitleArr[indexPath.row];
        _sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dataArr.count > 1) {
            
            _sexCell.sex = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
        }
        return _sexCell;
    }
    
    //日期
    if (indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 12) {
        
        _dateCell = [tableView dequeueReusableCellWithIdentifier:@"dateCell"];
        if (!_dateCell) {
            _dateCell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:nil options:nil] objectAtIndex:2];
        }
        _dateCell.dateTitleLab.text = passportTitleArr[indexPath.row];
        _dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataArr.count > 1) {
            
            
            NSMutableString *birth = [[NSMutableString alloc] initWithString:_dataArr[indexPath.row]];
            
            if (![birth containsString:@"-"] && birth.length > 2) {
                [birth insertString:@"-" atIndex:4];
                [birth insertString:@"-" atIndex:7];
                
                if (indexPath.row == 5) { _birthday = birth; }
                
                _dataArr[indexPath.row] = birth;
            }
            _dateCell.dateTextLab.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
        }
        return _dateCell;
    }
    
    DefaultCell *defaCell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!defaCell) {
        defaCell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    defaCell.valueTF.tag = 2000 + indexPath.row;
    defaCell.valueTF.delegate = self;
    defaCell.titleLab.text = passportTitleArr[indexPath.row];
    defaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArr.count > 1) {
        
        defaCell.valueTF.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
    }
    if (indexPath.row == _dataArr.count - 2) {
        defaCell.isLast = YES;
    }

    return defaCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 39 * WIDTH / 375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 12) && _selectIndex != indexPath.row ) {
        
        _selectIndex = indexPath.row;
        [self addDateSelectView:indexPath.row == 5 || indexPath.row == 8];
    }
}

#pragma mark - 日期选择
- (DatePicker *)datepic {
    
    if (!_datepic) {
        
        //选择预约面试时间
        _datepic = [[DatePicker alloc]initWithFrame:CGRectMake(0, (HEIGHT - 64)/5 * 3, WIDTH,(HEIGHT - 64)/5*2)];
        _datepic.delegate = self;
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
- (void)addDateSelectView:(BOOL)passportBirthTime {
    
    _tableView.userInteractionEnabled = NO;
    self.markView.hidden = NO;
    self.datepic.frame = CGRectMake(0, (HEIGHT - 64)/5 * 3, WIDTH,(HEIGHT - 64)/5*2);
   
    self.datepic.datePicker.maximumDate = nil;
    self.datepic.datePicker.minimumDate = nil;
    passportBirthTime ?
    (self.datepic.datePicker.maximumDate = [NSDate date]) :
    (self.datepic.datePicker.minimumDate = [NSDate date]) ;
}

- (void)markViewTapAction:(UITapGestureRecognizer *)tap {
    
    _isChange = YES;
    [_datepic dismiss];
    _markView.hidden = YES;
    _selectIndex = 0;
    _tableView.userInteractionEnabled = YES;
}

- (void)datePickerView:(DatePicker *)datePickerView didClickSureBtnWithSelectDate:(NSString *)date{
    
    _tableView.userInteractionEnabled = YES;
    _dataArr[_selectIndex] = date;
    _selectIndex = 0;
    [_tableView reloadData];
}

#pragma mark- 拍照导入图片
-(void)passportGetIntoCamera{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"对不起，您没有开启调用相机权限，是否前往 设置-隐私-相机 中设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * quxiaoBtn = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [quxiaoBtn setValue:NAVGATIONCOLOR forKey:@"_titleTextColor"];
        [alertTip addAction:quxiaoBtn];
        
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
            VC.markImg.image =[[UIImage imageNamed:@"passport"] stretchableImageWithLeftCapWidth:WIDTH topCapHeight:HEIGHT - 139];
            [self presentViewController:VC animated:YES completion:nil];
        }else {
            UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于您的设备暂不支持摄像头，您无法使用该功能!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertTip addAction:queRenAlert];
            [self.navigationController presentViewController:alertTip animated:YES completion:nil];
        }
    }
}
#pragma  mark - 相机代理  获取图片
-(void)selectPaiShePhotos:(UIImage *)photosMy {
    
    [self getUserSelectImage:photosMy];
}

- (void)selectAlbumPhotos:(UIImage *)photosAlbum {
    
    [self getUserSelectImage:photosAlbum];
}
- (void)getUserSelectImage:(UIImage *)photoArr {
    
    if (photoArr == nil) { return;  }
    
    _haveImg = YES;
    UIImage *image = photoArr;
    _headView.passportImagheView.contentMode = UIViewContentModeScaleToFill;
    [_headView.passportImagheView setImage:image];
    [self saveImage:image withName:@"3.jpg"];
    [self presentSheet];
    [self startRec2];
}

-(void)recongnitionResult2:(id)sender
{
    _dataStr= sender;
    
    NSArray *errorArr = @[ERROR_SERVER,ERROR_TIMEOUT,ERROR_NULL,ERROR_NotReachable];
    for (NSString *value in errorArr) {
        if ([_dataStr isEqualToString:value]) {
            
            UIAlertController * alertTip = [UIAlertController alertControllerWithTitle:@"提示" message: value preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * queRenAlert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
            [alertTip addAction:queRenAlert];
            [self.navigationController presentViewController:alertTip animated:YES completion:nil];
            return;
        }
    }
    
    if (_dataStr.length > 0) {
        [self xmlResult:_dataStr];
        _dataArr[11] = @"中国";
        [_tableView reloadData];
    }
}

-(void)xmlResult:(NSString *)html {
    
    NSData * data = [NSData dataWithBytes:[html UTF8String] length:[html length]];
    self.parserXML = [[NSXMLParser alloc]initWithData:data];
    
    //设置代理
    _parserXML.delegate = self;
    //开始解析
    [self.parserXML parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"你大爷");
}

- (NSString *)makeCardResultWithStr:(NSString*)dataStr {
    
    if (!dataStr.length)
        return nil;
    return dataStr;
}
-(void)parse{
    
    [self.parserXML parse];
}
#define mark - - - - - - - - - SAX开始解析xml - - - - - - - -
//遇到标签时 sax解析调用的方法（可用于解析html中带属性的标签）
-(void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {
    
    _eleString = elementName;
}
//遇到内容是sax解析调用的方法

-(void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string{
   
    if (string.length == 0) {return; }
    //如果解析出错  会给出一定的提示
    if ([_eleString isEqualToString:@"info"]) {
        [self alertShow:string];
    }
    NSArray * passportArr = @[@"nameCh",@"name",@"cardno",@"nation",@"sexCH",@"birthday",@"addressCH",@"address",@"issueDate",@"issueAddressCH",@"issueAuthority",@"China",@"validPeriod"];
    for (int i = 0 ; i<passportArr.count; i++) {
        
        if([_eleString isEqualToString:@"birthday"]) {
            
            _birthday = [[NSString alloc] initWithFormat:@"%@%@",_birthday,string ];
            _dataArr[5] = _birthday;
            break;
            
        }else if ([_eleString isEqualToString:@"validPeriod"]) {
            
            NSMutableString *text = [[NSMutableString alloc] initWithString:string];
            
            [text insertString:@"-" atIndex:4];
            [text insertString:@"-" atIndex:7];
            _dataArr[12] = text;
            break;
        } if ([_eleString isEqualToString:@"issueDate"]) {
            
            NSMutableString *text = [[NSMutableString alloc] initWithString:string];
            
            [text insertString:@"-" atIndex:4];
            [text insertString:@"-" atIndex:7];
            _dataArr[8] = text;
            break;
        }else if ([_eleString isEqualToString:passportArr[i]]) {
            
            if (![_eleString isEqualToString:@"name"]) {
                _dataArr[i] = string;
            }
            break;
        }
    }
}

- (void)presentSheet {
    _birthday = @"";
    if (!progressSheet) {
        progressSheet = [[UIActionSheet alloc] initWithTitle:@"识别中,请稍后⋯⋯" delegate: self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles: nil];
        
        progressSheet.actionSheetStyle =  UIActionSheetStyleAutomatic;
        progressBar = [[UIProgressView alloc] initWithFrame: CGRectZero];
        [progressBar setProgressViewStyle: UIProgressViewStyleBar];
        [progressSheet addSubview: progressBar];
        
        activityView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [progressSheet addSubview: activityView];
        [activityView startAnimating];
        
    }
    progressBar.frame = CGRectMake(30.0f, 45.0f, 320 - 60.0f, 9.0f);
    activityView.frame = CGRectMake(320 / 2 - 20.0f, -120.0f, 40.0f, 40.0f);
    
    [progressBar setProgress:0.0f];
    [progressSheet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --保存图片到沙盒
-(void)saveImage:(UIImage *)currentImage withName:(NSString *) imageName{
    
    NSData *imageData=UIImageJPEGRepresentation(currentImage, 1);
    
    NSString *fullPath=[[NSHomeDirectory() stringByAppendingString:@"/Documents"]stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)startRec2
{
    NSString *docs2 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/aa.jpg"] ;
    
    YM_SaveImage(_bImage,(char*)[docs2 UTF8String]);
    idCardImage = [[UIImage alloc]initWithContentsOfFile:docs2];
    NSData *sendImageData = UIImageJPEGRepresentation(_headView.passportImagheView.image, 0.1f);
    
    NSUInteger sizeOrigin = [sendImageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > 5*1024) {
        
        [self dismissPresentSheet];
        [CXUtils createAllTextHUB:@"图片大小超过5M，请重试"];
        return;
    }
    
    self.package = [[PackageAPI alloc]init];
    __block typeof(PassportViewController *)weakSelf = self;
    [_package AFNuploadPackage2:sendImageData Success:^(NSString *retStr, BOOL isSuccess) {
        [weakSelf dismissPresentSheet];
        if (isCancel == YES) {
            
            isCancel = NO;
            return ;
        }
        if (isSuccess) {
            [weakSelf recongnitionResult2:retStr];
        }
        else{
            [weakSelf recongnitionResult2:nil];
        }
        
    } Fail:^(NSError *error) {
        [weakSelf dismissPresentSheet];
        if (isCancel == YES) {
            isCancel = NO;
            return ;
        }
        [weakSelf recongnitionResult2:ERROR_SERVER];
    }];
}
- (void)dismissPresentSheet {
    
    [progressSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//当遇到识别信息解析 遇到 info 标签 调用
- (void)alertShow:(NSString *)message {
    NSString *info = @"照片不清晰，请重新拍照识别";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:info preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {  }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:^{}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - - - - - - - - - - 确定 - - - - - - - - - - -
- (void)createNextBtn {
    
    _nextBtn = [super createDownNextBtn];
    [_nextBtn addTarget:self action:@selector(passportQueding:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}
#pragma mark - 确定按钮响应事件 、判断数据是否为空
-(void)passportQueding:(UIButton *)sender {
    
    [self markViewTapAction:nil];
    [_markTF resignFirstResponder];
    
    NSArray *alertArr = @[@"请输入姓名",@"请输入姓名",@"请输入英文性别",@"请选择中文性别",@"请输入国籍",@"请输入出生日期",@"请输入英文住址",@"请输入中文地址",@"请输入英文签发地址",@"请输入中文签发地址",@"请输入发证日期",@"请输入有效期限",@"请输入护照编号"];
    if (_haveImg == NO) {
        
        [CXUtils createAllTextHUB:@"请上传护照图片"];
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    for (int i = 0; i < _dataArr.count - 1; i ++) {
        
        NSString *value = _dataArr[i];
        
        if (value.length < 1 || [value isEqualToString:@""] || [value isEqualToString:@" "] || [value isEqualToString:NULL]) {
            
            if (![alertArr[i] isEqualToString:@"请输入国籍"] && ![alertArr[i] isEqualToString:@"请输入英文性别"]) {
                [CXUtils createAllTextHUB:@"请完善信息"];
                return;
            }
        }
    }
    
    if (![_dataArr[0] isEqualToString:_contactModel.contact_name]) {
        
        [CXUtils createAllTextHUB:@"姓名与申请人姓名不一致"];
        self.view.userInteractionEnabled = YES;

        return;
    }
    
    NSArray *imageArr = @[_headView.passportImagheView.image];
    if (_contactChange) {
        
        NSDictionary *changeParam = @{@"attachment_id":_datumModel.attachment_id,@"visa_datum_type":@"2",@"contact_id":_contactID,@"detail_id":_datumModel.detail_id,@"is_del":@"0",@"visa_datum_id":_datumModel.visa_datum_id};
        [self contactChangeUpImage:changeParam withImage:imageArr];
        return;
    }
    
     NSDictionary *orderParam = @{@"attachment_id":_datumModel.attachment_id,@"visa_datum_type":@"2",@"order_id":_orderID,@"detail_id":_datumModel.detail_id,@"is_del":@"0",@"order_datum_id":_datumModel.order_datum_id};
   
    [self postImagewithImages:orderParam withImageArr:imageArr];

    self.view.userInteractionEnabled = YES;

}
- (void)setDatumModel:(MSLOrderDatumModel *)datumModel {
    
    _datumModel = datumModel;
    
    if (_datumModel.path_name.length > 1) {
        
        _haveImg = YES;
    }
}

#pragma mark - 上传图片
// 申请人 修改 信息    上传图片
- (void)contactChangeUpImage:(NSDictionary *)param withImage:(NSArray *)upImgArr{
    
    [NetWorking postImageOnlywithURL:UPIMG_CONTACR_URL withParam:param Images:upImgArr success:^(id responseObjc) {

        [self upPassPortinfoData];
        
    } failBlock:^(NSError *error) { }];
}

- (void)postImagewithImages:(NSDictionary *)param withImageArr:(NSArray *)imageArr {

    [NetWorking postImageOnlywithURL:UPIMG_URL withParam:param Images:imageArr success:^(id responseObjc) {
        
        [self upPassPortinfoData];

    } failBlock:^(NSError *error) { }];
}

//根据infoType选择跳转的控制器
- (void)selectPopVC {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark -  上传护照信息

- (void)upPassPortinfoData {
    /*
     1、中文姓名  2、英文姓名 3、护照号码 4、国家码
     5、中文性别 6、出生日期 7、出生地点  8、英文出生地点
     9、签发日期 10、签发地点 11、英文签发地点
     12、国籍：由于识别不出来，默认填写中国，可修改
     13、有效期至*/
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];

    NSArray*passArr=@[@"contact_name",@"e_contact_name",
                      @"passport_no",@"now_nationality",
                      @"contact_sex",@"contact_birth",
                      @"passport_place_birth",@"e_passport_place_birth",
                      @"passport_birth_time",
                      @"passport_place_issuse",@"e_passport_place_issuse",
                      @"passport_nationality",@"passport_validity_time"
                      ];
    for (int i = 0; i<passArr.count ; i++) {
        dic[passArr[i]] = _dataArr[i];
    }
    dic[@"contact_id"] = _contactID;
    dic[@"contact_sex"] = _sexCell.manBtn.selected ? @"男" : @"女";
    dic[@"e_contact_sex"] = _sexCell.manBtn.selected ? @"M" : @"F";
    
    [NetWorking postHUDRequest:CHANGE_CONTACT_URL withParam:dic withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpInfoReLoadData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactReLoadData" object:nil];
        [CXUtils createAllTextHUB:responseObjc[@"reason"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) { }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _tableView.userInteractionEnabled = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

@end
#define SYSTEM_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ERROR_OK @"1"
#define ERROR_SERVER @"服务器请求超时，请重试"
#define ERROR_NULL @"识别结果为空，请重新拍照或者导入"
#define ERROR_TIMEOUT @"识别错误，请检查手机时间"
#define ERROR_NotReachable @"无网络连接，请连接网络"
