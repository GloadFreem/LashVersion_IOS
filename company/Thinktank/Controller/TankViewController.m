//
//  TankViewController.m
//  company
//
//  Created by Eugene on 2016/10/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankViewController.h"
#import "GENENavTabBar.h"
#import <objc/message.h>
#import "HeadlineViewController.h"
#import "TankFastNewsController.h"
#import "TankPointController.h"
#import "NetStatusViewController.h"
#import "AuthenticInfoBaseModel.h"

#define DENGLU @"loginUser"
#define LOGINUSER @"isLoginUser"
#define AUTHENINFO @"authenticInfoUser"
#define VERSIONINFO @"versionInfoSystem"
#define GOLDCOUNT @"requestUserGoldGetInfo"

@interface TankViewController ()<UIScrollViewDelegate,GENENavTabBarDelegate>

{
    UIImageView *imageView;
    NSTimer *timer;
}

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selectedVCArray;
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) GENENavTabBar *navTabBar;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *totalTitles;
@property (nonatomic, assign) NSString *recordLastClickTitle;
@property (nonatomic, copy) NSString *loginPartner;
@property (nonatomic, copy) NSString *authenPartner;
//金条
@property (nonatomic, copy) NSString *goldPartner;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger tomorrowCount;
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *tomorrowLabel;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger secondLeave;
//版本更新
@property (nonatomic, copy) NSString *versionStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isForce;
@property (nonatomic, copy) NSString *versionPartner;

@end

static void *RecordLastClickKey = @"RecordLastClickKey";

@implementation TankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGold) name:@"comeBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netNotEnable) name:@"netNotEnable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEnable) name:@"netEnable" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    //版本更新
    self.versionPartner = [TDUtil encryKeyWithMD5:KEY action:VERSIONINFO];
    //金条
    self.goldPartner = [TDUtil encryKeyWithMD5:KEY action:GOLDCOUNT];
    
    _second = 0;
    _secondLeave = 3;
    
    [self viewConfig];
    [self initConfig];
    _netView  = [noNetView new];
    _netView.frame = CGRectMake(0, 64, SCREENWIDTH, 40);
    _netView.delegate = self;
    
    //自动登录
    if ([TDUtil checkNetworkState] != NetStatusNone)
    {
        [self isLogin];
    }else{
        [self.view addSubview:_netView];
    }
}

-(void)netEnable
{
    //    [self isLogin];
    if (_netView) {
        [_netView removeFromSuperview];
    }
    if (!self.online  && !self.loginSucess) {
        [self isAutoLogin];
    }
}

-(void)netNotEnable
{
//    [self.view addSubview:_netView];
    [[UIApplication sharedApplication].windows[0] addSubview:_netView];
}

#pragma mark-------------没有网络点击事件处理--------------
-(void)didClickBtnInView
{
    NetStatusViewController *netStatus =[NetStatusViewController new];
    netStatus.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:netStatus animated:YES];
}

#pragma mark-------------------------自动登录-----------------------
-(void)isLogin
{
    _loginPartner = [TDUtil encryKeyWithMD5:KEY action:LOGINUSER];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.loginPartner,@"partner", nil];
    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:ISLOGINUSER postParam:dic type:0 delegate:self sel:@selector(requestIsLogin:)];
    [[EUNetWorkTool shareTool] POST:JZT_URL(ISLOGINUSER) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
//            NSLog(@"登陆状态在线");
            //下载认证信息
            [self loadAuthenData];
            
            [self loadOtherData];
        }else if ([dic[@"status"] integerValue] == 401){
            //自动登录
            [self isAutoLogin];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.loginSucess ) {
                    [self loadAuthenData];
                    [self loadOtherData];
                }
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self isAutoLogin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.loginSucess ) {
                [self loadAuthenData];
                [self loadOtherData];
            }
        });
    }];
    
}

#pragma mark -------------------下载认证信息--------------------------
-(void)loadAuthenData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.authenPartner,@"partner", nil];
    //开始请求
    [[EUNetWorkTool shareTool] POST:JZT_URL(AUTHENTIC_INFO) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:dic[@"data"]];
