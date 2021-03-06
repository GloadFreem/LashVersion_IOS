//
//  FeedBackViewController.m
//  company
//
//  Created by Eugene on 16/6/30.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "FeedBackViewController.h"

#define FEEDBACK @"requestFeedBack"
#define CONTENT @"您遇到了什么问题  来吐槽吧"
@interface FeedBackViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.partner = [TDUtil encryKeyWithMD5:KEY action:FEEDBACK];
    
    [self setupNav];
    [self createTextView];
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"意见反馈";
    
    UIButton *commitBtn = [UIButton new];
    commitBtn.frame = CGRectMake(0, 0, 35, 20);
    commitBtn.layer.cornerRadius = 3;
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.borderWidth = 0.5;
    commitBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = BGFont(15);
    [commitBtn addTarget:self action:@selector(commitBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
}

-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commitBtn
{
    if ([_textView.text isEqualToString:@""] || [_textView.text isEqualToString:CONTENT]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"发布内容不能为空"];
        return;
    }else{
        //发布内容
//        _textView.text = nil;
        [_textView resignFirstResponder];
        [self feedBack];
    }
}

-(void)feedBack
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",_textView.text,@"content", nil];
    //开始请求
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUESTFEEDBACK) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"感谢您的宝贵意见"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self leftBack];
            });
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:error.localizedDescription];
    }];
    
}

-(void)createTextView
{
    _textView = [UITextView new];
    _textView.delegate = self;
    _textView.text = CONTENT;
    _textView.textColor = color74;
    _textView.font = BGFont(15);
    _textView.backgroundColor =[TDUtil colorWithHexString:@"F5F5F5"];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.layer.cornerRadius = 3;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = [UIColor whiteColor].CGColor;
    _textView.layer.borderWidth = 2;
    
//    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(250);
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:CONTENT]) {
        _textView.font= BGFont(15);
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _textView.font = BGFont(15);
        _textView.text = CONTENT;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].enable = YES;
}

-(void)dealloc
{
    [self cancleRequest];
}

@end
