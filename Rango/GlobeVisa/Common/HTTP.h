//
//  HTTP.h
//  GlobeVisa
//
//  Created by 盟仕乐 on 2017/5/11.
//  Copyright © 2017年 MSLiOS. All rights reserved.
//

#ifndef HTTP_h
#define HTTP_h

//#define BASEURL        @"http://139.196.136.150:8081/VisaInterface/app/"  //测试 接口
//#define BASEURL         @"http://139.196.88.32:8080"       //正式数据

//  相对端口
#define ROOTURL          @"http://139.196.136.150:8080/VisaInterface/app"
//#define ROOTURL         @"http://192.168.16.54:8080/VisaInterface/app"
// 首页轮播图  banner
#define BANNER_URL       @"/index/bannerList"

// 热门
#define HOT_URL          @"/visa/appLoadVisaEasy"

// 首页国家列表
#define COUNTRYLIST_URL @"/index/countryList.do"

// 搜索国家
#define URL_CITY_SEARCH     @"/area/loadCountry.do"

// area 界面
#define AREA_URL        @"/visa/loadVisaName"

// 省份
#define PROVICE_URL     @"/area/loadProvince.do"

// 所需资料
#define NEEDINFO_URL    @"/visa/loadVisaDatumFen"

// 联系人查询
#define CONTACT_QUERY   @"/contact/selectContactAll"

// 人员类型  1：在职人员、2：自由职业者、3：学龄前儿童、4：学生、5：退休人员）
#define JOB_URL         @"/visa/loadCustTypeList"


#pragma mark - - - - - - - - - - - - - - 资料上传  - - - - - - - - - - - - - - -


// 签证所需 相片 列表 《护照、身份证、户口本、驾驶证等》
#define ORDERDATUM_URL      @"/visa/orderDatum"


// 上传图片    订单流程进入时调用  url 拼接的时候file前不带有“/”
#define  UPIMG_URL           @"fileupload/uploadOrder.do"
// 申请人管理界面进入时调用
#define  UPIMG_CONTACR_URL    @"fileupload/uploadDatum"

// 上传完资料 调用   用于关联 资料
#define UPINFO_URL               @"/order/updateOrderDatum"

#pragma mark - - - - - - - - - - - - - - HTML  - - - - - - - - - - - - - - -

// 获取签证表单
#define HTML_FORM_URL           @"/order/selectRequest.do"

// HTML  最终保存 的时候调用
#define HTML_UPINFO_URL          @"/order/updateInfo"

#pragma mark - - - - - - - - - - - - - - 订单操作  - - - - - - - - - - - - - - -

// 新增联系人并下单
#define ADD_POSTORDER_URL   @"/contact/fromContact.do"

// 下单
#define ADD_ORDER_URL       @"/order/orderVisaIsAdd.do"

// 订单列表
#define ORDER_LIST_URL      @"/order/AppOrderAll"

// 订单详情
#define ORDERDETAIL_URL     @"/order/orderDetail"

// 取消订单
#define CANCEL_ORDER_URL     @"/order/orderUpdateStop.do"

//支付完成改变状态
#define CHANGE_ORDER_URL     @"/order/orderPay.do"

// 更新订单
#define URL_ORDER_UPDATE    @"/order/updateOrder.do"


#pragma mark - - - - - - - - - - - - - - 联系人操作  - - - - - - - - - - - - - - -

// 获取申请人信息
#define  CONTACTINFO_URL    @"/contact/getContact"

// 新增联系人
#define ADD_CONTACT_URL     @"/contact/contact.do"

// 修改联系人
#define CHANGE_CONTACT_URL  @"/contact/updateContact.do"

// 申请人详细资料     /visa/findContactList?contact_id=240
#define CONTACT_INFO_URL        @"/visa/findContactList"


#pragma mark - - - - - - - - - - - - - - 登录  注册   - - - - - - - - - - - - - - -


// 用户注册
#define REG_URL         @"/customer/registerCust"

// 核对手机号
#define TEL_URL         @"/customer/validationPhone"

// 发送验证码
#define MESAGE_URL      @"/customer/sendSMS.do"

//  密码登录
#define LOGIN_URL       @"/customer/login"

//   验证码登录
#define MESLOGIN_URL    @"/customer/loginMsg"

//  忘记面密码
#define CHANGEPW_URL    @"/customer/forgotPwd.do"

// 第三方登录
#define OTHER_LOGIN     @"/customer/loginOther.do"

#define CHANGE_TEL_URL  @"/customer/bundlingPhone.do"

#pragma mark - - - - - - - - - - - - - - - 支付 - - - - - - - - - - - - - - -

// 银行查询  //longitude=121.5241682687&latitude=31.2289578381&area_name=上海
#define BANK_SEARCH_URL          @"/index/bankDef.do"

//银行网点
#define URL_BANK_DOT_CONTACTS   @"/index/bankList.do"

//获取签名
#define URL_SECRETKEY           @"/index/aliPayCode.do"


// 支付完成  签证国家推荐
#define PAYEND_URL               @"/index/countryOrderList.do"

// 线下支付
#define UNLINE_PAY_URL            @"/order/orderOffPayAdd.do"

#pragma mark - - - - - - - - - - - - - - - 发现 - - - - - - - - - - - - - - -

//平台资询
#define PLATFORM_URL            @"/index/informationList"

//  名词解析 问题咨询     （名词解析 ：problem 默认传递 “签证”）（问题咨询： &page=页&num=条）
#define NOUNAN_URL               @"/index/problemList"

// 隐私政策     关于平台
#define  URL_PRIVACY_WEB        @"http://139.196.88.32:8080/GlobalVisa/app/authorize/authorize.do"//



#endif /* HTTP_h */
