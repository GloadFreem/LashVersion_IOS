//
//  BannerViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "YeePayViewController.h"
//#import "ShareView.h"
#import "DialogUtil.h"
//#import "ShareNewsView.h"
#import "GDataXMLNode.h"
//#import "PurseViewController.h"
#import "PaySuccessViewController.h"
//#import "FinialApplyViewController.h"
#import "MoneyAccountVC.h"

#define DRAWMONEY @"requestWithDraw"
#define ACCOUNTCGARGE @"requestAccountCharge"
@interface YeePayViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    BOOL isGetStatus;
//    ShareNewsView* shareNewsView;
    NSString *_request;
}
@end

@implementation YeePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    [self setNav];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.dataDetectorTypes  = UIDataDetectorTypeAll;
    [self.view addSubview:self.webView];

    self.canBack = YES;
    
     [self loadUrl];
    
}

-(void)setNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
}

-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)back:(id)sender
{
//    switch (self.state) {
//        case PayStatusConfirm:
//            [self.navigationController popViewControllerAnimated:YES];
//            break;
//        case PayStatusBindCard:
//            [self.navigationController popViewControllerAnimated:YES];
//            break;
//        case PayStatusPayfor:
////            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"业务进行中，无法返回!"];
//            break;
//        case PayStatusTransfer:
////            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"业务进行中，无法返回!"];
//            break;
//            
//        default:
//            break;
//    }
    if (self.canBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"业务进行中，无法返回!"];
    }
}

-(void)setUrl:(NSURL *)url
{
    self->_url = url;
    
    [self loadUrl];
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic  = dic;
    isGetStatus = YES;
}


-(void)loadUrl
{
    if (!self.webView.loading) {
        NSString * postString = [TDUtil convertDictoryToFormat:@"%@=%@&" dicData:self.PostPramDic];
        
//        postString = [self encodeToPercentEscapeString:postString];
        
//        NSLog(@"post前:%@",postString);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:self.url];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: [postString dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (self.state == PayStatusTransfer) {
            self.state = PayStatusNormal;
            [self finialConfirm:nil];
        }else{
          [self.webView loadRequest:request];
        }
    }
}


-(void)setType:(int)type
{
    self->_type = type;
}

/**
 *  提现
 *
 *  @param dic 返回参数 toWithdraw
 */
-(void)toWithdrawConfirm:(NSDictionary*)dic
{
    [self withDraw];
    NSLog(@"%@",dic);
    [self back:nil];
    
}
-(void)withDraw
{
    self.drawPartner = [TDUtil encryKeyWithMD5:KEY action:DRAWMONEY];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.drawPartner,@"partner",_tradeCode,@"tradeCode", nil];
    [self.httpUtil getDataFromAPIWithOps:REQUEST_WITH_DRAW postParam:dic type:0 delegate:self sel:@selector(requestDraw:)];
}
-(void)requestDraw:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic != nil) {
        NSString *status = [dic objectForKey:@"status"];
        if ([status integerValue] == 200)  {
            
            
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
    }
    
}
/**
 *  绑定银行卡回调
 *
 *  @param dic 返回参数
 */
-(void)bindCardConfirm:(NSDictionary*)dic
{
//    for(UIViewController * c in self.navigationController.childViewControllers)
//    {
//        if ([c isKindOfClass:PurseViewController.class]) {
//            [c removeFromParentViewController];
//            
//            PurseViewController * controller = [[PurseViewController alloc]init];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//    }
    
    [self back:nil];
}

/**
 *  注册易宝账号回调
 *
 *  @param dic 返回参数
 */
