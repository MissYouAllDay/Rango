//
//  MSLPayVC.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLPayVC.h"
#import "MSLPayHeadView.h"
#import "MSLPayTabCell.h"
#import "SegmentView.h"
#import "MSLOrderDetailModel.h"
#import "MSLBankModel.h"
#import "MSLBankSeachVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MSLPaySuccessVC.h"
#import "MSLChangeContactVC.h"
@interface MSLPayVC ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,CXBankSearchVCDelegate>
{
    UITableView *_tableView;
    MSLPayHeadView *_headView;
    MSLPayTabCell *_markCell;    // 线下支付
    UIView *_downView;      // 底部价格迪曾试图
    UILabel *_priceLa;      //底部价格
    UIButton *_payBtn;
    UIView *_markView;      // dianji 明细   遮罩视图
  
    MSLOrderDetailModel *_model;
    MSLBankModel *_bankModel;
    NSMutableArray *_detailPriceArr;        // 明细
    NSString *_localname;       // 定位省份
    CGFloat _priceF; // 总价格
    BOOL _onLine;// 是否选择线上
    UIView *_visaWithBgV; // 明细中 陪签
    
}
@property (nonatomic, strong) UIView *priceDetail;// 明细
@property(nonatomic,strong)CLLocationManager * locationManager; //定位

@end

@implementation MSLPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _onLine = YES;
    self.title = @"确认订单并支付";
    self.view.backgroundColor = COLOR_245;
    [self createTab];
    [self createDownView];
    [self loadData];
    [self startLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payActionOver:) name:@"PAYOVER" object:nil];
}

- (void)payActionOver:(NSNotification *)notification {
    
    [self payOut:notification.object];
}

#pragma mark - - - - - - - - - - UITableViewDataSource - - - - - - - - - - -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_onLine) { return section == 0 ? 3: 1; }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_onLine) { return indexPath.section == 1 && indexPath.row == 0 ? 100 : 44; }
    
    return indexPath.section == 0 ? 44 : 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return  section == 0 ? 10 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return section == 0 ? [self sectionZeroHead] : [self sectionOneHead];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    view.backgroundColor = COLOR_245;
    return view;
}

#pragma mark - - - - - - - - - -  创建cell - - - - - - - - - - -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSLPayTabCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
    
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"MSLPayTabCell" owner:nil options:nil] firstObject];
    }
    if (indexPath.section == 0) {
     
        switch (indexPath.row) {
            case 0:
                cell1.titleName.text = @"订单";
                cell1.name.text = _model.visa_name;
                break;
            case 1:
                cell1.titleName.text = @"姓名";
                cell1.name.text = _model.contact_name;
                break;
            case 2:
                cell1.titleName.text = @"电话";
                cell1.name.text = _model.contact_phone;
                break;
            default:break;
        }
        cell1.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell1;
    }
    
    if (_onLine) {
        // 选择支付方式
        MSLPayTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payOnLineCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLPayTabCell" owner:nil options:nil] objectAtIndex:1];
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    
    if (indexPath.row == 0) {
        // 搜索框
        MSLPayTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payOneCell"];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MSLPayTabCell" owner:nil options:nil] objectAtIndex:2];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell.searchBtn addTarget:self action:@selector(pushSeachVC) forControlEvents:UIControlEventTouchUpInside];
        if (_bankModel) {
            cell.bankName.text = _bankModel.name;
            
        }
        return cell;
    }
   
    switch (indexPath.row) {
        case 1:
            cell1.titleName.text = @"地址";
            cell1.name.text = _bankModel ? _bankModel.address : nil;
            break;
        case 2:
            cell1.titleName.text = @"电话";
            cell1.name.text = _bankModel ? _bankModel.fixed_line : nil;
            break;
            
        default: break;
    }

    cell1.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell1;
}

#pragma mark - - - - - - - - - - 跳转银行搜索界面 - - - - - - - - - - -
- (void)pushSeachVC {
    
    MSLBankSeachVC *vc = [[MSLBankSeachVC alloc] init];
    vc.delegate = self;
//    BaseNavigationVC *na = [[BaseNavigationVC alloc] initWithRootViewController:vc];
    [self presentViewController:vc animated:YES completion:^{ }];
}

-(void)bankSearchwithModel:(MSLBankModel *)model {
    
    _bankModel = model;
    [_tableView reloadData];
}

