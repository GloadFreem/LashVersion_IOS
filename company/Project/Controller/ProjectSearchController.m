//
//  ProjectSearchController.m
//  company
//
//  Created by Eugene on 2016/11/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectSearchController.h"
#import "SKTagView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ProjectTagCell.h"
#import "ProjectTagBaseModel.h"
#import "ProjectListProBaseModel.h"
#import "ProjectListProModel.h"
#import "ProjectListCell.h"
#import "ProjectNoRoadCell.h"
#import "ProjectDetailController.h"
#import "ProjectPrepareDetailVC.h"
#define REQUESTSEARCHHOTWORD @"requestHotWordList"
#define REQUESTSEARCHPROJECTSTR @"requestSearchFromStrProjectList"
#define REQUESTSEARCHPROJECTLIST @"requestSearchProjectList"
#define REQUESTPROJECTTAG @"requestSearchCondition"
@interface ProjectSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UIButton * operateBtn;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UITableViewCustomView *tagTableView;
@property (nonatomic, strong) NSMutableArray *tagViewBtnTagArray;
@property (nonatomic, strong) NSMutableArray *tagCellTitleCommitArray;
@property (nonatomic, strong) NSMutableArray *tagCellTitleArray;
@property (nonatomic, strong) NSMutableArray *tagCategoryArray;
@property (nonatomic, strong) NSMutableArray *tagCellHeightArray;
@property (nonatomic, strong) NSMutableArray *tagCommitArray;
@property (nonatomic, strong) NSMutableDictionary *selectedDic;
@property (nonatomic, strong) UITableViewCustomView *resultTableView;
@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) NSMutableArray *tempResultProArray;
@property (nonatomic, strong) NSMutableArray *searchProjectStatusArray;

@property (nonatomic, strong) UISearchBar *tagSearchBar;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIView *topSearchView;
@property (nonatomic, strong) UIView *bottomSearchView;
@property (nonatomic, strong) SKTagView *tagBtnView;
@property (nonatomic, strong) NSMutableArray *hotDataSource;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) NSString *loadTagPartner;
@property (nonatomic, copy) NSString *searchProjectPartner;
@property (nonatomic, copy) NSString *searchProjectStrPartner;
@property (nonatomic, copy) NSString *searchHotWordPartner;
@property (nonatomic, assign) NSInteger page;

@property (strong, nonatomic) UIView *gifView;
@property (strong, nonatomic) UIImageView *gifImageView;

@property (nonatomic, assign) BOOL isTagSearch;
@end

static NSString *tagCellidentity = @"ProjectTagCell";

@implementation ProjectSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    self.loadTagPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTPROJECTTAG];
    self.searchProjectPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSEARCHPROJECTLIST];
    self.searchProjectStrPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSEARCHPROJECTSTR];
    self.searchHotWordPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSEARCHHOTWORD];
    NSMutableArray *searchResultArray = [NSMutableArray array];
    self.searchResultArray = searchResultArray;
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCetainStatus) name:SHOWCERTAINNOTI object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCetainStatus) name:HIDECERTAINNOTI object:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    //结果视图
    [self setupResult];
    
    [self loadTagsData];
    //创建默认布局
    
    //下载热门词汇
    [self loadHotWord];
    
}

