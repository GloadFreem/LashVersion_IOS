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
#import "AppSetVC.h"
#import "PingTaiVC.h"
#import "MineDataVC.h"
#import "YeePayViewController.h"
#import "AuthenticInfoBaseModel.h"

#import "CircleShareBottomView.h"
#define INVITEFRIEND @"requestInviteFriends"

#define SIGNVERIFY @"signVerify"
#define AUTHENINFO @"authenticInfoUser"

#import "RenzhengViewController.h"
#import "MineInvestViewController.h"
#import "MineProjectViewController.h"
#import "MineThinkTankViewController.h"
@interface MineViewController ()<CircleShareBottomViewDelegate>

@property (nonatomic,strong)UIView * bottomView;

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
@property (nonatomic, assign) BOOL isAuthentic;

@property (nonatomic, copy) NSString *authenticName;
//@property (nonatomic, copy) NSString *identiyTypeId;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *contentText;
@property (nonatomic, copy) NSString *shareUrl; //分享地址
@property (nonatomic, copy) NSString *shareImage;//分享图片
@property (nonatomic, copy) NSString *sharePartner;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isFinish;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isFinish = YES;
    _iconWidth.constant =_iconHeight.constant= 83 *WIDTHCONFIG ;
    _iconBtn.layer.cornerRadius = 41.5 *WIDTHCONFIG;
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.borderWidth = 2;
    _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    _iconBtn.translatesAutoresizingMaskIntoConstraints = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:INVITEFRIEND];
    
    self.loadingViewFrame = self.view.frame;
    self.isTransparent = YES;
    [self loadShareData];
    
}


-(void)loadShareData
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",@"3",@"type", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_INVITE_FRIEND postParam:dic type:0 delegate:self sel:@selector(requestShareData:)];
}
-(void)requestShareData:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = jsonDic[@"data"];
            
            _shareUrl = dataDic[@"url"];
            _shareImage = dataDic[@"image"];
            _contentText = dataDic[@"content"];
            _shareTitle = dataDic[@"title"];
        }else{
        
        }
    }
    
}
#pragma mark -下载认证信息
-(void)loadAuthenData
{
//    if (_isFirst) {
//        self.startLoading = YES;
//    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.authenPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:AUTHENTIC_INFO postParam:dic type:0 delegate:self sel:@selector(requestAuthenInfo:)];
}

-(void)requestAuthenInfo:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            AuthenticInfoBaseModel *baseModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
            _authenticModel = baseModel;
            
            NSArray *authenticsArray = baseModel.authentics;
            if (authenticsArray.count) {
                ProjectAuthentics *authentics = authenticsArray[0];
                
                _nameStr = authentics.name;
                
                ProjectAuthenticstatus *authenticsstatus = authentics.authenticstatus;
                
                if ([authenticsstatus.name isEqualToString:@"已认证"] || [authenticsstatus.name isEqualToString:@"认证中"]) {
                    if ([authenticsstatus.name isEqualToString:@"已认证"]) {
                        _isAuthentic = YES;
                    }else{
                        _isAuthentic = NO;
                    }
                    
                    if (authentics.companyName && authentics.companyName.length && authentics.position && authentics.position.length) {
                        _companyStr = [NSString stringWithFormat:@"%@ | %@",authentics.companyName,authentics.position];
                    }else{
                        _companyStr = @"";
                    }
                }else{
                    _nameStr = baseModel.telephone;
                    _isAuthentic = NO;
                }
                _authenticName = authenticsstatus.name;
                _identiyTypeId = authentics.identiytype.identiyTypeId;
                _authId = authentics.authId;
            }
            
            [self setModel];
            
//            if (_isFirst) {
//                _isFirst = NO;
//            }
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
//        self.isNetRequestError = YES;
    }
}

