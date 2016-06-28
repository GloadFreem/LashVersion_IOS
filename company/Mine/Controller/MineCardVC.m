//
//  MineCardVC.m
//  company
//
//  Created by Eugene on 16/6/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineCardVC.h"
#define SIGNVERIFY @"signVerify"

#import "YeePayViewController.h"
#import "MineAlertView.h"
@interface MineCardVC ()<MineAlertViewDelegate>

@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic, copy) NSString *signPartner;

@property (nonatomic, strong) NSMutableDictionary *bandDic;

@property (nonatomic, strong) UIImageView *cardImage;
@property (nonatomic, strong) UILabel *bandName;
@property (nonatomic, strong) UILabel *cardNum;

@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, copy) NSString *request;
@end

@implementation MineCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获得partner
    self.signPartner = [TDUtil encryKeyWithMD5:KEY action:SIGNVERIFY];
    
    NSArray *keyArray = [NSArray arrayWithObjects:@"BOCO",@"CEB",@"SPDB",@"ABC",@"ECITIC",@"CCB",@"CMBC",@"SDB",@"PSBC",@"CMBCHINA",@"CIB",@"ICBC",@"BOC",@"BCCB",@"GDB",@"HX",@"XAYH",@"SHYH",@"TJYH",@"SZNCSYYH",@"BJNCSYYH",@"HZYH",@"KLYH",@"ZHENGZYH",@"WZYH",@"HKYH",@"NJYH",@"XMYH",@"NCYH",@"JISYH",@"HKBEA",@"CDYH",@"NBYH",@"CSYH",@"HBYH",@"GUAZYH", nil];
    NSArray *objectArray = [NSArray arrayWithObjects:@"交通银行",@"光大银行",@"上海浦东发展银行",@"农业银行",@"中信银行",@"建设银行",@"民生银行",@"平安银行",@"中国邮政储蓄",@"招商银行",@"兴业银行",@"中国工商银行",@"中国银行",@"北京银行",@"广发银行",@"华夏银行",@"西安市商业银行",@"上海银行",@"天津市商业银行",@"深圳农村商业银行",@"北京农商银行",@"杭州市商业银行",@"昆仑银行",@"郑州银行",@"温州银行",@"汉口银行",@"南京银行",@"厦门银行",@"南昌银行",@"江苏银行",@"东亚银行(中国)",@"成都银行",@"宁波银行",@"长沙银行",@"河北银行",@"广州银行", nil];
    
    _bandDic = [[NSMutableDictionary alloc]initWithObjects:objectArray forKeys:keyArray];
    
    
    
    
    [self setNav];
    //根据状态显示不同的界面
    [self createUI];
    
    
}

-(void)setNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(32, 20);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"银行卡";
}


#pragma mark--------已绑卡
-(void)createUI
{
    _cardImage = [UIImageView new];
    _cardImage.image = [UIImage imageNamed:@"icon_card_bg"];
    _cardImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_cardImage];
    _cardImage.sd_layout
    .leftSpaceToView(self.view,12)
    .topSpaceToView(self.view,12)
    .rightSpaceToView(self.view,12)
    .heightIs(230);
    
    _bandName = [UILabel new];
