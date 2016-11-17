//
//  MyDataCompanyVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MyDataCompanyVC.h"
#import "MineViewController.h"

#define MODIFYPOSITION @"requestModifyPosition"
#define MODIFYCOMPANY @"requestModifyCompany"
@interface MyDataCompanyVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, copy) NSString *positionPartner;

@end

@implementation MyDataCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.partner = [TDUtil encryKeyWithMD5:KEY action:MODIFYCOMPANY];
    self.positionPartner = [TDUtil encryKeyWithMD5:KEY action:MODIFYPOSITION];
    
    [self setupNav];
}

#pragma mark - 初始化导航栏
-(void)setupNav
{
    _textField.placeholder = _placorText;
    
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = _titleName;
    
    UIButton *certainBtn = [UIButton new];
    [certainBtn setTitle:@"确认" forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainBtn.titleLabel.font = BGFont(12);
    certainBtn.frame = CGRectMake(0, 0, 32, 20);
    certainBtn.layer.cornerRadius = 2;
    certainBtn.layer.masksToBounds = YES;
    certainBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    certainBtn.layer.borderWidth = 0.5;
    certainBtn.backgroundColor = [UIColor clearColor];
    [certainBtn addTarget:self action:@selector(certainClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:certainBtn];
}
#pragma mark- 返回按钮
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)certainClick
{
    //有长度
    if (self.textField.text.length) {
        //返回上一页
        //刷新表格
        if ([_titleName isEqualToString:@"公司"]) {
            _datavc.companyName = self.textField.text;
            [_datavc.tableView reloadData];
            
            [self modifyCompany];
        }
        if ([_titleName isEqualToString:@"职位"]) {
            _datavc.position = self.textField.text;
            [_datavc.tableView reloadData];
            [self modifyPosition];
        }
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确信息"];
    }
}

-(void)modifyPosition
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.positionPartner,@"partner",self.textField.text,@"position", nil];
    //开始请求
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_MODIFY_POSITION) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:self.textField.text forKey:USER_STATIC_POSITION];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)modifyCompany
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.textField.text,@"name", nil];
    //开始请求
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_MODIFY_COMPANY) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:self.textField.text forKey:USER_STATIC_COMPANY_NAME];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
//    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
    }
//    NSLog(@"结束编辑");
}

-(void)dealloc
{
    [self cancleRequest];
}
@end