#pragma mark - - - - - - - - - - 创建视图 - - - - - - - - - - -
- (void)createTab {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - [CXUtils statueBarHeight] -44 - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_245;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UIView *view = [UIView new];
    view.backgroundColor = COLOR_245;
    _tableView.tableFooterView = view;
    _headView = [[[NSBundle mainBundle] loadNibNamed:@"MSLPayHeadView" owner:nil options:nil] lastObject];
    _tableView.tableHeaderView = _headView;
    
    [_headView.togetherBtn addTarget:self action:@selector(togetherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
// 陪签
- (void)togetherBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    _priceF = sender.selected ? [_model.accompany_price floatValue] + [_model.preferential_price floatValue] : [_model.preferential_price floatValue];
    _headView.togetherImg.image = [UIImage imageNamed:sender.selected ? @"pay_sele" : @"pay_unsele"];
    [self downViewPrice];
}

//
- (void)createDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(-1, _tableView.bottomCX, WIDTH + 2, 52)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    _priceLa = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _downView.widthCX - 100, _downView.heightCX)];
    [_downView addSubview:_priceLa];
    _priceLa.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapAction:)];
    [_priceLa addGestureRecognizer:tap];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(_downView.widthCX - 120, (_downView.heightCX - 40  )/2, 100, 40);
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    _payBtn.titleLabel.font = FONT_SIZE_15;
    _payBtn.backgroundColor = COLOR_BUTTON_BLUE;
    _payBtn.layer.cornerRadius = 5;
    [_downView addSubview:_payBtn];
    [_payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
}
// 明细点击事件
- (void)detailTapAction:(UITapGestureRecognizer *)tap {

    if (self.priceDetail.topCX != _downView.bottomCX) {

        [UIView animateWithDuration:0.35 animations:^{

            self.priceDetail.transform = CGAffineTransformIdentity;
        }];
        _markView.hidden = YES;

    }else {
        [UIView animateWithDuration:0.35 animations:^{
            
            self.priceDetail.transform = CGAffineTransformMakeTranslation(0, - self.priceDetail.heightCX - _downView.heightCX);
        }];
        _markView.hidden = NO;

    }
}

- (void)payAction {
    
    if (_onLine) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        [self alipayPayCode:app_Version];
    }else {
        // 线下支付
        [self payWithDownLine];
    }
}

#pragma mark - - - - - - - - - - 订单信息     线上支付 - - - - - - - - - - -
// 订单信息
- (UIView *)sectionZeroHead {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 80, 44)];
    [bgView addSubview:la];
    la.backgroundColor = [UIColor whiteColor];
    la.text = @"    订单信息";
    la.font = FONT_14;
    la.userInteractionEnabled = YES;
    
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 80, 0,80, 44)];
    [bgView addSubview:right];
    right.backgroundColor = [UIColor whiteColor];
    right.font = FONT_SIZE_14;
    right.attributedText = [[NSAttributedString alloc] initWithString:@"修改" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSFontAttributeName:FONT_14}];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeOrderInfo)];
    [right addGestureRecognizer:tap];
    right.textAlignment = NSTextAlignmentCenter;
    right.userInteractionEnabled = YES;
    return bgView;
}

- (void)changeOrderInfo {
    
    MSLChangeContactVC *vc = [[MSLChangeContactVC alloc] init];
    vc.isContact = NO;
    vc.orderID = _orderID;
    vc.contactID = _contactID;
    [self.navigationController pushViewController:vc animated:YES];
}

// 支付方式
- (UIView *)sectionOneHead {
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    bg.backgroundColor = [UIColor whiteColor];
    SegmentView *seg =[[SegmentView alloc] initWithFrame:CGRectMake(10, 0, 150, 44)];
    seg.titleList = @[@"线上支付",@"线下支付"];
    seg.selectIndex = _onLine?0:1;
    [seg addBlock:^(NSInteger index) {
        
        _onLine = index == 0 ? YES : NO;
        
        [_payBtn setTitle:index == 0 ? @"立即支付" : @"立即支付" forState:UIControlStateNormal];
        [_tableView reloadData];
    }];
    [bg addSubview:seg];
    return bg;
}