-(void)loadHotWord
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.searchHotWordPartner,@"partner", nil];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_SEARCH_HOTWORD) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"热刺出来啊---%@",dic);
        if ([dic[@"status"] integerValue] == 200) {
            self.hotDataSource = [NSMutableArray arrayWithArray:dic[@"data"]];
        }else{
        
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"热刺错误--%@",error.localizedDescription);
    }];
}
-(void)loadTagsData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.loadTagPartner,@"partner", nil];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_PROJECT_TAG) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSArray *data = [NSArray arrayWithArray:dic[@"data"]];
            if (data.count > 0) {
                //移除原先的数据、
                [self.tagViewBtnTagArray removeAllObjects];
                [self.tagCellTitleArray removeAllObjects];
                [self.tagCellTitleCommitArray removeAllObjects];
                NSArray *baseTagArray = [ProjectTagBaseModel mj_objectArrayWithKeyValuesArray:data];
                for (NSInteger i = 0; i < baseTagArray.count; i ++) {
                    ProjectTagBaseModel *tagBaseModel = baseTagArray[i];
                    if (tagBaseModel.cData.count > 0) {
                        [self.tagCellTitleArray addObject:tagBaseModel.cName];
                        [self.tagCellTitleCommitArray addObject:tagBaseModel.cKey];
                        NSMutableArray *tagTitleArray = [NSMutableArray array];
                        [tagTitleArray addObject:@"不限"];
                        [self.tagViewBtnTagArray addObject:[NSNumber numberWithInteger:0]];
                        for (NSInteger j = 0; j < tagBaseModel.cData.count; j ++) {
                            ProjectTagModel *tagModel = tagBaseModel.cData[j];
                            [tagTitleArray addObject:tagModel.value];
                            [self.tagViewBtnTagArray addObject:[NSNumber numberWithInteger:tagModel.itemKey]];
                        }
                        NSMutableDictionary *nsmDic = [NSMutableDictionary dictionary];
                        [nsmDic setObject:tagTitleArray forKey:@"title"];
                        [self.tagCategoryArray addObject:nsmDic];
                    }
                }
            }
            [self setupTagView];
        }else{
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)showCetainStatus
{
    _selected = YES;
    [_operateBtn setTitle:@"确定" forState:UIControlStateNormal];
    _operateBtn.enabled = YES;
}

//-(void)hideCetainStatus
//{
//    _selected = NO;
//    [_operateBtn setTitle:@"" forState:UIControlStateNormal];
//    _operateBtn.enabled = NO;
//}

-(void)setNav
{
    //返回按钮
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
    
    //编辑按钮
    UIButton * operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operateBtn.tag = 1;
    [operateBtn setTitle:@"" forState:UIControlStateNormal];
    operateBtn.enabled = YES;
    [operateBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14]];
//    [operateBtn setTitle:@"完成" forState:UIControlStateSelected];
    [operateBtn setBackgroundColor:[UIColor clearColor]];
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    operateBtn.size = CGSizeMake(36, 18);
    [operateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:operateBtn];
    _operateBtn = operateBtn;
    
    self.navigationItem.title = @"项目筛选";
}
#pragma mark--------------------标签视图----------------------
-(void)setupTagView
{
    [self.view addSubview:self.tagView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = 0.0;
        for (NSInteger i = 0; i< self.tagCellHeightArray.count; i ++) {
            height = height + [self.tagCellHeightArray[i] floatValue] + 10;
        }
//        NSLog(@"tableView高度%f",height);
        _tagTableView.contentSize = CGSizeMake(SCREENWIDTH, height);
    });
    

}
-(UIView *)tagView
{
    if (!_tagView) {
        UIView *tagView = [[UIView alloc] initWithFrame:self.view.bounds];
        tagView.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];;
        
        UITableViewCustomView *tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
        tableView.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
        tableView.tag = 1;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tagSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        //    self.searchBar.delegate = self;
        self.tagSearchBar.placeholder = @"搜索";
        self.tagSearchBar.showsCancelButton = NO;

        UIButton *searchBtn = [[UIButton alloc]initWithFrame:self.tagSearchBar.frame];
        [searchBtn addTarget:self action:@selector(setupSearch) forControlEvents:UIControlEventTouchUpInside];
        searchBtn.backgroundColor = [UIColor clearColor];
        [self.tagSearchBar addSubview:searchBtn];
        tableView.tableHeaderView = self.tagSearchBar;
        self.tagTableView = tableView;
        [tagView addSubview:self.tagTableView];
        _tagView = tagView;
    }
    return _tagView;
}

-(void)setupSearch
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.searchView];
    [self.searchBar becomeFirstResponder];
}

