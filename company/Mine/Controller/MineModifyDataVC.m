//
//  MineModifyDataVC.m
//  company
//
//  Created by Eugene on 2016/9/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineModifyDataVC.h"

#define UPDATEUSERINFO @"requestUpdateUserInfoAction"
@interface MineModifyDataVC ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *textViewContent;
@property (nonatomic, copy) NSString *updatePartner;

@end

@implementation MineModifyDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.updatePartner = [TDUtil encryKeyWithMD5:KEY action:UPDATEUSERINFO];
    self.view.backgroundColor = colorGray;
    _textViewContent = self.placorText;
    [self createNav];
    [self createTextView];
}

-(void)createNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
    
    UIButton *releaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 20)];
    releaseBtn.layer.cornerRadius = 3;
    releaseBtn.layer.masksToBounds = YES;
    releaseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    releaseBtn.layer.borderWidth = 0.5;
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseBtn setTitle:@"确定" forState:UIControlStateNormal];
    releaseBtn.titleLabel.font = BGFont(15);
//    [releaseBtn setBackgroundImage:[UIImage imageNamed:@"icon_releaseBtn"] forState:UIControlStateNormal];
    
//    releaseBtn.size = releaseBtn.currentBackgroundImage.size;
    [releaseBtn addTarget:self action:@selector(certainClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn];
    
    self.navigationItem.title = self.titleText;
}

-(void)createTextView
{


        UIView *backView = [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.top.mas_equalTo(self.view.mas_top);
            make.right.mas_equalTo(self.view.mas_right);
            make.height.mas_equalTo(230*HEIGHTCONFIG);
        }];
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, SCREENWIDTH - 20, 200)];
        _textView.delegate = self;
        
        _textView.font = BGFont(15);
        _textView.textColor = color47;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.text = _textViewContent;
        _textView.scrollEnabled = YES;
        
        [backView addSubview:_textView];
    
}

#pragma mark -textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    //    [self publishClick:nil];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _textView.font= BGFont(18);
    if ([textView.text isEqualToString:_textViewContent]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _textView.font = BGFont(15);
        _textView.text = _textViewContent;
    }
    
}

-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)certainClick:(UIButton*)btn
{
    if ([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:self.placorText]) {
        
        return;
    }else{
        if ([self.titleText isEqualToString:@"个人简介"]) {
            
            [self modifyIntroduce];
            self.dataVC.introduce = self.textView.text;
            [self.dataVC.tableView reloadData];
            
        }
        
        if ([self.titleText isEqualToString:@"机构介绍"] || [self.titleText isEqualToString:@"服务领域"]) {
            [self modifyCompanyIntroduce];
            self.dataVC.companyIntroduce = self.textView.text;
            [self.dataVC.tableView reloadData];
        }

    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)modifyCompanyIntroduce
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.updatePartner,@"partner",@"",@"userIntroduce",self.textView.text,@"companyIntroduce",@"",@"areas",nil];
    [self.httpUtil getDataFromAPIWithOps:REQUEST_UPDATE_USERINFO postParam:dic type:1 delegate:self sel:@selector(requestModifyCompanyIntroduce:)];
}
-(void)requestModifyCompanyIntroduce:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!= nil) {
        NSString *status = [dic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"城市修改成功");
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:self.textView.text forKey:USER_STATIC_COMPANYINTRODUCE];
            [data synchronize];
        }else{
            //            NSLog(@"城市修改失败");
        }
    }
}
-(void)modifyIntroduce
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.updatePartner,@"partner",self.textView.text,@"userIntroduce",@"",@"companyIntroduce",@"",@"areas",nil];
    [self.httpUtil getDataFromAPIWithOps:REQUEST_UPDATE_USERINFO postParam:dic type:1 delegate:self sel:@selector(requestModifyIntroduce:)];
}

-(void)requestModifyIntroduce:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!= nil) {
        NSString *status = [dic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"城市修改成功");
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:self.textView.text forKey:USER_STATIC_INTRODUCE];
            [data synchronize];
        }else{
            //            NSLog(@"城市修改失败");
        }
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].enable = YES;
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
