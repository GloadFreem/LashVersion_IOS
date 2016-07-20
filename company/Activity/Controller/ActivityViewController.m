//
//  ActivityViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "ActivityDetailVC.h"
#import "ActivityViewModel.h"
#import "ActivityBlackCoverView.h"

#import "RenzhengViewController.h"

#define ACTIONLIST @"requestActionList"
#define ACTIONSEARCH @"requestSearchAction"
@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ActivityViewDelegate,ActivityBlackCoverViewDelegate>

@property (nonatomic,assign)id attendInstance; //回复
@property (nonatomic, assign) NSInteger page; 

@property (nonatomic, copy) NSString * actionListPartner;

@property (nonatomic, strong) ActivityBlackCoverView *blackCoverView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *searchPartner;
@property (nonatomic, assign) NSInteger searchPage;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    //初始化tableView
    [self createTableView];
    //初始化搜索框
    [self createSearchView];
    
    //生成请求partner
    self.actionListPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONLIST];
    self.searchPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONSEARCH];
    
    self.page = 0;
    self.searchPage = 0;
    //加载数据
    [self loadActionListData];
    
}

-(void)loadSearchList
{
    [SVProgressHUD show];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.searchPartner,@"partner",_textField.text,@"keyword",[NSString stringWithFormat:@"%ld",(long)_searchPage],@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_SEARCH postParam:dic type:0 delegate:self sel:@selector(requestSearchList:)];
}
-(void)requestSearchList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            NSMutableArray * array = [[NSMutableArray alloc] init];
            
            //解析
            NSDictionary *dataDic;
            ActivityViewModel * baseModel;
            for (int i=0; i<dataArray.count; i++) {
                dataDic = dataArray[i];
                baseModel = [ActivityViewModel mj_objectWithKeyValues:dataDic];
                [array addObject:baseModel];
            }
            
            //设置数据模型
            self.dataSourceArray = array;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            _isSearch = YES;
            self.textField.text = @"";
            [SVProgressHUD dismiss];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}
/**
 *  获取活动列表
 */

-(void)loadActionListData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionListPartner,@"partner",STRING(@"%ld",(long)self.page),@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_LIST postParam:dic type:0 delegate:self sel:@selector(requestActionList:)];
}

-(void)requestActionList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            NSMutableArray * array = [[NSMutableArray alloc] init];
            
            //解析
            NSDictionary *dataDic;
            ActivityViewModel * baseModel;
            for (int i=0; i<dataArray.count; i++) {
                dataDic = dataArray[i];
                baseModel = [ActivityViewModel mj_objectWithKeyValues:dataDic];
                [array addObject:baseModel];
            }
            
            //设置数据模型
            self.dataSourceArray = array;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }
}

-(void)setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    _dataSourceArray = dataSourceArray;
    if(_dataSourceArray.count>0)
    {
        //刷新数据
        [self.tableView reloadData];
    }
}

#pragma mark -初始化 tableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.backgroundColor = color(239, 239, 244, 1);
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

}

-(void)refreshHttp
{
    _isSearch = NO;
    _page = 0;
    [self loadActionListData];
}
-(void)nextPage
{
    if (_isSearch) {
        _searchPage ++;
        [self loadSearchList];
    }else{
    _page ++;
    [self loadActionListData];
    }
}

-(void)createSearchView
{
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-20, 29)];
    _textField.borderStyle = UITextBorderStyleBezel;
    
    _textField.placeholder = @"请输入关键词：活动名、地点…";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor blackColor];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.clearsOnBeginEditing = YES; //再次编辑清空
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate =self;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor colorWithRed:253/255.0 green:133/255.0 blue:0 alpha:1];
    searchBtn.frame = CGRectMake(0, 0, 49, 29);
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTag:0];
    _textField.rightView = searchBtn;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    [self.navigationItem setTitleView:_textField];
    
}
#pragma mark -tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ActivityCell";
    ActivityCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
        cell.delegate = self;
    }
    cell.model = [_dataSourceArray objectAtIndex:indexPath.row];
    [cell.expiredImage setHidden:YES];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ActivityDetailVC * vc = [ActivityDetailVC new];
    ActivityViewModel * model = [_dataSourceArray objectAtIndex:indexPath.row];
    vc.activityModel = model;
    vc.viewController = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -btnAction
-(void)searchBtnClick:(UIButton*)btn
{
    [self.textField resignFirstResponder];
    
    if (btn.tag == 0) {
        if (self.textField.text.length && ![self.textField.text isEqualToString:@""]) {
            [self loadSearchList];
//            NSLog(@"开始搜索");
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确的搜索关键字"];
        }
        
    }
}

#pragma mark- UItextField的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self loadSearchList];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
//已经开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
//已经结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        self.textField.text = textField.text;
    }
}
#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ActivityDelegate
-(void)attendAction:(id)model
{
    if ([_authenticName isEqualToString:@"已认证"])
    {
        self.attendInstance = model;
        
        ActivityBlackCoverView * attendView = [ActivityBlackCoverView instancetationActivityBlackCoverView];
        attendView.delegate = self;
        attendView.tag = 1000;
        [[UIApplication sharedApplication].windows[0] addSubview:attendView];
        [attendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _blackCoverView = attendView;
    }
    
    if ([_authenticName isEqualToString:@"认证中"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    if ([_authenticName isEqualToString:@"未认证"])
    {
        [self presentAlertView];
    }
}

-(void)presentAlertView
{
    //没有认证 提醒去认证
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有实名认证，请先实名认证" preferredStyle:UIAlertControllerStyleAlert];
    __block ActivityViewController* blockSelf = self;
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf btnCertain:nil];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)btnCertain:(id)sender
{
    RenzhengViewController  * renzheng = [RenzhengViewController new];
    renzheng.identifyType = self.identiyTypeId;
    [self.navigationController pushViewController:renzheng animated:YES];
    
}
#pragma ActivityBlackCoverViewDelegate
-(void)clickBtnInView:(ActivityBlackCoverView *)view andIndex:(NSInteger)index content:(NSString *)content
{
    if (index==0) {
        [view removeFromSuperview];
    }else{
        //确定
        [self attendActionWithContent:content];
    }
}

/**
 *  报名
 */

-(void)attendActionWithContent:(NSString*)content
{
    NSString * parthner = [TDUtil encryKeyWithMD5:KEY action:ATTEND_ACTION];
    
    ActivityViewModel * modle = (ActivityViewModel*)self.attendInstance;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",parthner,@"partner",content,@"content",STRING(@"%ld", (long)modle.actionId),@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ATTEND_ACTION postParam:dic type:0 delegate:self sel:@selector(requestAttendAction:)];
}

-(void)requestAttendAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
//            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
//            NSMutableArray * array = [[NSMutableArray alloc] init];
//            
//            //解析
//            NSDictionary *dataDic;
//            ActivityViewModel * baseModel;
//            for (int i=0; i<dataArray.count; i++) {
//                dataDic = dataArray[0];
//                baseModel = [ActivityViewModel mj_objectWithKeyValues:dataDic];
//                [array addObject:baseModel];
//            }
//            
//            //设置数据模型
//            self.dataSourceArray = array;
            
            ActivityViewModel * modle = (ActivityViewModel*)self.attendInstance;
            modle.attended = YES;
            NSInteger index = [_dataSourceArray indexOfObject:modle];
            [_dataSourceArray replaceObjectAtIndex:index withObject:modle];
            [_tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
//        UIView * view  = [self.view viewWithTag:1000];
//        if(view)
//        {
//            [view removeFromSuperview];
//        }
        
        [_blackCoverView removeFromSuperview];
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }
}

@end