#pragma mark - - - - - - - - - - 价格明细 - - - - - - - - - - -
- (UIView *)priceDetail {
    
    if (!_priceDetail) {
        _markView = [[UIView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapAction:)];
        [_markView addGestureRecognizer:tap];
        _markView.hidden = YES;
        [self.view addSubview:_markView];
        _priceDetail = [[UIView alloc] initWithFrame:CGRectMake(0, _downView.bottomCX, WIDTH, 0)];
        _priceDetail.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_priceDetail];
        //    [self.view insertSubview:_priceDetail belowSubview:_downView];
        int hei = 0;
        CGFloat singHei = 44;
        
        for (int i = 0; i < _detailPriceArr.count; i ++) {
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, i * 44, WIDTH, singHei)];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH/2 - 15, bgView.heightCX)];
            name.font = FONT_SIZE_13;
            name.text = _detailPriceArr[i][@"detail"];
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2 - 15, bgView.heightCX)];
            price.font = FONT_SIZE_13;
            price.textColor = COLOR_FONT_BLUE;
            price.text = [NSString stringWithFormat:@"￥%@",_detailPriceArr[i][@"price"]];
            price.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:name];
            [bgView addSubview:price];
            
            [_priceDetail addSubview:bgView];
            hei = i + 1;
        }
        _priceDetail.heightCX = hei * singHei;
    }
    if (_headView.togetherBtn.selected && !_visaWithBgV) {
        
        _visaWithBgV = [[UIView alloc] initWithFrame:CGRectMake(0, _detailPriceArr.count * 44, WIDTH, 44)];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, WIDTH/2 - 15, _visaWithBgV.heightCX)];
        name.font = FONT_SIZE_13;
        name.text = @"陪签费";
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2 - 15, _visaWithBgV.heightCX)];
        price.font = FONT_SIZE_13;
        price.textColor = COLOR_FONT_BLUE;
        price.text = [NSString stringWithFormat:@"￥%@",_model.accompany_price];
        price.textAlignment = NSTextAlignmentRight;
        [_visaWithBgV addSubview:name];
        [_visaWithBgV addSubview:price];
        [_priceDetail addSubview:_visaWithBgV];
        _priceDetail.heightCX = _detailPriceArr.count * 44  + 44;
    }
    
    if (_headView.togetherBtn.selected == NO && _visaWithBgV) {
        [_visaWithBgV removeFromSuperview];
    }
    return _priceDetail;
}

#pragma mark - - - - - - - - - - 请求数据 - - - - - - - - - - -

// 获取订单信息
- (void)loadData {
    
    [NetWorking getHUDRequest:ORDERDETAIL_URL withParam:@{@"order_id":_orderID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        _detailPriceArr = [[NSMutableArray alloc] initWithArray:responseObjc[@"priceData"]];

        _model = [[MSLOrderDetailModel alloc] initWithDictionary:responseObjc[@"result"][0]];
        
        NSMutableAttributedString *money = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_model.preferential_price] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [money addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 1)];
        _headView.money.attributedText = money;
        
        NSMutableAttributedString *moneyAcc = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_model.accompany_price] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FONT_SIZE_15}];
        [money addAttribute:NSFontAttributeName value:FONT_SIZE_9 range:NSMakeRange(0, 1)];
        _headView.togetherMoney.attributedText = moneyAcc;
      
        _priceF = [_model.preferential_price floatValue];
        [self downViewPrice];
        
        [_tableView reloadData];

        
    } failBlock:^(NSError *error) { }];
}

// 底部价格赋值
- (void)downViewPrice {
    
    NSTextAttachment *downImg = [[NSTextAttachment alloc] init];
    downImg.image = [UIImage imageNamed:@"pay_down"];
    downImg.bounds = CGRectMake(0, 0, 15, 9);
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:downImg];
    
    NSString *price = [NSString stringWithFormat:@"%.2f",_priceF];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需付：￥%@      明细  ",price] attributes:@{NSFontAttributeName:FONT_SIZE_13}];
    
    [att addAttribute:NSFontAttributeName value:FONT_SIZE_15 range:NSMakeRange(4, price.length)];
    [att addAttribute:NSFontAttributeName value:FONT_SIZE_11 range:NSMakeRange(3, 1)];
    [att addAttribute:NSForegroundColorAttributeName value:HWColor(242, 61, 61) range:NSMakeRange(3, price.length + 1)];
    [att appendAttributedString:imageStr];
    
    _priceLa.attributedText = att;
}

