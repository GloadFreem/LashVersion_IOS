//
//  MineProjectViewController.m
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineProjectViewController.h"
#import "UpProjectViewController.h"
#import "MIneProjectCommitRecordVC.h"
#import "RenzhengViewController.h"

#import "MineLogoProjectBaseModel.h"
#import "ProjectListProModel.h"

#import "ProjectDetailController.h"
#import "ProjectPrepareDetailVC.h"

#import "MineProjectCenterProCell.h"
#import "MineProjectCenterAddProjectCell.h"
#import "MineProjectCenterYuXuanCell.h"

#define COMMITRECORD @"requestProjectCommitRecords"
#define PROJECTCENTER @"requestProjectCenter"
@interface MineProjectViewController ()<UITableViewDelegate,UITableViewDataSource,MineProjectCenterYuXuanCellDelegate,MineProjectCenterProCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *recordPartner;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@end

@implementation MineProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    _page = 0;
    
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCENTER];
    self.recordPartner = [TDUtil encryKeyWithMD5:KEY action:COMMITRECORD];
    [self startLoadData];
    
    [self setupNav];
    
    [self createTableView];
    
    self.navigationController.navigationBar.translucent=NO;
    
}

-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_type],@"type",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    
//    开始请求
        [self.httpUtil getDataFromAPIWithOps:LOGO_PROJECT_CENTER postParam:dic type:0 delegate:self sel:@selector(requestList:)];
}

-(void)requestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            if (_page == 0) {
                [_dataArray removeAllObjects];
                [_statusArray removeAllObjects];
            }
            
            if ([jsonDic[@"data"] count]) {
                NSArray *dataArray =[MineLogoProjectBaseModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i =0; i < dataArray.count; i ++) {
                    MineLogoProjectBaseModel *baseModel = dataArray[i];
                    ProjectListProModel *listModel = [ProjectListProModel new];
                    listModel.startPageImage = baseModel.startPageImage;
                    listModel.abbrevName = baseModel.abbrevName;
                    listModel.address = baseModel.address;
                    listModel.fullName = baseModel.fullName;
                    listModel.status = baseModel.financestatus.name;
                    listModel.projectId  = baseModel.projectId;
                    listModel.timeLeft = baseModel.timeLeft;
                    
                    //少一个areas 数组
                    listModel.areas = [baseModel.industoryType componentsSeparatedByString:@"，"];
                    listModel.collectionCount = baseModel.collectionCount;
                    LogoRoadshows *roadshows = baseModel.roadshows[0];
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    
                    [_statusArray addObject:baseModel.financestatus.name];
                    [_dataArray addObject:listModel];
                }
            }
            
            [self.tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    }
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.frame = CGRectMake(0, 0, 80, 30);
//    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"项目中心";
}

-(void)createTableView
{
    _tableView  = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    //    _tableView.backgroundColor = [UIColor redColor];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    //    tableView.mj_footer.hidden = YES;
    _tableView.mj_footer.automaticallyHidden = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
}

#pragma mark -刷新控件
-(void)nextPage
{
    _page ++;
    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page = 0;
    
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}

-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count) {
        return _dataArray.count + 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        if (indexPath.row != _dataArray.count) {
            return 250;
        }
        return 50;
    }
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        if (indexPath.row !=_dataArray.count ) {//不是最后一个cell
            if (_statusArray.count && _dataArray.count) {
                if ([_statusArray[indexPath.row] isEqualToString:@"预选项目"]) {
                    static NSString *cellId = @"MineProjectCenterYuXuanCell";
                    MineProjectCenterYuXuanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (!cell) {
                        cell = [[MineProjectCenterYuXuanCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
                    }
                    cell.delegate = self;
                    cell.indexpath = indexPath;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = _dataArray[indexPath.row];
                    return cell;
                    
                }
                static NSString *cellId = @"MineProjectCenterProCell";
                MineProjectCenterProCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[MineProjectCenterProCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
                    
                }
                cell.delagate =self;
                cell.indexPath = indexPath;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = _dataArray[indexPath.row];
                return cell;
            }
            
        }
        
        static NSString *cellId = @"MineProjectCenterAddProjectCell";
        MineProjectCenterAddProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellId = @"MineProjectCenterAddProjectCell";
    MineProjectCenterAddProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataArray.count) {
        if (indexPath.row == _dataArray.count) {//进入提交项目界面
            
            UpProjectViewController *up = [UpProjectViewController new];
            
            [self.navigationController pushViewController:up animated:YES];
        }else{
            ProjectListProModel *model = _dataArray[indexPath.row];
            if ([_statusArray[indexPath.row] isEqualToString:@"预选项目"]){
                ProjectPrepareDetailVC *vc = [ProjectPrepareDetailVC new];
                vc.projectId = model.projectId;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            ProjectDetailController *vc = [ProjectDetailController new];
            vc.projectId = model.projectId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }else{
            UpProjectViewController *up = [UpProjectViewController new];
            [self.navigationController pushViewController:up animated:YES];
       
    }
}

#pragma mark---------MineProjectCenterYuXuanCellDelegate-------------
-(void)didClickRecordBtnInTheCell:(MineProjectCenterYuXuanCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    MIneProjectCommitRecordVC *vc = [MIneProjectCommitRecordVC new];
    ProjectListProModel *model = _dataArray[indexPath.row];
    vc.projectId = model.projectId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didClickDetailBtnInTheCell:(MineProjectCenterYuXuanCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    ProjectListProModel *model = _dataArray[indexPath.row];
    if ([_statusArray[indexPath.row] isEqualToString:@"预选项目"]){
        ProjectPrepareDetailVC *vc = [ProjectPrepareDetailVC new];
        vc.projectId = model.projectId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    ProjectDetailController *vc = [ProjectDetailController new];
    vc.projectId = model.projectId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark--------MineProjectCenterProCellDelegate--------------
-(void)didClickRecordBtnInCenterCell:(MineProjectCenterProCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    MIneProjectCommitRecordVC *vc = [MIneProjectCommitRecordVC new];
    ProjectListProModel *model = _dataArray[indexPath.row];
    vc.projectId = model.projectId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didClickDetailBtnInCenterCell:(MineProjectCenterProCell *)cell andIndexPath:(NSIndexPath *)indexPath
{
    ProjectListProModel *model = _dataArray[indexPath.row];
    if ([_statusArray[indexPath.row] isEqualToString:@"预选项目"]){
        ProjectPrepareDetailVC *vc = [ProjectPrepareDetailVC new];
        vc.projectId = model.projectId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    ProjectDetailController *vc = [ProjectDetailController new];
    vc.projectId = model.projectId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
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
    
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
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
