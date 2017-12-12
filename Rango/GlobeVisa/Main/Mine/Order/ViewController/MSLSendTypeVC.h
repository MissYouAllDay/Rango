//
//  MSLSendTypeVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/22.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
@protocol CXMSLSendTypeDelegate <NSObject>

- (void)sendType:(NSString *)type withIndex:(NSInteger)index;

@end
@interface MSLSendTypeVC : RootViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, weak) id<CXMSLSendTypeDelegate> delegate;

@end
