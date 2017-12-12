//
//  MSLNeedInfoModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLNeedInfoModel : BaseModel

@property (nonatomic, copy) NSString *explain_desc;             //说明

@property (nonatomic, copy) NSString *cust_type;

@property (nonatomic, copy) NSString *visa_datum_id;            //NUM  材料id

@property (nonatomic, copy) NSString *visa_id;                  //NUM

@property (nonatomic, copy) NSString *visa_datum_name;          //材料名称

@property (nonatomic, copy) NSString *VISA_DATUM_TYPE;          //NUM   材料类型

@property (nonatomic, copy) NSString *show_order;
@end
