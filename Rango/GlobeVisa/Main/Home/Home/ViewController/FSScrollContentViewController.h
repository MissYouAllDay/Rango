//
//  FSScrollContentViewController.h
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSScrollContentViewController : UIViewController

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *str;

@property (nonatomic, strong) NSArray *dataArr;     //数据

@property (nonatomic, copy) NSString *localName; // 定位身份


@end