#pragma mark--------------------结果视图----------------------
//-(NSMutableArray *)searchResultArray
//{
//    if (!self.searchResultArray) {
//        NSMutableArray *searchResultArray = [NSMutableArray array];
//        self.searchResultArray = searchResultArray;
//    }
//    return self.searchResultArray;
//}
-(NSMutableArray *)searchProjectStatusArray
{
    if (!_searchProjectStatusArray) {
        NSMutableArray *searchProjectStatusArray = [NSMutableArray array];
        self.searchProjectStatusArray = searchProjectStatusArray;
    }
    return _searchProjectStatusArray;
}
-(NSMutableArray *)tempResultProArray
{
    if (!_tempResultProArray) {
        NSMutableArray *tempResultProArray = [NSMutableArray array];
        self.tempResultProArray = tempResultProArray;
    }
    return _tempResultProArray;
}
-(void)setupResult
{
    [self.view addSubview:self.resultTableView];
}
-(UITableViewCustomView *)resultTableView
{
    if (!_resultTableView) {
        UITableViewCustomView *tableView = [[UITableViewCustomView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
        tableView.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
        tableView.tag = 0;
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(lastPage)];
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
        tableView.isNone = NO;
        self.resultTableView = tableView;
    }
    return _resultTableView;
}
-(void)lastPage
{
    if (self.page > 0) {
        self.page --;
    }else{
        self.page = 0;
    }
    if (self.isTagSearch) {
        [self loadSearchProject];
    }else{
        [self searchProjectStrList];
    }
    
}
-(void)nextPage
{
    self.page ++;
    if (self.isTagSearch) {
        [self loadSearchProject];
    }else{
        [self searchProjectStrList];
    }
    
}
#pragma mark------------------搜索视图------------------------
-(NSMutableArray *)tagViewBtnTagArray
{
    if (!_tagViewBtnTagArray) {
        NSMutableArray *tagViewBtnTagArray = [NSMutableArray array];
        self.tagViewBtnTagArray = tagViewBtnTagArray;
    }
    return _tagViewBtnTagArray;
}
-(NSMutableArray *)tagCellTitleArray
{
    if (!_tagCellTitleArray) {
        NSMutableArray *tagCellTitleArray = [NSMutableArray array];
        self.tagCellTitleArray = tagCellTitleArray;
    }
    return _tagCellTitleArray;
}
-(NSMutableArray *)tagCellTitleCommitArray
{
    if (!_tagCellTitleCommitArray) {
        NSMutableArray *tagCellTitleCommitArray = [NSMutableArray array];
        self.tagCellTitleCommitArray = tagCellTitleCommitArray;
    }
    return _tagCellTitleCommitArray;
}
-(NSMutableArray *)tagCellHeightArray
{
    if (!_tagCellHeightArray) {
        NSMutableArray *array = [NSMutableArray array];
        self.tagCellHeightArray = array;
    }
    return _tagCellHeightArray;
}
-(NSMutableArray *)tagCommitArray
{
    if (!_tagCommitArray) {
        NSMutableArray *tagCommitArray = [NSMutableArray array];
        self.tagCommitArray = tagCommitArray;
    }
    return _tagCommitArray;
}
-(NSMutableDictionary *)selectedDic
{
    if (!_selectedDic) {
        NSMutableDictionary *selectedDic = [NSMutableDictionary dictionary];
        self.selectedDic = selectedDic;
    }
    return _selectedDic;
}
-(NSMutableArray *)tagCategoryArray
{
    if (!_tagCategoryArray) {
//        NSMutableArray *tagCategoryArray = [[NSMutableArray alloc] initWithArray:@[@{@"first":@[@"不限",@"天使轮",@"A轮",@"B轮",@"IPO"]},@{@"first":@[@"不限",@"移动互联网",@"新材料",@"节能环保",@"生物制药",@"消费服务",@"信息技术",@"新能源",@"文化传媒",@"其他"]},@{@"first":@[@"不限",@"300万以下",@"300万~500万",@"500万~2000万",@"2000万~5000万",@"5000万以上"]},@{@"first":@[@"不限",@"西安",@"北京",@"广州",@"上海",@"深圳"]}]];
        NSMutableArray *tagCategoryArray = [NSMutableArray array];
        self.tagCategoryArray = tagCategoryArray;
    }
    return _tagCategoryArray;
}

#pragma mark-----------------searchBarDelegate--------------------
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == self.searchBar) {
        searchBar.showsCancelButton = YES;
        for (UIView *view in [[[searchBar subviews] objectAtIndex:0] subviews]) {
            if ([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
                UIButton *cancle = (UIButton *)view;
                [cancle setTitle:@"取消" forState:UIControlStateNormal];
//                [cancle.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17]];
                cancle.titleLabel.font = BGFont(17);
                [cancle setTitleColor:[TDUtil colorWithHexString:@"007aff"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchBar == searchBar) {
        self.searchBar.text = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (searchBar.text.length && ![searchBar.text isEqualToString:@""]) {
            [self.searchBar resignFirstResponder];
            // self.searchBar.placeholder = self.searchBar.text;
            [self startSearch];
        }
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchBar == searchBar) {
        [_searchView removeFromSuperview];
    }
}
-(void)startSearch
{
    //检索标签
//    [self checkSelectedTag];
    self.isTagSearch = NO;
    [self createLoadingView];
    [self searchProjectStrList];
    self.page = 0;
    [self.searchResultArray removeAllObjects];
    [self.tempResultProArray removeAllObjects];
    [self.searchProjectStatusArray removeAllObjects];
    [_operateBtn setTitle:@"筛选" forState:UIControlStateNormal];
    _operateBtn.enabled = YES;
    _selected = NO;
    [self.view bringSubviewToFront:self.resultTableView];
    [_searchView removeFromSuperview];
}
-(void)searchProjectStrList
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",self.page],@"page",self.searchBar.text,@"search", nil];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_SEARCH_PROJECT_STR) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSLog(@"当前页%ld",self.page);
            self.searchBar.text = @"";
            [self.resultTableView.mj_header endRefreshing];
            [self.resultTableView.mj_footer endRefreshing];
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            if (self.page == 0) {
                [self.searchResultArray removeAllObjects];
                [self.tempResultProArray removeAllObjects];
                [self.searchProjectStatusArray removeAllObjects];
            }
            if (dataArray.count > 0) {
                [self analysisProjectListData:dataArray];
            }
        }else if ([dic[@"status"] integerValue] == 201){
            NSLog(@"没有数据");
            [self.resultTableView.mj_header endRefreshing];
            [self.resultTableView.mj_footer endRefreshingWithNoMoreData];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeLoadingView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"报错%@",error.localizedDescription);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeLoadingView];
        });
    }];
}
-(void)checkSelectedTag
{
//    self.startLoading = YES;
//    self.isTransparent = YES;
    [self createLoadingView];
    
    ProjectTagCell *tagCell;
    NSIndexPath *indexPath;
//    SKTagView *tagView;
    NSMutableArray *selectedArray = [NSMutableArray array];
//    [self.tagCommitArray removeAllObjects];
    [self.selectedDic removeAllObjects];
    [self.searchResultArray removeAllObjects];
    [self.tempResultProArray removeAllObjects];
    [self.searchProjectStatusArray removeAllObjects];
    for (NSInteger i = 0; i < self.tagCategoryArray.count; i ++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        tagCell = [self.tagTableView cellForRowAtIndexPath:indexPath];
        selectedArray = tagCell.tagView.selectedArray;
//        NSLog(@"打印数组---%@",selectedArray);
        NSMutableString *str = [NSMutableString string];
        if (selectedArray.count > 0) {
            for (NSInteger j = 0; j < selectedArray.count; j ++) {
                if (j == selectedArray.count - 1) {
                    [str appendFormat:@"%@",selectedArray[j]];
                }else{
                    [str appendFormat:@"%@,",selectedArray[j]];
                }
            }
        }
        if (str.length > 0) {
            [self.selectedDic setObject:str forKey:self.tagCellTitleCommitArray[i]];
        }else{
            [self.selectedDic setObject:@"0" forKey:self.tagCellTitleCommitArray[i]];
        }
    }
    [self loadSearchProject];
    NSLog(@"打印提交字典---%@",self.selectedDic);
}
-(void)loadSearchProject
{
    
    [self.selectedDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_SEARCH_PROJECT_LIST) parameters:self.selectedDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"%@",dic[@"status"]);
        if ([dic[@"status"] integerValue] == 200) {
            NSLog(@"当前页%ld",self.page);
            [self.resultTableView.mj_header endRefreshing];
            [self.resultTableView.mj_footer endRefreshing];
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            if (self.page == 0) {
                [self.searchResultArray removeAllObjects];
                [self.tempResultProArray removeAllObjects];
                [self.searchProjectStatusArray removeAllObjects];
            }
            if (dataArray.count > 0) {
                [self analysisProjectListData:dataArray];
            }
        }else if([dic[@"status"] integerValue] == 201) {//其他状态码
            NSLog(@"没有数据");
            [self.resultTableView.mj_header endRefreshing];
            [self.resultTableView.mj_footer endRefreshingWithNoMoreData];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeLoadingView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.isNetRequestError  =YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeLoadingView];
        });
        NSLog(@"请求错误---%@",error.localizedDescription);
    }];
}


