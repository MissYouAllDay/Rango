//
//  PassportViewController.h
//  GlobeVisa
//
//  Created by MSLiOS on 2017/6/1.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"

#import "MSLOrderDatumModel.h"//订单

#import "NSData+Base64.h"
#import "PackageAPI.h"
#import "Config.h"
#import "SVProgressHUD.h"
#import "HCCommonAPI.h"

@interface PassportViewController : RootViewController
{
    UIImagePickerController *_pickerController;
    NSString                 *_dataStr;
    UIActionSheet           *progressSheet;
    UIProgressView          *progressBar;
    UIActivityIndicatorView *activityView;
    NSInteger               progressValue;
    BImage                  *_bImage;
    UIImage                 *idCardImage;
}

// 是否是从联系人中进行修改
@property (nonatomic, assign) BOOL contactChange;

@property (nonatomic,copy) NSString *contactID;  //联系人id
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic,strong) MSLOrderDatumModel *datumModel;  //订单model

@property (nonatomic,assign)BOOL  isProgressCanceled;
@end
