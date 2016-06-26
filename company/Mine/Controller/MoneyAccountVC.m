//
//  MoneyAccountVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MoneyAccountVC.h"
#import "DealBillVC.h"
#define SIGNVERIFY @"signVerify"

@interface MoneyAccountVC ()
@property (nonatomic, copy) NSString *request;
@property (nonatomic, copy) NSString *signPartner;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *avalable;
@property (nonatomic, copy) NSString *freezon;


@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *avalableAmount;
@property (weak, nonatomic) IBOutlet UILabel *freezonAmount;

@end

@implementation MoneyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得partner
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    //自定义nav
//    [self setupNav];
    
    [self isCheckUserConfirmed];
}

#pragma mark ----------认证是否是易宝用户-------------
-(void)isCheckUserConfirmed
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    
    [self sign:signString sel:@selector(requestCheckUserSign:)];
    
}
-(void)requestCheckUserSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign",ACCOUNT_INFO,@"service", nil];
            [self.httpUtil getDataFromYeePayAPIWithOps:@"" postParam:dic type:0 delegate:self sel:@selector(requestCheckUser:)];
        }
        
    }
}

-(void)requestCheckUser:(ASIHTTPRequest *)request{
    NSString *xmlString = [TDUtil convertGBKDataToUTF8String:request.responseData];
        NSLog(@"返回:%@",xmlString);
    NSDictionary * xmlDic = [TDUtil convertXMLStringElementToDictory:xmlString];
    
    NSLog(@"%@",xmlDic);
    
    if ([DICVFK(xmlDic, @"code") intValue]==101) {
        
    }else if([DICVFK(xmlDic, @"code") intValue]==1)
    {
        _number = DICVFK(xmlDic, @"balance");
        _avalable = DICVFK(xmlDic, @"availableAmount");
        _freezon = DICVFK(xmlDic, @"freezeAmount");
        
        [self setModel];
    }
}

-(void)setModel
{
    _numLabel.text = _number;
    
    
    _avalableAmount.text = _avalable;
    _freezonAmount.text = _freezon;
}

-(void)sign:(NSString*)signString sel:(SEL)sel
{
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.signPartner,@"partner",signString,@"req",@"sign",@"method",@"",@"sign",@"1",@"type",nil] type:0 delegate:self sel:sel];
}



#pragma mark -返回上一页
- (IBAction)leftClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -btnClick
- (IBAction)btnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
//            DealBillVC *vc = [DealBillVC new];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
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
#pragma mark- 自定义nav
-(void)setupNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:color(25, 177, 158, 1)];
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREENWIDTH, 20)];
    [statusBar setBackgroundColor:color(25, 177, 158, 1)];
    [self.navigationController.navigationBar addSubview:statusBar];
}

@end