-(void)analysisProjectListData:(NSArray*)array
{
    NSArray *dataArray = [Project mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger i =0; i < dataArray.count; i ++) {
        ProjectListProModel *listModel = [ProjectListProModel new];
        Project *project = (Project*)dataArray[i];
        listModel.startPageImage = project.startPageImage;
        listModel.abbrevName = project.abbrevName;
        listModel.address = project.address;
        listModel.fullName = project.fullName;
        listModel.status = project.financestatus.name;
        listModel.projectId = project.projectId;
        listModel.timeLeft = project.timeLeft;
        [self.searchProjectStatusArray addObject:project.financestatus.name];//加入项目类别
        listModel.areas = [project.industoryType componentsSeparatedByString:@"，"];
        listModel.collectionCount = project.collectionCount;
        if (project.roadshows.count) {
            Roadshows *roadshows = project.roadshows[0];
            listModel.financedMount = roadshows.roadshowplan.financedMount;
            listModel.financeTotal = roadshows.roadshowplan.financeTotal;
            listModel.endDate = roadshows.roadshowplan.endDate;
        }
        [self.tempResultProArray addObject:listModel];
    }
    self.searchResultArray = self.tempResultProArray;
}
-(void)setSearchResultArray:(NSMutableArray *)searchResultArray
{
    self->_searchResultArray = searchResultArray;
    if (_searchResultArray.count <= 0) {
        self.resultTableView.isNone = YES;
    }else{
        self.resultTableView.isNone = NO;
    }
    [self.resultTableView reloadData];
    
}
-(void)cancle
{
    [_searchView removeFromSuperview];
}
#pragma mark---topSearchView---
-(UIView *)topSearchView
{
    if (!_topSearchView) {
        UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
//        searchView.backgroundColor = [TDUtil colorWithHexString:@"bfc0c5"];
        searchView.backgroundColor = [UIColor whiteColor];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"请输入项目名/公司名/成员姓名";
        searchBar.backgroundColor = [UIColor clearColor];
        searchBar.backgroundImage = [UIImage new];
        UITextField *searchBarTextField = [searchBar valueForKey:@"_searchField"];
        if (searchBarTextField) {
            [searchBarTextField setBackgroundColor:color(243, 243, 243, 1)];
            searchBarTextField.borderStyle = UITextBorderStyleRoundedRect;
            searchBarTextField.layer.cornerRadius = 5.0f;
        }else{
            UIImage *image = [TDUtil createImageWithColor:color(243, 243, 243, 1) rect:CGRectMake(0, 0, 1, 1)];
            [searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
            
        }
        [searchView addSubview:searchBar];
        self.searchBar = searchBar;
        self.topSearchView = searchView;
        
    }
    return _topSearchView;
}
#pragma mark---bottomSearchView---
-(UIView *)bottomSearchView
{
    if (!_bottomSearchView) {
        UIView *bottomSearchView = [UIView new];
        bottomSearchView.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
    }
    return _bottomSearchView;
}
#pragma mark---tagBtnView---
-(SKTagView *)tagBtnView
{
    if (!_tagBtnView) {
        SKTagView *tagBtnView = [[SKTagView alloc] init];
        
        //内边距
        tagBtnView.padding = UIEdgeInsetsMake(10, 15, 10, 15);
        //行距
        tagBtnView.lineSpacing = 20;
        //边距
        tagBtnView.interitemSpacing = 5;
        //最大宽度
        tagBtnView.preferredMaxLayoutWidth = SCREENWIDTH;
        //加载数据
        [self.hotDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //初始化标签
            SKTag *tag = [[SKTag alloc] initWithText:self.hotDataSource[idx]];
            //内边距
            tag.padding = UIEdgeInsetsMake(3, 12.25, 3, 12.25);
            //弧度
            tag.cornerRadius = 3.0f;
            //字体
            tag.font = BGFont(15);
            //边框宽度
            tag.borderWidth = 0;
            //背景
            tag.bgColor = [UIColor clearColor];
            //边框颜色
            //  tag.borderColor = color(191, 191, 191, 1);
            //字体颜色
            tag.textColor = [TDUtil colorWithHexString:@"6c92ff"];
            //是否可点击
            tag.enable = YES;
            //加入到tagView
            [tagBtnView addTag:tag];
        }];
        //点击事件回调
        tagBtnView.didTapTagAtIndex = ^(NSUInteger idx){
            NSLog(@"点击了第%ld个",(unsigned long)idx);
            self.searchBar.text = self.hotDataSource[idx];
            [self startSearch];
        };
        //获取刚才加入多有tag之后的内在高度
        CGFloat tagHeight = tagBtnView.intrinsicContentSize.height;
        tagBtnView.frame = CGRectMake(0, 100, SCREENWIDTH, tagHeight);
        [tagBtnView layoutSubviews];
        self.tagBtnView = tagBtnView;
    }
    return _tagBtnView;
}

