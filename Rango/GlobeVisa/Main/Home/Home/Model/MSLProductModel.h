//
//  MSLProductModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

// - - - - - - - - - - - - - - 产品model  - - - - - - - - - - - - - - -

@interface MSLProductModel : BaseModel

@property (nonatomic, copy) NSString *visa_id;              //签证id

@property (nonatomic, copy) NSString *visa_area_id;         // 领区id

@property (nonatomic, strong) NSNumber *preferential_price;   //价格

@property (nonatomic, copy) NSString *is_easy;              // 是否热门

@property (nonatomic, copy) NSString *logo_url;             //logo 地址

@property (nonatomic, copy) NSString *logo_url_plus;

@property (nonatomic, copy) NSString *remark;               // 基本信息

@property (nonatomic, copy) NSString *country_name;         //国家名称

@property (nonatomic, copy) NSString *visa_area_name;       //领区名称

@property (nonatomic, copy) NSString *visa_name;            //签证名称

@property (nonatomic, copy) NSString *service_desc;         //费用明细

@property (nonatomic, copy) NSString *range_desc;           //价钱下面的说明（使用规定：请在90天之内必须处境）

@property (nonatomic, copy) NSString *is_stop_set;          //停留期

@property (nonatomic, copy) NSString *visa_label;           //标签

@property (nonatomic, copy) NSString *plan_weekday;         //预计工作日

@property (nonatomic, copy) NSString *validity_time;        //签证有效期

@property (nonatomic, copy) NSString *visa_number;          //入境次数

@property (nonatomic, copy) NSString *is_refund;            // 是否陪签

@property (nonatomic, copy) NSString *bg_img_url;           // 产品详情页顶部

@property (nonatomic, copy) NSString *ensign_url;           // 国旗

@property (nonatomic, copy) NSString *region_url;           // 各个大洲图片

@property (nonatomic, copy) NSString *photo_format;          // 照片规格

@end
