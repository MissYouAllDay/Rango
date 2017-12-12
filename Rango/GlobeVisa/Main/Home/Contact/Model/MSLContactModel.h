//
//  MSLContactModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/3.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLContactModel : BaseModel
/*
address = " ";
"contact_birth" = " ";
"contact_id" = 1276;
"contact_name" = 1234;
"contact_number" = " ";
"contact_phone" = 17051108684;
"contact_sex" = " ";
"cust_type" = 3;
"customert_id" = 387;
"e_contact_name" = " ";
"e_contact_sex" = " ";
"e_mail" = "22@qq.com";
"e_passport_place_birth" = " ";
"e_passport_place_issuse" = " ";
"group_id" = 1;
"head_url" = "http://139.196.136.150/oss/ ";
"id_place_issuse" = " ";
"id_validity" = " ";
nationality = " ";
"passport_birth_time" = " ";
"passport_nationality" = CHN;
"passport_no" = " ";
"passport_place_birth" = " ";
"passport_place_issuse" = " ";
"passport_validity_time" = " ";
remark = " ";
"show_order" = 1;
"use_status" = 1;
*/
@property (nonatomic, copy) NSString *contact_id;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *contact_birth;

@property (nonatomic, copy) NSString *contact_name;

@property (nonatomic, copy) NSString *e_contact_name;

@property (nonatomic, copy) NSString *contact_sex;

@property (nonatomic, copy) NSString *e_contact_sex;

@property (nonatomic, copy) NSString *contact_number;

@property (nonatomic, copy) NSString *contact_phone;

@property (nonatomic, copy) NSString *cust_type;

@property (nonatomic, copy) NSString *customert_id;

@property (nonatomic, copy) NSString *e_mail;

@property (nonatomic, copy) NSString *passport_place_birth;

@property (nonatomic, copy) NSString *e_passport_place_birth;

@property (nonatomic, copy) NSString *passport_place_issuse;

@property (nonatomic, copy) NSString *e_passport_place_issuse;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *head_url;

@property (nonatomic, copy) NSString *id_place_issuse;

@property (nonatomic, copy) NSString *id_validity;

@property (nonatomic, copy) NSString *nationality;

@property (nonatomic, copy) NSString *passport_birth_time;

@property (nonatomic, copy) NSString *passport_nationality;

@property (nonatomic, copy) NSString *passport_no;

@property (nonatomic, copy) NSString *passport_validity_time;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *show_order;

@property (nonatomic, copy) NSString *use_status;


@property (nonatomic, copy) NSString *now_nationality;  // 国家吗



@end
