//
//  UnfinOrderCell.h
//  GlobeVisa
//
//  Created by MSLiOS on 2017/2/10.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

//@class UnfinOrderApplication;

@interface UnfinOrderCell : UITableViewCell

@property (nonatomic, strong) MyOrderModel *model;

@property (nonatomic, copy) NSString * isPay;//用来判断是否显示。取消订单  按钮

@property(nonatomic,assign) int orderID; //是否为evus签证  1为evus 0 为普通

@property(nonatomic,assign) int orderStatus; //订单状态

@property(nonatomic,strong) UILabel * nameLabel;//名字
@property(nonatomic,strong) UILabel * finishStylelabel;//签证类型


@property(nonatomic,strong) UILabel * scheduleNumLabel;//进度数字
@property(nonatomic,strong) UIImageView * circleImageView;//颜色
@property(nonatomic,strong) UILabel * scheduleNameLabel;//进度名称

@property(nonatomic,strong) UILabel * priceLabel;//价格
//
@property(nonatomic,strong) UIButton * cancleBtn;//取消订单
@property(nonatomic,strong) UIButton * detailRightBtn;//详情按钮
@property(nonatomic,strong) UIButton * continueBtn;//继续按钮
@property(nonnull,strong) NSArray * arrWord;

@property(nonatomic,strong) UIView *markView;//取消订单//这盖视图  用于展示evus签证视图

@end
