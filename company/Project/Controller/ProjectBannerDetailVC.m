//
//  ProjectBannerDetailVC.m
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectBannerDetailVC.h"
#import "CircleShareBottomView.h"
#import "ShareToCircleView.h"

#define SHARETOCIRCLE @"shareContentToFeeling"

@interface ProjectBannerDetailVC ()<UIWebViewDelegate,CircleShareBottomViewDelegate,ShareToCircleViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (nonatomic,strong)UIView * bottomView;
@property (strong, nonatomic) UIView *gifView;
@property (strong, nonatomic) UIImageView *gifImageView;

@property (nonatomic, strong) ShareToCircleView *shareCircleView;
@property (nonatomic, copy) NSString *circlePartner;

@end

@implementation ProjectBannerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.circlePartner = [TDUtil encryKeyWithMD5:KEY action:SHARETOCIRCLE];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNav];
    _webView  =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [_webView scalesPageToFit];
    [_webView sizeToFit];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    
    [self startLoadDetailData];
    //加载视图区域
    self.loadingViewFrame = _webView.frame;
}

-(void)setNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    UIButton *shareBtn = [UIButton new];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share_btn"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.size = CGSizeMake(35, 35);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    self.navigationItem.title = self.titleStr;
}

#pragma mark-----创建loadingView
-(void)createLoadingView
{
    _gifView = [[UIView alloc]initWithFrame:self.view.frame];
    _gifView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_gifView];
    
    _gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 174*WIDTHCONFIG, 174*WIDTHCONFIG)];
    _gifImageView.centerX = self.view.centerX;
    _gifImageView.centerY = self.view.centerY - 50*WIDTHCONFIG;
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loadingView"];
    _gifImageView.image = image;
    [self.view addSubview:_gifImageView];
    
}
#pragma mark----移除loadingView
-(void)removeLoadingView
{
    [_gifImageView removeFromSuperview];
    [_gifView removeFromSuperview];
    
}

-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareBtnClick
{
    [self startShare];
}

#pragma mark -开始分享

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
    NSArray *titleList = @[@"圈子",@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_circle@2x",@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareCircleViewWithTitleArray:titleList imageArray:imageList];
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
        NSString* shareImage = _image;
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_contentText];
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                [self dismissBG];
                [self createShareCircleView];
                
                //                NSLog(@"分享圈子");
            }
                break;
            case 1:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _url;
                    [UMSocialData defaultData].extConfig.qqData.title = _titleText;
//                    [UMSocialData defaultData].extConfig.qzoneData.title = _model.name;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
                break;
            case 2:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
//                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _titleText;
//                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _model.name;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 3:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
//                [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
//                [UMSocialData defaultData].extConfig.wechatSessionData.title = _model.name;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _titleText;
                
                //                NSLog(@"分享到朋友圈");
            }
                break;
            case 4:{
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
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_titleText,_contentText,_url];
        }
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            shareImage];
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self performSelector:@selector(dismissBG) withObject:nil afterDelay:1.0];
                    
                    
//                });
            }
        }];
    }
}

-(void)createShareCircleView
{
    ShareToCircleView *shareView =[[[NSBundle mainBundle] loadNibNamed:@"ShareToCircleView" owner:nil options:nil] lastObject];
    shareView.backgroundColor = [UIColor clearColor];
    if (self.isActivity) {
        _titleStr = _titleText;
    }
    [shareView instancetationShareToCircleViewWithimage:_image title:_titleStr content:_contentText];
    shareView.tag = 1000;
    [[UIApplication sharedApplication].windows[0] addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    shareView.textView.delegate = self;
    shareView.delegate = self;
    _shareCircleView = shareView;
}

#pragma mark-------ShareToCircleViewDelegate--------
-(void)clickBtnInView:(ShareToCircleView *)view andIndex:(NSInteger)index content:(NSString *)content
{
    if (index == 0) {
        [view removeFromSuperview];
    }else{
        //        NSLog(@"调接口");
        [_shareCircleView removeFromSuperview];
        
        if ([content isEqualToString:@"说点什么吧..."]) {
            content = @"";
        }
        if (_model.desc.length > 200) {
            _model.desc = [_model.desc substringToIndex:200];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.circlePartner,@"partner",@"",@"contentId",@"8",@"type",content,@"comment",_url,@"content",_contentText,@"description",_image,@"image",self.titleStr,@"tag",nil];
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:SHARE_TO_CIRCLE postParam:dic type:0 delegate:self sel:@selector(requestShareToCircle:)];
    }
}

-(void)requestShareToCircle:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"分享成功");
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络好像出了点问题，检查一下"];
    }
}

-(void)startLoadDetailData
{
    if (![_url hasPrefix:@"http://"]) {
        NSString * url =[NSString stringWithFormat:@"http://%@",_url];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }else{
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        self.startLoading = YES;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        self.startLoading = NO;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView == self.webView) {
        self.startLoading = YES;
        self.isNetRequestError = YES;
    }
}

#pragma mark -textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.font= BGFont(18);
    textView.textColor = color47;
    if ([textView.text isEqualToString:@"说点什么吧..."]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.font = BGFont(15);
        textView.text = @"说点什么吧...";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self createLoadingView];    //创建加载动画
    
    [self.navigationController.navigationBar setHidden:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
