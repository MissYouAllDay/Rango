//
//  MessageCell.h
//  GlobeVisa
//
//  Created by MSLiOS on 2017/2/4.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

//1) 聊天窗口的间隙
#define kEdgeSize       10
//2) 头像的宽度
#define kHeadImageSize  40
@interface MessageCell : UITableViewCell

@property(nonatomic,strong) NSDictionary *message;

@end
