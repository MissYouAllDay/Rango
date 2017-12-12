//
//  MSLMerchandiseModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/31.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLMerchandiseModel : BaseModel

//is_easy : "0"
//visa_number : ""
//remark : "签证说明"
//plan_weekday : "30"
//visa_name : "美国旅游/商务/探亲签证"
//preferential_price : "0.01"
//is_stop_set : "以入境时边防所盖章为准"
//visa_area_name : "成都"
//service_desc : "签证费+服务费"
//visa_id : 30
//country_name : "美国"
//range_desc : "全国受理"
//visa_label : ""
//is_refund : "0"
//validity_time : "10年"

//是否热门
@property (nonatomic, copy) NSString *is_easy;
//入境次数
@property (nonatomic, copy) NSString *visa_number;
//基本信息
@property (nonatomic, copy) NSString *remark;
//预计工作日
@property (nonatomic, copy) NSString *plan_weekday;
//产品名称
@property (nonatomic, copy) NSString *visa_name;
//价格
@property (nonatomic, copy) NSString *preferential_price;
//停留期
@property (nonatomic, copy) NSString *is_stop_set;
//领区名称
@property (nonatomic, copy) NSString *visa_area_name;
//费用明细
@property (nonatomic, copy) NSString *service_desc;
//签证id
@property (nonatomic, copy) NSString *visa_id;
//国家名称
@property (nonatomic, copy) NSString *country_name;
//价钱下面的说明（使用规定：请在90天之内必须处境）
@property (nonatomic, copy) NSString *range_desc;
//标签
@property (nonatomic, copy) NSString *visa_label;
//是否陪签
@property (nonatomic, copy) NSString *is_refund;
//签证有效期
@property (nonatomic, copy) NSString *validity_time;
// 各个大洲图片
@property (nonatomic, copy) NSString *region_url;



@end
