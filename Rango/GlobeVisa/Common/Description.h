//
//  Description.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/8/15.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#ifndef Description_h
#define Description_h

// 1、首页banner 及点击事件不一致   中信为网址   蜥蜴为图片

// - - -- - -- - - -  - -- - - -  - - - - 分享 - - - - -  - -- - - -  - -- - - - - - - - - - -

#define APP_NAME        @"百变蜥蜴"

#define SHARE_TITLE     @"百变蜥蜴全球签证，一同畅享全球酒店和全球飞行吧！"
#define SHARE_DETAIL    @"轻触开始签证按钮即可办理全球签证"
#define SHARE_URL       @"http://usamsl.com/APP/index.html"


// - - - - - - - - - - - - - - 友盟  - - - - - - - - - - - - - - -

#define UM_APPKEY       @"5982d40304e2050ea5000468"
#define QQ_APPKEY       @"101418106"
#define WX_APPKEY       @"wx624ee0202313e892"
#define WX_APPSECRET    @"d530a71d445825cfdf67beaf302fe5cd"


// - - - - - - - - - - - - - - 签证照片  - - - - - - - - - - - - - -

#define SAFELIGHT_KEY        @"d5e9b21ad4064641a530305efeaa61a5"
#define SAFELIGHT_SECRET     @"e83fbf29f5e9478c8d2b23d8ac7607ba"
#define SAFELIGHT_SPECKEY    @"774fc5348ae0419ca5328c4a0446c46b"


// - - --  - -- - - -  - -- - - - - - - - 推送 - - - - - - - - -- - - -  - -- - - -  - - - - -

#define JPUSH_APPKEY    @"23e14a54508bcf625d7e70d7"


// - - --  - -- - - -  - -- - - - - - - - 支付宝 - - - - - - - - -- - - -  - -- - - -  - - - - -

#define APPSCHEME   @"alipay2017080708077999"

// - - --  - -- - - -  - -- - - - - - - - 后台账号区分 - - - - - - - - -- - - -  - -- - - -  - - - - -

#define APP_COMPANY_ID          @"app_company_id"  //key
#define APP_COMPANY_IDNUM       @"2"               // value  百变蜥蜴 ： 2  中信银行： 3

#define PROJECT_ID              @"app_id"           // ava 区分标志
#define PROJECT_IDNUM           @"global_visa"      //

//首页 第一次加载时候的ava动画      知道了   按钮 颜色 
#define KNOW_BTN ([UIColor colorWithRed:89/255.0 green:241/255.0 blue:224/255.0 alpha:1])

//浅色按钮 浅绿
//#define QIANSEBTNCOLOR          ([UIColor colorWithRed:188/255.0 green:215/255.0 blue:142/255.0 alpha:1])
//导航栏颜色 深绿
#define NAVGATIONCOLOR          ([UIColor colorWithRed:120/255.0 green:178/255.0 blue:0/255.0 alpha:1])

//国家英文名 字体颜色
//#define COUNTRY_NAME_ENGLISH    ([UIColor colorWithRed:176/255.0 green:208/255.0 blue:124/255.0 alpha:1])
// 登录  注册  密码修改  确定按钮颜色
//#define COLOR_LOGINSURE         ([UIColor colorWithRed:90/255.0 green:241/255.0 blue:224/255.0 alpha:1])

// 客服电话
#define SERVICEMAN_PHONE      @"4000066518"

#endif /* Description_h */
