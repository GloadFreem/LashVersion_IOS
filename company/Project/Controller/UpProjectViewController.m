//
//  UpProjectViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "UpProjectViewController.h"
#import "ProjectViewController.h"
#import "JTabBarController.h"

#define UPPROJECTINFO @"requestuploadProjectInfo"
@interface UpProjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *email;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@end

@implementation UpProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:UPPROJECTINFO];
    [self setupNav];
    [self startLoadData];
    [self.emailBtn setAdjustsImageWhenHighlighted:NO];
    [self.phoneBtn setAdjustsImageWhenHighlighted:NO];
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"提交项目";
}

#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    if (_isFirstPage) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    _phoneLabel.text = @"点击图标呼叫客服";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=NO;
    
}
- (IBAction)backBtnClick:(UIButton *)sender {
}
- (IBAction)emailBtnClick:(UIButton *)sender {
    
    if (_email) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _email;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"邮箱已复制到剪切板"];
    }
    
}
- (IBAction)phoneBtnClick:(UIButton *)sender {
    if (_telephone) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_telephone]]];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self cancleRequest];
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
