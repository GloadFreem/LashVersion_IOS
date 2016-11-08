//
//  TankSearchController.m
//  company
//
//  Created by Eugene on 2016/10/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankSearchController.h"
#import "TankNoImageCell.h"
#import "TankBigImageCell.h"
#import "TankRightImageCell.h"
#import "TankMoreImageCell.h"

#import "HeaderBigImageCell.h"
#import "HeaderNoneImageCell.h"
#import "HeaderMoreImageCell.h"
#import "HeaderRightImageCell.h"
#import "HeadlineDetailViewController.h"
#import "ProjectBannerDetailVC.h"
@interface TankSearchController ()<UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation TankSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    _page = 0;
    _isFirst = YES;
    [self setupTableView];
    
    [self setupNav];
    [self setupSearchView];
    
    
//    [self becomeActive];
}

-(void)setupTableView
{
    UITableViewCustomView *tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [self.tableView.mj_header beginRefreshing];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    _tableView = tableView;
    self.loadingViewFrame = tableView.frame;
    
}
-(void)refreshHttp
{
    if (_page > 0) {
        _page --;
    }else{
        _page = 0;
    }
    
    if (self.searchBar.text.length && ![self.searchBar.text isEqualToString:@""]) {
        [self startSearch];
    }else{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
    
}
-(void)nextPage
{
    if (self.searchBar.text.length && ![self.searchBar.text isEqualToString:@""]) {
        _page ++;
        [self startSearch];
    }else{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }
}


-(void)setupSearchView
{
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    _searchView.backgroundColor = [TDUtil colorWithHexString:@"bfc0c5"];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(8, 0, SCREENWIDTH - 50, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.searchBar becomeFirstResponder];
    self.searchBar.showsCancelButton = NO;
    [_searchView addSubview:self.searchBar];
    UIButton *cancleBtn = [UIButton new];
    [cancleBtn setBackgroundColor:[TDUtil colorWithHexString:@"bfc0c5"]];
    [cancleBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = BGFont(16);
    [cancleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_searchView addSubview:cancleBtn];
    cancleBtn.sd_layout
    .leftSpaceToView(self.searchBar, 0)
    .centerYEqualToView(self.searchBar)
    .heightIs(44)
    .rightEqualToView(_searchView);
//    [self.view addSubview:_searchView];
//
//    self.navigationItem.titleView = _searchView;
    
}

-(void)setIsActive:(BOOL)isActive
{
    _isActive = isActive;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        self.tableView.isNone = NO;
    }
}
#pragma mark---  取消按钮点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        [self.searchBar resignFirstResponder];
        //        self.searchBar.text = @"";
        //        self.searchBar.showsCancelButton = NO;
        [self back];
         ;
//        NSLog(@"取消按钮点击");
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
        if (self.searchBar == searchBar) {
            self.searchBar.text = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (searchBar.text.length && ![searchBar.text isEqualToString:@""]) {
                [self.searchBar resignFirstResponder];
//                self.searchBar.placeholder = self.searchBar.text;
//                self.searchBar.text = @"";
                [self startSearch];
            }
        }
}

