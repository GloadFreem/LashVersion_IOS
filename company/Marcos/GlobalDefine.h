#ifndef PetGuLu_Constance_h
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//UIStatusBarStyle SB=UIStatusBarStyleLightContent;
#else
//UIStatusBarStyle SB=UIStatusBarStyleBlackTranslucent
#endif
#define PetGuLu_Constance_h
#define WebServiceUri @"http://ws.gulu8.com"
#define PetDefaultImage @"PetDefault.jpg"
#define UserDefaultImage @"UserDefault.jpg"

#define PopuleColor [UIColor colorWithRed:194.0/255 green:5.0/255  blue:81.0/255 alpha:1.0f]
#define GreenColor [UIColor colorWithRed:173.0/255 green:202.0/255  blue:83.0/255 alpha:1.0f]
#define YellowColor [UIColor colorWithRed:242.0/255 green:188.0/255  blue:0.0/255 alpha:1.0f]
#define GrayColor [UIColor colorWithRed:137.0/255 green:130.0/255  blue:148.0/255 alpha:1.0f]
#define LightGrayColor [UIColor colorWithRed:236.0/255 green:236.0/255  blue:236.0/255 alpha:1.0f]
#define DEFAULT_BLUE [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]



//表格数据库

#define ROADTABLE @"road"
#define PROJECTTABLE @"project"
#define BANNERTABLE @"banner"

#define INVESTPERSONTABLE @"investPerson"
#define INVESTORGANIZATIONTABLE @"investOrganization"
#define INVESTORGANIZATIONSECONDTABLE @"investOrganizationSecond"
#define THINKTANKTABLE @"thinkTank"
#define CIRCLETABLE @"circle"
#define ACTIVITYTABLE @"activity"
//常量
#define VIEWWIDTH 320   //视图宽度
#define VIEWSTART 0     //视图起始坐标x
#define VIEWEND   320   //视图起始坐标y
#define NUMBERTHIRTY 30
#define NUMBERFORTY 40
#define NUMBERHUNDRED 100

//屏幕
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)

 
/***===================================================================================**
 *                                          app 颜色常亮
 *
 ***===================================================================================**/
#define THEME_COLOR [UIColor colorWithRed:0.0/255 green:186.0/255  blue:181.0/255 alpha:1.0f]
#define PEISONG_COLOR [UIColor colorWithRed:252.0/255 green:107.0/255  blue:79.0/255 alpha:1.0f]
#define CLEAR_COLOR [UIColor colorWithRed:0.0/255 green:186.0/255  blue:181.0/255 alpha:1.0f]
#define MORNING_COLOR [UIColor colorWithRed:0.0/255 green:186.0/255  blue:181.0/255 alpha:1.0f]
#define BUTTON_COLOR [UIColor colorWithRed:246.0/255 green:140.0/255  blue:66.0/255 alpha:1.0f]
#define BACKGROUND_COLOR [UIColor colorWithRed:239.0/255 green:239.0/255  blue:246.0/255 alpha:1.0f]
#define BACKGROUND_GRAY_COLOR [UIColor colorWithRed:239.00/255 green:239.00/255 blue:244.00/255 alpha:1]
#define TABLE_ORDER_IMAGE_COLOR1 [UIColor colorWithRed:246.00/255 green:140.00/255 blue:66.00/255 alpha:1]
#define TABLE_ORDER_IMAGE_COLOR2 [UIColor colorWithRed:204.00/255 green:204.00/255 blue:204.00/255 alpha:1]

