//
//  ActivityViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityViewController.h"
//#import "ActivityCell.h"
#import "ActivityListCell.h"
#import "ActivityDetailVC.h"
#import "ActivityViewModel.h"
#import "ActivityBlackCoverView.h"
#import "ProjectBannerDetailVC.h"
#import "PingTaiWebViewController.h"

#import "RenzhengViewController.h"
#import "HeaderView.h"
#import "HeadlineViewController.h"

#define ACTIONLIST @"requestActionList"
#define ACTIONSEARCH @"requestSearchAction"
@interface ActivityViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign)id attendInstance; //回复
@property (nonatomic, assign) NSInteger page; 

@property (nonatomic, copy) NSString * actionListPartner;


@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *searchPartner;
@property (nonatomic, assign) NSInteger searchPage;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL haveData;   //是否有离线数据
@property (nonatomic, strong) NSMutableArray *tempArray;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    _isFirst = YES;
    
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    //初始化tableView
    [self createTableView];
    self.title = @"活动";
    
    //生成请求partner
    self.actionListPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONLIST];
    self.searchPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONSEARCH];
    
    self.page = 0;
    self.searchPage = 0;
    //设置加载视图范围
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -49);
    
    //加载数据
//    [self loadActionListData];
    
}


#pragma mark----------加载离线数据-----------
-(void)loadOffLineData
{
    //先从数据库加载 没有数据  则进行数据请求
    NSArray *activityArray = [self getDataFromBaseTable:ACTIVITYTABLE];
    if (activityArray.count) {
        [self analysisActivityListData:activityArray];
        _haveData = YES;
    }else{
        if ([TDUtil checkNetworkState] != NetStatusNone)
        {
            [self loadActionListData];
        }
        
    }
}
/**
 *  获取活动列表
 */

-(void)loadActionListData
{
    if (!_haveData) {
        self.startLoading = YES;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionListPartner,@"partner",STRING(@"%ld",(long)self.page),@"page", @"version", @"1",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_LIST postParam:dic type:0 delegate:self sel:@selector(requestActionList:)];
    
}

-(void)requestActionList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
            dictM[@"data"] = jsonString;
            if (_page == 0) {
                [_tempArray removeAllObjects];
                [self saveDataToBaseTable:ACTIVITYTABLE data:dictM];
                _haveData = YES;
            }
            
            //解析数据
            [self analysisActivityListData:dataArray];

        }else{

        }
        self.startLoading = NO;
    }else{
         self.isNetRequestError  =YES;
    }
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)analysisActivityListData:(NSArray*)array
{
    NSDictionary *dataDic;
    ActivityViewModel * baseModel;
    for (int i=0; i<array.count; i++) {
        dataDic = array[i];
        baseModel = [ActivityViewModel mj_objectWithKeyValues:dataDic];
        [_tempArray addObject:baseModel];
    }
    //设置数据模型
    self.dataSourceArray = _tempArray;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    if ([TDUtil checkNetworkState] != NetStatusNone){
        self.startLoading = YES;
        self.isNetRequestError = YES;
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)refresh
{
    [self loadActionListData];
}

-(void)setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    self->_dataSourceArray = dataSourceArray;
    if(_dataSourceArray.count>0)
    {
        self.tableView.isNone = NO;
    }else{
        self.tableView.isNone = YES;
    }
    //刷新数据
    [self.tableView reloadData];
}

#pragma mark -初始化 tableView
-(void)createTableView
{
    _tableView = [[UITableViewCustomView alloc]init];
    _tableView.backgroundColor = color(239, 239, 244, 1);
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
//    HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70 )];
//    _tableView.tableHeaderView = headerView;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toHeadline)];
//    [headerView addGestureRecognizer:tap];
}

- (void)toHeadline
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    [self.navigationController pushViewController:[[HeadlineViewController alloc] init] animated:YES];
}

-(void)refreshHttp
{

    _page = 0;
    [self loadActionListData];
}
-(void)nextPage
{
    _page ++;
    [self loadActionListData];
}

#pragma mark -tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175+120+10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ActivityCell";
    ActivityListCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ActivityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model = [_dataSourceArray objectAtIndex:indexPath.row];
    cell.model.isExpired = NO;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ActivityDetailVC * vc = [ActivityDetailVC new];
//    ActivityViewModel * model = [_dataSourceArray objectAtIndex:indexPath.row];
//    vc.actionId = model.actionId;
//    vc.viewController = self;
//    if(![TDUtil isArrivedTime:model.endTime])
//    {
//        vc.isExpired = YES;
//    }
//    [self.navigationController pushViewController:vc animated:YES];
    ProjectBannerDetailVC *web = [[ProjectBannerDetailVC alloc]init];
    ActivityViewModel * model = [_dataSourceArray objectAtIndex:indexPath.row];
    web.url = model.url;
    web.titleStr = @"活动详情";
    web.contentText = @"金指投活动";
    web.titleText = model.name;
    web.image = model.imgUrl;
    web.isActivity = YES;
    [self.navigationController pushViewController:web animated:YES];
}


#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.dataSourceArray.count) {
        [self loadOffLineData];
    }
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


@end
