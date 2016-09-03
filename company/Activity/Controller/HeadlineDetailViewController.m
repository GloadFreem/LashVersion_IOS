//
//  HeadlineDetailViewController.m
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeadlineDetailViewController.h"
#import "CircleShareBottomView.h"
#import "ShareToCircleView.h"
#define SHARETOCIRCLE @"shareContentToFeeling"

@interface HeadlineDetailViewController () <CircleShareBottomViewDelegate,UIWebViewDelegate,ShareToCircleViewDelegate>
@property (nonatomic,strong) UIView * shareView;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, strong) ShareToCircleView *shareCircleView;
@property (nonatomic, copy) NSString *circlePartner;
@property (strong, nonatomic) UIWebView * webView;
@end

@implementation HeadlineDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [Encapsulation returnWithViewController:self img:@"leftBack"];
    [Encapsulation rightBarButtonWithViewController:self imgName:@"write-share"];
    
    
    self.circlePartner = [TDUtil encryKeyWithMD5:KEY action:SHARETOCIRCLE];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.opaque = NO; // 将webView设置为不透明
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    //加载视图区域
    self.loadingViewFrame = _webView.frame;
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


#pragma mark - BarButton method

// 返回上一vc
- (void)backHome:(UIViewController *)mySelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------------------------开始分享---------------------------------

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
    if(self.shareView != nil)
    {
        [self.shareView removeFromSuperview];
    }
}


- (void)rightBarButtonAction:(UIViewController *)vc
{
    NSArray *titleList = @[@"圈子",@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_circle@2x",@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareCircleViewWithTitleArray:titleList imageArray:imageList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBG)];
    [share addGestureRecognizer:tap];
    [[self topView] addSubview:share];
    self.shareView = share;
    share.delegate = self;
}

-(void)sendShareBtnWithView:(CircleShareBottomView *)view index:(int)index
{
    //分享
    if (view.tag == 1) {
        //得到用户SID
        NSString * shareImage = _shareImage;
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_shareContent];
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
                    [UMSocialData defaultData].extConfig.qqData.url = _shareurl;
                    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
                    //                    [UMSocialData defaultData].extConfig.qzoneData.title = _shareTitle;
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
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareurl;
                //                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                //                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 3:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                //                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
                //                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
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
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_shareTitle,_shareContent,_shareurl];
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
    [shareView instancetationShareToCircleViewWithimage:_image title:_titleText content:_contentText];
    shareView.tag = 1000;
    [[UIApplication sharedApplication].windows[0] addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.circlePartner,@"partner",@"",@"contentId",@"8",@"type",content,@"comment",_url,@"content",_titleText,@"description",_image,@"image",_contentText,@"tag",nil];
//        NSLog(@"打印字典---%@",dic);
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:SHARE_TO_CIRCLE postParam:dic type:0 delegate:self sel:@selector(requestShareToCircle:)];
    }
}

-(void)requestShareToCircle:(ASIHTTPRequest*)request
{
    
    
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.contentText;
//    NSLog(@"打印标题---%@",self.contentText);
}



@end