//普通app字体颜色
#define ColorFontNormal  [UIColor colorWithRed:0x66/256. green:0x66/256. blue:0x66/256. alpha:1]
//浅色app字体颜色
#define ColorFontLight  [UIColor colorWithRed:0x66/256. green:0x66/256. blue:0x66/256. alpha:1]
//鸡肉描述颜色
#define CHICKEN_COLOR [UIColor colorWithRed:250.00/255 green:124.00/255 blue:124.00/255 alpha:1];
//猪肉描述颜色
#define PIG_COLOR [UIColor colorWithRed:128.00/255 green:200.00/255 blue:255.00/255 alpha:1];
//鱼肉颜色描述
#define FISH_COLOR [UIColor colorWithRed:228.00/255 green:164.00/255 blue:255.00/255 alpha:1];
//牛肉颜色描述
#define COW_COLOR [UIColor colorWithRed:255.00/255 green:170.00/255 blue:128.00/255 alpha:1];
//蔬菜描述颜色
#define VEGETABLE_COLOR [UIColor colorWithRed:132.00/255 green:205.00/255 blue:111.00/255 alpha:1];
//描述盒子类型颜色
#define BOX_MODEL_COLOR [UIColor colorWithRed:176.00/255 green:92.00/255 blue:58.00/255 alpha:1];
#define  MESSAGETPL @"您的短信验证码为：%ld"

//各种溯源状态
//厨师烹饪
#define ORINGINL_COOKING [UIColor colorWithRed:0xFC/256. green:0x6B/256. blue:0x4F/256. alpha:1.0]
//你好早安
#define ORINGINL_MORNING [UIColor colorWithRed:0x84/256. green:0xCD/256. blue:0x6F/256. alpha:1.0]
//厨师烹饪
#define ORINGINL_TAKEN [UIColor colorWithRed:0xF6/256. green:0x8c/256. blue:0x42/256. alpha:1.0]
//厨师烹饪
#define ORINGINL_FRESH [UIColor colorWithRed:0x68/256. green:0xA5/256. blue:0xE1/256. alpha:1.0]
//厨师烹饪
#define ORINGINL_DISPATCH [UIColor colorWithRed:0x00/256. green:0xBA/256. blue:0xB5/256. alpha:1.0]
//背景
#define BACKGROUND_LIGHT_GRAY_COLOR [UIColor colorWithRed:0x99/256. green:0x99/256. blue:0x99/256. alpha:1.0]
//中餐未选中种类颜色
#define MENU_CHINESE_COLOR [UIColor colorWithRed:204.00/255 green:92.00/255 blue:93.00/255 alpha:1]
//西餐未选中种类颜色
#define MENU_WESTRN_COLOR [UIColor colorWithRed:170.00/255 green:117.00/255 blue:71.00/255 alpha:1]

//单元格选中颜色
#define CELL_SELECTED_COLOR [UIColor colorWithRed:229.0/255 green:248.0/255 blue:248.0/255 alpha:1]
//默认地址选中颜色
#define DEFAULT_ADDRESS_COLOR [UIColor colorWithRed:229.0/255 green:248.0/255 blue:248.0/255 alpha:1]
//textView字体颜色
#define DEFAULT_TEXTVIEW_FONT_COLOR [UIColor colorWithRed:177.0/255 green:177.0/255 blue:177.0/255 alpha:1]


//主题色
#define AppColorTheme  [UIColor colorWithRed:0xff/256. green:0x6d/256. blue:0x00/256. alpha:1]
#define AppGrayColorTheme  [UIColor colorWithRed:0x72/256. green:0x72/256. blue:0x72/256. alpha:1]
//#define ColorTheme  [UIColor colorWithRed:0xcb/256. green:0x02/256. blue:0x02/256. alpha:1]
//#define ColorTheme  [UIColor colorWithRed:46.0/255. green:45.0/256. blue:51.0/255. alpha:1]
#define ColorTheme  [UIColor colorWithRed:0x3d/256. green:0x3d/256. blue:0x3d/256. alpha:1]

#define ColorFontBlueTheme  [UIColor colorWithRed:0.0/255 green:0.0/255 blue:204/55 alpha:1]
#define ColorCompanyTheme  [UIColor colorWithRed:0xd4/256. green:0xa2/256. blue:0x25/256. alpha:1]
#define ColorTheme2  [UIColor colorWithRed:0xe6/256. green:0x97/256. blue:0x85/256. alpha:1]
#define BackColor [UIColor colorWithRed:245.0/255 green:245.0/255 blue:244.0/255 alpha:1]
//描述菜品属性
#define ColorFish  [UIColor colorWithRed:0xE4/256. green:0xA4/256. blue:0xFF/256. alpha:1]
#define ColorPig  [UIColor colorWithRed:0x80/256. green:0xC8/256. blue:0xFF/256. alpha:1]
#define ColorChicken  [UIColor colorWithRed:0xFA/256. green:0x7C/256. blue:0x7C/256. alpha:1]
#define ColorBeef  [UIColor colorWithRed:0xFF/256. green:0xAA/256. blue:0x80/256. alpha:1]
#define ColorVegeTable  [UIColor colorWithRed:0x84/256. green:0xCD/256. blue:0x6F/256. alpha:1]

