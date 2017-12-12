//
//  MSLBankModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLBankModel : BaseModel
/*
 address = " \U4e0a\U6d77\U5e02\U5357\U4eac\U4e1c\U8def 61 \U53f7";
 "bank_outlets_id" = 12;
 contact = "";
 email = "";
 "fixed_line" = "021-58776326";
 ju = 649;
 latitude = "31.2386471949";
 longitude = "121.4886635870";
 name = "\U4e2d\U4fe1\U94f6\U884c\U80a1\U4efd\U6709\U9650\U516c\U53f8\U4e0a\U6d77\U5206\U884c";
 "outlets_no" = 302290031000;
 province = 13653;
 "province_name" = "\U4e0a\U6d77";
 remark = "";
 status = 0;
 */
@property (nonatomic, copy) NSString *address;//

@property (nonatomic, copy) NSString *bank_outlets_id;//

@property (nonatomic, copy) NSString *contact;//

@property (nonatomic, copy) NSString *email;//

@property (nonatomic, copy) NSString *fixed_line;//

@property (nonatomic, copy) NSString *ju;//

@property (nonatomic, copy) NSString *latitude;//

@property (nonatomic, copy) NSString *longitude;//

@property (nonatomic, copy) NSString *name;//

@property (nonatomic, copy) NSString *outlets_no;

@property (nonatomic, copy) NSString *province;//

@property (nonatomic, copy) NSString *province_name;

@property (nonatomic, copy) NSString *remark;       //

@property (nonatomic, copy) NSString *status;

@end
