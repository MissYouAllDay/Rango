//
//  MSLOrderModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/7.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLOrderModel : BaseModel


//{
//    "contact_name": "I ",
//    "depart_time": 1510070400000,
//    "contact_phone": "17051108681",
//    "photo_format": "e972c319e4c24deaa297aa992f327a81",
//    "contact_id": 1316,
//    "contact_number": "Mm",
//    "visa_name": "日本三年多次旅游签证-不指定入境口岸",
//    "order_code": "1711071719578",
//    "order_status": "0.5",
//    "head_url": "http://139.196.136.150/oss/ ",
//    "form_url": "http://139.196.136.150:8080/GlobalVisa/application/japan/japan.html",
//    "cust_type": "1",
//    "visa_id": 260,
//    "country_name": "日本",
//    "payment": 0.02,
//    "is_pay": "0",
//    "order_id": 79352
//}

@property (nonatomic, copy) NSString *contact_name;

@property (nonatomic, copy) NSString *depart_time;

@property (nonatomic, copy) NSString *contact_phone;

@property (nonatomic, copy) NSString *photo_format;

@property (nonatomic, copy) NSString *contact_id;

@property (nonatomic, copy) NSString *contact_number;

@property (nonatomic, copy) NSString *visa_name;

@property (nonatomic, copy) NSString *order_code;

@property (nonatomic, copy) NSString *order_status;

@property (nonatomic, copy) NSString *head_url;

@property (nonatomic, copy) NSString *form_url;

@property (nonatomic, copy) NSString *cust_type;

@property (nonatomic, copy) NSString *visa_id;

@property (nonatomic, copy) NSString *country_name;

@property (nonatomic, copy) NSString *payment;

@property (nonatomic, copy) NSString *is_pay;

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, copy) NSString *mail_address; // 材料寄送地址

@property (nonatomic, copy) NSString *file_mail_type; // 默认为0   1:快递给平台  2：上门去护照  3：银行送取护照

@property (nonatomic, copy) NSString *country_id;
@end