//西餐菜品描述
#define ColorWest_Spaghetti  [UIColor colorWithRed:0xbc/256. green:0x88/256. blue:0x59/256. alpha:1]
#define ColorWest_Pizza  [UIColor colorWithRed:0xf0/256. green:0x8a/256. blue:0x58/256. alpha:1]
#define ColorWest_Gali  [UIColor colorWithRed:0xf5/256. green:0x8b/256. blue:0x8b/256. alpha:1]
//启动页背景
#define StartPageColor  [UIColor colorWithRed:0xFF/256. green:0xFC/256. blue:0xF7/256. alpha:1]
#define StartPageTextColor  [UIColor colorWithRed:0xA3/256. green:0x58/256. blue:0x34/256. alpha:1]

//默认地址背景颜色
#define AdreessDefaultBckColor  [UIColor colorWithRed:0xea/256. green:0xea/256. blue:0xeb/256. alpha:1]
//购物车背景颜色
#define DEFAULT_SHOPPING_COLOR [UIColor colorWithRed:63.0/255 green:67.0/255 blue:73.0/255 alpha:1]
//购物车总计份数背景颜色
#define DEFAULT_SHOPPING_COUNT_COLOR [UIColor colorWithRed:255.0/255 green:45.0/255 blue:75.0/255 alpha:1]
//购物车视图背景颜色
#define DEFAULT_SHOPPING_BACK_COLOR [UIColor colorWithRed:75.0/255 green:80.0/255 blue:87.0/255 alpha:1]

//字体名称
#define FONT_NAME @"STHeitiSC-Light"

//红色字体
#define FONT_COLOR_RED [UIColor colorWithRed:233.0/255 green:72.0/255 blue:25.0/255 alpha:1]

//红色字体
#define FONT_COLOR_BLACK [UIColor colorWithRed:0x40/256. green:0x40/256. blue:0x40/256. alpha:1]

//红色字体
#define FONT_COLOR_GRAY [UIColor colorWithRed:0x72/256. green:0x72/256. blue:0x72/256. alpha:1]
//连接颜色
#define FONT_LINK_COLOR_GRAY [UIColor colorWithRed:0/255 green:128.0/255 blue:0/255 alpha:1]

//溯源背景颜色数组
#define ORINGINL_COLORS [NSMutableArray arrayWithObjects:ORINGINL_MORNING,ORINGINL_TAKEN,ORINGINL_FRESH,ORINGINL_COOKING,ORINGINL_DISPATCH,ORINGINL_DISPATCH,ORINGINL_COOKING,ORINGINL_COOKING,nil]
#define ClearColor [UIColor clearColor]
#define BlackColor [UIColor blackColor]
#define WriteColor [UIColor whiteColor]

/***===================================================================================**
 *                                          服务器数据获取相关
 *
 
 
 ***===================================================================================**/

//服务器域名地址
//#define SERVICE_URL @"http://www.jinzht.com:8088/jinzht/"//服务器域名地址
//#define SERVICE_URL @"http://www.jinzht.com:8080/jinzht/"//服务器域名地址
#define SERVICE_URL @"http://192.168.5.162:8080/jinzht/"//本地

