//
//  RootViewController.m
//  company
//
//  Created by Eugene on 16/6/4.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "RootViewController.h"
#import "LoginRegistViewController.h"
#define LOGINUSER @"isLoginUser"
#define DENGLU @"loginUser"
#define WELOGINUSER @"wechatLoginUser"

@interface RootViewController ()
{
    LoadingView *loadingView;
    DataBaseHelper *_dataBase;
    LoadingBlackView *loadingBlackView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化网络请求对象
    self.httpUtil  =[[HttpUtils alloc]init];
    
    //数据库工具
    _dataBase = [DataBaseHelper sharedInstance];
}

/**
 *  网络请求错误
 *
 *  @param isNetRequestError 是否网络请求错误
 */
-(void)setIsNetRequestError:(BOOL)isNetRequestError
{
    
    self->_isNetRequestError = isNetRequestError;
    if (self.isNetRequestError) {
        if (!loadingView) {
            if (self.loadingViewFrame.size.height>0) {
                loadingView =[LoadingUtil shareInstance:self.view frame:self.loadingViewFrame];
            }else{
                loadingView = [LoadingUtil shareInstance:self.view];
            }
            loadingView.delegate  =self;
        }
        loadingView.isTransparent  = NO;
        loadingView.isError = YES;
    }else{
        [LoadingUtil close:loadingView];
        loadingView.isError = NO;
        loadingView.isTransparent  = YES;
    }
}
/**
 *  设置开始加载
 *
 *  @param startLoading 加载执行标致, true:开始加载动画 false:取消加载动画
 */
-(void)setStartLoading:(BOOL)startLoading
{
    
    self->_startLoading  = startLoading;
    if (self.startLoading) {
        if (!loadingView) {
            if (self.loadingViewFrame.size.height>0) {
                loadingView =[LoadingUtil shareInstance:self.view frame:self.loadingViewFrame];
            }else{
                loadingView = [LoadingUtil shareInstance:self.view];
            }
            loadingView.delegate  =self;
        }else{
            if (self.loadingViewFrame.size.height>0) {
                [loadingView setFrame:self.loadingViewFrame];
            }
        }
        self.isNetRequestError  =NO;
        loadingView.isTransparent  = NO;
        
//        [self addBlackView];
        [LoadingUtil show:loadingView];
        
    }else{
//        [self closeBlackView];
        [LoadingUtil close:loadingView];
        
    }
    
}

/**
 *  设置全局视图是否透明
 *
 *  @param isTransparent 视图是否透明标志，true：透明显示，false：不透明
 */
-(void)setIsTransparent:(BOOL)isTransparent
{
    
    self->_isTransparent  =isTransparent;
    loadingView.isTransparent  =isTransparent;
    
}

//设置黑色背景
-(void)setIsBlack:(BOOL)isBlack
{
    self->_isBlack = isBlack;
    loadingView.isBlack = isBlack;
}
/**
 *  设置加载视图内容大小
 *
 *  @param loadingViewFrame 视图内容大小
 */
-(void)setLoadingViewFrame:(CGRect)loadingViewFrame
{
    
    self->_loadingViewFrame =loadingViewFrame;
    
}

/**
 *  设置提示消息内容
 *
 *  @param content 消息内容信息
 */
-(void)setContent:(NSString *)content
{
    
    self->_content  =content;
    if ([TDUtil isValidString:self.content]) {
        loadingView.content  = self.content;
    }
}


/**
 *  设置数据字典
 *
 *  @param dataDic 数据字典
 */
-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    
    self->_dataDic = dataDic;
    if (self.dataDic) {
        int code = [[dataDic valueForKey:@"code"] intValue];
        //设置状态码
        [self setCode:code];
    }
}


/**
 *  重新加载，刷新
 */
-(void)refresh
{
    self.startLoading = YES;
}

/**
 *  重新设置加载视图内容大小
 */
-(void)resetLoadingView
{
    [self.view bringSubviewToFront:loadingView];
}

//==============================网络请求处理开始==============================//

-(void)isOnline
{
    NSString *partner = [TDUtil encryKeyWithMD5:KEY action:LOGINUSER];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",partner,@"partner", nil];
    
    LYJWeakSelf;
    //开始请求
    [[EUNetWorkTool shareTool] POST:JZT_URL(ISLOGINUSER) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
//        NSLog(@"打印在线数据---%@",responseObject);
        if ([dic[@"status"] intValue]== 200){
            weakSelf.online = YES;
            weakSelf.loginFailed = NO;
//            NSLog(@"在线呢");
        }else{
            weakSelf.online = NO;
            [self isAutoLogin];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            weakSelf.online = NO;
            [self isAutoLogin];
//        NSLog(@"在线错误---%@",error.localizedDescription);
    }];
    
}

