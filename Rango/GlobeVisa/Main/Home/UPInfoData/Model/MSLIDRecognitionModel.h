//
//  MSLIDRecognitionModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/9.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLIDRecognitionModel : BaseModel
/*
 address =
 birthday = "1988\U5e7411\U670816\U65e5";
 cardno = "132261198811160681(wrong number)";
 folk = "\U6c49";
 "header_pic" =     (
 );
 "issue_authority" =     (
 );
 name = "\U5b9c\U5c0f\U4fe1";
 sex = "\U5973";
 "valid_period" =     (
 );
 */

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *folk;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *cardno;

//@property (nonatomic, copy) NSString *valid_period; // 有效日期
//
//@property (nonatomic, copy) NSString *issue_authority; // 签发机关

@end
