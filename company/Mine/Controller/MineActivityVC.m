//
//  MineActivityVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineActivityVC.h"

#import "ActivityListCell.h"

#import "ActivityDetailVC.h"

#import "ActivityViewModel.h"

#import "MineActivityListModel.h"

#import "ProjectBannerDetailVC.h"

#define LOGOACTIVITY @"requestMineAction"

@interface MineActivityVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MineActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    self.partner = [TDUtil encryKeyWithMD5:KEY action:LOGOACTIVITY];
    _page = 0;
    self.loadingViewFrame = self.view.frame;
    [self setupNav];
    [self createTableView];
    [self startLoadData];
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 2;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"我的活动";
}
#pragma mark -创建tableView
-(void)createTableView
{
    _tableView  = [UITableViewCustomView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    
    [self.view addSubview:_tableView];
    
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

-(void)startLoadData
{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    self.startLoading = YES;
    
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_ACTIVITY_LIST postParam:dic type:0 delegate:self sel:@selector(requestInvestList:)];
}

-(void)requestInvestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (_page == 0) {
        [_dataArray removeAllObjects];
    }
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            self.startLoading = NO;
            NSMutableArray *tempArray = [NSMutableArray new];
            NSArray *modelArray = [ActivityViewModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            for (NSInteger i =0; i < modelArray.count; i ++) {
                ActivityViewModel *model = modelArray[i];
                [tempArray addObject:model];
            }
            self.dataArray = tempArray;
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }else{
        self.isNetRequestError = YES;
    }
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (_dataArray.count <= 0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
    }
    [self.tableView reloadData];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityViewModel *model = [_dataArray objectAtIndex:indexPath.row];
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ActivityListCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ActivityCell";
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ActivityListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    ActivityViewModel *model = [_dataArray objectAtIndex:indexPath.row];
        if ([TDUtil isArrivedTime:model.endTime]) {
            model.isExpired = NO;
        }else{
            model.isExpired = YES;
        }
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ActivityDetailVC * vc = [ActivityDetailVC new];
//    
//    ActivityViewModel * model = [_dataArray objectAtIndex:indexPath.row];
//    vc.actionId = model.actionId;
//    
//    [self.navigationController pushViewController:vc animated:YES];
    ProjectBannerDetailVC *web = [[ProjectBannerDetailVC alloc]init];
    ActivityViewModel * model = [_dataArray objectAtIndex:indexPath.row];
    web.url = model.url;
    web.titleStr = @"活动详情";
    web.contentText = @"金指投活动";
    web.titleText = model.name;
    web.image = model.imgUrl;
    web.isActivity = YES;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark -btnAction
-(void)btnClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
