//
//  MSLOrderDetailModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/20.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"


// - - - - - - - - - - - - - - 订单详情  - - - - - - - - - - - - - - -


@interface MSLOrderDetailModel : BaseModel
//order_id    订单id    int
//order_code    订单号    String
//order_status    订单状态    int
//order_status_name    订单状态名称    String
//visa_id    签证分类id    int
//visa_name    签证分类名称    String
//contact_id    联系人id    int
//contact_name    联系人名称    String
//contact_phone    联系人手机号    String
//visa_area_id    国家领区名称    String
//is_pay    支付进度    String
//pay_type    支付类型    double
//depart_time    计划出行时间    String
//area_staff_id    陪签人ID    int
//bank_outlets_id    网点id    int
//payment    支付金额    double
//remark    备注    String
//accompany_price    陪签叠加价格    double
//preferential_price    价格    double
//photo_format    照片规格    String


@property (nonatomic, copy) NSString *order_id;//

@property (nonatomic, copy) NSString *order_code;//

@property (nonatomic, copy) NSString *order_status;//

@property (nonatomic, copy) NSString *order_status_name;//

@property (nonatomic, copy) NSString *attachment_id;//

@property (nonatomic, copy) NSString *visa_id;//

@property (nonatomic, copy) NSString *visa_name;//

@property (nonatomic, copy) NSString *contact_id;//

@property (nonatomic, copy) NSString *contact_name;//

@property (nonatomic, copy) NSString *contact_phone;

@property (nonatomic, copy) NSString *visa_area_id;//

@property (nonatomic, copy) NSString *is_pay;

@property (nonatomic, copy) NSString *pay_type;       //

@property (nonatomic, copy) NSString *depart_time;

@property (nonatomic, copy) NSString *area_staff_id;//

@property (nonatomic, copy) NSString *bank_outlets_id;//

@property (nonatomic, copy) NSString *payment;//

@property (nonatomic, copy) NSString *remark;//

@property (nonatomic, copy) NSString *accompany_price;

@property (nonatomic, copy) NSString *preferential_price;

@property (nonatomic, copy) NSString *photo_format;
@end
