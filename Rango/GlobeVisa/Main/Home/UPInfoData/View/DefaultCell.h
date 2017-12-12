//
//  DefaultCell.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/27.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXDefaultCellDelegate <NSObject>



@end
@interface DefaultCell : UITableViewCell

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, assign) BOOL isLast;

@property (nonatomic, assign) BOOL changed; // 性别是或否改变

//普通cell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *valueTF;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

// 性别
@property (weak, nonatomic) IBOutlet UILabel *sexTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *manImg;
@property (weak, nonatomic) IBOutlet UIImageView *girlImg;

@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *dateTextLab;


- (BOOL)changed;
@end

