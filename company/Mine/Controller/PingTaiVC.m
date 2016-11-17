//
//  PingTaiVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PingTaiVC.h"
#import "PingTaiWebViewController.h"
#import "FeedBackViewController.h"

#define PLATFORMINTRODUCE @"requestPlatformIntroduce"
#define USERINTRODUCE @"requestNewUseIntroduce"
#define USERPROTOCOL @"requestUserProtocol"
#define LAWERINTRODUCE @"requestLawerIntroduce"

@interface PingTaiVC ()

@property (nonatomic, copy) NSString *platformPartner;
@property (nonatomic, copy) NSString *userIntroducePartner;
@property (nonatomic, copy) NSString *protocolPartner;
@property (nonatomic, copy) NSString *lawerpartner;

@property (nonatomic, copy) NSString *paltformUrl;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *protocolUrl;
@property (nonatomic, copy) NSString *lawerurl;

@end

@implementation PingTaiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.platformPartner= [TDUtil encryKeyWithMD5:KEY action:PLATFORMINTRODUCE];
    self.userIntroducePartner = [TDUtil encryKeyWithMD5:KEY action:USERINTRODUCE];
    self.protocolPartner = [TDUtil encryKeyWithMD5:KEY action:USERPROTOCOL];
    self.lawerpartner = [TDUtil encryKeyWithMD5:KEY action:LAWERINTRODUCE];
    
    
    NSString * version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"金指投  V%@",version];
    
    
    [self setupNav];
}

-(void)loadPlatform
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.platformPartner,@"partner", nil];
    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:REQUESTPLATFORMINTRODUCE postParam:dic type:1 delegate:self sel:@selector(requestPlatform:)];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUESTPLATFORMINTRODUCE) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSDictionary *dicM = [dic valueForKey:@"data"];
            _paltformUrl = dicM[@"url"];
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = _paltformUrl;
            vc.titleStr = @"平台介绍";
            if (vc.url.length) {
                [self.navigationController  pushViewController:vc animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)loadUserIntroduce
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.userIntroducePartner,@"partner", nil];
    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:REQUESTUSERGUIDE postParam:dic type:1 delegate:self sel:@selector(requestUser:)];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUESTUSERGUIDE) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSDictionary *dicM = [dic valueForKey:@"data"];
            _userUrl = dicM[@"url"];
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = _userUrl;
            vc.titleStr = @"新手指南";
            if (vc.url.length) {
                [self.navigationController  pushViewController:vc animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(void)loadProtocol
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.protocolPartner,@"partner", nil];
    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:REQUESTUSERPROTOCOL postParam:dic type:1 delegate:self sel:@selector(requestProtocol:)];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUESTUSERPROTOCOL) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSDictionary *dicM = [dic valueForKey:@"data"];
            _protocolUrl = dicM[@"url"];
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = _protocolUrl;
            vc.titleStr = @"用户协议";
            if (vc.url.length) {
                [self.navigationController  pushViewController:vc animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)loadLawer
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.lawerpartner,@"partner", nil];
    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:REQUESTLAWERINTRODUCE postParam:dic type:1 delegate:self sel:@selector(requestLawer:)];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUESTLAWERINTRODUCE) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSDictionary *dicM = [dic valueForKey:@"data"];
            _lawerurl = dicM[@"url"];
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = _lawerurl;
            vc.titleStr = @"免责声明";
            if (vc.url.length) {
                [self.navigationController  pushViewController:vc animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"关于平台";
}

-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{
            [self loadPlatform];

        }
            break;
        case 1:{
            [self loadUserIntroduce];

        }
            break;
        case 2:{
            [self loadProtocol];

        }
            break;
        case 3:{
            [self loadLawer];
        }
            break;
        case 4:{
            FeedBackViewController *vc = [FeedBackViewController new];
            [self.navigationController  pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}



- (IBAction)feedBack:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)dealloc
{
    [self cancleRequest];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
