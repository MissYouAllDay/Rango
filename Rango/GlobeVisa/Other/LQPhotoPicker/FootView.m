//
//  FootView.m
//  GlobeVisa
//
//  Created by MSLiOS on 2017/4/19.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "FootView.h"

@implementation FootView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //
        if (WIDTH>375) {
            self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,15, WIDTH-30, 14)];
            self.fLabel.font = FONT_14;
            
            self.fLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,52, WIDTH-30, 12)];
            self.fLabel.font = FONT_12;
            
            self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,73 , WIDTH-30, 12)];
            self.tLabel.font = FONT_12;
            
            self.thLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,95 , WIDTH-30, 12)];
            self.thLabel.font = FONT_12;

        }else
        {
            self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,10, WIDTH-30, 11)];
            self.fLabel.font = FONT_11;
            
            self.fLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,36, WIDTH-30, 10)];
            self.fLabel.font = FONT_10;
            
            self.tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,52 , WIDTH-30, 10)];
            self.tLabel.font = FONT_10;
            
            self.thLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,68 , WIDTH-30, 10)];
            self.thLabel.font = FONT_10;
        }
        self.nameLabel.textColor = FONT_COLOR_38;
        [self addSubview:self.nameLabel];
        
        self.fLabel.textColor = GRAY_126;
        [self addSubview:self.fLabel];
        
        self.tLabel.textColor = GRAY_126;
        [self addSubview:self.tLabel];
        
        self.thLabel.textColor =GRAY_126;
        [self addSubview:self.thLabel];
        
    }
    return self;
}
@end
