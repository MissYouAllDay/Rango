//
//  PackageAPI.h
//  BankCardScanDemo
//
//  Created by mac on 15-1-7.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CCHttpManager.h"

//#define serverUrl @"http://eng.ccyunmai.com:5008/SrvEngine"
//#define serverUrl @"http://www.yunmaiocr.com/SrvXMLAPI"
#define serverUrl @"https://www.yunmaiocr.com/SrvXMLAPI"

@interface PackageAPI : UIViewController

@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, copy) NSData *receiveData;
@property (nonatomic, copy) NSString *result;

-(void)AFNuploadPackage:(NSData*)imageData Success:(SuccessBlock)sucess Fail:(ErrorBlock)fail;
-(void)AFNuploadPackage2:(NSData*)imageData Success:(SuccessBlock)sucess Fail:(ErrorBlock)fail;
@end