#pragma mark---热门数据---
-(NSMutableArray *)hotDataSource
{
    if (!_hotDataSource) {
        NSMutableArray *hotDataSource = [NSMutableArray array];
        self.hotDataSource = hotDataSource;
    }
    return _hotDataSource;
}

#pragma mark---searchView---
-(UIView *)searchView
{
    if (!_searchView) {
        UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 20)];
        searchView.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
        [searchView addSubview:self.topSearchView];
        
        UILabel *hotSearch = [UILabel new];
        hotSearch.text = @"热门搜索";
        hotSearch.textColor = [UIColor blackColor];
//        hotSearch.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        hotSearch.font = BGFont(15);
        hotSearch.textAlignment = NSTextAlignmentCenter;
        [searchView addSubview:hotSearch];
        [hotSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREENWIDTH);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(self.topSearchView.mas_bottom).offset(15*HEIGHTCONFIG);
        }];
        
        [searchView addSubview:self.tagBtnView];
        self.searchView = searchView;
    }
    return _searchView;
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.tagCategoryArray.count;
    }
    return self.searchResultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        CGFloat height = [_tagCellHeightArray[indexPath.row] floatValue];
//        NSLog(@"打印高度---%f",height);
        return height;
    }
    return 172;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (self.searchResultArray.count > 0) {
            if ([self.searchProjectStatusArray[indexPath.row] isEqualToString:@"融资中"]) {
                static NSString * cellId = @"ProjectListCell";
                ProjectListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:nil options:nil] lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.searchResultArray[indexPath.row]) {
                    cell.model = self.searchResultArray[indexPath.row];
                }
                return cell;
            }
            
            if ([self.searchProjectStatusArray[indexPath.row] isEqualToString:@"预选项目"]) {
                static NSString * cellId =@"ProjectNoRoadCell";
                ProjectNoRoadCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                    
                }
                if (self.searchResultArray[indexPath.row]) {
                    cell.model = self.searchResultArray[indexPath.row];
                }
                [cell.statusImage setHidden:YES];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    if (tableView.tag == 1) {
        ProjectTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellidentity];
        if (cell == nil) {
            cell = [[ProjectTagCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tagCellidentity];
        }
//        cell.backgroundColor = [UIColor redColor];
        cell.categoryLabel.text = self.tagCellTitleArray[indexPath.row];
        [self configCell:cell indexpath:indexPath];
        CGFloat height = [cell getCellHeight];
        [self.tagCellHeightArray addObject:[NSNumber numberWithFloat:height]];
        return cell;
    }
    return nil;
}

