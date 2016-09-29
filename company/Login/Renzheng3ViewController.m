//
//  Renzheng3ViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "Renzheng3ViewController.h"
#import "Renzheng4ViewController.h"
#import "Renzheng2ViewController.h"
@interface Renzheng3ViewController ()<UITextViewDelegate>

{
    UIActivityIndicatorView *activity;
    NSString *_textPlaceholder;
}

@property (weak, nonatomic) IBOutlet UITextView *companyTextView;


@property (weak, nonatomic) IBOutlet UITextView *personTextView;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;

//公司介绍输入框视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyLabelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyTextViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@end

@implementation Renzheng3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#pragma mark -设置导航栏标题和下一页按钮标题
    if ([self.identifyType integerValue] == 2) {
        self.titleLabel.text = @"(2/3)";
        [self.nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
        //设置公司介绍视图高度为0
        self.topViewHeight.constant = 0;
        self.companyLabelHeight.constant = 0;
        self.companyTextViewHeight.constant = 0;
        self.bottomViewHeight.constant = 0;
    }else if ([self.identifyType integerValue] == 3){
        self.titleLabel.text = @"(3/4)";
        [self.nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
        _companyTitle.text = @"机构介绍(可选)";
        _textPlaceholder = @"写一写机构介绍";
        _companyTextView.text = _textPlaceholder;
    }else if ([self.identifyType integerValue] == 4){
        self.titleLabel.text = @"(3/3)";
        _companyTitle.text = @"服务领域(可选)";
        _textPlaceholder = @"写一写服务领域";
        _companyTextView.text = _textPlaceholder;
        [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self createUI];
}
#pragma mark- 改变button布局
-(void)createUI
{
    _nextBtn.layer.cornerRadius = 20;
    _nextBtn.layer.masksToBounds = YES;
    
}
#pragma mark -返回按钮
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -下一步按钮点击事件
- (IBAction)nextStupClick:(UIButton *)sender {
    
    [self.companyTextView resignFirstResponder];
    [self.personTextView resignFirstResponder];
    
    //判断数据  往数据字典提那家数据
    [_dicData setObject:self.companyTextView.text forKey:@"companyIntroduce"];
    [_dicData setObject:self.personTextView.text forKey:@"introduce"];
#pragma mark -投资人身份验证界面-------投资机构------------
    if ([self.identifyType integerValue] == 2 || [self.identifyType integerValue] == 3) {
        
        //进入下一页
        Renzheng4ViewController * regist =[Renzheng4ViewController new];
        regist.identifyType = self.identifyType;
        regist.dicData = [NSMutableDictionary dictionaryWithDictionary:self.dicData];
        
        [self.navigationController pushViewController:regist animated:YES];
        
    }
#pragma mark -智囊团界面 验证信息 提交 进入项目首页
    if ([self.identifyType integerValue] == 4) {
        //设置身份类型
        [_dicData setObject:self.identifyType forKey:@"identiyTypeId"];
        
        //读取图片加到图片字典 并请求数据
        //检验照片是否存在
        BOOL retA =[TDUtil checkImageExists:@"identiyCarA"];
        
        BOOL retB =[TDUtil checkImageExists:@"identiyCarB"];
        
        BOOL retC =[TDUtil checkImageExists:@"buinessLicence"];
        
        //加到上传文件字典
        if (retA && retB && retC) {
            NSDictionary *fileDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"identiyCarA",@"identiyCarA",@"identiyCarB",@"identiyCarB",@"buinessLicence",@"buinessLicence", nil];
            //加载动画
            
            //开始加载动画
            //上传文件
            self.loadingViewFrame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
            
            self.startLoading = YES;
            self.isTransparent  = YES;
            
            [self.httpUtil getDataFromAPIWithOps:AUTHENTICATE postParam:_dicData files:fileDic type:0 delegate:self sel:@selector(requestSetIdentifyType:)];

        }
    }
}
    
#pragma mark -智囊团注册身份方法

-(void)requestSetIdentifyType:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        
        if ([status integerValue] == 200) {

            self.startLoading = NO;
            //进入项目首页
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            UINavigationController *nav = (UINavigationController*)window.rootViewController;
            JTabBarController * tabBarController;
            for (UIViewController *vc in nav.childViewControllers) {
                if ([vc isKindOfClass:JTabBarController.class]) {
                    tabBarController = (JTabBarController*)vc;
                }
            }
            
            if (!tabBarController) {
                tabBarController = [CommentTD createViewControllers];
            }
            
            [self.navigationController pushViewController:tabBarController animated:NO];
        }else{
            self.startLoading = NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }
    }

}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = NO;
}

#pragma mark- textView  delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = color47;
    textView.font = BGFont(15);
}

-(void)textViewDidChange:(UITextView *)textView
{
//    if (textView.tag == 0 && ![textView.text isEqualToString:@"写一写公司介绍"]) {
//        CGFloat height = [self heightForString:textView andWidth:textView.frame.size.width];
//        if (height > _firstTextHeight.constant) {
//            _firstTextHeight.constant = height;
//        }
//    }else if (textView.tag == 1 &&![textView.text isEqualToString:@"写一写个人介绍"]){
//        CGFloat height = [self heightForString:textView andWidth:textView.frame.size.width];
//        if (height > _secondTextHeight.constant) {
//            _secondTextHeight.constant = height;
//        }
//    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 0) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = _textPlaceholder;
            textView.textColor = color74;
            self.companyTextView.text = @"";
        }else{
            self.companyTextView.text = textView.text;
        }
    }else{
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"写一写个人简介";
            textView.textColor = color74;
            self.personTextView.text = @"";
        }else{
            self.personTextView.text = textView.text;
        }
    
    }
    
    
}

#pragma mark -计算textView的高度
-(CGFloat)heightForString:(UITextView*)textView andWidth:(CGFloat)width
{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

@end

