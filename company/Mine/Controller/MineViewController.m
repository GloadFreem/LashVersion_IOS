//
//  MineViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineViewController.h"
#import "MoneyAccountVC.h"
#import "MineAttentionVC.h"
#import "MineActivityVC.h"
#import "MineGoldVC.h"
#import "MineProjectCenterVC.h"
#import "AppSetVC.h"
#import "PingTaiVC.h"
#import "MineDataVC.h"
#import "YeePayViewController.h"
#import "AuthenticInfoBaseModel.h"

#define SIGNVERIFY @"signVerify"
#define AUTHENINFO @"authenticInfoUser"


@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *companyStr;

@property (nonatomic, copy) NSString *request;
@property (nonatomic, copy) NSString *signPartner;
@property (nonatomic, copy) NSString *authenPartner;
@property (nonatomic, strong) AuthenticInfoBaseModel *authenticModel;

@property (nonatomic, assign) NSInteger identiyTypeId;
@property (nonatomic, assign) NSInteger authId;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    
}

#pragma mark -下载认证信息
-(void)loadAuthenData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.authenPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:AUTHENTIC_INFO postParam:dic type:0 delegate:self sel:@selector(requestAuthenInfo:)];
}

-(void)requestAuthenInfo:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            AuthenticInfoBaseModel *baseModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
            _authenticModel = baseModel;
            
            
            NSArray *authenticsArray = baseModel.authentics;
            ProjectAuthentics *authentics = authenticsArray[0];
            
            _nameStr = authentics.name;
            _companyStr = [NSString stringWithFormat:@"%@ | %@",authentics.companyName,authentics.position];
            
            _identiyTypeId = authentics.identiytype.identiyTypeId;
            _authId = authentics.authId;
            
            [self setModel];
            
        }
    }
}

-(void)setModel
{
    _iconBtn.layer.cornerRadius = 41.5;
    _iconBtn.layer.masksToBounds = YES;
    
    
//    [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_authenticModel.headSculpture]] forState:UIControlStateNormal placeholderImage:[UIImage new]];
    
    [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_authenticModel.headSculpture]] forState:UIControlStateNormal placeholderImage:[UIImage new] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [_iconBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    
    _name.text = _nameStr;
    _company.text = _companyStr;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //下载认证信息
    [self loadAuthenData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.navigationController.navigationBar setHidden:NO];
}
#pragma mark -进入头像详情页面
- (IBAction)iconDetail:(UIButton *)sender {
    MineDataVC *vc = [MineDataVC new];
    vc.authenticModel = _authenticModel;
    vc.identiyTypeId = _identiyTypeId;
    vc.authId = _authId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -进入各个小界面
- (IBAction)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            //先检查是否是易宝用户---非易宝账号则去实名认证---是易宝账号则进入资金页面
            [self isCheckUserConfirmed];
            
            
            
        }
            break;
        case 1:
        {
            MineAttentionVC *vc = [MineAttentionVC new];
            [self.navigationController  pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            MineActivityVC *vc =[MineActivityVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            MineGoldVC *vc = [MineGoldVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            if (_identiyTypeId == 1) {//项目方
                
            }
            if (_identiyTypeId == 2) {//投资人
                
            }
            if (_identiyTypeId == 3) {//投资机构
                
            }
            if (_identiyTypeId == 4) {//智囊团
                
            }
            MineProjectCenterVC *vc = [MineProjectCenterVC new];
            [self.navigationController  pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            AppSetVC *vc =[AppSetVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            PingTaiVC *vc = [PingTaiVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            
        }
            break;
        default:
            break;
    }

}

#pragma mark ----------认证是否是易宝用户-------------
-(void)isCheckUserConfirmed
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    
    [self sign:signString sel:@selector(requestCheckUserSign:) type:1];
    
}

-(void)requestCheckUserSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign",ACCOUNT_INFO,@"service", nil];
            [self.httpUtil getDataFromYeePayAPIWithOps:@"" postParam:dic type:0 delegate:self sel:@selector(requestCheckUser:)];
        }
    }
}

-(void)requestCheckUser:(ASIHTTPRequest *)request{
    NSString *xmlString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",xmlString);
    NSDictionary * xmlDic = [TDUtil convertXMLStringElementToDictory:xmlString];
    
//    NSLog(@"%@",xmlDic);
    
    if ([DICVFK(xmlDic, @"code") intValue]==101) {
        [self goConfirm];
    }else if([DICVFK(xmlDic, @"code") intValue]==1)
    {
    //进入资金界面
        MoneyAccountVC *vc = [MoneyAccountVC new];
    
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        self.isNetRequestError = YES;
    }
}

#pragma mark ----------------易宝用户认证--------------------
-(void)goConfirm
{
    NSUserDefaults * data = [NSUserDefaults standardUserDefaults];
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"G2_IDCARD" forKey:@"idCardType"];
    [dic setObject:@"ios://verify:" forKey:@"callbackUrl"];
    
    [dic setObject:[data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE]forKey:@"mobile"];
    [dic setObject:[data valueForKey:USER_STATIC_NAME] forKey:@"realName"];
    [dic setObject:[data valueForKey:USER_STATIC_IDNUMBER] forKey:@"idCardNo"];
    
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    //    [dic setObject:[data valueForKey:USER_STATIC_NICKNAME] forKey:@"nickName"];
    
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requestSign:) type:0];
    
}

-(void)requestSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            YeePayViewController * controller = [[YeePayViewController alloc]init];
            controller.title = @"实名认证";
            controller.PostPramDic = dic;
            controller.center = @"0";
            //            controller.dic = self.dic;
            controller.state = PayStatusConfirm;
            //            [controller.dic setValue:STRING(@"%d", currentSelect) forKey:@"currentSelect"];
            controller.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,YeePayToRegister,nil)];
            [self.navigationController pushViewController:controller animated:YES];
            self.startLoading = NO;
            return;
        }
        self.isNetRequestError = YES;
    }
}

-(void)sign:(NSString*)signString sel:(SEL)sel type:(int)type
{
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.signPartner,@"partner",signString,@"req",@"sign",@"method",@"",@"sign",STRING(@"%d", type),@"type",nil] type:0 delegate:self sel:sel];
}

#pragma mark -退出logo界面
- (IBAction)closeView:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
