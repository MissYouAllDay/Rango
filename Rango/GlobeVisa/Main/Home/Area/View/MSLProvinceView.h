//
//  MSLProvinceView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/31.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>


// - - - - - - - - - - - - - - 省份 请选择长期居住地点击后弹出的界面  - - - - - - - - - - - - - - -


@protocol CXProvinceDelegate <NSObject>

- (void)provinceSelectIndex:(NSInteger)inidex;

@end
@interface MSLProvinceView : UIView

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, weak) id<CXProvinceDelegate> delegate;

- (void)show;
- (void)closeSelf;
@end
