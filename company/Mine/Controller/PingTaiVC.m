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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

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
    [self.httpUtil getDataFromAPIWithOps:REQUESTPLATFORMINTRODUCE postParam:dic type:1 delegate:self sel:@selector(requestPlatform:)];
    
}
-(void)requestPlatform:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dic = [jsonDic valueForKey:@"data"];
            _paltformUrl = dic[@"url"];
        }
    }
}

-(void)loadUserIntroduce
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.userIntroducePartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUESTUSERGUIDE postParam:dic type:1 delegate:self sel:@selector(requestUser:)];
}

-(void)requestUser:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dic = [jsonDic valueForKey:@"data"];
            _userUrl = dic[@"url"];
        }
    }
}

-(void)loadProtocol
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.protocolPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUESTUSERPROTOCOL postParam:dic type:1 delegate:self sel:@selector(requestProtocol:)];
}
-(void)requestProtocol:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dic = [jsonDic valueForKey:@"data"];
            _protocolUrl = dic[@"url"];
        }
    }
}
-(void)loadLawer
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.lawerpartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUESTLAWERINTRODUCE postParam:dic type:1 delegate:self sel:@selector(requestLawer:)];
}

-(void)requestLawer:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dic = [jsonDic valueForKey:@"data"];
            _lawerurl = dic[@"url"];
        }
    }
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
    
    PingTaiWebViewController *vc = [PingTaiWebViewController new];
    if (sender.tag == 0) {
        [self loadPlatform];
        
        vc.url = _paltformUrl;
        vc.titleStr = @"平台介绍";
    }
    if (sender.tag == 1) {
        [self loadUserIntroduce];
        vc.url = _userUrl;
        vc.titleStr = @"新手指南";
    }
    if (sender.tag == 2) {
        [self loadProtocol];
        vc.url = _protocolUrl;
        vc.titleStr = @"用户协议";
    }
    if (sender.tag == 3) {
        [self loadLawer];
        vc.url = _lawerurl;
        vc.titleStr = @"免责声明";
    }
    if (vc.url) {
        [self.navigationController  pushViewController:vc animated:YES];
    }
    
    if (sender.tag == 4) {
        FeedBackViewController *vc = [FeedBackViewController new];
        [self.navigationController  pushViewController:vc animated:YES];
    }
}



- (IBAction)feedBack:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
