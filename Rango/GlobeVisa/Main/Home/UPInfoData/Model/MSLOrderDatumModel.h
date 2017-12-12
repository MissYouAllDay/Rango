//
//  MSLOrderDatumModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/8.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

// - - - - - - - - - - - - - - 资料上传  资料列表  - - - - - - - - - - - - - - -


@interface MSLOrderDatumModel : BaseModel

@property (nonatomic, copy) NSString *explain_desc;//照片要求

//@property (nonatomic, copy) NSString *visa_datum_id;//

@property (nonatomic, copy) NSString *approval_status;//

@property (nonatomic, copy) NSString *is_must;//是否必须

@property (nonatomic, copy) NSString *attachment_id;//

//@property (nonatomic, copy) NSString *use_status;//

@property (nonatomic, copy) NSString *visa_datum_name;//材料名称

@property (nonatomic, copy) NSString *show_order;//显示顺序

@property (nonatomic, copy) NSString *order_id;//

@property (nonatomic, copy) NSString *visa_datum_type;//材料类型

@property (nonatomic, copy) NSString *path_name;//路径地址

@property (nonatomic, copy) NSString *order_datum_id;//材料id

@property (nonatomic, copy) NSString *detail_id;       //

@property (nonatomic, copy) NSString *visa_datum_id;    
@end
