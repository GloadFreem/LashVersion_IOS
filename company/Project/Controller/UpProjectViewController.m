//
//  UpProjectViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "UpProjectViewController.h"

#define UPPROJECTINFO @"requestuploadProjectInfo"
@interface UpProjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *email;

@end

@implementation UpProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:UPPROJECTINFO];
    
    [self setupNav];
    [self startLoadData];
    
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(50, 30);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"提交项目";
}

#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startLoadData
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_UPLOAD_PROJECTINFO postParam:dic type:0 delegate:self sel:@selector(requestUpInfo:)];
}

-(void)requestUpInfo:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data = jsonDic[@"data"];
            _telephone  =data[@"tel"];
            _email = data[@"email"];
            
            [self setModel];
        }else{
        
        }
    }
}
-(void)setModel
{
    _emailLabel.text = _email;
    _phoneLabel.text = _telephone;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    
}
- (IBAction)backBtnClick:(UIButton *)sender {
}
- (IBAction)emailBtnClick:(UIButton *)sender {
}
- (IBAction)phoneBtnClick:(UIButton *)sender {
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
