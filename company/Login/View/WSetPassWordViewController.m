//
//  WSetPassWordViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "WSetPassWordViewController.h"
#define ZHUCE @"registUser"
#import "RenzhengViewController.h"

@interface WSetPassWordViewController ()
{
    UIActivityIndicatorView* activity;
}
@end

@implementation WSetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _cerfityBtn.layer.cornerRadius = 22;
    _cerfityBtn.layer.masksToBounds = YES;
    
    self.partner = [TDUtil encryKeyWithMD5:KEY action:ZHUCE];
    
}
- (IBAction)leftBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnClick:(UIButton*)sender{
    
    NSString *password = _firstTextField.text;
    NSString *passwordRepeat = _secondTextField.text;
    
    if (!password || [password isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
        return ;
    }
    if (!passwordRepeat || [passwordRepeat isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请再次输入密码"];
        return ;
    }
    if ([passwordRepeat intValue]!=[password intValue]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"两次密码输入不一致"];
        return ;
    }
    //加密
    password = [TDUtil encryptPhoneNumWithMD5:self.telephone passString:password];
    //激光推送Id
    NSString *regId = [JPUSHService registrationID];
    
     NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner, @"partner",self.telephone,@"telephone",password,@"password",self.certifyNum,@"verifyCode",self.ringCode,@"inviteCode",PLATFORM,@"platform",REGIST_TYPE,@"type",regId,@"regId",nil];
    
    //加载动画
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.cerfityBtn)/3-18, HEIGHT(self.cerfityBtn)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.cerfityBtn addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:WriteColor];
    
    //开始加载动画
    [activity startAnimating];
    NSString *serverUrl = USER_REGIST;
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestRegiste:)];
}
//注册
-(void)requestRegiste:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString* password  =self.firstTextField.text;
            password = [TDUtil encryptPhoneNumWithMD5:self.telephone passString:password];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
            //进度查看
            double delayInSeconds = 1.0;
            //__block RoadShowDetailViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //进入认证信息界面
                RenzhengViewController  * renzheng = [RenzhengViewController new];
                renzheng.identifyType = self.identifyType;
                [self.navigationController pushViewController:renzheng animated:YES];
            });
            
        }else{
            NSString* msg =[jsonDic valueForKey:@"message"];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
        }
        [activity stopAnimating];
    }
    
    //    //测试
    //    PerfectViewController * perfect =[PerfectViewController new];
    //    [self.navigationController pushViewController:perfect animated:YES];
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    [activity stopAnimating];
}

@end
