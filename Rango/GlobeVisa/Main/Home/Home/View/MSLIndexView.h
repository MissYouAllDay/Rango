//
//  MSLIndexView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXIndexViewDelegate <NSObject>

- (void)indexView:(NSInteger)tag withSelectIndex:(NSInteger)inidex;

@end

@interface MSLIndexView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<CXIndexViewDelegate> delegate;

@property (nonatomic, assign) NSInteger selectIndex;  // 点击的位置

@property (nonatomic, strong) NSArray *itemArr;       //  索引 数据


+ (id)shareIndexView;



@end
