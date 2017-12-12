//
//  ViewController.h
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DJCameraViewControllerDeletate <NSObject>

//图片数组
- (void)selectPaiShePhotos:(UIImage *)photosMy;

- (void)selectAlbumPhotos:(UIImage *)photosAlbum;

- (void)selectPaiShePhoto:(UIImage *)image withURL:(NSURL *)url;

@end

@interface DJCameraViewController : UIViewController

@property (nonatomic, assign) BOOL albimHidden; // 相册隐藏

@property(nonatomic,strong) UIImageView* markImg;//修改背景图片使用

@property(nonatomic,weak) id<DJCameraViewControllerDeletate>delegateMy;//x选择回调
@property(nonatomic,weak) id<DJCameraViewControllerDeletate>delegateAlbum;//x选择回调

@end