#define KEY @"jinzht_server_security"
#define PLATFORM @"1"
#define REGIST_TYPE @"0"
#define FORGET_TYPE @"1"
#define CERTIFY_TYPE @"2"
#define CHANGE_PHONE_TYPE @"3"
#define VERSION @"1"
//身份证号
#define USER_STATIC_IDNUMBER @"user_static_ido"
//真实姓名
#define USER_STATIC_NAME @"user_static_name"
//地址
#define USER_STATIC_ADDRESS @"user_static_address"
//地址
#define USER_STATIC_COMPANY_NAME @"user_static_company"
//地址
#define USER_STATIC_POSITION @"user_static_position"
//身份证图片地址
#define USER_STATIC_IDPIC @"user_static_pic"
//身份证图片路径
#define USER_STATIC_IDPIC_PATH @"user_static_pic_path"
//手机号码
#define USER_STATIC_TEL @"user_static_tel"
//性别
#define USER_STATIC_GENDER @"user_static_gender"
//昵称
#define USER_STATIC_NICKNAME @"user_static_nickname"
//头像
#define USER_STATIC_HEADER_PIC @"user_static_header_pic"
//背景
#define USER_STATIC_CYCLE_BG @"user_static_cycle_bg"
//背景url
#define USER_STATIC_CYCLE_BG_URL @"user_static_cycle_bg_url"
//用户id
#define USER_STATIC_USER_ID @"user_static_user_id"

#define USER_STATIC_EXT_USER_ID @"user_static_ext_user_id"
//用户认证状态
#define USER_STATIC_USER_AUTHENTIC_STATUS @"user_static_user_authentic_status"
//用户身份
#define USER_STATIC_USER_AUTHENTIC_TYPE @"user_static_user_authentic_type"


//#define SERVICE_URL @"http://www.jinzht.com:8000/phone/"//服务器域名地址
//#define BUINESS_SERVER @"http://220.181.25.233:8081/member/bhawireless/" //易宝支付测试环境
//#define BUINESE_SERVERD @"http://220.181.25.233:8081/member/bhaexter/bhaController" //直连接口

#define BUINESS_SERVER @"https://member.yeepay.com/member/bhawireless/" //易宝支付生产环境
#define BUINESE_SERVERD @"https://member.yeepay.com/member/bhaexter/bhaController" //直连接口
#define notifyUrl @"http://www.jinzht.com/phone5/notify/"

//服务器域名地址
//#define SERVICE_URL @"http://www.jinzht.com/phone/"//服务器域名地址
//#define SERVICE_URL @"http://192.168.31.236:8080/weini/"
//#define SERVICE_URL @"http://192.168.0.182:8080/weini/"

#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------注册认证接口------------------------------------------
#pragma mark----------------------------------------------------------------------------
//是否登录
#define ISLOGINUSER @"isLoginUser.action"
//用户注册
#define USER_REGIST @"registUser.action"
//手机验证码发送
#define  SEND_MESSAGE_CODE @"verifyCode.action"
//用户手机验证码登陆
#define  USER_LOGIN @"loginUser.action"
//用户认证
#define USER_VERFITY @"requestAuthentic.action"
//忘记密码
#define USER_FORGET_PWD @"resetPassWordUser.action"
//身份类型
#define USER_IDENTIFY_TYPE @"updateIdentiyTypeUser.action"
//行业类别
#define INVEST_FIELD_LIST @"getIndustoryAreaListAuthentic.action"
//省份列表
#define PROVINCE_LIST @"getProvinceListAuthentic.action"
//城市
#define CITY_LIST @"getCityListByProvinceIdAuthentic.action"
//认证
#define AUTHENTICATE @"requestAuthentic.action"
//认证协议
#define AUTHENTICATE_PROTOCOL @"getProtocolAuthentic.action"

//微信授权登录
#define WECHATLOGINUSER @"wechatLoginUser.action"