//                        NSLog(@"打印字典---%@",dataDic);
            AuthenticInfoBaseModel *baseModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
            //            authenticModel = baseModel;
            //            NSLog(@"打印个人信息：----%@",baseModel);
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            
            [data setValue:baseModel.headSculpture forKey:USER_STATIC_HEADER_PIC];
            [data setValue:baseModel.telephone forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:[NSString stringWithFormat:@"%ld",(long)baseModel.userId] forKey:USER_STATIC_USER_ID];
            
            NSMutableString *areaStr = [[NSMutableString alloc]init];
            if (baseModel.areas.count) {
                for (NSInteger i = 0; i < baseModel.areas.count; i++) {
                    if (i!= baseModel.areas.count - 1) {
                        [areaStr appendFormat:@"%@ | ",baseModel.areas[i]];
                    }else{
                        [areaStr appendFormat:@"%@",baseModel.areas[i]];
                    }
                }
            }
            [data setValue:areaStr forKey:USER_STATIC_INVEST_AREAS];
            
            NSArray *authenticsArray = baseModel.authentics;
            if (authenticsArray.count) {
                ProjectAuthentics *authentics = authenticsArray[0];
                [data setObject:authentics.city.name forKey:USER_STATIC_CITY];
                [data setObject:authentics.city.province.name forKey:USER_STATIC_PROVINCE];
                [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
                [data setValue:authentics.name forKey:USER_STATIC_NAME];
                [data setValue:authentics.identiyCarA forKey:USER_STATIC_IDPIC];
                [data setValue:authentics.identiyCarNo forKey:USER_STATIC_IDNUMBER];
                [data setValue:authentics.position forKey:USER_STATIC_POSITION];
                [data setValue:authentics.authenticstatus.name forKey:USER_STATIC_USER_AUTHENTIC_STATUS];
                [data setValue:[NSString stringWithFormat:@"%ld",(long)authentics.identiytype.identiyTypeId] forKey:USER_STATIC_USER_AUTHENTIC_TYPE];
                [data setValue:[NSString stringWithFormat:@"%@",authentics.identiytype.name] forKey:USER_STATIC_USER_AUTHENTIC_NAME];
                [data setValue:[NSString stringWithFormat:@"%ld",(long)authentics.authId] forKey:USER_STATIC_AUTHID];
                [data setValue:authentics.introduce forKey:USER_STATIC_INTRODUCE];
                [data setValue:authentics.companyIntroduce forKey:USER_STATIC_COMPANYINTRODUCE];
            }
//            NSLog(@"认证信息下载成功");
            [data synchronize];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)loadOtherData
{
    if (self.online || self.loginSucess) {
        //保存登录时间
        [self compareTime];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loadVersion];
//        });
    }
}
#pragma mark--------版本更新----------
-(void)loadVersion
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.versionPartner,@"partner",@"1",@"platform", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:VERSIONINFOSYSTEM postParam:dic type:0 delegate:self sel:@selector(requestVersion:)];
}
-(void)requestVersion:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = jsonDic[@"data"];
            _versionStr = dataDic[@"versionStr"];
            //            _versionStr = @"4.0.0";
            _contentStr = dataDic[@"content"];
            _url = dataDic[@"url"];
            _isForce = [dataDic[@"isForce"] boolValue];
            //利用key取到对应的版本（当前版本）
            NSString * version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSArray *currentArray = [version componentsSeparatedByString:@"."];
            //                NSLog(@"本地----%@",currentArray);
            NSArray *upArray = [_versionStr componentsSeparatedByString:@"."];
            //            NSLog(@"返回版本号----%@",upArray);
            //比较版本号
            if ([upArray[0] integerValue] > [currentArray[0] integerValue]) {
                if (_isForce) {
                    [self forceUpdateAlertView];
                }else{
                    [self alertViewShow];
                }
                return;
            }
            
            if ([upArray[0] integerValue] == [currentArray[0] integerValue]) {
                //第二位
                if ([upArray[1] integerValue] > [currentArray[1] integerValue]) {
                    if (_isForce) {
                        [self forceUpdateAlertView];
                    }else{
                        [self alertViewShow];
                    }
                    return;
                }
                if ([upArray[1] integerValue] == [currentArray[1] integerValue]) {
                    //第三位
                    if ([upArray[2] integerValue] > [currentArray[2] integerValue]) {
                        if (_isForce) {
                            [self forceUpdateAlertView];
                        }else{
                            [self alertViewShow];
                        }
                        return;
                    }
                }
                
            }
            
        }
    }
}

