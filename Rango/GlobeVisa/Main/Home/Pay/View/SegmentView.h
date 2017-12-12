//
//  SegmentView.h
//  SegmentView
//
//  Created by Mac on 15-10-24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SegmentbBlock)(NSInteger index);
@interface SegmentView : UIView
{
    SegmentbBlock _segmentBlock;
}

@property (strong, nonatomic) UIImageView *seletImageView;
@property (strong, nonatomic) UIButton *button;

@property (nonatomic, copy) NSArray *titleList;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) NSString *selectImage;


- (void)addBlock:(SegmentbBlock)block;


@end
