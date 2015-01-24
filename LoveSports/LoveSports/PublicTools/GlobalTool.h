//
//  GlobalTool.h
//  MissionSky-iOS

//  通用宏 & 枚举

#ifndef Global_h
#define Global_h

#pragma mark ---------------- 屏幕适配 ------------
#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kUnderStatusBarStartY (kIOSVersions>=7.0 ? 20 : 0)                 //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kIPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)     //设置

#define kApplicationSize      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define kApplicationWidth     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             215

#define kButtonDefaultWidth (kIPhone4s ? 278 : 288)   //默认输入框宽
#define kSendSMSButtonWidth  90  //验证码按钮长度
#define kButtonDefaultHeight 42  //默认输入框&按钮高
#define kCellDefaultHeight = 44       //默认Cell高度

#pragma mark ---------------- 第三方函数 ------------
//比较字符串是否相等（忽略大小写），相等的话返回YES，否则返回NO。
#define kCompareStringCaseInsenstive(thing1, thing2) [thing1 compare:thing2 options:NSCaseInsensitiveSearch|NSNumericSearch] == NSOrderedSame
#define kCenterTheView(view) view.center = CGPointMake(kScreenWidth / 2.0, view.center.y)  //设置x方向屏幕居中


#pragma mark ---------------- 字体/颜色 ------------
#define kRGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define kRGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define kHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//页面通用背景颜色
#define kBackgroundColor kHexRGB(0xFFFFFF)
//导航栏背景颜色值
#define kNavigationBarColor kHexRGB(0x111923)
//导航栏字体颜色值：#FFFFFF;
#define kNavigationBarTitleColor kHexRGB(0xFFFFFF)
//页面字体颜色
#define kPageTitleColor [UIColor blackColor]
//holdPlacer字体颜色
#define kHoldPlacerColor kRGB(166.0, 166.0, 166.0)
//页面标记高亮颜色
#define KBackgroundHighlightColor kRGB(243.0, 243.0, 243.0)
//页面分隔线颜色
#define KLineBackgroundColor kHexRGB(0xaaaaaa)
//底部下单等背景颜色
#define KBottomBtnBackgroundColor kRGB(245.0, 204.0, 51.0)


#define kNavigationBarTitleFontSize       20   //导航条标题字体大小
#define kNavigationBarTitleFont  [UIFont fontWithName:@"HelveticaNeue-Light" size:kNavigationBarTitleFontSize]  //导航标题字体

#define kStatementFontSize    [UIFont systemFontOfSize:12]            //陈述字体大小
#define kTextFontSize         [UIFont systemFontOfSize:16]            //正文字体大小
#define kButtonFontSize       [UIFont systemFontOfSize:19]         //按钮字体大小
#define kButtonBackgroundColor kRGB(248.0, 194.0, 40.0)   //按钮默认背景色
#define kLabelTitleDefaultColor kRGBAlpha(0, 0, 0, 0.8)  //默认label文字颜色
#define kButtonBackGroundImage @"btn_bg"    //按钮默认背景图片

#define kTitleFontSize        [UIFont systemFontOfSize:20]            //标题字体
#define kTextFeildFontSize     [UIFont systemFontOfSize:12]             //输入框字体大小
#define kBackGroundImage      [UIImage imageNamed:@"shurukuang.png"]  //输入框背景图片

#define kDefaultPlaceholderImage  @"default-holdpic.jpg"    //通用背景placeHolde图片
#define kDefaultPlaceholderImage_Long  @"default-holdpic-long.jpg"    //通用背景placeHolde长图片

#define kDefaultHeadPhoto  @"头像"        //默认头像


#pragma mark ---------------- 请求相关------------
#define kNotifyOfOutTimer       @"requestoutoftime"                     //请求超时



#pragma mark ---------------- 通知 & Key------------
/*
 登录
 */
#define kNotifyLoginSuccess                     @"kNotifyLoginSuccess"   //登录成功
#define kNotifyLoginFailure                     @"kNotifyLoginFailure";  //登录失败

/*
 用户信息
 */
#define kLastLoginUserName             @"LoginSuccess_userName"   //前一次登录用户名
#define kLastLoginUserInfo                      @"kLastLoginUserInfo"      //上次登录用户的信息 用于持续登录

//用户信息相关key
#define kUserInfoOfHeadPhotoKey  @"userInfo001"  //头像
#define kUserInfoOfNickNameKey  @"userInfo002"  //昵称
#define kUserInfoOfAgeKey  @"userInfo003"  //年龄
#define kUserInfoOfSexKey  @"userInfo004"  //性别
#define kUserInfoOfHeightKey  @"userInfo005"  //身高
#define kUserInfoOfWeightKey  @"userInfo006"  //体重
#define kUserInfoOfInterestingKey  @"userInfo007"  //兴趣点
#define kUserInfoOfAreaKey  @"userInfo008"  //地区
#define kUserInfoOfDeclarationKey  @"userInfo009"  //宣言

/*
 缓存信息
 */
#define kLastHomePageInfo             @"LastHomePageInfo"   //前一次首页信息


#pragma mark ---------------- 枚举、类型------------
/*
 接收、发送、更新数据
 */
typedef enum{
    kAPI_GET,       //get data from sever
    kAPI_POST,      //post data to sever
    kAPI_PUT,       //update the data to sever
    kAPI_DELETE     //delete
}kAPI_PROTO;

/*
 API接口
 */
#define kCheckVersion  @"CheckVersion"            //1.1.1  版本检测



#pragma mark ---------------- 描述文字、默认业务字符------------
#define kCustomerServicePhoneNumber   @"0591-8888888"  //客服电话号码

#define kShopUrl  @"http://www.baidu.com"   //爱运动商城URL


#define kUserNamePlaceHoldText @"请输入您的手机号或Email"              //用户名holdplace文字
#define kPasswordPlaceHoldText @"请输入您的密码"              //密码holdplace文字
#define kSMSPlaceHoldText @"请输入验证码"                   //验证码...
#define kPhonePlaceHoldText @"请输入您的手机号码"                 //手机号码...
#define kNickNamePlaceHoldText @"请输入您的昵称，最多16位"              //昵称...
#define kNewPasswordPlaceHoldText  @"请输入您的密码，至少6位"          //新密码...
#define kNewPassword2PlaceHoldText @"请再次输入您的密码，至少6位"          //新密码确认密码

#define kPasswordErrorMessage @"密码长度为8~20位，由6至20位的字母或数字组成"  //密码错误时提示

#define kUpdateNickNamePlaceHoldText @"请输入您的昵称，最多16位"         //昵称修改
#define kUpdateEmailPlaceHoldText @"请输入您电子邮箱"         //邮箱修改
#define kUpdatePasswordPlaceHoldText @"请输入旧密码，由6至20位的字母或数字组成"         //密码修改






#endif