-(void)verify:(NSDictionary*)dic
{
    NSLog(@"%@",dic);
    
    _tradeCode = dic[@"requestNo"];
    switch (self.state) {
        case PayStatusConfirm:
            if ([self.center isEqualToString:@"0"]) {
                
                MoneyAccountVC *vc = [MoneyAccountVC new];
                
                [self.navigationController pushViewController:vc animated:YES];
                
                [self removeFromParentViewController];
                
                
            }else{
            [self back:nil];
            }
            break;
        case PayStatusBindCard:
            [self bindCard];
            break;
        case PayStatusPayfor:
            [self goPayfor];
            break;
        case PayStatusTransfer:
            [self finialConfirm:dic];
            break;
            
        case PayStatusAccount:{
            [self charge];
            
            for (UIViewController *VC in self.navigationController.viewControllers){
                if ([VC isKindOfClass:[MoneyAccountVC class]]) {
                MoneyAccountVC *vc = (MoneyAccountVC*)VC;
                    
                [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
            [self removeFromParentViewController];
        }
            break;
            case PayToWithdraw:{
                
        }
            break;
        default:
            break;
    }
    
}

-(void)charge
{
    self.chargePartner = [TDUtil encryKeyWithMD5:KEY action:ACCOUNTCGARGE];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.chargePartner,@"partner",_tradeCode,@"tradeCode", nil];
    [self.httpUtil getDataFromAPIWithOps:REQUEST_ACCOUNT_CHARGE postParam:dic type:0 delegate:self sel:@selector(requestCharge:)];
}
-(void)requestCharge:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic != nil) {
        NSString *status = [dic objectForKey:@"status"];
        if ([status integerValue] == 200)  {
           
            
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
    }
    
}
/**
 *  绑定银行卡
 */
-(void)bindCard
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    float mount = [[self.dataDic valueForKey:@"mount"] floatValue]*10000.00;
    
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    [dic setObject:STRING(@"%.2f", mount) forKey:@"amount"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"ios://bindCardConfirm" forKey:@"callbackUrl"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requestSignBindCard:) type:0];
}


-(void)goPayfor
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    float mount = [[self.dataDic valueForKey:@"mount"] floatValue]*10000.00;
    
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    [dic setObject:STRING(@"%.2f", mount) forKey:@"amount"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"ios://finialConfirm" forKey:@"callbackUrl"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requestSignFinial:) type:0];
}


-(void)sign:(NSString*)signString sel:(SEL)sel type:(int)type
{
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:signString,@"req",@"sign",@"method",@"",@"sign",STRING(@"%d", type),@"type",nil] type:0 delegate:self sel:sel];
}



-(void)finialConfirm:(NSDictionary*)dicData
{
    NSLog(@"%@",dicData);
    if ([DICVFK(dicData, @"code") intValue]==1) {
        self.canBack = NO;
    }
    
//    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    self.navigationItem.title = @"投标";
    
    NSString * str = [TDUtil generateUserPlatformNo];
    
    float mount = [DICVFK(self.dic, @"mount") floatValue]*10000;
    double profit = [DICVFK(self.dic, @"profit") doubleValue];
    
    float mount_profit = mount * profit;
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    
    NSMutableDictionary * dicItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.4f",mount - mount_profit],@"amount",@"MEMBER",@"targetUserType",DICVFK(self.dic, @"borrower_user_no"),@"targetPlatformUserNo",@"TENDER",@"bizType", nil];
    NSMutableDictionary * dicItem2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:STRING(@"%.4f", mount_profit),@"amount",@"MERCHANT",@"targetUserType",YeePayPlatformID,@"targetPlatformUserNo",@"TENDER",@"bizType", nil];
    
    [dic setObject:STRING(@"%.2f", mount) forKey:@"amount"];
    [dic setObject:str forKey:@"platformUserNo"];
    [dic setObject:@"MEMBER" forKey:@"userType"];
    [dic setObject:@"TENDER" forKey:@"bizType"];
    [dic setObject:[NSArray arrayWithObjects:dicItem,dicItem2,nil] forKey:@"details"];
    
     [dic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[TDUtil generateTenderNo:DICVFK(self.dic, @"projectId")],@"tenderOrderNo",DICVFK(self.dic, @"abbrevName"),@"tenderName",STRING(@"%.2f", [DICVFK(self.dic, @"planfinance") floatValue]*10000),@"tenderAmount",DICVFK(self.dic, @"fullName"),@"tenderDescription",DICVFK(self.dic, @"borrower_user_no"),@"borrowerPlatformUserNo", nil] forKey:@"extend"];
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    [dic setObject:@"ios://tenderConfirm" forKey:@"callbackUrl"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString];
}