- (void)configCell:(ProjectTagCell *)cell indexpath:(NSIndexPath *)indexpath
{
    [cell.tagView removeAllTags];
    cell.tagView.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
    cell.tagView.preferredMaxLayoutWidth = SCREENWIDTH;
    cell.tagView.padding = UIEdgeInsetsMake(15, 20, 15, 20);
    cell.tagView.lineSpacing = 20;
    cell.tagView.interitemSpacing = 15;
    cell.tagView.singleLine = NO;
    // 给出两个字段，如果给的是0，那么就是变化的,如果给的不是0，那么就是固定的
    //        cell.tagView.regularWidth = 80;
    cell.tagView.regularHeight = 28;
    NSArray *arr = [self.tagCategoryArray[indexpath.row] valueForKey:@"title"];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SKTag *tag = [[SKTag alloc] initWithText:arr[idx]];
        tag.isTag = YES;
        tag.index = [self.tagViewBtnTagArray[idx] integerValue];
        tag.font = [UIFont systemFontOfSize:12];
        tag.textColor = [TDUtil colorWithHexString:@"474747"];
        tag.textSelectedColor = [UIColor whiteColor];
        tag.bgColor = [UIColor clearColor];
        tag.selectedBgColor = [TDUtil colorWithHexString:@"3e454f"];
        tag.cornerRadius = 4;
        tag.enable = YES;
        tag.borderWidth = 0.5;
        tag.borderColor = [UIColor darkTextColor];
        tag.padding = UIEdgeInsetsMake(8,12, 8, 12);
        [cell.tagView addTag:tag];
    }];
    CGFloat tagHeight = cell.tagView.intrinsicContentSize.height;
