//
//  MSJYShell.m
//  mugshot
//
//  Created by EyreFree on 15/9/6.
//  Copyright (c) 2015年 junyu. All rights reserved.
//

#import "MSJYManager_OC.h"
#import "UIImage+RGBAConv.h"
#include "JY_IDPhoto.h"


@interface MSJYManager_OC()

@end

@implementation MSJYManager_OC {
    NSData* h_data;
    
    CAMPicContext* contentFun;
    CAMBuffer* buffertest;
    
    //是否双人
    BOOL isMulti;
}

+ (id)sharedInstance{
    static dispatch_once_t timer = 0;
    static id instance = nil;
    dispatch_once(&timer, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init {
    if(self=[super init]) {
        [self chuShiHua];
        buffertest = [CAMBuffer new];
    }
    return self;
}

-(void)setMode:(BOOL)isMultiPlay {
    isMulti = isMultiPlay;
}

-(void)chuShiHua {
    NSLog(@"初始化");
    NSError *error;

    NSString *fpath = [[NSBundle bundleForClass:[self class]] pathForResource:@"JY_FaceSDK" ofType:@"bin"];

    h_data = [NSData dataWithContentsOfFile:fpath
                                    options:NSDataReadingMappedAlways
                                      error:&error];
    if(error) {
        NSLog(@"%@", error);
    }
    JY_IDPhoto_Init(h_data.bytes);
    NSLog(@"初始化 完成");
}

//获取缩放尺寸 :和 CGSize.autoSize 重复了
-(CGSize)checkSize:(CGSize)staticSize :(CGSize)targetSize {
    CGFloat targetScale = targetSize.width / targetSize.height;
    CGFloat usableScale = staticSize.width / staticSize.height;
    
    return (targetScale > usableScale ?
            CGSizeMake(staticSize.width, CGFloat(staticSize.width / targetScale)) :
            CGSizeMake(CGFloat(staticSize.height * targetScale), staticSize.height)
            );
}

#define MY_MAX_PIXELS CGSizeMake(720, 960)//800,800//960,1280
-(CAMPicContext *)renLianShu:(UIImage*)image {
    NSLog(@"计算人脸");
    if (image.size.width > MY_MAX_PIXELS.width || image.size.height > MY_MAX_PIXELS.height) {
        UIImage *tempImg = [image fixOrientationWithSize: [self checkSize:MY_MAX_PIXELS :image.size]];
        //todo:这里有问题的哦
        if (nil != tempImg) {
            image = tempImg;
        }
    }
    contentFun = [[CAMPicContext alloc] initWithImg:image];
    [contentFun initOriBuf];
    
    uint8_t* gray = [contentFun.oriBuf getGray];
    int count = 0;
    if (isMulti) {
        count = JY_IDPhoto_FaceLocMrg(gray, contentFun.oriBuf.width, contentFun.oriBuf.height);
    } else {
        count = JY_IDPhoto_FaceLoc(gray, contentFun.oriBuf.width, contentFun.oriBuf.height);
    }
    free(gray);
    if(count > 0) {
        contentFun.param[@"count"] = @(count);
    }
    NSLog(@"计算人脸 完成");
    return contentFun;
}

-(void)jiSuanKuang {
    NSLog(@"计算框");
    NSMutableDictionary *pp = contentFun.param;
    if(pp[@"count"] == nil || [pp[@"count"] intValue] == 0) {
        return;
    }
    CGRect last;
    int rectangleMrg[4];  //两个人合并框;
    int rectLeftPerson[4];  //左边人框
    int rectRightPerson[4]; //右边人框
    if (isMulti) {
        JY_IDPhoto_AreaMrg(rectangleMrg,rectLeftPerson,rectRightPerson);
        last = CGRectMake(
                          rectangleMrg[0],
                          rectangleMrg[1],
                          rectangleMrg[2] - rectangleMrg[0] + 1,
                          rectangleMrg[3] - rectangleMrg[1] + 1
                          );
    } else {
        JY_IDPhoto_GetArea(rectLeftPerson);
        last = CGRectMake(
                          rectLeftPerson[0],
                          rectLeftPerson[1],
                          rectLeftPerson[2] - rectLeftPerson[0] + 1,
                          rectLeftPerson[3] - rectLeftPerson[1] + 1
                          );
    }
    
    
    NSMutableArray *box = [NSMutableArray array];
    [box addObject:[NSValue valueWithCGRect: last]];
    
    //合成出最大的框后，偏移point端点
    last.origin.x = -last.origin.x;
    last.origin.y = -last.origin.y;
    
    //偏移端点为图片内嵌区域
    pp[@"area"] = [NSValue valueWithCGRect:last];
    pp[@"box"] = box;
    
    NSLog(@"pp.area:%@", [NSValue valueWithCGRect:last]);
    NSLog(@"计算框 完成");
}

-(void)sheZhiTuPian:(UIImage*)extImage {
    NSLog(@"设置图片");
    buffertest.ext32 = YES;
    [buffertest putImage:extImage];
    
    if (isMulti) {
        JY_IDPhoto_SetImgMrg(buffertest.buf, buffertest.width, buffertest.height);
    } else {
        JY_IDPhoto_SetImg(buffertest.buf, buffertest.width, buffertest.height);
    }

    //获得灰度图数据
    //NSLog(@"width:%d, height:%d", buffertest.width, buffertest.height);
    //[self getDataFile:buffertest.buf :buffertest.width * buffertest.height * 3 :@"extImage"];
    
    NSLog(@"设置图片 完成");
}

-(void)daFeng {
    NSLog(@"打分");
    int judgepositive_ = 0;
    int judgedim_;
    int judgetwoFaces_;
    int judgeBFSimilarity_;
    int judgeHeightDifference_ = 0;
    int judgeDistanceDifference_ = 0;
    if (isMulti) {
        JY_IDPhoto_Judge_EnvMrg(&judgedim_,&judgetwoFaces_,&judgeBFSimilarity_,&judgeHeightDifference_,&judgeDistanceDifference_);
    } else {
        JY_IDPhoto_EnvJudge(&judgepositive_,&judgedim_,&judgetwoFaces_,&judgeBFSimilarity_);
    }
    NSMutableArray* _judge = [NSMutableArray array];
    [_judge addObject:@(judgetwoFaces_)];
    [_judge addObject:@(judgedim_)];
    [_judge addObject:@(judgeBFSimilarity_)];
    if (isMulti) {
        [_judge addObject:@(judgeHeightDifference_)];
        [_judge addObject:@(judgeDistanceDifference_)];
    } else {
        [_judge addObject:@(judgepositive_)];
    }
    contentFun.param[@"judge"] = _judge;
    NSLog(@"打分 完成");
}

@end

