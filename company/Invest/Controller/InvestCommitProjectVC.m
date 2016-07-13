//
//  InvestCommitProjectVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestCommitProjectVC.h"
#import "InvestCommitProjectReasonCell.h"
#import "InvestCommitProjectPersonCell.h"
#import "InvestCommitProjectPCell.h"
#import "UpProjectViewController.h"

#import "ProjectListProBaseModel.h"
#import "ProjectListProModel.h"

#define PROJECTCENTER @"requestProjectCenter"
#define PROJECTCOMMIT @"requestProjectCommit"
@interface InvestCommitProjectVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSString *projectPartner;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *certainBtn;    //

@property (nonatomic, copy) NSString *textViewStr;

@end

@implementation InvestCommitProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //获得partner
    self.projectPartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCENTER];
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCOMMIT];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [self startLoadData];
    
    [self setUpNavBar];
    
    [self createTableView];
    
}

-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.projectPartner,@"partner",@"0",@"type",@"0",@"page",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_PROJECT_CENTER postParam:dic type:0 delegate:self sel:@selector(requestProject:)];
}
-(void)requestProject:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//     NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSArray *dataArray = [Project mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            if (dataArray.count) {
                for (NSInteger i = 0; i < dataArray.count; i ++) {
                    ProjectListProModel *listModel = [ProjectListProModel new];
                    Project *project = dataArray[i];
                    listModel.startPageImage = project.startPageImage;
                    listModel.abbrevName = project.abbrevName;
                    listModel.address = project.address;
                    listModel.fullName = project.fullName;
                    listModel.status = project.financestatus.name;
                    listModel.projectId = project.projectId;
                    listModel.desc = project.desc;
                    listModel.timeLeft = project.timeLeft;
                    //少一个areas 数组
                    
                    listModel.collectionCount = project.collectionCount;
                    Roadshows *roadshows = project.roadshows[0];
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    [_dataArray addObject:listModel];
                    //                NSLog(@"--打印数组--%@",listModel);
                }
                
            }else{
            
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有上传项目，请先上传项目！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
            [_tableView reloadData];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UpProjectViewController *vc = [UpProjectViewController new];
        vc.isFirstPage = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark- 设置导航栏
-(void)setUpNavBar
{
    
    self.view.backgroundColor = colorGray;
//    self.navigationItem.title = @"个人资料";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
    
    UIButton * serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn.tag = 1;
    [serviceBtn setImage:[UIImage imageNamed:@"iconfont_kefu.png"] forState:UIControlStateNormal];
    serviceBtn.size = CGSizeMake(45, 30);
    [serviceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:serviceBtn];
    
}

#pragma mark -初始化tableView
-(void)createTableView
{
    _tableView = [UITableView new];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(505);
    }];
    
    _certainBtn = [UIButton new];
    _certainBtn.tag = 2;
    _certainBtn.layer.cornerRadius = 5;
    _certainBtn.layer.masksToBounds = YES;
    
    _certainBtn.backgroundColor = colorBlue;
    [_certainBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certainBtn.titleLabel.font = BGFont(23);
    [_certainBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_certainBtn];
    
    [_certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).offset(18);
        make.centerX.mas_equalTo(_tableView.mas_centerX);
        make.width.mas_equalTo(300*WIDTHCONFIG);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark- btnClick
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1) {
        NSLog(@"呼叫客服");
        
        
    }
    if (btn.tag == 2) {
        if (self.textViewStr && self.textViewStr.length >= 20) {
            ProjectListProModel *listModel = _dataArray[0];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)listModel.projectId],@"projectId",self.textViewStr,@"content",[NSString stringWithFormat:@"%@",self.model.userId],@"userId", nil];
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_COMMIT postParam:dic type:0 delegate:self sel:@selector(requestUpProject:)];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入20字以上推荐理由"];
        }
    }
}
-(void)requestUpProject:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //改变提交的状态
            NSInteger index = [_viewController.investPersonArray indexOfObject:_model];
            _model.commited = YES;
            [_viewController.investPersonArray replaceObjectAtIndex:index withObject:_model];
            [_viewController.investPersonTableView reloadData];
            
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        //延迟2秒
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count) {
        return 3;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 105;
    }
    if (indexPath.row == 2) {
        if (_dataArray.count) {
            return 200;
        }else{
            return 0.000000001f;
        }
    }
    return 200;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellId= @"InvestCommitProjectPersonCell";
        InvestCommitProjectPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        cell.model = self.model;
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *cellId = @"InvestCommitProjectReasonCell";
        InvestCommitProjectReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        cell.textView.delegate = self;
        return cell;
    }
    
    static NSString *cellId = @"InvestCommitProjectPCell";
    InvestCommitProjectPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
    }
    if (_dataArray.count) {
        cell.model = _dataArray[0];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
//    NSLog(@"开始比按钮及");
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    self.textViewStr = textView.text;
//    NSLog(@"结束编辑");
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
@end
