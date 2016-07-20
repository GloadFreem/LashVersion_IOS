//
//  MoneyAccountVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MoneyAccountVC.h"
#import "DealBillVC.h"
#import "YeePayViewController.h"

#import "MineCardVC.h"
#import "MineAccountRechargeVC.h"
#define SIGNVERIFY @"signVerify"
#define WITHDRAW @"requestWithDraw"
@interface MoneyAccountVC ()
@property (nonatomic, copy) NSString *request;
@property (nonatomic, copy) NSString *signPartner;
@property (nonatomic, copy) NSString *withDrawPartner;
@property (nonatomic, copy) NSString *tradeCode;

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *avalable;
@property (nonatomic, copy) NSString *freezon;


@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *avalableAmount;
@property (weak, nonatomic) IBOutlet UILabel *freezonAmount;
@property (weak, nonatomic) IBOutlet UILabel *leftText;
@property (weak, nonatomic) IBOutlet UILabel *rightText;

@end

@implementation MoneyAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!self.dataDict) {
        self.dataDict = [[NSMutableDictionary alloc]init];
    }
    //获得partner
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    self.withDrawPartner = [TDUtil encryKeyWithMD5:KEY action:WITHDRAW];
    
    //自定义nav
//    [self setupNav];
    
    
}

#pragma mark ----------认证是否是易宝用户-------------
-(void)isCheckUserConfirmed
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    
    [self sign:signString sel:@selector(requestCheckUserSign:) type:1];
    
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
//        NSLog(@"返回:%@",xmlString);
    NSDictionary * xmlDic = [TDUtil convertXMLStringElementToDictory:xmlString];
    
//    NSLog(@"%@",xmlDic);
    
    if ([DICVFK(xmlDic, @"code") intValue]==101) {
        
    }else if([DICVFK(xmlDic, @"code") intValue]==1)
    {
        self.dataDict = [NSMutableDictionary dictionaryWithDictionary:xmlDic];
        _number = DICVFK(xmlDic, @"balance");
        _avalable = DICVFK(xmlDic, @"availableAmount");
        _freezon = DICVFK(xmlDic, @"freezeAmount");
        
        [self setModel];
    }
}

-(void)setModel
{
    _numLabel.text = _number;
    
    NSArray *arr1 = [_number componentsSeparatedByString:@"."];
    NSString *str1 = [TDUtil translation:arr1[0]];
    if ([str1 isEqualToString:@""]) {
        str1 = @"零元";
    }else{
        str1 = [NSString stringWithFormat:@"%@元",str1];
    }
    
    NSString *str2 = [TDUtil translationSmallSum:arr1[1]];
    if ([str2 isEqualToString:@""]) {
        
    }else{
        if ([str1 isEqualToString:@"零元"]) {
            str1 = @"";
        }
    }
    NSMutableString *nsmStr = [[NSMutableString alloc]initWithString:str1];
    [nsmStr appendString:[NSString stringWithFormat:@"%@",str2]];
    _textLabel.text = nsmStr;
    
    _avalableAmount.text = _avalable;
    
    NSArray *arr2 = [_avalable componentsSeparatedByString:@"."];
    str1 = [TDUtil translation:arr2[0]];
    if ([str1 isEqualToString:@""]) {
        str1 = @"零元";
    }else{
        str1 = [NSString stringWithFormat:@"%@元",str1];
    }
    
    str2 = [TDUtil translationSmallSum:arr2[1]];
    if ([str2 isEqualToString:@""]) {
        
    }else{
        if ([str1 isEqualToString:@"零元"]) {
            str1 = @"";
        }
    }
    nsmStr = [[NSMutableString alloc]initWithString:str1];
    [nsmStr appendString:str2];
    _leftText.text = nsmStr;
    
    
    _freezonAmount.text = _freezon;
    NSArray *arr3 = [_freezon componentsSeparatedByString:@"."];
    str1 = [TDUtil translation:arr3[0]];
    if ([str1 isEqualToString:@""]) {
        str1 = @"零元";
    }else{
        str1 = [NSString stringWithFormat:@"%@元",str1];
    }
    str2 = [TDUtil translationSmallSum:arr3[1]];
    
    if ([str2 isEqualToString:@""]) {
        
    }else{
        if ([str1 isEqualToString:@"零元"]) {
            str1 = @"";
        }
    }
    nsmStr = [[NSMutableString alloc]initWithString:str1];
    
    [nsmStr appendString:str2];
    _rightText.text = nsmStr;
}

-(void)sign:(NSString*)signString sel:(SEL)sel type:(int)type
{
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.signPartner,@"partner",signString,@"req",@"sign",@"method",@"",@"sign",STRING(@"%d", type),@"type",nil] type:0 delegate:self sel:sel];
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
            //进入银行卡
            MineCardVC *vc = [MineCardVC new];
            vc.dataDict = self.dataDict;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
            //充值
            MineAccountRechargeVC *vc =[MineAccountRechargeVC new];
            [self.navigationController pushViewController:vc animated:YES];
//            [self goRecharge];
        }
            break;
        case 2:
        {
            //交易账单
            DealBillVC *vc = [DealBillVC new];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            //资金提现
            
            [self toWithdrawConfirm];
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark-----------------提现---------------------------
-(void)toWithdrawConfirm
{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    _tradeCode =[TDUtil generateTradeNo];
    [dic setObject:@"CONFIRM" forKey:@"mode"];
    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    [dic setObject:_tradeCode forKey:@"requestNo"];
    [dic setObject:@"ios://toWithdrawConfirm:" forKey:@"callbackUrl"];
    [dic setObject:[TDUtil generateUserPlatformNo] forKey:@"platformUserNo"];
    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requesttoWithdrawSign:) type:0];
    
}

-(void)requesttoWithdrawSign:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            YeePayViewController * controller = [[YeePayViewController alloc]init];
            controller.dic = nil;
            controller.PostPramDic = dic;
            controller.title = @"提现";
            controller.titleStr = @"提现";
            controller.state = PayToWithdraw;
            controller.tradeCode = _tradeCode;
            controller.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,toWithdraw,nil)];
            [self.navigationController pushViewController:controller animated:YES];
        }else if([code intValue] == 1){
            
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self isCheckUserConfirmed];
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
