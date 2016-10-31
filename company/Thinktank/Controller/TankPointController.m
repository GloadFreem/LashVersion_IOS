//
//  TankPointController.m
//  company
//
//  Created by Eugene on 2016/10/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankPointController.h"
#import "HeaderBigImageCell.h"
#import "HeaderNoneImageCell.h"
#import "HeaderMoreImageCell.h"
#import "HeaderRightImageCell.h"
#import "AFNetworking.h"
#import "TankPointModel.h"
#import "ProjectBannerDetailVC.h"
#import "TankSearchController.h"

#define REQUESTLIST @"requestViewPointList"

@interface TankPointController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isFirst;


@property (nonatomic, copy) NSString *listPartner;
@property (nonatomic, copy) NSString *searchPartner;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) TankPointModel *currentModel;

@end

@implementation TankPointController

-(void)createTableView
{
    UITableViewCustomView *tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64 - 49)];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    //设置刷新控件
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [self.tableView.mj_header beginRefreshing];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    _tableView = tableView;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
//    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:self.searchBar.frame];
    [searchBtn addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor clearColor];
    [self.searchBar addSubview:searchBtn];
    
    self.tableView.tableHeaderView = self.searchBar;
    
//    TankSearchResultController *result = [[TankSearchResultController alloc]init];
//    result.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    self.searchController = [[UISearchController alloc]initWithSearchResultsController:result];
//    self.searchController.searchBar.frame= CGRectMake(0, 0, SCREENWIDTH, 44);
//    self.searchController.searchBar.placeholder = @"搜索";
//    self.searchController.searchBar.delegate = self;
//    self.tableView.tableHeaderView = self.searchController.searchBar;
//    self.definesPresentationContext = YES;
    
}

-(void)searchView
{
    TankSearchController *searchVC = [[TankSearchController alloc]init];
    searchVC.index = 3;
    searchVC.isActive = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

-(void)refreshHttp
{
    _page = 0;
    [self loadListData];
}
-(void)nextPage
{
    _page ++;
    [self loadListData];
}


-(void)loadListData
{
    if (_isFirst) {
        self.startLoading = YES;
    }
    
    NSDictionary *para = @{@"key":@"jinzht_server_security", @"partner":@"requestViewPointList",@"page":STRING(@"%ld", (long)_page)};
    
    // 初始化Manager
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *netManager = [AFHTTPRequestOperationManager manager];
    netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [netManager POST:JZT_URL(REQUEST_POINT_LIST) parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
//        NSLog(@"请求成功====%@", dic);
        if ([dic[@"status"] intValue]== 200) {
            if (self.page == 0) {
                [_tempArray removeAllObjects];
            }
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            [self analysisThinkTankListData:dataArray];
            if (_isFirst) {
                _isFirst = NO;
            }
        } else {
            
        }
        weakSelf.startLoading = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weakSelf.isNetRequestError  =YES;
//        NSLog(@"错误信息%@", error);
    }];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(void)refresh
{
    [self loadListData];
}
-(void)analysisThinkTankListData:(NSArray *)dataArray
{
    NSDictionary *modelDic;
    TankPointModel *model;
    for (NSInteger i =0; i < dataArray.count; i++) {
        modelDic = dataArray[i];
        model = [TankPointModel mj_objectWithKeyValues:modelDic];
        [_tempArray addObject:model];
    }
    self.dataSourceArray = _tempArray;
}

-(void)setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    self->_dataSourceArray = dataSourceArray;
    if (dataSourceArray.count > 0) {
        self.tableView.isNone = NO;
    }else{
        self.tableView.isNone = YES;
    }
    [self.tableView reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    _page = 0;
    _isFirst = YES;
    self.listPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTLIST];
//    self.searchPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSEARCH];
    [self createTableView];
    self.loadingViewFrame = self.tableView.frame;
    
    [self loadListData];
    
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceArray.count) {
        TankPointModel *model = self.dataSourceArray[indexPath.row];
        CGFloat height = 0.0;
        if (model.webcontenttype.typeId == 1) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderNoneImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontenttype.typeId == 2) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderRightImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontenttype.typeId == 3) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderBigImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontenttype.typeId == 4) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderMoreImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        
        return height;
    }
    return 0;
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
    
    if (self.dataSourceArray.count) {
        _currentModel = self.dataSourceArray[indexPath.row];
        if (_currentModel.webcontenttype.typeId  == 1) {//无图
            static NSString *cellId=@"HeaderNoneImageCell";
            
            HeaderNoneImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderNoneImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.pointModel = _currentModel;
            return cell;
        }
        if (_currentModel.webcontenttype.typeId == 2) {//小图
            static NSString *cellId=@"HeaderRightImageCell";
            
            HeaderRightImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderRightImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.pointModel = _currentModel;
            return cell;
        }
        if (_currentModel.webcontenttype.typeId == 3) {//大图
            static NSString *cellId=@"HeaderBigImageCell";
            
            HeaderBigImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderBigImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.pointModel = _currentModel;
            return cell;
        }
        if (_currentModel.webcontenttype.typeId == 4) {//多图
            static NSString *cellId=@"HeaderMoreImageCell";
            
            HeaderMoreImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderMoreImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.pointModel = _currentModel;
            return cell;
        }

    }

        return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectBannerDetailVC *webDetail = [[ProjectBannerDetailVC alloc]init];
    TankPointModel *model= self.dataSourceArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@?infoId=%ld",JZT_URL(REQUEST_POINT_DETAIL),(long)model.infoId];
//    NSLog(@"网址---%@",url);
    webDetail.url = url;
    webDetail.titleStr = model.oringl;
    webDetail.titleText = model.title;
    webDetail.contentText = model.oringl;
    webDetail.isPoint = YES;
    if (model.originalImgs.count) {
        webDetail.image = model.originalImgs[0][@"url"];
    }
    [self.navigationController pushViewController:webDetail animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        NSLog(@"结束编辑");
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        NSLog(@"开始搜索");
    }
}

@end