#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------圈子接口------------------------------------------
#pragma mark----------------------------------------------------------------------------
//分享到圈子
#define SHARE_TO_CIRCLE @"shareContentToFeeling.action"
//个人圈子列表
#define CYCLE_USER_LIST @"requestUsersFeelingList.action"
//圈子功能
#define CYCLE_CONTENT_LIST @"requestFeelingList.action"
//圈子首页点赞
#define CYCLE_CELL_PRAISE @"requestPriseFeeling.action"
//圈子详情
#define CIRCLE_FEELING_DETAIL  @"requestFeelingDetail.action"
//状态分享
#define CIRCLE_FEELING_SHARE @"requestShareFeeling.action"
//分享状态更新
#define CIRCLE_FEELING_UPDATFEEL @"requestUpdateShareFeeling.action"
//状态评论
#define CIRCLE_COMMENT_FEELING @"requestCommentFeeling.action"
//发表状态
#define CIRCLE_PUBLIC_FEELING @"requestPublicFeeling.action"
//删除圈子评论
#define CIRCLE_COMMENT_DELETE @"requestContentCommentDelete.action"
//删除圈子
#define CIRCLE_LIST_DELETE @"requestPublicContentDelete.action"


#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------投资人接口------------------------------------------
#pragma mark----------------------------------------------------------------------------

//投资人列表
#define INVEST_PUBLIC_LIST @"requestInvestorList.action"
//投资人详情
#define INVEST_LIST_DETAIL @"requestInvestorDetail.action"
//项目提交
#define REQUEST_PROJECT_COMMIT @"requestProjectCommit.action"
//关注投资人
#define REQUEST_INVESTOR_COLLECT @"requestInvestorCollect.action"
//分享投资人
#define REQUEST_SHARE_INVESTOR  @"requestShareInvestor.action"


#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------项目接口------------------------------------------
#pragma mark----------------------------------------------------------------------------
//项目列表
#define REQUEST_PROJECT_LIST @"requestProjectList.action"
//项目详情
#define REQUEST_PROJECT_DETAIL @"requestProjectDetail.action"
//财务状况
#define REQUEST_PROJECT_FINANAL @"requestProjectFinance.action"
//融资状况
#define REQUEST_PROJECT_FINNAL_STATUS @"requestProjectFinanceStatus.action"
//融资方案
#define REQUEST_PROJECT_FINNAL_CASE @"requestProjectFinanceCase.action"
//商业计划书
#define REQUEST_PROJECT_FINNAL_PLAN @"requestProjectFinancePlan.action"
//退出渠道
#define REQUEST_PROJECT_FINNAL_EXIT @"requestProjectFinanceExit.action"
//分控报告
#define REQUEST_PROJECT_FINNAL_CONTROL @"requestProjectFinanceControl.action"
//投资交易明细
#define REQUEST_VERIFY_CODE @"requestVerifyCode.action"
//关注
#define REQUEST_PROJECT_COLLECT @"requestProjectCollect.action"
//分享
#define REQUESTPROJECTSHARE @"requestProjectShare.action"

//投资项目
#define REQUESTINVESTPROJECT @"requestInvestProject.action"

//成员
#define REQUEST_PROJECT_MEMBER @"requestProjectMember.action"



//评论列表
#define REQUEST_COMMENT_LIST @"requestProjectCommentList.action"

//现场
#define REQUEST_SCENE @"requestScene.action"
//现场评论列表
#define REQUEST_SCENE_COMMENT_LIST @"requestProjectSceneCommentList.action"
//播放ppt
#define REQUEST_RECORDATA @"requestRecorData.action"
//现场评论
#define REQUEST_SCENE_COMMENT @"requestSceneComment.action"
//评论
#define REQUEST_PROJECT_COMMENT @"requestProjectComment.action"

#pragma mark-----------------------站内信-------------------------------

//站内信
#define REQUEST_INNER_MESSAGE_LIST @"requestInnerMessageList.action"
//站内信详情
#define REQUEST_INNER_MESSAGE_DETAIL @"requestInnermessageDetail.action"
//删除站内信
#define REQUEST_DELETE_INNER_MESSAGE @"requestDeleteInnerMessage.action"
//标记站内信已读
#define REQUEST_HAS_READ_MESSAGE @"requestHasReadMessage.action"
//站内信提醒数据获取
#define REQUEST_HAS_MESSAGE_INFO @"requestHasMessageInfo.action"

//上传项目信息获取
#define REQUEST_UPLOAD_PROJECT_INFO @"requestuploadProjectInfo.action"