//// 银行查询  //longitude=121.5241682687&latitude=31.2289578381&area_name=上海
- (void)bankInfoData:(NSString *)lat withlong:(NSString *)lon withName:(NSString *)name {
    
    [NetWorking getHUDRequest:BANK_SEARCH_URL withParam:@{@"longitude":lon,@"latitude":lat,@"area_name":name} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        _bankModel = [[MSLBankModel alloc] initWithDictionary:responseObjc[@"result"]];
    
    } failBlock:^(NSError *error) {
        
        
    }];
}


#pragma mark - - - - - - - - - - 线下支付 - - - - - - - - - - -
- (void)payWithDownLine {
    
    [NetWorking postHUDRequest:UNLINE_PAY_URL withParam:@{@"token":TOKEN_VALUE,@"bank_outlets_id":_bankModel.bank_outlets_id,@"order_id":_orderID} withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    } failBlock:^(NSError *error) { }];
}
#pragma mark - - - - - - - - - - 支付宝支付 - - - - - - - - - - -
- (void)alipayPayCode:(NSString *)version {
    
//    NSDictionary *dic = @{@"totalPrice":[NSString stringWithFormat:@"%.2f",_priceF],@"AppVersionCode":version,@"visaName":_model.visa_name,APP_COMPANY_ID:APP_COMPANY_IDNUM};
    NSDictionary *dic = @{@"totalPrice":@"0.01",@"AppVersionCode":version,@"visaName":_model.visa_name,APP_COMPANY_ID:APP_COMPANY_IDNUM};
    [NetWorking getHUDRequest:URL_SECRETKEY withParam:dic withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        
        [self alipaywithPayCode:responseObjc[@"payCode"]];
    } failBlock:^(NSError *error) { }];
}

//支付宝支付
- (void)alipaywithPayCode:(NSString *)payCode {
    
    [[AlipaySDK defaultService] payOrder:payCode fromScheme:APPSCHEME callback:^(NSDictionary *resultDic) {
        
        [self payOut:resultDic];
        
    }];
}

//支付回调，目的在于payorder的回调不执行
- (void)payOut:(NSDictionary *)param {
    
    if (![param[@"resultStatus"] isEqualToString :@"9000"]) {
        
        [CXUtils createAllTextHUB:@"交易失败"];
        return;
    }
    
    NSDictionary *dic = @{@"order_id":_model.order_id,@"pay_type":@"1",@"payment":[NSString stringWithFormat:@"%.2f",_priceF],@"is_accompany_visa":_headView.togetherBtn.selected?@"1":@"0"};
    
    //支付宝数据
    NSString *reslut = param[@"result"];
    NSDictionary *reslutDic = [BaseModel dictionaryWithJsonString:reslut];
    NSDictionary *payResp = reslutDic[@"alipay_trade_app_pay_response"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    [data setObject:payResp[@"timestamp"] forKey:@"gmt_payment"];
    [data setObject:payResp[@"total_amount"] forKey:@"buyer_pay_amount"];
    [data setObject:payResp[@"out_trade_no"] forKey:@"out_trade_no"];
    [data setObject:payResp[@"trade_no"] forKey:@"trade_no"];
    
    [NetWorking postHUDRequest:CHANGE_ORDER_URL withParam:data withErrorCode:NO withHUD:NO success:^(id responseObjc) {
        MSLPaySuccessVC *vc = [[MSLPaySuccessVC alloc] init];
        vc.orderID = _orderID;
        vc.localName = _localname;
        [self.navigationController pushViewController:vc animated:YES];
    } failBlock:^(NSError *error) { }];
}

#pragma mark -  开始定位
-(void)startLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 100.0f;//过滤距离
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0) {
            //            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始实现定位
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder =[[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary * test = [placemark addressDictionary];
            
            //  省份
            NSMutableString *name = [[NSMutableString alloc] initWithString:[test objectForKey:@"State"]];
            NSString *localName =  [name substringToIndex:(name.length == 3 ? name.length - 1 : 3)] ;
            
            CLLocation *location = [placemark location];
            CLLocationCoordinate2D  coor = location.coordinate;
            _localname = localName;
            [self bankInfoData:[NSString stringWithFormat:@"%lf",coor.latitude] withlong:[NSString stringWithFormat:@"%lf",coor.longitude] withName:localName];
            
        }
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PAYOVER" object:nil];
}



@end
