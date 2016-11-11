//
//  MineViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineViewController.h"
#import "MineAttentionVC.h"
#import "MineActivityVC.h"
#import "MineGoldVC.h"
#import "AppSetVC.h"
#import "PingTaiVC.h"
#import "MineDataVC.h"
#import "AuthenticInfoBaseModel.h"
#import "LYJVerticalBtn.h"
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

/** 按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;

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

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBtns];
    
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
    
    [self readData];
    self.loadingViewFrame = self.view.frame;
    self.isTransparent = YES;
    
    [self loadShareData];
    
}

-(void)setupBtns
{
    //数据
    NSArray *images = @[@"logo_project",@"logo_collect",@"logo_activity",@"logo_gold",@"logo_set",@"logo_platform",@"logo_recomend",@"logo_recomend"];
    NSArray *titles = @[@"项目中心",@"我的关注",@"我的活动",@"我的金条",@"软件设置",@"关于平台",@"推荐好友",@"推荐好友"];
    // 一些参数
    NSUInteger count = titles.count;
    int maxColsCount = 4; // 一行的列数
    //    NSUInteger rowsCount = (count + maxColsCount - 1) / maxColsCount;
    // 按钮尺寸
    CGFloat buttonW = (SCREEN_WIDTH - 43) / maxColsCount;
    CGFloat buttonH = buttonW * 0.95;
    CGFloat buttonStartY = 250;
    
    for (int i = 0; i < count; i++) {
        
        if (i != 7) {
            // 创建、添加
            LYJVerticalBtn *button = [LYJVerticalBtn buttonWithType:UIButtonTypeCustom];
            button.width = -1; // 按钮的尺寸为0，还是能看见文字缩成一个点，设置按钮的尺寸为负数，那么就看不见文字了
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [self.buttons addObject:button];
            [self.view addSubview:button];
            //        [button setBackgroundColor:[UIColor redColor]];
            // 内容
            [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[TDUtil colorWithHexString:@"474747"] forState:UIControlStateNormal];
//            [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:13]];
            [button.titleLabel setFont:BGFont(13)];
            
            // frame
            CGFloat buttonX = (i % maxColsCount) * buttonW + 21.5;
            CGFloat buttonY = buttonStartY + (i / maxColsCount) * (buttonH +20 );
            button.frame = CGRectMake(buttonX, buttonY + 35, buttonW, buttonH);
        }
        
        // 动画
//        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
//        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - SCREEN_HEIGHT, buttonW, buttonH)];
//        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY + 25, buttonW, buttonH)];
//        anim.springSpeed = XMGSpringFactor;
//        anim.springBounciness = XMGSpringFactor;
//        // CACurrentMediaTime()获得的是当前时间
//        anim.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
//        [button pop_addAnimation:anim forKey:nil];
        
    }
    
    UIButton *btn = [UIButton new];
//        btn.backgroundColor = [UIColor greenColor];
    [btn setImage:[UIImage imageNamed:@"logo_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        //        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

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
            }
            
            
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
//        self.isNetRequestError = YES;
    }
}

-(void)readData
{
    [self setModel];
}
-(void)setModel
{
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    _iconStr = [data objectForKey:USER_STATIC_HEADER_PIC];
//    NSLog(@"dayin---%@",_iconStr);
    NSString *authenticStatus = [data objectForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    NSString *telephone = [data objectForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    _companyS = [data objectForKey:USER_STATIC_COMPANY_NAME];
    _position = [data objectForKey:USER_STATIC_POSITION];
    _identiyTypeId = [[data objectForKey:USER_STATIC_USER_AUTHENTIC_TYPE] integerValue];
//    NSLog(@"%@---%@",_companyS,_position);
    NSString *name = [data objectForKey:USER_STATIC_NAME];
    if (name) {
        _nameStr = name;
    }
    
    if ([authenticStatus isEqualToString:@"已认证"] || [authenticStatus isEqualToString:@"认证中"]) {
        if ([authenticStatus isEqualToString:@"已认证"]) {
            _isAuthentic = YES;
        }else{
            _isAuthentic = NO;
        }
        
        if ( _companyS && _companyS.length && _position.length && _position) {
            _companyStr = [NSString stringWithFormat:@"%@ | %@",_companyS,_position];
        }else{
            _companyStr = @"";
        }
        
    }else{
        _nameStr = telephone;
        _isAuthentic = NO;
    }
    _authenticName = authenticStatus;
    
    
    
    UIImage *image = [TDUtil loadContent:@"iconImage"];
    if (image) {
        [_iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_iconStr]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderIcon"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [_iconBtn setBackgroundImage:image forState:UIControlStateNormal];
            }
        }];
    }
    
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
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    self.startLoading = YES;
//    self.isNetRequestError = YES;
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);

    
}

-(void)refresh
{
    [self loadAuthenData];
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

#pragma mark -进入头像详情页面
- (IBAction)iconDetail:(UIButton *)sender {
        MineDataVC *vc = [MineDataVC new];
        vc.mineVC = self;
        vc.position = _position;
        vc.companyName = _companyS;
        vc.iconImg = _iconBtn.currentBackgroundImage;
        [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -进入各个小界面
- (void)buttonClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            if (_identiyTypeId == 1) {//项目方
                MineProjectViewController *vc = [MineProjectViewController new];
                vc.type = _identiyTypeId - 1;
                [self.navigationController pushViewController:vc animated:YES];
                NSLog(@"项目方");
                return;
                
            }
            if (_identiyTypeId == 2) {//投资人
                
                MineInvestViewController *vc = [MineInvestViewController new];
                vc.type = _identiyTypeId -1 ;
                [self.navigationController  pushViewController:vc animated:YES];
                
                NSLog(@"投资人");
                return;
            }
            if (_identiyTypeId == 3) {//投资机构
                
                MineInvestViewController *vc = [MineInvestViewController new];
                vc.type = _identiyTypeId -1 ;
                [self.navigationController pushViewController:vc animated:YES];
                
                NSLog(@"投机机构");
                return;
            }
            if (_identiyTypeId == 4) {//智囊团
                MineThinkTankViewController *vc = [MineThinkTankViewController new];
                vc.type = _identiyTypeId -1;
                [self.navigationController pushViewController:vc animated:YES];
                NSLog(@"智囊团");
                return;
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
            AppSetVC *vc =[AppSetVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            PingTaiVC *vc = [PingTaiVC new];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            //邀请好友
            [self startShare];
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

#pragma mark -退出logo界面
- (void)dismiss:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc
{
    [self cancleRequest];
}
@end