/*
***===================================================================================**
*                                          活动接口定义
*
***===================================================================================**/
//活动列表
#define  ACTION_LIST @"requestActionList.action"
//活动详情
#define  ACTION_DETAIL @"requestDetailAction.action"
//活动报名
#define  ACTION_ATTEND @"requestAttendListAction.action"
//活动评论列表
#define  ACTION_COMMENT_LIST @"requestPriseListAction.action"
//活动点赞
#define ACTION_PRISE @"requestPriseAction.action"
//活动评论
#define ACTION_COMMENT @"requestCommentAction.action"
//参加活动
#define ATTEND_ACTION @"requestAttendAction.action"
//搜搜活动
#define ACTION_SEARCH @"requestSearchAction.action"
//活动分享
#define ACTION_SHARE @"requestShareAction.action"

#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------LOGO菜单接口------------------------------------------
#pragma mark----------------------------------------------------------------------------
//认证信息
#define AUTHENTIC_INFO  @"authenticInfoUser.action"
//邀请码
#define REQUESTINVITECODE @"requestInviteCode.action"

//更换头像
#define REQUEST_CHANGE_HEADERPIC @"requestChangeHeaderPicture.action"
//修改公司
#define REQUEST_MODIFY_COMPANY @"requestModifyCompany.action"
//修改职位
#define REQUEST_MODIFY_POSITION @"requestModifyPosition.action"
//修改所在地
#define REQUEST_MODIFY_CITY @"requestModifyCity.action"
//催一催
#define REQUEST_AUTHENTIC_QUICK @"requestAuthenticQuick.action"


//资金账户交易账单
#define REQUEST_TRADE_LIST @"requestTradeList.action"


//我的关注
#define LOGO_ATTENTION_LIST @"requestMineCollection.action"

//我的活动
#define LOGO_ACTIVITY_LIST @"requestMineAction.action"

//我的金条账户总数
#define LOGO_GOLD_ACCOUNT @"requestUserGoldCount.action"
//当日用户获得金条信息
#define REQUEST_USER_GOLD_GETCOUNT @"requestUserGoldGetInfo.action"
//金条交易明细流水
#define LOGO_GOLD_DETAIL @"requestUserGoldTradeList.action"
//金条积累规则
#define REQUEST_GOLD_GET_RULE @"requestGoldGetRule.action"
//金条使用规则
#define REQUEST_GOLD_USE_RULE @"requestGoldUseRule.action"
//邀请送金条
#define REQUEST_GOLD_INVITE_FRIEND @"requestGoldInviteFriends.action"


//项目中心
#define LOGO_PROJECT_CENTER @"requestProjectCenter.action"
//上传项目
#define REQUEST_UPLOAD_PROJECTINFO @"requestuploadProjectInfo.action"
//提交记录
#define REQUEST_PROJECT_COMMIT_RECORD @"requestProjectCommitRecords.action"
//忽略项目
#define REQUEST_IGNORE_PROJECT_COMMIT @"requestIgorneProjectCommit.action"

//平台介绍
#define REQUESTPLATFORMINTRODUCE @"requestPlatformIntroduce.action"
//新手指南
#define REQUESTUSERGUIDE @"requestNewUseIntroduce.action"
//用户协议
#define REQUESTUSERPROTOCOL @"requestUserProtocol.action"
//免责声明
#define REQUESTLAWERINTRODUCE @"requestLawerIntroduce.action"
//意见反馈
#define REQUESTFEEDBACK @"requestFeedBack.action"

#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------软件设置------------------------------------------
#pragma mark----------------------------------------------------------------------------
//修改登录密码
#define MODIFYPASSWORD @"requestModifyPassword.action"

//更换手机号
#define CHANGEBINDTELEPHONE @"requestChangeBindTelephone.action"
//版本更新
#define VERSIONINFOSYSTEM @"versionInfoSystem.action"

//注销登录
#define SIGNUPUSER @"signupUser.action"


//推荐好友
#define REQUEST_INVITE_FRIEND @"requestInviteFriends.action"