-(void)forceUpdateAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:_contentStr delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
    alertView.delegate =self;
    alertView.tag = 20;
    [alertView show];
}
-(void)alertViewShow
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:_contentStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
    alertView.tag = 21;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //强更
    if (alertView.tag == 20) {
        if (buttonIndex == 0) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_url]];
        }
    }
    
    if (alertView.tag == 21) {
        if (buttonIndex == 0) {
            
        }else{
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_url]];
        }
    }
}

-(void)compareTime
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isLaunchedByNotification) {
        
    }else{
        NSString *currentTime = [TDUtil CurrentDay];
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *firstDate = [data objectForKey:@"firstLogin"];
        if ([currentTime isEqualToString:firstDate]) {
            
        }else{
            [self loadGoldCount];
        }
    }
//    [self loadGoldCount];
}

-(void)loadGold
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *currentTime = [TDUtil CurrentDay];
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *firstDate = [data objectForKey:@"firstLogin"];
        if ([currentTime isEqualToString:firstDate]) {
            [self loadVersion];
        }else{
            [self loadGoldCount];
        }
    });
}

-(void)loadGoldCount
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.goldPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_USER_GOLD_GETCOUNT postParam:dic type:0 delegate:self sel:@selector(requestGoldCount:)];
}
-(void)requestGoldCount:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _count = [dataDic[@"count"] integerValue];
            _tomorrowCount = [dataDic[@"countTomorrow"] integerValue];
            
            [self saveDate];
            
            [self createGoldImageView];
        }else{
            
        }
    }
}

-(void)saveDate
{
    NSString *firstLogin = [TDUtil CurrentDay];
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    [data setValue:firstLogin forKey:@"firstLogin"];
    [data synchronize];
}

-(void)createGoldImageView
{
    UIView *background = [UIView new];
    [background setBackgroundColor:[UIColor blackColor]];
    background.alpha = 0.7;
    
    [[UIApplication sharedApplication].windows[0] addSubview:background];
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    _background = background;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.layer.cornerRadius = 15;
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _timeLabel.layer.borderWidth = 0.5;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%lds",(long)_secondLeave]];
    [attributeString addAttribute:NSFontAttributeName value:BGFont(20) range:NSMakeRange(0, 1)];
    
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:1];
    
    _timeLabel.attributedText = attributeString;
    [[UIApplication sharedApplication].windows[0] addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.mas_equalTo(background.mas_right).offset(-30);
        make.top.mas_equalTo(55);
    }];
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].windows[0] addSubview:imageView];
    
    
    NSMutableArray *imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i =0; i < 36; i ++) {
        NSString * name = [NSString stringWithFormat:@"jintiao%.2ld",(long)i];
        //        NSLog(@"filename:%@",name);
        UIImage *image = [UIImage imageNamed:name];
        [imageArr addObject:image];
    }
    
    imageView.animationImages = imageArr;
    imageView.animationRepeatCount = 1;
    imageView.animationDuration = 1.5;
    [imageView startAnimating];
    [self performSelector:@selector(setImage) withObject:self afterDelay:1.51];
    
    UIButton *certainBtn = [UIButton new];
    certainBtn.backgroundColor = [UIColor clearColor];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:color(255, 204, 0, 1) forState:UIControlStateNormal];
    certainBtn.titleLabel.font = BGFont(16);
    [certainBtn addTarget:self action:@selector(disBackground) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.layer.cornerRadius = 4;
    certainBtn.layer.masksToBounds = YES;
    certainBtn.layer.borderColor = color(255, 204, 0, 1).CGColor;
    certainBtn.layer.borderWidth = 1;
    [[UIApplication sharedApplication].windows[0] addSubview:certainBtn];
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(background.mas_centerX);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(background.mas_bottom).offset(-70*HEIGHTCONFIG);
    }];
    
    _certainBtn = certainBtn;
    _tomorrowLabel = [UILabel new];
    _tomorrowLabel.textColor = [UIColor whiteColor];
    _tomorrowLabel.font = BGFont(16);
    _tomorrowLabel.textAlignment = NSTextAlignmentCenter;
    //    _tomorrowLabel.text = [NSString stringWithFormat:@"明天登录即可获得%ld根金条",(long)_tomorrowCount];
    [[UIApplication sharedApplication].windows[0] addSubview:_tomorrowLabel];
    [_tomorrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(background.mas_centerX);
        make.height.mas_equalTo(16);
        make.bottom.mas_equalTo(background.mas_bottom).offset(-175*HEIGHTCONFIG);
    }];
    
    _todayLabel = [UILabel new];
    _todayLabel.textColor = color(255, 204, 0, 1);
    _todayLabel.font = BGFont(24);
    _todayLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"恭喜获得 %ld根金条",(long)_count]];
    NSRange range = NSMakeRange(5, 1);
    if (_count > 9) {
        range = NSMakeRange(5, 2);
    }
    [attributeStr addAttribute:NSFontAttributeName value:BGFont(32) range:range];
    _todayLabel.attributedText = attributeStr;
    [[UIApplication sharedApplication].windows[0] addSubview:_todayLabel];
    [_todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(background.mas_centerX);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(_tomorrowLabel.mas_top).offset(-16);
    }];
}

