//
//  HeadlineViewController.m
//  company
//
//  Created by LiLe on 16/8/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeadlineViewController.h"

#import "HeadlineDetailViewController.h"
#import "TankHeaderModel.h"
#import "HeaderBigImageCell.h"
#import "HeaderMoreImageCell.h"
#import "HeaderNoneImageCell.h"
#import "HeaderRightImageCell.h"
#import "TankSearchController.h"

@interface HeadlineViewController () <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, strong) NSMutableArray *tempArray;
/** 判断是否是第一次成功加载数据 */
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation HeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableViewCustomView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64 - 49)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPageA)];
    [self.view addSubview:_tableView];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    self.searchBar.placeholder = @"搜索";
//    self.searchBar.delegate = self;
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:self.searchBar.frame];
    [searchBtn addTarget:self action:@selector(searchView) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor clearColor];
    [self.searchBar addSubview:searchBtn];
    self.tableView.tableHeaderView = self.searchBar;
    
    //设置加载视图范围
    self.loadingViewFrame = self.tableView.frame;
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    self.nextPage = 0;
    self.isUpLoading = NO;
    _isFirst = YES;
    [self loadHeadlineData];
}

-(void)searchView
{
    TankSearchController *searchVC = [[TankSearchController alloc]init];
    searchVC.index = 2;
    searchVC.isActive = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)refreshHttp
{
    self.nextPage = 0;
    [self loadHeadlineData];
}

- (void)nextPageA
{
    self.nextPage ++;
    [self loadHeadlineData];
}

#pragma mark - table view delegate method and datasource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count) {
        TankHeaderModel *model = self.dataArr[indexPath.row];
        CGFloat height = 0.0;
        if (model.webcontenttype.typeId == 1) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderNoneImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontenttype.typeId == 2) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderRightImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontenttype.typeId == 3) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderBigImageCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (model.webcontenttype.typeId == 4) {
            height = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderMoreImageCell class] contentViewWidth:[self cellContentViewWith]];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArr.count) {
        TankHeaderModel *model = self.dataArr[indexPath.row];
        if (model.webcontenttype.typeId == 1) {
            static NSString *cellId=@"HeaderNoneImageCell";
            
            HeaderNoneImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderNoneImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.headerModel = model;
            return cell;
        }
        if (model.webcontenttype.typeId == 2) {
            static NSString *cellId=@"HeaderRightImageCell";
            
            HeaderRightImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderRightImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.headerModel = model;
            return cell;
        }
        if (model.webcontenttype.typeId == 3) {
            static NSString *cellId=@"HeaderBigImageCell";
            
            HeaderBigImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderBigImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.headerModel = model;
            return cell;
        }
        if (model.webcontenttype.typeId == 4) {
            static NSString *cellId=@"HeaderMoreImageCell";
            
            HeaderMoreImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
            
            if(cell==nil){
                
                cell=[[HeaderMoreImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                
            }
            cell.headerModel = model;
            return cell;
        }

    }
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TankHeaderModel *model = self.dataArr[indexPath.row];
    HeadlineDetailViewController *headlineDetailVc = [[HeadlineDetailViewController alloc] init];
    headlineDetailVc.url = model.url;
    headlineDetailVc.image = model.image;
    headlineDetailVc.titleText = model.title;
    headlineDetailVc.contentText = model.contenttype.name;
    [self.navigationController pushViewController:headlineDetailVc animated:YES];
}

#pragma mark - barButton method
// 返回上一vc
- (void)backHome:(UIViewController *)mySelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)loadHeadlineData
{
    if (_isFirst) {
        self.startLoading = YES;
    }
    NSString *partner = [TDUtil encryKeyWithMD5:KEY action:@"requestConsultList"];
    NSDictionary *paramsDic = @{@"key":KEY,
                                @"partner": partner,
                                @"page":[NSString stringWithFormat:@"%ld", (long)_nextPage],
                                @"version":@"1"};
    // 初始化Manager
    AFHTTPRequestOperationManager *netManager = [AFHTTPRequestOperationManager manager];
    netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    __weak typeof(self) weakSelf = self;
    [netManager POST:JZT_URL(@"requestConsultList.action") parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
//        NSLog(@"今日投条请求成功====%@", dic);
        if ([dic[@"status"] intValue]== 200) {
                        if (self.nextPage == 0) {
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
    }];
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(void)analysisThinkTankListData:(NSArray *)dataArray
{
    NSDictionary *modelDic;
    TankHeaderModel *model;
    for (NSInteger i =0; i < dataArray.count; i++) {
        modelDic = dataArray[i];
        model = [TankHeaderModel mj_objectWithKeyValues:modelDic];
        [_tempArray addObject:model];
    }
    self.dataArr = _tempArray;
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    self->_dataArr = dataArr;
    if (dataArr.count > 0) {
        self.tableView.isNone = NO;
    }else{
        self.tableView.isNone = YES;
    }
    [self.tableView reloadData];
}

#pragma mark--- 是否开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    if (searchBar == self.searchBar) {
//        if ([searchBar.text isEqualToString:@"\n"]) {
//            [self.searchBar resignFirstResponder];
//            return NO;
//        }
//    }
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
    }
}
#pragma mark---  取消按钮点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        [self.searchBar resignFirstResponder];
        self.searchBar.text = @"";
        self.searchBar.showsCancelButton = NO;
        
    }
}
#pragma mark--- 搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        NSLog(@"开始搜索");
        [self.searchBar resignFirstResponder];
        [self searchBarShouldBeginEditing:self.searchBar];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
@end
