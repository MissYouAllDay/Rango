//
//  MSLIDCardVC.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/11/8.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#import "RootViewController.h"
#import "MSLOrderDatumModel.h"

//云脉
#import "PackageAPI.h"      //云脉
#import "Config.h"          //云脉
#import "SVProgressHUD.h"
#import "HCCommonAPI.h"
@interface MSLIDCardVC : RootViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,NSXMLParserDelegate,UITextFieldDelegate>
{
    UIImagePickerController *_pickerController;
    
    NSString                 *_dataStr;
        UIActionSheet           *progressSheet;
    UIProgressView          *progressBar;
    UIActivityIndicatorView *activityView;
    UIButton                *cancelButton;
    NSInteger               progressValue;
    // BKAppDelegate           *BKApp;
    BImage                  *_bImage;
    UIImage                 *idCardImage;
}

// 是否是从联系人中进行修改
@property (nonatomic, assign) BOOL contactChange;

@property (nonatomic, copy) NSString *contactID; // 联系人id

@property (nonatomic, copy) NSString *orderID;  // 订单id

@property (nonatomic, strong) NSArray *imageArr;

//@property (nonatomic, strong) MSLOrderDatumModel *fontModel;
//
//@property (nonatomic, strong) MSLOrderDatumModel *backModel;



@end
