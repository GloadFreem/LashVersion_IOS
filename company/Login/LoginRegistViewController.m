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
    
    //加载本地默认数据
    [self loadDefaultData];
    
    //下载客服电话
    [self loadServicePhone];
}

-(void)loadServicePhone
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.servicePartner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CUSTOM_SERVICE_SYSTEM postParam:dic type:0 delegate:self sel:@selector(requestServicePhone:)];
}
-(void)requestServicePhone:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = jsonDic[@"data"];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setObject:dataDic[@"tel"] forKey:@"servicePhone"];
            [data synchronize];
            
        }else{
        
        }
    }
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
        [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
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
            NSLog(@"登陆成功");
            
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
            }
            
            [self.navigationController pushViewController:tabBarController animated:NO];
        
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:self.phoneField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:_password forKey:STATIC_USER_PASSWORD];
            [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
            
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
//    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误"];
    [activity stopAnimating];
    
}
#pragma mark -没有账号
//没有账号
- (IBAction)noBtn:(id)sender {
    
    RegisterViewController * registerVC = [RegisterViewController new];
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
    [self sendAuthRequest];
}
-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    //    [WXApi sendReq:req];
    //    [WXApi sendAuthReq:req viewController:self delegate:self];
    [WXApi sendReq:req];
}
-(void)getAccess_token:(NSDictionary*)dic
{
    NSString* code =[[dic valueForKey:@"userInfo"] valueForKey:@"code"];
    NSString* url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx33aa0167f6a81dac&secret=bc5e2b89553589bf7d9e568545793842&code=%@&grant_type=authorization_code",code];
    
    //    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,self.wxCode.text];
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                openId =[dic objectForKey:@"openid"];
                if (openId) {
                    [self getUserInfo:[dic objectForKey:@"access_token"] openId:openId];
                }
                
            }else{
//                self.startLoading =NO;
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"信息获取失败!"];
            }
        });
    });
}
-(void)getUserInfo:(NSString*)tokean openId:(NSString*)openID
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",tokean,openId];
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                //                self.nickname.text = [dic objectForKey:@"nickname"];
                //                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
                [data setValue:[dic objectForKey:@"nickname"] forKey:USER_STATIC_NICKNAME];
                [data setValue:[dic objectForKey:@"headimgurl"] forKey:USER_STATIC_HEADER_PIC];
                if (openID) {
                    [self.httpUtil getDataFromAPIWithOps:@"openid/" postParam:[NSDictionary dictionaryWithObject:openID forKey:@"openid"] type:0 delegate:self sel:@selector(requestFinished:)];
                }
            }else{
                self.startLoading =NO;
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"信息获取失败!"];
            }
        });
        
    });
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSString* flag = [[jsonDic valueForKey:@"data"] valueForKey:@"flag"];
            if (![flag boolValue]) {
//                WeChatBindController* controller =[[WeChatBindController alloc]init];
//                controller.openId = openId;
//                [self.navigationController pushViewController:controller animated:YES];
            }else{
                UIButton *sender = [UIButton new];
                [self loginClick:sender];
            }
        }
        
//        self.startLoading = NO;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
