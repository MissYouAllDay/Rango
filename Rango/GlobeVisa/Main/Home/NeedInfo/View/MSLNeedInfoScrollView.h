//
//  MSLNeedInfoScrollView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXNeedInfoDelegate <NSObject>

- (void)needInfoScrollViewSelectIndex:(NSInteger)index;

@end

@interface MSLNeedInfoScrollView : UIView

@property (nonatomic, weak) id<CXNeedInfoDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *titleArr;  // 索引
@property (nonatomic, strong) NSMutableArray *imageArr;              //未选中图片数组
@property (nonatomic, assign) int selectIndex;


@end
