//
//  LoginRegistViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "LoginRegistViewController.h"
#import "RegisterViewController.h"
#import "FindPassWordViewController.h"
#import "PerfectViewController.h"
#import "RenzhengViewController.h"
#import "ProjectViewController.h"
#import "MyNavViewController.h"
#import "InvestViewController.h"
#import "ActivityViewController.h"
#import "MineViewController.h"
#import "CircleViewController.h"

#define WELOGINUSER @"wechatLoginUser"
#define DENGLU @"loginUser"
#define CUSTOMSERVICE @"customServiceSystem"

@interface LoginRegistViewController ()
{
    UIActivityIndicatorView* activity;
    NSString* openId;
    NSString *_password;
}

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, copy) NSString *servicePartner;
@property (nonatomic, copy) NSString *servicePhone;

@property (nonatomic, copy) NSString *wePartner;

@property (nonatomic, copy) NSString *wePic;
@property (nonatomic, copy) NSString *weToken;

@end

@implementation LoginRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    
    NSString * string = [AES encrypt:DENGLU password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    //    NSLog(@"%@",_partner);
    //客服
    self.servicePartner = [TDUtil encryKeyWithMD5:KEY action:CUSTOMSERVICE];
    self.wePartner = [TDUtil encryKeyWithMD5:KEY action:WELOGINUSER];
    
    //加载本地默认数据
    [self loadDefaultData];
    
    
}


-(void)loadDefaultData
{
    NSUserDefaults * data = [NSUserDefaults standardUserDefaults];
    NSString * phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    if (phoneNumber) {
        self.phoneField.text = phoneNumber;
    }
    
    
}

-(void)createUI{
    //头像
    _iconBtn.layer.cornerRadius = 52;
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.borderWidth = 4;
    _iconBtn.layer.borderColor = color(190, 178, 176, 1).CGColor;
}
//登录
- (IBAction)loginClick:(UIButton *)sender {
    
    
    [self.phoneField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if ([sender isKindOfClass:[UIButton class]]) {
        //初始化网络请求对象
        //获取数据
        NSString *phoneNumber = self.phoneField.text;
        _password  = self.passwordField.text;
        
        //校验数据
        if (phoneNumber && ![phoneNumber isEqualToString:@""]) {
            if (![TDUtil validateMobile:phoneNumber]) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确手机号码"];
                self.phoneField.text=@"";
                return ;
            }
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入手机号码"];
            return ;
        }
        
        if (!_password || [_password isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
            return ;
        }
        
        //加密
        _password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:_password];
        //激光推送Id
        NSString *regId = [JPUSHService registrationID];
        
        
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",phoneNumber,@"telephone",_password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
        
        //加载动画
        //加载动画控件
        if (!activity) {
            //进度
            activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.loginBtn)/3-18, HEIGHT(self.loginBtn)/2-15, 30, 30)];//指定进度轮的大小
            [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
            [self.loginBtn addSubview:activity];
        }else{
            if (!activity.isAnimating) {
                [activity startAnimating];
            }
        }
        [activity setColor:WriteColor];
        
        //开始加载动画
        [activity startAnimating];
        
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:1 delegate:self sel:@selector(requestLogin:)];
    }
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================

/**
 *  登录
 *
 *  @param request 请求实例
 */
-(void)requestLogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
//            NSLog(@"登陆成功");
            
            
            //进入主界面
//            AppDelegate * app =(AppDelegate* )[[UIApplication sharedApplication] delegate];
//            app.window.rootViewController = app.tabBar;
            
            
            JTabBarController * tabBarController;
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:JTabBarController.class]) {
                    tabBarController = (JTabBarController*)vc;
                }
            }
            
            if (!tabBarController) {
                tabBarController = [self createViewControllers];
//                [self.navigationController pushViewController:tabBarController animated:NO];
            }else{
            
            }
            
            [self.navigationController pushViewController:tabBarController animated:NO];
        

            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:self.phoneField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:_password forKey:STATIC_USER_PASSWORD];
            [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
            [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
//            [data setValue:@"YES" forKey:@"isLogin"];
//            [self removeFromParentViewController];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
         
        }
        
    }
    [activity stopAnimating];
}