-(void)startSearch
{
    if (_page == 0) {
        
        self.startLoading = YES;
    }
    
    //http://192.168.5.182:8080/MyProject/messageSystem/requestSearchThinkTank.action?key=jinzht_server_security&partner=sdfwefwf&page=0&keyWord=10
    NSDictionary *para = @{@"key":KEY,@"partner":@"",@"page":STRING(@"%ld", (long)_page),@"keyWord":self.searchBar.text};
    NSString *str;
    if (self.index == 1) {
        str = JZT_URL(REQUEST_SEARCH_THINKTANK);
    }
    if (self.index == 2) {
        str = JZT_URL(@"requestSearchConsultList.action");
        para = @{@"key":KEY,@"partner":@"",@"page":STRING(@"%ld", (long)_page),@"keyWord":self.searchBar.text,@"version":@"1"};
    }
    if (self.index == 3) {
        str = JZT_URL(REQUEST_SEARCH_POINT);
    }
    
    // 初始化Manager
    __weak typeof(self) weakSelf = self;
    
    [[EUNetWorkTool shareTool] POST:str parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
//                        NSLog(@"请求成功====%@", dic);
        if ([dic[@"status"] intValue]== 200) {
            if (weakSelf.page == 0) {
                [_tempArray removeAllObjects];
                weakSelf.startLoading = NO;
            }
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            if (weakSelf.index == 1) {
                [self analysisFastNewsListData:dataArray];
            }
            if (weakSelf.index == 2) {
                [self analysisHeaderListData:dataArray];
            }
            if (weakSelf.index == 3) {
                [self analysisPointListData:dataArray];
            }
            
            if (weakSelf.isFirst) {
                weakSelf.isFirst = NO;
            }
            
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
        if ([dic[@"status"] intValue]== 201) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        weakSelf.startLoading = NO;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"错误信息%@", error.localizedDescription);
        weakSelf.isNetRequestError  =YES;
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark---原创
-(void)analysisPointListData:(NSArray *)dataArray
{
    NSDictionary *modelDic;
    TankPointModel *model;
    for (NSInteger i =0; i < dataArray.count; i++) {
        modelDic = dataArray[i];
        model = [TankPointModel mj_objectWithKeyValues:modelDic];
        [_tempArray addObject:model];
    }
    self.dataArray = _tempArray;
}
-(void)analysisHeaderListData:(NSArray *)dataArray
{
    NSDictionary *modelDic;
    TankHeaderModel *model;
    for (NSInteger i =0; i < dataArray.count; i++) {
        modelDic = dataArray[i];
        model = [TankHeaderModel mj_objectWithKeyValues:modelDic];
        [_tempArray addObject:model];
    }
    self.dataArray = _tempArray;
}

#pragma mark---快讯
-(void)analysisFastNewsListData:(NSArray *)dataArray
{
    NSDictionary *modelDic;
    TankModel *model;
    for (NSInteger i =0; i < dataArray.count; i++) {
        modelDic = dataArray[i];
        model = [TankModel mj_objectWithKeyValues:modelDic];
        [_tempArray addObject:model];
    }
    self.dataArray = _tempArray;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (dataArray.count > 0) {
        self.tableView.isNone = NO;
    }else{
        self.tableView.isNone = YES;
    }
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count) {
        if (self.index == 1) {
            TankModel *model = self.dataArray[indexPath.row];
            if (model.webcontentType.typeId == 1) {
                return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankNoImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontentType.typeId == 2) {
                return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankRightImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontentType.typeId == 3) {
                return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankBigImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontentType.typeId == 4) {
                return  [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TankMoreImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
        }
        
        if (self.index == 2) {
            TankHeaderModel *model = self.dataArray[indexPath.row];
            if (model.webcontenttype.typeId == 1) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderNoneImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontenttype.typeId == 2) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderRightImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontenttype.typeId == 3) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderBigImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontenttype.typeId == 4) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"headerModel" cellClass:[HeaderMoreImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
        }
        
        if (self.index == 3) {
            TankPointModel *model = self.dataArray[indexPath.row];
            if (model.webcontenttype.typeId == 1) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderNoneImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontenttype.typeId == 2) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderRightImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontenttype.typeId == 3) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderBigImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
            if (model.webcontenttype.typeId == 4) {
                return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"pointModel" cellClass:[HeaderMoreImageCell class] contentViewWidth:[self cellContentViewWith]];
            }
        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (self.dataArray.count) {
        if (self.index == 1) {
            TankModel *currentModel = self.dataArray[indexPath.row];
            if (currentModel.webcontentType.typeId  == 1) {//无图
                static NSString *cellId=@"TankNoImageCell";
                
                TankNoImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[TankNoImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.model = currentModel;
                return cell;
            }
            if (currentModel.webcontentType.typeId == 2) {//小图
                static NSString *cellId=@"TankRightImageCell";
                
                TankRightImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[TankRightImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.model = currentModel;
                return cell;
            }
            if (currentModel.webcontentType.typeId == 3) {//大图
                static NSString *cellId=@"TankBigImageCell";
                
                TankBigImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[TankBigImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.model = currentModel;
                return cell;
            }
            if (currentModel.webcontentType.typeId == 4) {//多图
                static NSString *cellId=@"TankMoreImageCell";
                
                TankMoreImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[TankMoreImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.model = currentModel;
                return cell;
            }

        }
        
        if (self.index == 2) {
            TankHeaderModel *model = self.dataArray[indexPath.row];
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
        
        if (self.index == 3) {
            TankPointModel *currentModel = self.dataArray[indexPath.row];
            if (currentModel.webcontenttype.typeId  == 1) {//无图
                static NSString *cellId=@"HeaderNoneImageCell";
                
                HeaderNoneImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[HeaderNoneImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.pointModel = currentModel;
                return cell;
            }
            if (currentModel.webcontenttype.typeId == 2) {//小图
                static NSString *cellId=@"HeaderRightImageCell";
                
                HeaderRightImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[HeaderRightImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.pointModel = currentModel;
                return cell;
            }
            if (currentModel.webcontenttype.typeId == 3) {//大图
                static NSString *cellId=@"HeaderBigImageCell";
                
                HeaderBigImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[HeaderBigImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.pointModel = currentModel;
                return cell;
            }
            if (currentModel.webcontenttype.typeId == 4) {//多图
                static NSString *cellId=@"HeaderMoreImageCell";
                
                HeaderMoreImageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
                
                if(cell==nil){
                    
                    cell=[[HeaderMoreImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:cellId];
                    
                }
                cell.pointModel = currentModel;
                return cell;
            }

        }
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.index == 1) {
        ProjectBannerDetailVC *webDetail = [[ProjectBannerDetailVC alloc]init];
        TankModel *model = self.dataArray[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@?id=%@",JZT_URL(REQUEST_THINKTANK_DETAIL),model.ID];
        webDetail.url = url;
        webDetail.titleStr = @"7x24快讯";
        webDetail.titleText = model.title;
        webDetail.contentText = model.oringl;
        if (model.images.count) {
            webDetail.image = model.images[0];
        }
        [self.navigationController pushViewController:webDetail animated:YES];
    }
    if (self.index == 2) {
        HeadlineDetailViewController *headlineDetailVc = [[HeadlineDetailViewController alloc]init];
        TankHeaderModel *model = self.dataArray[indexPath.row];
        headlineDetailVc.url = model.url;
        headlineDetailVc.image = model.image;
        headlineDetailVc.titleText = model.title;
        headlineDetailVc.contentText = model.contenttype.name;
        [self.navigationController pushViewController:headlineDetailVc animated:YES];
        
    }
    if (self.index == 3) {
        ProjectBannerDetailVC *webDetail = [[ProjectBannerDetailVC alloc]init];
        TankPointModel *model= self.dataArray[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@?infoId=%ld",JZT_URL(REQUEST_POINT_DETAIL),(long)model.infoId];
        //    NSLog(@"网址---%@",url);
        webDetail.url = url;
        webDetail.titleStr = model.oringl;
        webDetail.titleText = model.title;
        webDetail.contentText = model.oringl;
        if (model.originalImgs.count) {
            webDetail.image = model.originalImgs[0][@"url"];
        }
        [self.navigationController pushViewController:webDetail animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    
    [self.navigationController.navigationBar addSubview:_searchView];
    
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.frame = CGRectMake(0, 0, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}
-(void)back
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isActive) {
        [self.searchBar becomeFirstResponder];
//        NSLog(@"弹起");
        self.isActive = NO;
    }
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchView removeFromSuperview];
}
@end