//站内信数据获取
#define REQUEST_HASMESSAGE_INFO @"requestHasMessageInfo.action"
//站内信
#define REQUEST_INNER_MESSAGE @"requestInnerMessageList.action"
//站内信详情
#define REQUEST_INNER_MESSAGE_DETAIL @"requestInnermessageDetail.action"
//删除站内信
#define REQUEST_DELETE_INNER_MESSAGE @"requestDeleteInnerMessage.action"
//标记站内信为已读
#define REQUEST_HAS_READ_MESSAGE @"requestHasReadMessage.action"


//广告栏Banner
#define BANNER_SYSTEM @"bannerSystem.action"
//启动页
#define START_PAGE_SYSTEM @"startPageSystem.action"
//客服
#define CUSTOM_SERVICE_SYSTEM @"customServiceSystem.action"




#pragma mark----------------------------------------------------------------------------
#pragma mark --------------------------易宝接口------------------------------------------
#pragma mark----------------------------------------------------------------------------
//投资
#define REQUESTINVESTPROJECT @"requestInvestProject.action"
//易宝加密
#define YEEPAYSIGNVERIFY  @"signVerify.action"
//易宝回调
#define YEEPAYREQUESTNOTIFY @"requestFinanceNotifyUrl.action"
//易宝充值  回调
#define YEEOAYCHARGENOTIFYURL @"requestChargeNotifyUrl.action"
//易宝投标
#define YEEPAYTENDERNOTIFYURL @"requestTenderNotifyUrl.action"

//资金提现
#define REQUEST_WITH_DRAW @"requestWithDraw.action"
//充值
#define REQUEST_ACCOUNT_CHARGE @"requestAccountCharge.action"


//版本更新itunes 地址
#define ITUNES_URL @"https://itunes.apple.com/us/app/jin-zhi-tou-zhong-guo-cheng/id1024857089?mt=8"


//==============================2016年3月份易宝支付App研发接口==============================//
//易宝支付签名
#define YeePayMent @"toRecharge"
#define toWithdraw @"toWithdraw"
#define toBindBankCard @"toBindBankCard"
#define YeePayToRegister @"toRegister"
#define YeePayPlatformID @"10013200657"

#define toUnbindBankCard @"UNBIND_CARD"

#define YeePayToCpTransaction @"toCpTransaction"
#define ACCOUNT_INFO @"ACCOUNT_INFO"
#define COMPLETE_TRANSACTION @"COMPLETE_TRANSACTION"
#define UserPlatFormNo @"jinzht_0000_%@"
#define ProjectTenderNo @"jinzht_project_%@"
#define IsTendered   @"IsTendered/"

#define BANK_LIST [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"交通银行",@"中国光大银行",@"上海浦发发展银行",@"中国农业银行",@"中信银行",@"中国建设银行",@"中国民生银行",@"中国平安银行",@"中国邮政储蓄",@"招商银行",@"兴业银行",@"中国工商银行",@"中国银行",@"北京银行",@"广发银行",@"华夏银行",@"西安市商业银行",@"上海银行",@"天津市商业银行",@"深圳农村商业银行",@"北京农商银行",@"杭州市商业银行",@"昆仑银行",@"郑州银行",@"温州银行",@"汉口银行",@"南京银行",@"厦门银行",@"南昌银行",@"江苏银行",@"东亚银行",@"成都银行",@"宁波银行",@"长沙银行",@"河北银行",@"广州银行", nil] forKeys:[NSArray arrayWithObjects:@"BOCO",@"CEB",@"SPDB",@"ABC",@"ECITIC",@"CCB",@"CMBC",@"SDB",@"PSBC",@"CMBCHINA",@"CIB",@"ICBC",@"BOC",@"BCCB",@"GDB",@"HX",@"XAYH",@"SHYH",@"TJYH",@"SZNCSYYH",@"BJNCSYYH",@"HZYH",@"KLYH",@"ZHENGZYH",@"WZYH",@"HKYH",@"NJYH",@"XMYH",@"NCYH",@"JISYH",@"HKBEA",@"CDYH",@"NBYH",@"CSYH",@"HBYH",@"GUAZYH",nil]]
//==============================2016年3月份易宝支付App研发接口==============================//

