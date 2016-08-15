//
//  MineGoldVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineGoldVC.h"
#import "MineGoldMingxiVC.h"

#import "CircleShareBottomView.h"

#import "PingTaiWebViewController.h"

#define GOLDACCOUNT  @"requestUserGoldCount"
#define INVITEFRIEND  @"requestGoldInviteFriends"
#define GOLDGETRULE  @"requestGoldGetRule"
#define GOLDUSERULE  @"requestGoldUseRule"

@interface MineGoldVC ()<CircleShareBottomViewDelegate>

@property (nonatomic,strong)UIView * bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBgHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldheight;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, copy) NSString *count;
@property (nonatomic, assign) NSInteger rewardId;

@property (nonatomic, copy) NSString *codePartner;
@property (nonatomic, copy) NSString *goldGetPartner;
@property (nonatomic, copy) NSString *goldUsepartner;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *useUrl;
@property (nonatomic, copy) NSString *getUrl;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation MineGoldVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topBgHeight.constant = 324*HEIGHTCONFIG;
    self.goldWidth.constant = 284*WIDTHCONFIG;
    self.goldheight.constant = 175*WIDTHCONFIG;
    
    self.loadingViewFrame = CGRectMake(0, 64, SCREENWIDTH, SCREENWIDTH-64);
    self.isTransparent = YES;
    _isFirst = YES;
    
    self.partner = [TDUtil encryKeyWithMD5:KEY action:GOLDACCOUNT];
    self.codePartner = [TDUtil encryKeyWithMD5:KEY action:INVITEFRIEND];
    self.goldGetPartner = [TDUtil encryKeyWithMD5:KEY action:GOLDGETRULE];
    self.goldUsepartner = [TDUtil encryKeyWithMD5:KEY action:GOLDUSERULE];
    [self startLoadData];
    [self loadGetRule];
    [self loadUseRule];
    [self loadCode];
    
}
#pragma maker-------邀请码
-(void)loadCode
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_GOLD_INVITE_FRIEND postParam:dic type:0 delegate:self sel:@selector(requestInviteCode:)];
}
-(void)requestInviteCode:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status =[jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _shareUrl = data[@"url"];
            _shareImage = data[@"image"];
            _shareTitle = data[@"title"];
            _shareContent = data[@"content"];
        }
    }
}
#pragma mark-------使用规则
-(void)loadUseRule
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_GOLD_USE_RULE postParam:dic type:0 delegate:self sel:@selector(requestUseRule:)];
}
-(void)requestUseRule:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status =[jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _useUrl = data[@"url"];
        }
    }
}
#pragma mark-------积累规则
-(void)loadGetRule
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_GOLD_GET_RULE postParam:dic type:0 delegate:self sel:@selector(requestGetRule:)];
}
-(void)requestGetRule:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status =[jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _getUrl = data[@"url"];
        }
    }
}

-(void)startLoadData
{
    if (_isFirst) {
        self.startLoading = YES;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_GOLD_ACCOUNT postParam:dic type:0 delegate:self sel:@selector(requestGoldInfo:)];
    
}

-(void)requestGoldInfo:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            _count = [dataDic valueForKey:@"count"];
            [self setModel];
            
        }else{
            self.isNetRequestError = YES;
        }
    }
}

-(void)setModel
{
    _countLabel.text = [NSString stringWithFormat:@"%@",_count];
    
    if (_isFirst) {
        _isFirst = NO;
    }
    self.startLoading = NO;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [self startLoadData];
}

- (IBAction)leftBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {//明细
            MineGoldMingxiVC *vc = [MineGoldMingxiVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {//邀请码
            //开始分享
            [self startShare];
        }
            break;
        case 2:
        {//积累
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = _getUrl;
            vc.titleStr = @"金条积累规则";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {//使用
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = _useUrl;
            vc.titleStr = @"金条使用规则";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_shareContent];
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
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareContent;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareContent;
                
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
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_shareTitle,_shareContent,_shareUrl];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
