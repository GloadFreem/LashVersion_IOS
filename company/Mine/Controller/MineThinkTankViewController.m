//
//  MineThinkTankViewController.m
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineThinkTankViewController.h"
#import "MineLogoProjectBaseModel.h"
#import "ProjectListProModel.h"

#import "ProjectDetailController.h"
#import "ProjectPrepareDetailVC.h"

#import "ProjectListCell.h"
#import "ProjectNoRoadCell.h"

#import "MineProjectCenterProCell.h"
#define PROJECTCENTER @"requestProjectCenter"

@interface MineThinkTankViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, strong) NSMutableArray *commentStatusArray;
@property (nonatomic, strong) NSMutableArray *investArray;
@property (nonatomic, strong) NSMutableArray *investStatusArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MineThinkTankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    if (!_investArray) {
        _investArray = [NSMutableArray array];
    }
    if (!_commentStatusArray) {
        _commentStatusArray = [NSMutableArray array];
    }
    if (!_investStatusArray) {
        _investStatusArray = [NSMutableArray array];
    }
    _page = 0;
    
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCENTER];
    
    [self setupNav];
    
    [self createTableView];
    
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setHidden:NO];
    
    self.loadingViewFrame = self.view.frame;
    
    [self startLoadData];
    
    
}

-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_type],@"type",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    
    self.startLoading = YES;
    //    开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_PROJECT_CENTER postParam:dic type:0 delegate:self sel:@selector(requestList:)];
}

-(void)requestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            self.startLoading = NO;
            
            if (_page == 0) {
                [_investStatusArray removeAllObjects];
                [_investArray removeAllObjects];
                [_commentArray removeAllObjects];
                [_commentStatusArray removeAllObjects];
            }
            NSDictionary *dataDic = jsonDic[@"data"];
            
            
            NSArray *commentArray = [MineLogoProjectBaseModel mj_objectArrayWithKeyValuesArray:dataDic[@"comment"]];
            
            if (commentArray.count) {
                for (NSInteger i =0; i < commentArray.count; i ++) {
                    ProjectListProModel *listModel = [ProjectListProModel new];
                    MineLogoProjectBaseModel *baseModel = commentArray[i];
                    listModel.startPageImage = baseModel.startPageImage;
                    listModel.abbrevName = baseModel.abbrevName;
                    listModel.address = baseModel.address;
                    listModel.fullName = baseModel.fullName;
                    listModel.status = baseModel.financestatus.name;
                    listModel.projectId = baseModel.projectId;
                    //少一个areas数组
                    listModel.areas = [baseModel.industoryType componentsSeparatedByString:@"，"];
                    listModel.collectionCount = baseModel.collectionCount;
                    LogoRoadshows *roadshows = baseModel.roadshows[0];
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    [_commentStatusArray addObject:baseModel.financestatus.name];
                    [_commentArray addObject:listModel];
                    
                }
            }
            
           
            
            NSArray *investArray = [MineLogoProjectBaseModel mj_objectArrayWithKeyValuesArray:dataDic[@"invest"]];
//            NSLog(@"打印投资个数---%ld",(unsigned long)investArray.count);
            
            if (investArray.count) {
                for (NSInteger i =0; i < investArray.count; i ++) {
                    ProjectListProModel *listModel = [ProjectListProModel new];
                    MineLogoProjectBaseModel *baseModel = investArray[i];
                    listModel.startPageImage = baseModel.startPageImage;
                    listModel.abbrevName = baseModel.abbrevName;
                    listModel.address = baseModel.address;
                    listModel.fullName = baseModel.fullName;
                    listModel.status = baseModel.financestatus.name;
                    listModel.projectId = baseModel.projectId;
                    //少一个areas数组
                    listModel.areas = [baseModel.industoryType componentsSeparatedByString:@"，"];
                    listModel.collectionCount = baseModel.collectionCount;
                    LogoRoadshows *roadshows = baseModel.roadshows[0];
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    [_investStatusArray addObject:baseModel.financestatus.name];
                    [_investArray addObject:listModel];
//                    NSLog(@"加入数组陈宫");
                }
            }
            if (_commentArray.count <= 0 && _investArray.count <= 0) {
                self.tableView.isNone = YES;
            }else{
                self.tableView.isNone = NO;
            }
//            NSLog(@"数组个数-----%ld",(unsigned long)_investArray.count);
            [self.tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }else{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            self.startLoading = NO;
        
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }else{
        self.isNetRequestError = YES;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [self startLoadData];
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"项目中心";
}

-(void)createTableView
{
    _tableView  = [UITableViewCustomView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    //    tableView.mj_footer.hidden = YES;
    _tableView.mj_footer.automaticallyHidden = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (_commentArray.count) {
            return 40;
        }else{
            return 0.00000000001f;
        }
    }
    
    if (_investArray.count) {
        return 40;
    }
    return 0.0000000001f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *commentView = [UIView new];
        commentView.backgroundColor = colorGray;
        commentView.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
        UILabel *title = [UILabel new];
        title.text = @"点评过的项目";
        title.font = BGFont(18);
        title.textColor = color74;
        title.textAlignment = NSTextAlignmentLeft;
        [commentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(commentView.mas_bottom);
            make.top.mas_equalTo(20);
        }];
        return commentView;
    }
    
    UIView *investView = [UIView new];
    investView.backgroundColor = colorGray;
    investView.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
    UILabel *title = [UILabel new];
    title.text = @"我认投的项目";
    title.font = BGFont(18);
    title.textColor = color74;
    title.textAlignment = NSTextAlignmentLeft;
    [investView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(investView.mas_bottom);
        make.top.mas_equalTo(20);
    }];
    return investView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _commentArray.count;
    }
    return _investArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 172;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_commentStatusArray.count && _commentArray.count) {
            if ([_commentStatusArray[indexPath.row] isEqualToString:@"预选项目"]) {
                static NSString *cellId = @"ProjectNoRoadCell";
                ProjectNoRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_commentArray.count) {
                    cell.model = _commentArray[indexPath.row];
                }
                return cell;
            }
            
            static NSString * cellId = @"ProjectListCell";
            ProjectListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:nil options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_commentArray.count) {
                cell.model = _commentArray[indexPath.row];
            }
            
            return cell;
        }
    }
    if (_investArray.count && _investStatusArray.count) {
        if (_investStatusArray.count && _investArray.count) {
            if ([_investStatusArray[indexPath.row] isEqualToString:@"预选项目"]) {
                static NSString *cellId = @"ProjectNoRoadCell";
                ProjectNoRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_investArray.count) {
                    cell.model = _investArray[indexPath.row];
                }
                return cell;
            }
            
            static NSString * cellId = @"ProjectListCell";
            ProjectListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:nil options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_investArray.count) {
                cell.model = _investArray[indexPath.row];
            }
            
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ProjectListProModel *model = _commentArray[indexPath.row];
        if ([_commentStatusArray[indexPath.row] isEqualToString:@"预选项目"]) {
            ProjectPrepareDetailVC *vc = [ProjectPrepareDetailVC new];
            vc.projectId = model.projectId;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        ProjectDetailController *vc = [ProjectDetailController new];
        vc.projectId = model.projectId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1) {
        ProjectListProModel *model = _investArray[indexPath.row];
        if ([_investStatusArray[indexPath.row] isEqualToString:@"预选项目"]){
            ProjectPrepareDetailVC *vc = [ProjectPrepareDetailVC new];
            vc.projectId = model.projectId;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        ProjectDetailController *vc = [ProjectDetailController new];
        vc.projectId = model.projectId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