-(void)isAutoLogin
{
    //判断是哪种登录方式
    
    //获取缓存数据
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    NSString *password = [data valueForKey:STATIC_USER_PASSWORD];
    NSString *isWeChatLogin = [data valueForKey:IS_WECHAT_LOGIN];
    NSString *weChatID = [data valueForKey:USER_WECHAT_ID];
    //优先进行手机号登陆
    if (phoneNumber.length && password.length) {
        [self loginPhoneWithPhoneNumber:phoneNumber andPassword:password];
    }else if (isWeChatLogin.length && weChatID.length){
        [self loginWithWechatID:weChatID];
    }else{
        [self setLoginView];
    }
}
-(void)loginWithWechatID:(NSString *)weChatID
{
    NSString *regId = [JPUSHService registrationID];
    NSString *wePartner = [TDUtil encryKeyWithMD5:KEY action:WELOGINUSER];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",wePartner,@"partner",weChatID,@"wechatID",@"1",@"platform",regId,@"regid", nil];
    LYJWeakSelf;
    [[EUNetWorkTool shareTool] POST:JZT_URL(WECHATLOGINUSER) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] intValue]== 200){
            weakSelf.loginSucess = YES;
            weakSelf.loginFailed = NO;
            NSLog(@"微信登陆成功");
        }else{
            weakSelf.loginFailed = YES;
            weakSelf.loginSucess = NO;
            [self setLoginView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.loginSucess = NO;
        weakSelf.loginFailed = YES;
        [self setLoginView];
    }];
}
-(void)loginPhoneWithPhoneNumber:(NSString *)phoneNumber andPassword:(NSString *)password
{
    //激光推送Id
    NSString *regId = [JPUSHService registrationID];
    
    NSString * string = [AES encrypt:DENGLU password:KEY];
    NSString *partner = [TDUtil encryptMD5String:string];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",partner,@"partner",phoneNumber,@"telephone",password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
    LYJWeakSelf;
    [[EUNetWorkTool shareTool] POST:JZT_URL(USER_LOGIN) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"打印登录数据---%@",responseObject);
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] intValue]== 200){
            weakSelf.loginSucess = YES;
            weakSelf.loginFailed = NO;
            NSLog(@"手机登陆成功");
        }else{
            weakSelf.loginFailed = YES;
            weakSelf.loginSucess = NO;
            
            [self setLoginView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"登录错误---%@",error.localizedDescription);
        weakSelf.loginSucess = NO;
        weakSelf.loginFailed = YES;
        [self setLoginView];
    }];

}
-(void)setLoginView
{
    //进入登录界面
    LoginRegistViewController * login = [[LoginRegistViewController alloc]init];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delegate.nav = [[UINavigationController alloc] initWithRootViewController:login];
    
    delegate.window.rootViewController = delegate.nav;
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);    
    self.isNetRequestError = YES;
}
//==============================网络请求处理结束==============================//


#pragma mark--------从数据库加载数据-------------
-(NSArray*)getDataFromBaseTable:(NSString*)tableName
{
    //    NSMutableString* data = [[NSMutableString alloc] init];
    NSArray *tableArr = [_dataBase queryWithTableName:tableName];
    if (tableArr.count) {
        NSDictionary* dict = tableArr[0];
//            for(NSString* key in dict.allKeys){
//                if ([key isEqualToString:@"data"]) {
//        //            [data appendFormat:@"%@: %@   ",key,dict[key]];
//        //            NSLog(@"打印字符串---%@",data);
//        //
//        //            NSLog(@"打印字典---%@",dic);
//        
//                }
//            }
        NSMutableDictionary *dic = [dict[@"data"] JSONValue];
//        NSLog(@"打印字典---%@,打印表明---%@",dic,tableName);
        NSArray *dataArray =[NSArray arrayWithArray:dic[@"data"]];
//        NSLog(@"打印数组---%@",dataArray);
        return dataArray;
    }
    return nil;
}
-(id)getOrgazinationDataFromBaseTable:(NSString*)tableName
{
    NSArray *tableArr = [_dataBase queryWithTableName:tableName];
    if (tableArr.count) {
        NSDictionary *dict = tableArr[0];
        NSMutableDictionary *dic = [dict[@"data"] JSONValue];
        return dic[@"data"];
    }
    return nil;
}
#pragma mark-------保存数据------
-(void)saveDataToBaseTable:(NSString*)tableName data:(NSDictionary*)dic
{
    BOOL rett = [_dataBase cleanTable:tableName];
    if (rett) {
//                NSLog(@"%@清理成功",tableName);
    }else{
        //        NSLog(@"%@清理失败",tableName);
    }
    BOOL ret = [_dataBase insertIntoTableName:tableName Dict:dic];
    if (ret) {
//                NSLog(@"%@插入成功",tableName);
    }else{
        //        NSLog(@"%@插入失败",tableName);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [MobClick beginLogPageView:self.navView.title];
    
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [MobClick endLogPageView:self.navView.title];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancleRequest
{
    [self.httpUtil requestDealloc];
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
