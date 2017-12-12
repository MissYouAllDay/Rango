//
//  CXAlertView.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/8/2.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    SexType,
    JobType,
    CameraType,
} MyInFoType;
@protocol CXAlertDelegate

- (void)popTableViewDidSelect :(NSIndexPath *)index withType:(MyInFoType)type;

@end

@interface CXAlertView : UIView

@property (nonatomic, assign) MyInFoType infoType;

@property (weak,nonatomic)id< CXAlertDelegate > popViewDelegate;

@property (nonatomic, assign) BOOL isSex;  //是否是  性别选项

// 标题
@property (nonatomic, copy) NSString *titler;

/*遮罩层背景色*/
@property (strong,nonatomic) UIColor *shadowViewBackgroundColor; //defult 155,155,155

//tableView dataSource
@property (nonatomic,strong) NSArray *tableDataArray;

- (void)showPopView;
/*从哪一点显示出来*/
@property (assign,nonatomic) CGPoint showPoint;

- (void)hidenPopView;

@end