-(void)setModel
{
    [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_authenticModel.headSculpture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderIcon"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [_iconBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    NSString *nickName = [data objectForKey:@"nickName"];
    if (_nameStr && _nameStr.length) {
        _name.text = _nameStr;
        
    }else{
        _name.text = nickName;
    }
    if (_isAuthentic) {
        [_vipImage setHidden:NO];
    }else{
        [_vipImage setHidden:YES];
    }
//    NSLog(@"%@",_nameStr);
    _company.text = _companyStr;
    if (!_isFirst) {
        _isFirst = YES;
    }
//    self.startLoading = NO;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    self.startLoading = YES;
//    self.isNetRequestError = YES;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
//    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
//    self.startLoading =NO;
    _isFinish = YES;
    
}

-(void)refresh
{
    [self loadAuthenData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //下载认证信息
    if (_isFinish) {
        [self loadAuthenData];
        _isFinish = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark -进入头像详情页面
- (IBAction)iconDetail:(UIButton *)sender {
    if (_isFirst) {
        MineDataVC *vc = [MineDataVC new];
        vc.authenticModel = _authenticModel;
        vc.identiyTypeId = _identiyTypeId;
        vc.authId = _authId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -进入各个小界面
- (IBAction)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            if ([_authenticName isEqualToString:@"已认证"]) {
                //先检查是否是易宝用户---非易宝账号则去实名认证---是易宝账号则进入资金页面
                [self isCheckUserConfirmed];
            }
            if ([_authenticName isEqualToString:@"认证中"]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            if ([_authenticName isEqualToString:@"未认证"] || [_authenticName isEqualToString:@"认证失败"]){
                [self presentAlertView];
            }
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
                MineProjectViewController *vc = [MineProjectViewController new];
                vc.type = _identiyTypeId - 1;
                [self.navigationController pushViewController:vc animated:YES];
//                NSLog(@"项目方");
                return;
                
            }
            if (_identiyTypeId == 2) {//投资人
                
                MineInvestViewController *vc = [MineInvestViewController new];
                vc.type = _identiyTypeId -1 ;
                [self.navigationController  pushViewController:vc animated:YES];
                
//                NSLog(@"投资人");
                return;
            }
            if (_identiyTypeId == 3) {//投资机构
                
                MineInvestViewController *vc = [MineInvestViewController new];
                vc.type = _identiyTypeId -1 ;
                [self.navigationController pushViewController:vc animated:YES];
                
//                NSLog(@"投机机构");
                return;
            }
            if (_identiyTypeId == 4) {//智囊团
                MineThinkTankViewController *vc = [MineThinkTankViewController new];
                vc.type = _identiyTypeId -1;
                [self.navigationController pushViewController:vc animated:YES];
//                NSLog(@"智囊团");
                return;
            }
            
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
        {//邀请好友
            [self startShare];
        }
            break;
        default:
            break;
    }

}

-(void)presentAlertView
{
    //没有认证 提醒去认证
    NSString *message;
    if ([_authenticName isEqualToString:@"未认证"]) {
        message = @"您还没有实名认证，请先实名认证";
    }else{
        message = @"您的实名认证未通过，请继续认证";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    __block MineViewController* blockSelf = self;
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf btnCertain:nil];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)btnCertain:(id)sender
{
    RenzhengViewController  * renzheng = [RenzhengViewController new];
    renzheng.identifyType = [NSString stringWithFormat:@"%ld",(long)self.identiyTypeId];
    [self.navigationController pushViewController:renzheng animated:YES];
}

#pragma mark -开始分享
#pragma mark  转发

- (UIView*)topView {
    UIViewController *recentView = self;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

/**
 *  点击空白区域shareView消失
 */

- (void)dismissBG
{
    if(self.bottomView != nil)
    {
        [self.bottomView removeFromSuperview];
    }
}

-(void)startShare
{
    NSArray *titleList = @[@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareViewWithTitleArray:titleList imageArray:imageList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBG)];
    [share addGestureRecognizer:tap];
    [[self topView] addSubview:share];
    self.bottomView = share;
    share.delegate = self;
}
-(void)sendShareBtnWithView:(CircleShareBottomView *)view index:(int)index
{
    //分享
    if (view.tag == 1) {
        //得到用户SID
        NSString *shareImage = _shareImage;
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_contentText];
        
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
                    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
                    [UMSocialData defaultData].extConfig.qzoneData.title = _shareTitle;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
                break;
            case 1:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到朋友圈");
            }
                break;
            case 3:{
                // 短信
                arr = @[UMShareToSms];
                shareContent = shareContentString;
                
                //                NSLog(@"分享短信");
            }
                break;
            case 100:{
                [self dismissBG];
            }
                break;
            default:
                break;
        }
        if(arr == nil)
        {
            return;
        }
        if ([[arr objectAtIndex:0] isEqualToString:UMShareToSms]) {
            shareImage = nil;
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_shareTitle,_contentText,_shareUrl];
        }
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            shareImage];
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self performSelector:@selector(dismissBG) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
                    
                    
                });
            }
        }];
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
