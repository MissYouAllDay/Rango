//
//  MSLProvinceItem.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/31.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLProvinceItem : UICollectionViewCell

@property (nonatomic, strong)  IBOutlet UILabel *name;

// 还原
- (void)reduction;

//选中
- (void)selectItem;
@end