//    [_bandName setBackgroundColor:[UIColor redColor]];
    _bandName.textColor = [UIColor whiteColor];
    _bandName.textAlignment = NSTextAlignmentLeft;
    _bandName.font = BGFont(20);
    [_cardImage addSubview:_bandName];
    
    _bandName.sd_layout
    .leftSpaceToView(_cardImage,30)
    .topSpaceToView(_cardImage,20)
    .heightIs(20);
    [_bandName setSingleLineAutoResizeWithMaxWidth:150];
    
    _cardNum = [UILabel new];
    _cardNum.textColor = [UIColor whiteColor];
    _cardNum.textAlignment = NSTextAlignmentLeft;
    _cardNum.font = BGFont(25);
    [_cardImage addSubview:_cardNum];
    _cardNum.sd_layout
    .leftEqualToView(_bandName)
    .topSpaceToView(_cardImage,120)
    .heightIs(25);
    [_cardNum setSingleLineAutoResizeWithMaxWidth:200];
    
    
    _desc = [UILabel new];
    _desc.textColor = color74;
    _desc.font = BGFont(14);
    _desc.textAlignment = NSTextAlignmentLeft;
    _desc.text = @"温馨提示：您未绑定任何银行卡，为方便您更好的享受平台提供的投融资服务请您尽快绑定";
    [self.view addSubview:_desc];
    
    _btn = [UIButton new];
    [self.view addSubview:_btn];
    
    if ([self.dataDict[@"cardStatus"] isEqualToString:@"VERIFIED"]) {
        NSString *bandName = self.dataDict[@"bank"];
        _bandName.text = [_bandDic valueForKey:bandName];
        [_bandName sizeToFit];
        _cardNum.text = _dataDict[@"cardNo"];
        [_cardNum sizeToFit];
        
        
        [_btn setBackgroundImage:[UIImage imageNamed:@"icon_jieCard"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(jieCard) forControlEvents:UIControlEventTouchUpInside];
        _btn.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(_cardImage,30)
        .leftEqualToView(_cardImage)
        .rightEqualToView(_cardImage)
        .heightIs(50);
        
        
        
        
        
    }else{
        _bandName.text = @"未绑定";
        _cardNum.text = @"您暂未绑定银行卡";
        
        _desc.sd_layout
        .leftSpaceToView(self.view,18)
        .rightSpaceToView(self.view,18)
        .topSpaceToView(_cardImage,21)
        .autoHeightRatio(0);
        
        [_btn setBackgroundImage:[UIImage imageNamed:@"icon_bangCard"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(bangCard) forControlEvents:UIControlEventTouchUpInside];
        
        _btn.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(_desc,32)
        .leftEqualToView(_cardImage)
        .rightEqualToView(_cardImage)
        .heightIs(50);
        
        
    }
    
}

#pragma mark----------绑定银行卡
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

-(void)bangCard
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
-(void)requestSignBindCard:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign", nil];
            YeePayViewController * controller = [[YeePayViewController alloc]init];
            controller.dic = nil;
            controller.PostPramDic = dic;
            controller.title = @"绑定银行卡";
            controller.titleStr = @"绑定银行卡";
            controller.state = PayStatusBindCard;
            controller.url = [NSURL URLWithString:STRING_3(@"%@%@",BUINESS_SERVER,toBindBankCard,nil)];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
    
}
#pragma mark----------解绑银行卡
-(void)jieCard
{
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    NSString *str = [data valueForKey:@"jiekaremind"];
    if ([str isEqualToString:@"YES"]) {
        [self unToBind];
        return;
    }
    
    NSArray *titleArray = [NSArray array];
    NSString *content = @"请先确认账户中无余额再解绑 \n是否继续";
    MineAlertView *alertView = [MineAlertView new];
    alertView.tag = 500;
    [alertView createAlertViewWithBtnTitleArray:titleArray andContent:content];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBG)];
    [alertView addGestureRecognizer:tap];
    [[self topView] addSubview:alertView];
    self.bottomView = alertView;
    alertView.delegate = self;
   
}


-(void)unToBind
{
    NSString * str = [TDUtil generateUserPlatformNo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:str forKey:@"platformUserNo"];
    //    [dic setObject:@"PLATFORM" forKey:@"feeMode"];
    
    [dic setObject:[TDUtil generateTradeNo] forKey:@"requestNo"];
    //    [dic setObject:@"ios://bindCardConfirm" forKey:@"callbackUrl"];
    //    [dic setObject:notifyUrl forKey:@"notifyUrl"];
    
    NSString * signString = [TDUtil convertDictoryToYeePayXMLString:dic];
    _request = signString;
    [self sign:signString sel:@selector(requestjieCard:) type:1];
}

-(void)requestjieCard:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * data = [jsonDic valueForKey:@"data"];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_request,@"req",[data valueForKey:@"sign"],@"sign",toUnbindBankCard,@"service", nil];
            [self.httpUtil getDataFromYeePayAPIWithOps:@"" postParam:dic type:0 delegate:self sel:@selector(requestUnbindCard:)];
            
        }
    }
}

-(void)requestUnbindCard:(ASIHTTPRequest *)request{
    NSString *xmlString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",xmlString);
    NSDictionary * xmlDic = [TDUtil convertXMLStringElementToDictory:xmlString];
    
    NSLog(@"%@",xmlDic);
    
    if ([DICVFK(xmlDic, @"code") intValue]==101) {
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        [data setValue:@"YES" forKey:@"jiekaremind"];
        
        [self dismissBG];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:DICVFK(xmlDic, @"description") delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:DICVFK(xmlDic, @"description")];
        
    }else if([DICVFK(xmlDic, @"code") intValue]==1)
    {
        [self dismissBG];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:DICVFK(xmlDic, @"description") delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:DICVFK(xmlDic, @"description")];
    }
}
-(void)sign:(NSString*)signString sel:(SEL)sel type:(int)type
{
    [self.httpUtil getDataFromAPIWithOps:YEEPAYSIGNVERIFY postParam:[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.signPartner,@"partner",signString,@"req",@"sign",@"method",@"",@"sign",STRING(@"%d", type),@"type",nil] type:0 delegate:self sel:sel];
}

-(void)didClickBtnInView:(MineAlertView *)view andIndex:(NSInteger)index
{
    if (view.tag == 500) {
        switch (index) {
            case 0:{
                [self unToBind];
            }
                break;
            case 1:{
                [self dismissBG];
            }
                break;
            default:
                break;
        }
    }
}
-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