//    cell.tagView.height = tagHeight;
    cell.tagView.frame = CGRectMake(0, 40, SCREENWIDTH, tagHeight);
    cell.cellHeight = tagHeight;
    [cell.tagView layoutSubviews];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (tableView.tag) {
        case 0:{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            ProjectListProModel *model = [ProjectListProModel new];
            if ([self.searchProjectStatusArray[indexPath.row] isEqualToString:@"融资中"]) {
                
                ProjectDetailController * detail = [[ProjectDetailController alloc]init];
                model = self.searchResultArray[indexPath.row];
                detail.isPush = YES;
                detail.projectId = model.projectId;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
            if ([self.searchProjectStatusArray[indexPath.row] isEqualToString:@"预选项目"]){
                
                ProjectPrepareDetailVC *detail = [ProjectPrepareDetailVC new];
                model = self.searchResultArray[indexPath.row];
                
                detail.projectId = model.projectId;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
            break;
        case 1:{
//            _selected = YES;
//            [_operateBtn setTitle:@"确定" forState:UIControlStateNormal];
//            _operateBtn.enabled = YES;
        }
            break;
        default:
            break;
    }
}

-(void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
//            if (_selected) {
////                [self.searchResultArray removeAllObjects];
////                [self.tempResultProArray removeAllObjects];
////                [self.searchProjectStatusArray removeAllObjects];
////                [self checkSelectedTag];
//                [_operateBtn setTitle:@"筛选" forState:UIControlStateNormal];
////                _operateBtn.enabled = YES;
//                [self.view bringSubviewToFront:self.resultTableView];
//                _selected = NO;
//            }else{
                if ([_operateBtn.currentTitle isEqualToString:@"筛选"]) {
                    [_operateBtn setTitle:@"确定" forState:UIControlStateNormal];
                    _operateBtn.enabled = YES;
                    [self.view bringSubviewToFront:self.tagView];
                }else{
//                    [self.searchResultArray removeAllObjects];
//                    [self.tempResultProArray removeAllObjects];
//                    [self.searchProjectStatusArray removeAllObjects];
                    self.page = 0;
                    self.isTagSearch = YES;
                    [self checkSelectedTag];
                    [_operateBtn setTitle:@"筛选" forState:UIControlStateNormal];
                    [self.view bringSubviewToFront:self.resultTableView];
                }
                
//            }
            
        }
        default:
            break;
    }
}

#pragma mark-----创建loadingView
-(void)createLoadingView
{
    
    _gifView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
    _gifView.backgroundColor = [UIColor whiteColor];
    [self.resultTableView addSubview:_gifView];
    
    _gifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*WIDTHCONFIG, 100*WIDTHCONFIG)];
    _gifImageView.centerX = self.resultTableView.centerX;
    _gifImageView.centerY = self.resultTableView.centerY - 50*WIDTHCONFIG;
    UIImage *image = [UIImage sd_animatedGIFNamed:@"loadingView1"];
    _gifImageView.image = image;
    [self.resultTableView addSubview:_gifImageView];
    
}
#pragma mark----移除loadingView
-(void)removeLoadingView
{
    [_gifImageView removeFromSuperview];
    [_gifView removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
