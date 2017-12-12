//
//  MSLOrderListCell.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/21.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLOrderListCell.h"

@implementation MSLOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [_contineBtn setTitleColor:COLOR_FONT_BLUE forState:UIControlStateNormal];
    _contineBtn.layer.cornerRadius = 5;
    _contineBtn.layer.borderColor = COLOR_BUTTON_BLUE.CGColor;
    _contineBtn.layer.borderWidth = 0.5;
    
    _cancelBtn.layer.cornerRadius = 5;
    _cancelBtn.layer.borderColor = HWColor(231, 231, 231).CGColor;
    _cancelBtn.layer.borderWidth = 0.5;
    
    _sendType.userInteractionEnabled = YES;
}

- (void)setModel:(MSLOrderModel *)model {
    
    _model = model;
    
    _orderNum.text = [NSString stringWithFormat:@"订单号:%@    申请人:%@",_model.order_code,_model.contact_name];
    _orderName.text = _model.visa_name;
    _sendType.textColor = COLOR_153;
    
    self.selectIndex = [_model.file_mail_type integerValue];
    // 订单：上传资料--支付--寄送材料--审核并送签--办理中（申请成功/申请失败）
   // 0  - 0.5：上传资料  1:支付  2：寄送材料  3-4-5：审核并送签  6-7-8 办理中  9：签证成功   大与9 失败
    // evus  2----8  办理中
    NSString *orderSta = [NSString stringWithFormat:@"%@",_model.order_status];
    int orderStatus = [_model.order_status intValue];
   
    // 上传资料
    if ([orderSta isEqualToString:@"0"] || [orderSta isEqualToString:@"0.5"]) {
        _upInfoLabel.textColor = COLOR_FONT_BLUE;
        _sendType.hidden = YES;

    }
    // 支付
    if ([orderSta isEqualToString:@"1"] ) {
        _payLabel.textColor = COLOR_FONT_BLUE;
        _sendType.hidden = YES;
    }
    
    // evus
    if ([_model.country_id intValue] == 1) {
        
        [self evusStatus:orderStatus];
        return;
    }
    // 寄送 材料
    if ([orderSta isEqualToString:@"2"] ) {
        [self unNeedBtn:_sendLabel];
    }
    
    // 审核送签
    if (orderStatus >=3 && orderStatus <=5) {
        [self unNeedBtn:_checkLabel];
    }
    //办理中
    if (orderStatus > 5 && orderStatus < 9) {
        _okLabel.text = @"办理中";
        [self loadingStep:_okLabel];
    }
    
    // 完成
    if (orderStatus == 9) {
        _okLabel.text = @"申请成功";
        [self endStap:_okLabel];
    }
    // 失败
    if ( orderStatus > 9) {
        _okLabel.text = @"申请失败";
        [self endStap:_okLabel];

    }
}

// evus 办理流程
- (void)evusStatus:(int)orderStatus {
    
    _fourView.hidden = YES;
    _fifView.hidden = YES;
    _sendRightImg.hidden = YES;
    _sendLabel.text = @"办理中";
   
    // 审核送签
    if (orderStatus >1 && orderStatus <=8) {
    
        [self loadingStep:_sendLabel];
    }
    // 完成
    if (orderStatus == 9) {
        _sendLabel.text = @"申请成功";
        [self endStap:_sendLabel];
    }
    // 失败
    if ( orderStatus > 9) {
        _sendLabel.text = @"申请失败";
        [self endStap:_sendLabel];
    }
}

// 办理中
- (void)loadingStep:(UILabel *)label {
   
    label.textColor = COLOR_FONT_BLUE;
    _sendType.hidden = NO;
    _cancelBtn.hidden = YES;
    _contineBtn.hidden = YES;
    _cancelBtn.userInteractionEnabled = NO;
    _contineBtn.userInteractionEnabled = NO;
}
// 完成  或者  失败
- (void)endStap:(UILabel *)label {
   
    label.textColor = COLOR_FONT_BLUE;
    [_contineBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_contineBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _contineBtn.layer.borderColor = HWColor(231, 231, 231).CGColor;
    _cancelBtn.hidden = YES;
}

// 隐藏 取消 和 继续
- (void)unNeedBtn:(UILabel *)label {
    
    label.textColor = COLOR_FONT_BLUE;
    _cancelBtn.hidden = YES;
    _contineBtn.hidden = YES;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    
    switch (selectIndex) {
        case 1: _sendType.text = @"快寄给平台"; break;
        case 2: _sendType.text = @"上门取护照"; break;
        case 3: _sendType.text = @"银行送取护照"; break;
        default:
            _sendType.text = @"请选择寄送方式";
            _sendType.textColor = HWColor(244, 101, 62);
            break;
    }
}

@end
