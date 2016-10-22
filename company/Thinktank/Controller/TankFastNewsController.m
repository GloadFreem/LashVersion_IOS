//
//  TankFastNewsController.m
//  company
//
//  Created by Eugene on 2016/10/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankFastNewsController.h"
#import "TankModel.h"
#import "TankNoImageCell.h"
#import "TankBigImageCell.h"
#import "TankRightImageCell.h"
#import "TankMoreImageCell.h"
#import "AFNetworking.h"
#import "ProjectBannerDetailVC.h"
#import "TankSearchController.h"
#define REQUESTLIST @"requestThinkTankList"
#define REQUESTSEARCH @"requestSearchThinkTank"

@interface TankFastNewsController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, copy) NSString *listPartner;
@property (nonatomic, copy) NSString *searchPartner;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) TankModel *currentModel;
@property (nonatomic, copy) NSString *url;

@end

@implementation TankFastNewsController


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
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.showsCancelButton = NO;
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:self.searchBar.frame];
    [searchBtn addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor clearColor];
    [self.searchBar addSubview:searchBtn];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    
}
-(void)searchView
{
    TankSearchController *searchVC = [[TankSearchController alloc]init];
    searchVC.index = 1;
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

//    NSDictionary *dic = @{@"key":@"jinzht_server_security",@"partner":self.listPartner,@"page":@"0"};
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.listPartner,@"partner",STRING(@"%ld", (long)_page),@"page", nil];

    NSString *url = @"http://192.168.5.182:8080/MyProject/messageSystem/requestThinkTankList.action";
    _url = url;
    // 初始化Manager
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *netManager = [AFHTTPRequestOperationManager manager];
    netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [netManager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
//        NSLog(@"请求成功====%@", dic);
        if ([dic[@"status"] intValue]== 200) {
                        if (self.page == 0) {
                            [_tempArray removeAllObjects];
                        }
                        NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
                        [self analysisThinkTankListData:dataArray];
                    } else {
                        
                    }
                    weakSelf.startLoading = NO;
        _isFirst = NO;
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
    TankModel *model;
    for (NSInteger i =0; i < dataArray.count; i++) {
        modelDic = dataArray[i];
        model = [TankModel mj_objectWithKeyValues:modelDic];
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
    self.searchPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSEARCH];
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
        TankModel *model = self.dataSourceArray[indexPath.row];
        CGFloat height = 0;
        if (model.webcontentType.typeId == 1) {
            height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankNoImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontentType.typeId == 2) {
            height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankRightImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontentType.typeId == 3) {
            height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankBigImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontentType.typeId == 4) {
            height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankMoreImageCell class] contentViewWidth:[self cellContentViewWith]];
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
        if (_currentModel.webcontentType.typeId  == 1) {//无图
            static NSString *cellId=@"TankNoImageCell";
            
            TankNoImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[TankNoImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.model = _currentModel;
            return cell;
        }
        if (_currentModel.webcontentType.typeId == 2) {//小图
            static NSString *cellId=@"TankRightImageCell";
            
            TankRightImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[TankRightImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.model = _currentModel;
            return cell;
        }
        if (_currentModel.webcontentType.typeId == 3) {//大图
            static NSString *cellId=@"TankBigImageCell";
            
            TankBigImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[TankBigImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.model = _currentModel;
            return cell;
        }
        if (_currentModel.webcontentType.typeId == 4) {//多图
            static NSString *cellId=@"TankMoreImageCell";
            
            TankMoreImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[TankMoreImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.model = _currentModel;
            return cell;
        }

    }
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectBannerDetailVC *webDetail = [[ProjectBannerDetailVC alloc]init];
    TankModel *model = self.dataSourceArray[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",@"http://192.168.5.182:8080/MyProject/messageSystem/requestThinkTankDetail.action",model.ID];
    webDetail.url = url;
    webDetail.titleStr = @"7x24快讯";
    webDetail.titleText = model.title;
    webDetail.contentText = model.oringl;
    if (model.images.count) {
        webDetail.image = model.images[0];
    }
    [self.navigationController pushViewController:webDetail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--- 是否开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
#pragma mark--- 开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        self.searchBar.showsCancelButton = YES;
        NSLog(@"开始编辑");
    }
}
#pragma mark--- 结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        NSLog(@"结束编辑");
//        self.searchBar.showsCancelButton = NO;
    }
}
#pragma mark---  取消按钮点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
//        [self.searchBar resignFirstResponder];
//        self.searchBar.text = @"";
//        self.searchBar.showsCancelButton = NO;
        
    }
}
#pragma mark--- 搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        NSLog(@"开始搜索");
        [self.searchBar resignFirstResponder];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.searchBar resignFirstResponder];
}



@end
