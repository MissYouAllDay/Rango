//
//  MSLNeedInfoTab.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLMerchandiseModel.h"
#import "MSLProductModel.h"
#import "MSLNeedInfoScrollView.h"
@interface MSLNeedInfoTab : UITableView<UITableViewDelegate,UITableViewDataSource,CXNeedInfoDelegate>
@property (nonatomic, strong) MSLProductModel *merModel;


@property (nonatomic, strong) NSMutableArray *titleArr;  // 索引
@property (nonatomic, strong) NSMutableArray *imageArr;              //未选中图片数组
@property (nonatomic, strong) NSMutableArray *baseInfoHeiArr;    //基本信息的高度
@property (nonatomic, strong) NSMutableArray *needInfoHeiArr;    //所需资料的高度


@end