-(void)tenderConfirm:(NSDictionary*)dicData
{
    NSLog(@"%@",dicData);
//    self.startLoading = YES;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    float mount = [DICVFK(self.dic, @"mount") floatValue];
    NSString *projectId = DICVFK(self.dic, @"projectId");
    
    [dic setValue:STRING(@"%.2f", mount) forKey:@"amount"];
    [dic setValue:[TDUtil generateTradeNo] forKey:@"tradeCode"];
    [dic setValue:[NSString stringWithFormat:@"%@",DICVFK(self.dic, @"currentSelect")] forKey:@"flag"];
    [dic setValue:projectId forKey:@"projectId"];
    
    [self.httpUtil getDataFromAPIWithOps:REQUESTINVESTPROJECT postParam:dic type:0 delegate:self sel:@selector(requestFinialSubmmmit:)];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlstr = request.URL.absoluteString;
    NSRange range = [urlstr rangeOfString:@"ios://"];
    
    if(range.length!=0)
    {
        
        NSString *method = [urlstr substringFromIndex:(range.location+range.length)];
        method = [method stringByAppendingString:@":"];
        SEL selctor = NSSelectorFromString(method);
        
        NSData * httpBody = request.HTTPBody;
        NSString* responseString = [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding];
        //获取字符串
        NSString *content = responseString;
        //替换+ 为空格
        content = [content stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        //decode
        content = [content stringByRemovingPercentEncoding];
        
        NSString * sign =@"";
        NSRange rangeSign = [content rangeOfString:@"&sign="];
        NSRange rangeResp = [content rangeOfString:@"resp="];
        if (rangeSign.length!=0 && rangeResp.length!=0) {
            
            sign = [content substringFromIndex:(rangeSign.location+rangeSign.length)];
            content = [content substringToIndex:rangeSign.location];
            
            rangeResp = [content rangeOfString:@"resp="];
            content = [content substringFromIndex:(rangeResp.location+rangeResp.length)];
            
            NSDictionary * dic =[TDUtil convertXMLStringElementToDictory:content];
            
            if (selctor) {
                [self performSelector:selctor withObject:dic];
            }
        }
        
        return NO;
    }else{
//        NSRange range = [urlstr rangeOfString:@"swiftRecharge"];
//        
//        if (range.length != 0) {
//            [_webView stringByEvaluatingJavaScriptFromString:@"submit();"];
////            return NO;
//        }
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    self.loadingViewFrame = CGRectMake(0, POS_X(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_X(self.navView));
    self.startLoading = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * str =  [webView stringByEvaluatingJavaScriptFromString:@"document.head.innerHTML"];
    if ([str containsString:@"操作成功"] || [str containsString:@"返回商户"]) {
        [_webView stringByEvaluatingJavaScriptFromString:@"submit();"];
    }else{
        NSString * string =  [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSLog(@"返回内容:%@",string);
        [self.webView.scrollView setContentSize:CGSizeMake(WIDTH(self.webView.scrollView), self.webView.scrollView.contentSize.height + 80)];
    }
//    self.startLoading =NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
//    self.isNetRequestError = YES;
}

-(void)refresh
{
    [super refresh];

    [self loadUrl];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //添加监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareNews" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareNewContent" object:nil];
}
-(void)dealloc
{
    self.webView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)sign:(NSString*)signString
{
    if (!self.httpUtil) {
        self.httpUtil = [[HttpUtils alloc]init];
    }
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",@"sign",@"method",@"0",@"type",@"",@"sign",nil] type:0 delegate:self sel:@selector(requestSign:)];
}


-(void)requestSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            
            self.titleStr = @"确认投资";
            self.PostPramDic = dic;
            self.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,YeePayToCpTransaction,nil)];
            return;
        }
//        self.isNetRequestError = YES;
//        self.startLoading  =NO;
    }
}

-(void)requestFinialSubmmmit:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            
            PaySuccessViewController * controller = [[PaySuccessViewController alloc]init];
            controller.dataDic = [NSMutableDictionary dictionaryWithDictionary:self.dic];
            controller.startPageImage = self.startPageImage;
            controller.abbrevName =self.abbrevName;
            controller.fullName = self.fullName;
            [self.navigationController pushViewController:controller animated:YES];
//            self.startLoading = NO;
            return;
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[jsonDic valueForKey:@"msg"],@"msg",@"",@"cancel",@"确认",@"sure",@"4",@"type",self,@"vController", nil]];
        }
//        self.startLoading = NO;
    }
}


-(void)requestSignFinial:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[data valueForKey:@"req"],@"req",[data valueForKey:@"sign"],@"sign", nil];
            self.PostPramDic = dic;
            self.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,YeePayMent,nil)];
//            self.startLoading  =NO;
            return;
        }
//        self.isNetRequestError = YES;
//        self.startLoading  =NO;
    }
}

-(void)requestSignBindCard:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
#pragma mark------将解卡状态改为NO
            NSUserDefaults* user =[NSUserDefaults standardUserDefaults];
            [user setValue:@"YES" forKey:@"jiekaremind"];
            
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[data valueForKey:@"req"],@"req",[data valueForKey:@"sign"],@"sign", nil];
            self.PostPramDic = dic;
            self.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,toBindBankCard,nil)];
//            self.startLoading  =NO;
            return;
        }
//        self.isNetRequestError = YES;
//        self.startLoading  =NO;
    }
}

@end
