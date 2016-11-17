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

@interface TankViewController ()<UIScrollViewDelegate,GENENavTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selectedVCArray;
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) GENENavTabBar *navTabBar;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *totalTitles;
@property (nonatomic, assign) NSString *recordLastClickTitle;
@property (nonatomic, copy) NSString *loginPartner;
@property (nonatomic, copy) NSString *authenPartner;
@end

static void *RecordLastClickKey = @"RecordLastClickKey";

@implementation TankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netNotEnable) name:@"netNotEnable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEnable) name:@"netEnable" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    
    [self viewConfig];
    [self initConfig];
    _netView  = [noNetView new];
    _netView.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
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
    [self.view addSubview:_netView];
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
            NSLog(@"登陆状态在线");
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
//    [self.httpUtil getDataFromAPIWithOps:AUTHENTIC_INFO postParam:dic type:0 delegate:self sel:@selector(requestAuthenInfo:)];
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
        NSLog(@"下载其他数据");
    }
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