-(void)startTimer
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop] run];
        //        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    });
}

-(void)disBackground
{
    if (_background !=nil) {
        [_background removeFromSuperview];
        [imageView removeFromSuperview];
        [_todayLabel removeFromSuperview];
        [_tomorrowLabel removeFromSuperview];
        [_certainBtn removeFromSuperview];
        [_timeLabel removeFromSuperview];
    }
    //版本更新
    [self loadVersion];
}

-(void)setTime
{
    _secondLeave--;
    if (_second == 3) {
        
        [self disBackground];
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }else{//设置label数字
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%lds",(long)_secondLeave]];
        _timeLabel.attributedText = attributeString;
    }
    _second ++;
}

-(void)setImage
{
    [imageView stopAnimating];
    UIImage * image =[UIImage imageNamed:@"jintiao35"];
    imageView.image = image;
}

- (void)viewConfig
{
//    _navTabBarColor = _navTabBarColor ? _navTabBarColor : NavTabbarColor;
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(ZERO_COORDINATE, ZERO_COORDINATE, SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    statusView.backgroundColor = [TDUtil colorWithHexString:@"3e454f"];
    [self.view addSubview:statusView];
    
    _navTabBar = [[GENENavTabBar alloc] initWithFrame:CGRectMake(ZERO_COORDINATE, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    
    _navTabBar.delegate = self;
    _navTabBar.backgroundColor = [TDUtil colorWithHexString:@"3e454f"];
    _navTabBar.lineColor = orangeColor;
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(ZERO_COORDINATE, _navTabBar.frame.origin.y + _navTabBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _navTabBar.frame.origin.y - _navTabBar.frame.size.height)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
//    _mainView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_mainView];
    [self.view addSubview:_navTabBar];
    
}

-(void)initConfig
{
    [self setupTotalTitles];
    [self setupViewControllerDict];
    if ([NSUD objectForKey:SELECTED_CHANNEL_NAMES] == nil) {
        for (int index = 0; index < 3; index++) {
            UIViewController *viewController = (UIViewController *)self.subViewControllers[index];
            viewController.view.frame = CGRectMake(index * SCREEN_WIDTH, ZERO_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
            [_mainView addSubview:viewController.view];
            [self addChildViewController:viewController];
            [self.titles addObject:[self.subViewControllers[index] title]];
        }
        _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, ZERO_COORDINATE);
    } else {
        self.titles = [NSUD objectForKey:SELECTED_CHANNEL_NAMES];
        [self addChildViewControllerWithTitlesArray:self.titles];
    }
    _navTabBar.totalItemTitles = self.totalTitles;
    _navTabBar.selectedItemTitles = self.totalTitles;
}

-(NSArray*)subViewControllers
{
    if (!_subViewControllers.count) {
        TankFastNewsController *sevenViewController = [[TankFastNewsController alloc] init];
        sevenViewController.title = @"7x24快讯";
//        sevenViewController.view.backgroundColor = [UIColor blueColor];
        
        HeadlineViewController *eightViewController = [[HeadlineViewController alloc] init];
        eightViewController.title = @"金日投条";
//        eightViewController.view.backgroundColor = [UIColor greenColor];
        
        TankPointController *ninghtViewController = [[TankPointController alloc] init];
        ninghtViewController.title = @"原创内容";
//        ninghtViewController.view.backgroundColor = [UIColor redColor];
        _subViewControllers = @[sevenViewController, eightViewController, ninghtViewController];
    }
    return _subViewControllers;
    
}

- (void)addChildViewControllerWithTitlesArray:(NSArray *)titles
{
    for (int index = 0; index < titles.count; index++) {
        NSDictionary *viewControllerDict = [NSUD objectForKey:VIEWCONTROLLER_INDEX_DICT];
        int viewControllerIndex = [viewControllerDict[titles[index]] intValue];
        UIViewController *viewController = (UIViewController *)_subViewControllers[viewControllerIndex];
        viewController.view.frame = CGRectMake(index * SCREEN_WIDTH, ZERO_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
        [_mainView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * titles.count, ZERO_COORDINATE);
}

- (void)cleanData
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
}

- (void)setupTotalTitles
{
    _totalTitles = [NSMutableArray arrayWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in self.subViewControllers)
    {
        [_totalTitles addObject:viewController.title];
    }
}
- (void)setupViewControllerDict
{
    NSMutableDictionary *viewControllerDict = [@{} mutableCopy];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:VIEWCONTROLLER_INDEX_DICT]) {
        [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
            [viewControllerDict setObject:[NSNumber numberWithInteger:idx] forKey:viewController.title];
        }];
        [NSUD setObject:viewControllerDict forKey:VIEWCONTROLLER_INDEX_DICT];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = round(scrollView.contentOffset.x / SCREEN_WIDTH);
    _navTabBar.currentIndex = _currentIndex;
    [self closeKeyboard];
}
-(void)closeKeyboard
{
    TankFastNewsController *fast = (TankFastNewsController *)_subViewControllers[0];
    [fast.searchBar resignFirstResponder];
    [fast.view endEditing:YES];
    HeadlineViewController *header = (HeadlineViewController *)_subViewControllers[1];
    [header.searchBar resignFirstResponder];
    [header.view endEditing:YES];
    TankPointController *point = (TankPointController *)_subViewControllers[2];
    [point resignFirstResponder];
    [point.view endEditing:YES];
}
-(void)closeKeyboard:(NSInteger)index
{
    if (index == 0) {
        HeadlineViewController *header = (HeadlineViewController *)_subViewControllers[1];
        [header.searchBar resignFirstResponder];
        TankPointController *point = (TankPointController *)_subViewControllers[2];
        [point resignFirstResponder];
    }
    if (index == 1) {
        TankFastNewsController *fast = (TankFastNewsController *)_subViewControllers[0];
        [fast.searchBar resignFirstResponder];
        TankPointController *point = (TankPointController *)_subViewControllers[2];
        [point resignFirstResponder];
    }
    if (index == 2) {
        TankFastNewsController *fast = (TankFastNewsController *)_subViewControllers[0];
        [fast.searchBar resignFirstResponder];
        HeadlineViewController *header = (HeadlineViewController *)_subViewControllers[1];
        [header.searchBar resignFirstResponder];
    }
}

#pragma mark - GENENavTabBarDelegate Methods
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    [self closeKeyboard];
    
    [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, ZERO_COORDINATE) animated:_scrollAnimation];
    NSString *selectedChannel = [NSUD objectForKey:SELECTED_CHANNEL_NAMES][index];
    objc_setAssociatedObject(self.recordLastClickTitle, RecordLastClickKey, selectedChannel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.online || self.loginSucess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hasLogin" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
