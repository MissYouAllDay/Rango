//
//  MSLCountryModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/28.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLCountryModel : BaseModel

@property (nonatomic, copy) NSString *country_id;            //    国家id    int

@property (nonatomic, copy) NSString *country_name;     //    国家名称    String

@property (nonatomic, copy) NSString *ensign_url;       //    圆图片    String

@property (nonatomic, copy) NSString *logo_url;         //    首页图片    String

@property (nonatomic, copy) NSString *logo_url_plus;    //    首页图片plus    String

@property (nonatomic, copy) NSString *country_en_name;  //    英文名称    String

@property (nonatomic, copy) NSString *photo_format;     //    照片规格    String

@property (nonatomic, copy) NSString *form_url;         //    h5路径    String

@property (nonatomic, copy) NSString *bg_img_url;       //    背景图片    String

@property (nonatomic, copy) NSString *rm_img_url;       // 支付完成  推荐   国家  图片

@property (nonatomic, copy) NSString *rm_url;          // 支付完成  推荐   国家  name

@end
