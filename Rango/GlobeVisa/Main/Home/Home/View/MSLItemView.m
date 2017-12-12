//
//  MSLItemView.m
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/10/17.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "MSLItemView.h"


@implementation MSLItemView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
   
//        self.meunImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.widthCX/4, self.heightCX/6, self.widthCX/2, self.heightCX/2)];
//        [self addSubview:self.meunImg];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.widthCX, self.heightCX)];
        [self addSubview:self.title];
        
        self.title.font = FONT_SIZE_14;
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