//支持区域
#define ROMATE_MSG_TYPE [NSDictionary dictionaryWithObjectsAndKeys:@"projectdetail",@"0",@"msg",@"1",@"system",@"2",@"web",@"3",@"news",@"4",@"knowledge",@"5",@"roadshow",@"6",@"participate",@"7",@"investor",@"8",@"feeling",@"9",nil]

/***===================================================================================**
 *                                          本地缓存静态变量
 *
 ***===================================================================================**/
//用户是否第一次启动app
#define STATIC_USER_FIRST_START_APP @"isUserFirstStartApp"
//用户账号名称
#define STATIC_USER_NAME @"userName"
//用户职位
#define STATIC_USER_POSITION @"userPositionName"
//公司名称
#define STATIC_COMPANY_NAME @"userCompanyName"
//用户密码
#define STATIC_USER_PASSWORD @"userPassword"
//用户
#define STATIC_USER_COUNT_DAYS @"userCountDays"
//用户头像
#define STATIC_USER_DEFAULT_PIC @"userDefaultPic"
//身份证号
#define STATIC_USER_DEFAULT_ID_PIC @"userDefaultIDPic"
//认证头像
#define STATIC_USER_AUTH_ID_PIC @"userDefaultAuthIDPic"
//用户头像
#define STATIC_USER_BACKGROUND_PIC @"userDefaultBackgroundPic"
//用户性别
#define STATIC_USER_GENDER @"userGender"
//用户类别
#define STATIC_USER_TYPE @"userType"
//用户默认头像
#define  USER_DEFAULT_PIC [UIImage imageNamed:@"img_default_avatar"]
//用户是否第一次通过客户端下单
#define  STATIC_IS_USER_IFRST_ORDER @"isFirstOrder"
//用户是否打开软件时间
#define  STATIC_IS_USER_ORDER_START_TIME @"orderStartTime"
//用户通过支持区域视图选择默认地址
#define  STATIC_IS_USER_SELECT_ADDRESS  @"selectDefaultAddress"
//默认手机号码
#define  STATIC_USER_DEFAULT_DISPATCH_PHONE @"defaultphone"
//默认地址
#define  STATIC_USER_DEFAULT_DISPATCH_ADDRESS @"defaultaddress"
//设置地理位置信息
// 省份
#define LOCATION_STATE @"locationstate"
//城市
#define LOCATION_CITY @"locationcity"
//行政区域
#define LOCATION_SUBLOCALITY @"locationsublocaity"
//区域名称
#define LOCATION_NAME @"locationname"
//默认地址
#define  STATIC_USER_DEFAULT_DISPATCH_ID @"dispatchid"
//商圈id
#define STATIC_LOCATION_AREA_ID @"buessAreaId"
//行政id
#define STATIC_LOCATION_SUBLOCAITY_ID @"locationsublocaity"


#define APP_PRIVATE_KEY @"lindyang"

#define PUBLISH_CONTENT @"发表最新、最热、最前沿投融资话题"
/***===================================================================================**
 *                                          静态数字型常量
 *
 ***===================================================================================**/
#define NAVVIEW_HEIGHT 44
#define NAVVIEW_POSITION_Y 20
#define   IOS7_NAVI_SPACE   -10
#define gestureMinimumTranslation  20.0

typedef NS_ENUM(NSInteger, NetStatus) {
    NetStatusWifi, /// WiFi 网络状态
    NetStatusSelfNet, /// 手机自带网络
    NetStatusNone,    /// 无网络状态
};

typedef NS_ENUM(NSInteger, PayStatus) {
    PayStatusNormal,
    PayStatusConfirm, /// 实名认证
    PayStatusBindCard, /// 绑定银行卡
    PayStatusPayfor,    /// 充值
    PayStatusTransfer,  ///转账确认
    PayToWithdraw,   //提现
    PayUnBindBank, //解绑银行卡
    PayStatusAccount,
};



#define SDColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

#define Global_mainBackgroundColor SDColor(248, 248, 248, 1)

#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]
#endif
