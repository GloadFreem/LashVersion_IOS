//
//  AppSetModifyPasswordVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "AppSetModifyPasswordVC.h"
#define LOGOMODIFYPASSWORD @"requestModifyPassword"
@interface AppSetModifyPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *oldTextField;

@property (weak, nonatomic) IBOutlet UITextField *firstNewField;
@property (weak, nonatomic) IBOutlet UITextField *secondNewField;
@property (weak, nonatomic) IBOutlet UIButton *certainBtn;
@property (nonatomic, copy) NSString *phoneNumber;

@end

@implementation AppSetModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:LOGOMODIFYPASSWORD];
    
    //拿到手机号码
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _phoneNumber = [data objectForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    
    [self setup];
    
    
    
}

#pragma mark -设置导航栏
-(void)setup
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"修改登录密码";
    
    _certainBtn.layer.cornerRadius = 5;
    _certainBtn.layer.masksToBounds = YES;
}
#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -提交修改
- (IBAction)certainBtnClick:(UIButton *)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        //初始化网络请求对象
        //获取数据
        NSString *oldPassword = self.oldTextField.text;
        NSString *firstPassword = self.firstNewField.text;
        NSString *secondPassword = self.secondNewField.text;
        
        if (!oldPassword || [oldPassword isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入旧密码"];
            return;
        }
        if (!firstPassword || [firstPassword isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入新密码"];
            return;
        }
        if (!secondPassword || [secondPassword isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请再次输入新密码"];
            return;
        }
        if (![firstPassword isEqualToString:secondPassword]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"新密码输入不一致"];
            return;
        }
        
        //加密
        oldPassword = [TDUtil encryptPhoneNumWithMD5:_phoneNumber passString:oldPassword];
        firstPassword =[TDUtil encryptPhoneNumWithMD5:_phoneNumber passString:firstPassword];

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",oldPassword,@"passwordOld",firstPassword,@"passwordNew", nil];
        
        [self.httpUtil getDataFromAPIWithOps:MODIFYPASSWORD postParam:dic type:0 delegate:self sel:@selector(requestModify:)];
        
//        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",phoneNumber,@"telephone",_password,@"password",PLATFORM,@"platform", nil];
//        
//        //加载动画
//        //加载动画控件
//        if (!activity) {
//            //进度
//            activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.loginBtn)/3-18, HEIGHT(self.loginBtn)/2-15, 30, 30)];//指定进度轮的大小
//            [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
//            [self.loginBtn addSubview:activity];
//        }else{
//            if (!activity.isAnimating) {
//                [activity startAnimating];
//            }
//        }
//        [activity setColor:WriteColor];
//        
//        //开始加载动画
//        [activity startAnimating];
//        
//        //开始请求
//        [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
    }

}

-(void)requestModify:(ASIHTTPRequest *)request{
    
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200){
        
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString *password = [TDUtil encryptPhoneNumWithMD5:self.phoneNumber passString:self.firstNewField.text];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
@end