-(JTabBarController*)createViewControllers{
    NSMutableArray * unSelectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project.png"],[UIImage imageNamed:@"invest.png"],[UIImage imageNamed:@"Circle.png"],[UIImage imageNamed:@"activity.png"],nil];
    
    NSMutableArray * selectedArray = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"project_selected .png"],[UIImage imageNamed:@"invest_selected.png"],[UIImage imageNamed:@"Circle_selected.png"], [UIImage imageNamed:@"activity_selected.png"],nil];
    
    NSMutableArray * titles = [[NSMutableArray alloc]initWithObjects:@"项目",@"投资人",@"圈子",@"活动", nil];
    
    ProjectViewController * project = [[ProjectViewController alloc]init];
    MyNavViewController * navProject = [[MyNavViewController alloc]initWithRootViewController:project];
    
    InvestViewController * invest = [[InvestViewController alloc]init];
    MyNavViewController * navInvest = [[MyNavViewController alloc]initWithRootViewController:invest];
    
    CircleViewController * circle =[[CircleViewController alloc]init];
    MyNavViewController * navCircle =[[MyNavViewController alloc]initWithRootViewController:circle];
    
    ActivityViewController * activityVC = [[ActivityViewController alloc]init];
    MyNavViewController * navActivity = [[MyNavViewController alloc]initWithRootViewController:activityVC];
    
    JTabBarController *tabBar = [[JTabBarController alloc]initWithTabBarSelectedImages:selectedArray normalImages:unSelectedArray titles:titles];
    tabBar.showCenterItem = YES;
    tabBar.centerItemImage = [UIImage imageNamed:@"mine.png"];
    tabBar.viewControllers = @[navProject,navInvest,navCircle,navActivity];
    tabBar.textColor = orangeColor;
    MyNavViewController *navMine = [[MyNavViewController alloc]initWithRootViewController:[[MineViewController alloc]init]];
    tabBar.centerViewController = navMine;
    
    return tabBar;
    
}


/**
 *  网络请求失败
 *
 *  @param request 请求实例
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误"];
    [activity stopAnimating];
    
}
#pragma mark -没有账号
//没有账号
- (IBAction)noBtn:(id)sender {
    
    RegisterViewController * registerVC = [[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
#pragma mark -忘记密码
//忘记密码
- (IBAction)forgetPassWord:(id)sender {
    FindPassWordViewController * find =[FindPassWordViewController new];
    [self.navigationController pushViewController:find animated:YES];
}
#pragma mark -微信登陆
- (IBAction)weChatBtn:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
//            snsAccount.openId
            //微信授权登录
            //激光推送Id
            NSString *regId = [JPUSHService registrationID];
            
            _wePic = snsAccount.iconURL;
             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.wePartner,@"partner",snsAccount.openId,@"wechatID",@"1",@"platform",regId,@"regid", nil];
            
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:WECHATLOGINUSER postParam:dic type:0 delegate:self sel:@selector(requestWELogin:)];
            
//            NSDictionary *dict = @{@"oauthType":@"2",@"nickName":snsAccount.userName,@"accountId":snsAccount.usid,@"pic":snsAccount.iconURL,@"parentId":@"0",@"deviceId":deviceId,@"pushToken":pushToken};
            
//            [self requsetOauthLoginWithDict:dict];
        }
    });
}

-(void)requestWELogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data= [jsonDic valueForKey:@"data"];
            NSDictionary *idenTypeDic = [NSDictionary dictionaryWithDictionary:[data valueForKey:@"identityType"]];
            NSString *name = idenTypeDic[@"name"];
//            NSInteger identifyId =(NSInteger)idenTypeDic[@"identiyTypeId"];
            
            if (name && [name isEqualToString:@"无身份"]) {//去认证
                //进入身份完善信息界面
                PerfectViewController *perfert = [PerfectViewController new];
                perfert.wxIcon = _wePic;
                [self.navigationController pushViewController:perfert animated:YES];
            }else{
               //进入应用
                JTabBarController * tabBarController;
                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    if ([vc isKindOfClass:JTabBarController.class]) {
                        tabBarController = (JTabBarController*)vc;
                    }
                }
                
                if (!tabBarController) {
                    tabBarController = [self createViewControllers];
                }
                
                [self.navigationController pushViewController:tabBarController animated:NO];
                
                NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
                [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
                [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
            }
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
-(void)dealloc
{
    
}
//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
