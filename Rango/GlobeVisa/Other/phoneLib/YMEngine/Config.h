//
//  Config.h
//  BankCardScanDemo
//
//  Created by apple on 15/1/14.
//
//

#define SYSTEM_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ERROR_OK @"1"
#define ERROR_SERVER @"服务器请求超时，请重试"
#define ERROR_NULL @"识别结果为空，请重新拍照或者导入"
#define ERROR_TIMEOUT @"识别错误，请检查手机时间"
#define ERROR_NotReachable @"无网络连接，请连接网络"


enum
{
    kerror = 0,
    kname,
    kcompany,
    kdepartment,
    kjobtitle,
    ktel_main,
    ktel_mobile,
    ktel_home,
    Ktel_inter,
    kfax,
    kpager,
    kweb,
    kemail,
    kaddress,
    kpostcode,
};