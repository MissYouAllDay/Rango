//
//  MSLBannerModel.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/26.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "BaseModel.h"

@interface MSLBannerModel : BaseModel

@property (nonatomic, copy) NSString *ban_no;  // 位置

@property (nonatomic, copy) NSString *img_url;  // 展示图片URL

@property (nonatomic, copy) NSString *title;    // title

@property (nonatomic, copy) NSString *hyperlinks; // 跳转的界面

@end
