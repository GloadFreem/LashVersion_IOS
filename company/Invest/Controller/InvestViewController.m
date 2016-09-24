//
//  InvestViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestViewController.h"
#import "AppDelegate.h"

#import "InvestPersonCell.h"
#import "InvestOrganizationCell.h"
#import "InvestOrganizationSecondCell.h"
#import "ThinkTankCell.h"

#import "InvestPersonDetailViewController.h"
#import "InvestThinkTankDetailVC.h"
#import "InvestCommitProjectVC.h"
#import "RenzhengViewController.h"
#import "PingTaiWebViewController.h"

#import "InvestBaseModel.h"
#import "InvestListModel.h"

#import "InvestOrganizationBaseModel.h"
#import "OrganizationFirstModel.h"
#import "OrganizationSecondModel.h"

#import "ThinkTankBaseModel.h"



#define defaultLineColor [UIColor blueColor]
#define selectTitleColor orangeColor
#define unselectTitleColor [UIColor blackColor]
#define titleFont [UIFont systemFontOfSize:16]

#define INVESPUBLICTLIST @"requestInvestorList"
#define INVESTLISTDETAIL @"requestInvestorDetail"
#define PROJECTCOMMIT @"requestProjectCommit"
#define INVESTORCOLLECT @"requestInvestorCollect"

@interface InvestViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,InvestPersonCellDelegate,InvestOrganizationSecondCellDelegate,ThinkTankCellDelegate>
{
    //投资人
    id  klistModel;
    id  klistCell;
    
}


@property (nonatomic,strong) NSMutableArray *btArray;           //点击切换按钮数组
@property (nonatomic,strong) UIScrollView *titleScrollView;     //切换按钮
@property (nonatomic,strong) NSArray *titleArray;              // 切换按钮名字数组
@property (nonatomic,strong) NSArray *imageArray;              //切换按钮图标
@property (nonatomic,strong) UIView *lineView;                  // 下划线视图
@property (nonatomic,strong) UIScrollView *subViewScrollView;   // 下边子滚动视图



@property (nonatomic, strong) UITableViewCustomView *investOrganizationTableView; //投资机构视图
@property (nonatomic, strong) NSMutableArray *investOrganizationArray; //投资机构模型数组

@property (nonatomic, strong) UITableViewCustomView *thinkTankTableView; //智囊团视图

@property (nonatomic, assign) NSInteger tableViewSelected; //当前显示tableView

@property (nonatomic, copy) NSString *identyType;  //身份类型
@property (nonatomic, assign) NSInteger page;  //当前页
@property (nonatomic, assign) NSInteger lastInvestPage;
@property (nonatomic, assign) NSInteger investPage;
@property (nonatomic, assign) NSInteger lastOrganizationPage;
@property (nonatomic, assign) NSInteger organizationPage;
@property (nonatomic ,assign) NSInteger lastTankPage;
@property (nonatomic, assign) NSInteger tankPage;


@property (nonatomic, copy) NSString *investorCollectPartner; //

@property (nonatomic, assign) BOOL collectSuccess;

@property (nonatomic, copy) NSString *authenticName;
@property (nonatomic, copy) NSString *identiyTypeId;


@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isSecond;
@property (nonatomic, assign) BOOL isThird;

@property (nonatomic, strong) NSMutableArray *tempInvestPersonArr;
@property (nonatomic, strong) NSMutableArray *tempInvestOrganizationArr;
@property (nonatomic, strong) NSMutableArray *tempInvestOrganizationSecondArr;
@property (nonatomic, strong) NSMutableArray *tempThinkTankArr;

@end

@implementation InvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:INVESPUBLICTLIST];
    self.investorCollectPartner = [TDUtil encryKeyWithMD5:KEY action:INVESTORCOLLECT];
    
    //加载视图大小
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -49);
    
    [self createUI];
    
//    [self startLoadData];
}

-(void)createUI
{
    self.navigationItem.title = @"投资人";
    
    //默认请求投资人列表
    _tableViewSelected =1;
    _page = 0;
    _investPage = 0;
    _organizationPage  = 0;
    _tankPage = 0;
    _lastInvestPage = 0;
    _lastOrganizationPage = 0;
    _lastTankPage = 0;
    
    _identyType = @"2";
    
    //初始化模型数组
    if (!_investPersonArray) {
        _investPersonArray = [NSMutableArray array];
    }
    if (!_investOrganizationArray) {
        _investOrganizationArray = [NSMutableArray array];
    }
    if (!_thinkTankArray) {
        _thinkTankArray = [NSMutableArray array];
    }
    if (!_investOrganizationSecondArray) {
        _investOrganizationSecondArray = [NSMutableArray array];
    }
    if (!_tempInvestPersonArr) {
        _tempInvestPersonArr = [NSMutableArray array];
    }
    if (!_tempInvestOrganizationArr) {
        _tempInvestOrganizationArr = [NSMutableArray array];
    }
    if (!_tempInvestOrganizationSecondArr) {
        _tempInvestOrganizationSecondArr = [NSMutableArray array];
    }
    if (!_tempThinkTankArr) {
        _tempThinkTankArr = [NSMutableArray array];
    }
    _titleArray = @[@" 投资人",@" 投资机构",@" 智囊团"];
    _imageArray = @[@"touziren-icon",@"iconfont-jigouT",@"iconfont-danaoT"];
    _lineColor = orangeColor;
    _type = 0;
    [self.view addSubview:self.titleScrollView];          //添加点击按钮
    [self.view addSubview:self.subViewScrollView];
    
}

-(void)loadOffLineData
{
    //先从数据库加载 没有数据  则进行数据请求
    NSArray *investPersonArray = [self getDataFromBaseTable:INVESTPERSONTABLE];
    if (investPersonArray.count) {
        [self analysisInvestPersonData:investPersonArray];
//        [self.tableView reloadData];
        _isFirst = YES;
        
        id  data = [self getOrgazinationDataFromBaseTable:INVESTORGANIZATIONTABLE];
        if (data !=nil) {
            [self analysisInvestOrganizationData:data];
            _isSecond = YES;
        }
        
        NSArray *thinkTankArray = [self getDataFromBaseTable:THINKTANKTABLE];
        if (thinkTankArray.count) {
            [self analysisThinkTankData:thinkTankArray];
            _isThird = YES;
        }
        
    }else{
        if ([TDUtil checkNetworkState] != NetStatusNone)
        {
            [self startLoadData];
        }
    }
}

#pragma mark - 开始请求数据
-(void)startLoadData
{
    //投资人
    if (_tableViewSelected == 1) {
        
        if (!_isFirst) {
            self.startLoading = YES;
            
        }
        _identyType = @"2";
        _page = _investPage;
        self.tableView =_investPersonTableView;
        
    }
    //投机机构
    if (_tableViewSelected == 2) {
        if (!_isSecond) {
            self.startLoading = YES;
        }
        _identyType = @"3";
        _page = _organizationPage;
        self.tableView = _investOrganizationTableView;
    }
    //智囊团
    if (_tableViewSelected == 3) {
        if (!_isThird) {
            self.startLoading = YES;
        }
        _identyType = @"4";
        _page = _tankPage;
        self.tableView = _thinkTankTableView;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",_identyType,@"type",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:INVEST_PUBLIC_LIST postParam:dic type:0 delegate:self sel:@selector(requestInvestList:)];
}

-(void)requestInvestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            if (jsonDic[@"data"]) {
                
                
                NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
                dictM[@"data"] = jsonString;
                
                //投资人列表
                if (_tableViewSelected == 1) {
                    
                    NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
                    
                    if (_page == 0) {
                        [_tempInvestPersonArr removeAllObjects];
                        [self saveDataToBaseTable:INVESTPERSONTABLE data:dictM];
                        _isFirst = YES;
                    }
                    [self analysisInvestPersonData:dataArray];
                    
                }
                
                //投资机构列表
                if (_tableViewSelected == 2) {
                    
                    if (_page == 0) {
                        [_tempInvestOrganizationArr removeAllObjects];
                        [_tempInvestOrganizationSecondArr removeAllObjects];
                        [self saveDataToBaseTable:INVESTORGANIZATIONTABLE data:dictM];
                        _isSecond = YES;
                    }
                    [self analysisInvestOrganizationData:jsonDic[@"data"]];
                    
                }
                
                //智囊团
                if (_tableViewSelected == 3) {
                    NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
                    if (_page == 0) {
                        [_tempThinkTankArr removeAllObjects];
                        [self saveDataToBaseTable:THINKTANKTABLE data:dictM];
                        _isThird = YES;
                    }
                    [self analysisThinkTankData:dataArray];
                }
                
//                [self.tableView reloadData];
            }
            
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

-(void)analysisInvestPersonData:(NSArray*)array
{
    NSArray *investBaseModelArray = [InvestBaseModel mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger i = 0; i < investBaseModelArray.count; i ++) {
        InvestListModel *listModel = [InvestListModel new];
        InvestBaseModel *baseModel = investBaseModelArray[i];
        listModel.headSculpture =baseModel.user.headSculpture;
        listModel.name = baseModel.user.name;
//        NSLog(@"打印名字---%@",listModel.name);
        listModel.areas = baseModel.areas;
        listModel.userId = [NSString stringWithFormat:@"%ld",(long)baseModel.user.userId];
        listModel.collectCount = baseModel.collectCount;
        listModel.collected = baseModel.collected;
        listModel.commited = baseModel.commited;
        //二级认证信息
        Authentics *authentics = baseModel.user.authentics[0];
        listModel.position = authentics.position;
        listModel.companyName = authentics.companyName;
        City *city = authentics.city;
        Province *province = city.province;
        if ([city.name isEqualToString:@"北京市"] || [city.name isEqualToString:@"上海市"] || [city.name isEqualToString:@"天津市"] || [city.name isEqualToString:@"重庆市"] || [city.name isEqualToString:@"香港"] || [city.name isEqualToString:@"澳门"] || [city.name isEqualToString:@"钓鱼岛"]) {
            listModel.companyAddress = [NSString stringWithFormat:@"%@",province.name];
        }else{
            listModel.companyAddress = [NSString stringWithFormat:@"%@ | %@",province.name,city.name];
        }
//        for (InvestListModel *model in _tempInvestPersonArr) {
//            if (![model.userId isEqualToString:listModel.userId]) {
//                
//            }
//        }
        [_tempInvestPersonArr addObject:listModel];
    }
    self.investPersonArray = _tempInvestPersonArr;
//    NSLog(@"打印当前页---%ld",(long)_page);
    [_investPersonTableView reloadData];
}
-(void)setInvestPersonArray:(NSMutableArray *)investPersonArray
{
    self->_investPersonArray = investPersonArray;
    if (_investPersonArray.count > 0) {
        _investPersonTableView.isNone = NO;
    }else{
        _investPersonTableView.isNone = YES;
    }
}
-(void)analysisInvestOrganizationData:(id)data
{
    InvestOrganizationBaseModel *baseModel =[InvestOrganizationBaseModel mj_objectWithKeyValues:data];
    
    NSArray *firstArray = [NSArray arrayWithArray:baseModel.founddations];
    for (NSInteger i= 0; i < firstArray.count;  i ++) {
        OrganizationFirstModel *model = [OrganizationFirstModel new];
        OrganizationFounddations *foundation = firstArray[i];
        model.image = foundation.image;
        model.name = foundation.name;
        model.content = foundation.content;
        model.foundationId = foundation.foundationId;
        model.url = foundation.url;
        [_tempInvestOrganizationArr addObject:model];
    }
    self.investOrganizationArray = _tempInvestOrganizationArr;
    
    NSArray *secondArray = [NSArray arrayWithArray:baseModel.investors];
    for (NSInteger i = 0; i < secondArray.count; i ++) {
        InvestListModel *model =[InvestListModel new];
        OrganizationInvestors *investor = secondArray[i];
        model.areas = investor.areas;
        model.collectCount = investor.collectCount;
        model.collected = investor.collected;
        model.commited = investor.commited;
        //二级认证信息
        OrganizationAuthentics *authentics =investor.user.authentics[0];
        model.headSculpture = investor.user.headSculpture;
        model.companyName = authentics.companyName;
        
        OrganizationCity *city = authentics.city;
        OrganizationProvince *province = city.province;
        if ([city.name isEqualToString:@"北京市"] || [city.name isEqualToString:@"上海市"] || [city.name isEqualToString:@"天津市"] || [city.name isEqualToString:@"重庆市"] || [city.name isEqualToString:@"香港"] || [city.name isEqualToString:@"澳门"] || [city.name isEqualToString:@"钓鱼岛"]) {
            model.companyAddress = [NSString stringWithFormat:@"%@",province.name];
        }else{
            model.companyAddress = [NSString stringWithFormat:@"%@ | %@",province.name,city.name];
        }
        model.userId = [NSString stringWithFormat:@"%ld",(long)investor.user.userId];
        [_tempInvestOrganizationSecondArr addObject:model];
    }
    self.investOrganizationSecondArray = _tempInvestOrganizationSecondArr;
    [_investOrganizationTableView reloadData];
}

-(void)setInvestOrganizationArray:(NSMutableArray *)investOrganizationArray
{
    self->_investOrganizationArray = investOrganizationArray;
}
-(void)setInvestOrganizationSecondArray:(NSMutableArray *)investOrganizationSecondArray
{
    self->_investOrganizationSecondArray = investOrganizationSecondArray;
    if (_investOrganizationArray.count > 0 || _investOrganizationSecondArray.count > 0) {
        _investOrganizationTableView.isNone = NO;
    }else{
        _investOrganizationTableView.isNone = YES;
    }
    
}

-(void)analysisThinkTankData:(NSArray*)array
{
    NSArray *thinkTankBaseModelArray = [ThinkTankBaseModel mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger i = 0; i < thinkTankBaseModelArray.count; i ++) {
        InvestListModel *listModel = [InvestListModel new];
        ThinkTankBaseModel *baseModel = thinkTankBaseModelArray[i];
        listModel.headSculpture =baseModel.user.headSculpture;
        listModel.name = baseModel.user.name;
        listModel.userId = [NSString stringWithFormat:@"%ld",(long)baseModel.user.userId];
        listModel.collectCount = baseModel.collectCount;
        listModel.commited = baseModel.commited;
        listModel.collected = baseModel.collected;
        //二级认证信息
        ThinkAuthentics *authentics = baseModel.user.authentics[0];
        listModel.position = authentics.position;
        listModel.companyName = authentics.companyName;
        ThinkCity *city = authentics.city;
        ThinkProvince *province = city.province;
        if ([city.name isEqualToString:@"北京市"] || [city.name isEqualToString:@"上海市"] || [city.name isEqualToString:@"天津市"] || [city.name isEqualToString:@"重庆市"] || [city.name isEqualToString:@"香港"] || [city.name isEqualToString:@"澳门"] || [city.name isEqualToString:@"钓鱼岛"]) {
            listModel.companyAddress = [NSString stringWithFormat:@"%@",province.name];
        }else{
            listModel.companyAddress = [NSString stringWithFormat:@"%@ | %@",province.name,city.name];
        }
        listModel.introduce = authentics.introduce;
        [_tempThinkTankArr addObject:listModel];
    }
    self.thinkTankArray = _tempThinkTankArr;
    [_thinkTankTableView reloadData];
}
-(void)setThinkTankArray:(NSMutableArray *)thinkTankArray
{
    self->_thinkTankArray = thinkTankArray;
    if (_thinkTankArray.count > 0) {
        _thinkTankTableView.isNone = NO;
    }else{
        _thinkTankTableView.isNone = YES;
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    if ([TDUtil checkNetworkState] != NetStatusNone)
    {
        self.startLoading = YES;
        self.isNetRequestError = YES;
    }
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)refresh
{
    [self startLoadData];
}

#pragma mark - 设置下滑条
- (void)setLineColor:(UIColor *)lineColor{
    
    _lineColor = lineColor;
    [_lineView setBackgroundColor:self.lineColor ? _lineColor : defaultLineColor];
}

#pragma mark - 初始化切换按钮
- (UIScrollView *)titleScrollView{
    
    if (!_titleScrollView) {
        
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREENWIDTH, 40)];
        _titleScrollView.contentSize = CGSizeMake(SCREENWIDTH*_titleArray.count/3, 0);
        _titleScrollView.scrollEnabled = YES;
        _titleScrollView.showsHorizontalScrollIndicator = YES;
    }
    
    for (int i = 0; i<_titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(SCREENWIDTH/3*i, 0, SCREENWIDTH/3, 40)];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [button.titleLabel setFont:titleFont];
        button.tag = i+10;
        
        i==0 ? [button setTitleColor:selectTitleColor forState:UIControlStateNormal] : [button setTitleColor: unselectTitleColor forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:button];
        [_btArray addObject:button];
    }
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_titleScrollView.frame)-0.5, SCREENWIDTH, 0.5)];
    bottomView.backgroundColor = color(224, 224, 224, 1);
    [_titleScrollView addSubview:bottomView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [_lineView setBackgroundColor:self.lineColor ? _lineColor : defaultLineColor];
    
    if (self.type == 0) {
        
        _lineView.frame = CGRectMake(0, CGRectGetHeight(_titleScrollView.frame)-2, SCREENWIDTH/3, 2);
        [_titleScrollView addSubview:_lineView];
        
    }else{
        
        _lineView.frame = CGRectMake(0, 0, 80, CGRectGetMaxX(_titleScrollView.frame));
        [_titleScrollView insertSubview:_lineView atIndex:0];
    }
    return _titleScrollView;
}


- (UIScrollView *)subViewScrollView{
    
    if (!self.tableView) {
        self.tableView = [[UITableViewCustomView alloc]init];
    }
    
    if (!_subViewScrollView) {
        _subViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT-64-49-40)];
        _subViewScrollView.backgroundColor = [UIColor greenColor];
        _subViewScrollView.showsHorizontalScrollIndicator = NO;
        _subViewScrollView.showsVerticalScrollIndicator = NO;
        _subViewScrollView.contentSize = CGSizeMake(SCREENWIDTH*_titleArray.count, 0);
        _subViewScrollView.delegate = self;
        _subViewScrollView.alwaysBounceVertical = NO;
        _subViewScrollView.pagingEnabled = YES;
        _subViewScrollView.bounces = NO;
        //方向锁
        _subViewScrollView.directionalLockEnabled = YES;
        
        //添加tableView
        _investPersonTableView = [[UITableViewCustomView alloc]init];
        [self createTableView:_investPersonTableView index:0];
        self.tableView = _investPersonTableView;
        
        _investOrganizationTableView = [[UITableViewCustomView alloc]init];
        [self createTableView:_investOrganizationTableView index:1];
        
        _thinkTankTableView = [[UITableViewCustomView alloc]init];
        [self createTableView:_thinkTankTableView index:2];
    }
    
    return _subViewScrollView;
}

#pragma mark - 按钮数组
- (NSMutableArray *)btArray{
    
    if (!_btArray) {
        
        _btArray = [NSMutableArray array];
    }
    return _btArray;
}

#pragma mark- 切换按钮的点击事件
- (void)buttonAction:(UIButton *)sender{
    
    //重置下划线位置
    [UIView animateWithDuration:0.3 animations:^{
        
        _lineView.frame = CGRectMake(sender.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
    }];
    //重置btn的颜色
    for (int i = 0; i<_titleArray.count; i++) {
        UIButton *bt = (UIButton *)[_titleScrollView viewWithTag:10+i];
        sender.tag == (10+i) ? [bt setTitleColor:selectTitleColor forState:UIControlStateNormal] : [bt setTitleColor:unselectTitleColor forState:UIControlStateNormal];
        
    }
    //设置当前选中的tableView
    _tableViewSelected = sender.tag - 10 +1;
    //子scrollView的偏移量
    _subViewScrollView.contentOffset=CGPointMake(SCREENWIDTH*(sender.tag-10), 0);
    //当没有数据才下载数据
    switch (_tableViewSelected) {
        case 1:
        {
            if (!_investPersonArray.count) {
                [self startLoadData];
            }else{
                [_investPersonTableView reloadData];
            }
            
        }
            break;
        case 2:
        {
            if (!_investOrganizationSecondArray.count && !_investOrganizationArray.count) {
                [self startLoadData];
            }else{
                [_investOrganizationTableView reloadData];
            }
        }
            break;
        case 3:
        {
            if (!_thinkTankArray.count) {
                [self startLoadData];
            }else{
                [_thinkTankTableView reloadData];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _subViewScrollView) {
        
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger index = offSetX/SCREENWIDTH;
        //当前选中tableView
        _tableViewSelected = index +1;
        
        UIButton *bt = (UIButton *)[self.view viewWithTag:(index+10)];
        _lineView.frame = CGRectMake(bt.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
        [bt setTitleColor:selectTitleColor forState:UIControlStateNormal];
        
        _titleScrollView.contentOffset = CGPointMake(index/4*SCREENWIDTH, 0);
        
        for (int i = 0; i<_titleArray.count; i++) {
            UIButton *bt = (UIButton *)[_titleScrollView viewWithTag:10+i];
            10+index == (10+i) ? [bt setTitleColor:selectTitleColor forState:UIControlStateNormal] : [bt setTitleColor:unselectTitleColor forState:UIControlStateNormal];
        }
        //当没有数据才下载数据
        switch (index) {
            case 0:
            {
                if (!_investPersonArray.count) {
                    [self startLoadData];
                }else{
                    [_investPersonTableView reloadData];
                }
                
            }
                break;
            case 1:
            {
                if (!_investOrganizationSecondArray.count && !_investOrganizationArray.count) {
                    [self startLoadData];
                }else{
                    [_investOrganizationTableView reloadData];
                }
            }
                break;
            case 2:
            {
                if (!_thinkTankArray.count) {
                    [self startLoadData];
                }else{
                    [_thinkTankTableView reloadData];
                }
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark ---------------tableViewDatasource--------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableViewSelected == 2) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableViewSelected == 1) {
        return 160;
    }
    
    if (_tableViewSelected == 2) {
        if (indexPath.section == 0) {
            return 110;
        }
        return 155;
    }
    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableViewSelected == 1) {
        return _investPersonArray.count;

    }
    if (_tableViewSelected == 2){
        
        if (section == 0) {
            return _investOrganizationArray.count;
        }
        return _investOrganizationSecondArray.count;
        
    }
    return _thinkTankArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //投资人
    if (_tableViewSelected == 1) {
        tableView = _investPersonTableView;
        InvestPersonCell *cell = [InvestPersonCell cellWithTableView:tableView];
        if (_investPersonArray.count) {
            if (_investPersonArray[indexPath.row]) {
                cell.model = _investPersonArray[indexPath.row];
                cell.indexPath = indexPath;
            }
            
        }
        if ([self.identiyTypeId isEqualToString:@"1"]) {
            cell.cimmitBtn.hidden = NO;
        }else{
            cell.cimmitBtn.hidden = YES;
        }
        cell.delegate = self;
        return cell;
    }
    if (_tableViewSelected == 2){ // 投资机构
        tableView = _investOrganizationTableView;
        if (indexPath.section == 0) {
            InvestOrganizationCell * cell = [InvestOrganizationCell cellWithTableView:tableView];
            
            if (_investOrganizationArray.count) {
                if (_investOrganizationArray[indexPath.row]) {
                    cell.model = _investOrganizationArray[indexPath.row];
                }
                
            }
            return cell;
        }else{
        
        InvestOrganizationSecondCell * cell = [InvestOrganizationSecondCell cellWithTableView:tableView];
        if (_investOrganizationSecondArray.count) {
            if (_investOrganizationSecondArray[indexPath.row]) {
                cell.model = _investOrganizationSecondArray[indexPath.row];
            }
        }
        cell.delegate = self;
        if ([self.identiyTypeId isEqualToString:@"1"]) {
            cell.commitBtn.hidden = NO;
        }else{
            cell.commitBtn.hidden = YES;
        }
        return cell;
        }
    };
    //智囊团
    if (_tableViewSelected == 3) {
        tableView = _thinkTankTableView;
        ThinkTankCell *  cell = [ThinkTankCell cellWithTableView:tableView];
        if (_thinkTankArray.count) {
            if (_thinkTankArray[indexPath.row]) {
                cell.model = _thinkTankArray[indexPath.row];
            }
        }
        cell.delegate =self;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_tableViewSelected == 1) {
        InvestListModel *listModel = _investPersonArray[indexPath.row];
        InvestPersonDetailViewController *vc = [InvestPersonDetailViewController new];
        self.investModel = listModel;
        
//        vc.attentionCount = [NSString stringWithFormat:@"%ld",(long)listModel.collectCount];
//        vc.titleText = @"个人 · 简介";
        vc.investorId = listModel.userId;
        
//        vc.collected  = listModel.collected;
//        vc.investorCollectPartner = self.investorCollectPartner;
        vc.viewController = self;  //圈子进入可忽略
        vc.selectedNum = 1;       //圈子进入可忽略
        vc.listModel = listModel; //圈子进入可忽略
//        vc.type = @"5";
//        vc.titleStr = @"投资人详情";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (_tableViewSelected == 2) {
        if (indexPath.section == 0) {
            
            OrganizationFirstModel *model = _investOrganizationArray[indexPath.row];
            PingTaiWebViewController *webView = [PingTaiWebViewController new];
            
            webView.url = model.url;
            webView.titleStr = @"基金详情";
            [self.navigationController pushViewController:webView animated:YES];

        }
        
        if (indexPath.section == 1) {
            
            InvestListModel *listModel = _investOrganizationSecondArray[indexPath.row];
            
            InvestPersonDetailViewController *vc = [InvestPersonDetailViewController new];
            
//            vc.attentionCount = [NSString stringWithFormat:@"%ld",(long)listModel.collectCount];
            vc.investorId = listModel.userId;
//            vc.titleText = @"机构 · 简介";
//            vc.collected  = listModel.collected;
//            vc.investorCollectPartner = self.investorCollectPartner;
            self.investModel  = listModel;
            
            vc.viewController =self;   //圈子进入可忽略
            vc.selectedNum = 2;        //圈子进入可忽略
            vc.listModel = listModel;  //圈子进入可忽略
            
//            vc.type = @"6";
//            vc.titleStr = @"投资机构详情";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    
    if (_tableViewSelected == 3) {
        InvestListModel *listModel = _thinkTankArray[indexPath.row];

        InvestThinkTankDetailVC * vc = [InvestThinkTankDetailVC new];

        vc.investorId = listModel.userId;
//        vc.attentionCount = [NSString stringWithFormat:@"%ld",(long)listModel.collectCount];
//        vc.collected  = listModel.collected;
//        vc.investorCollectPartner = self.investorCollectPartner;
        
        self.investModel = listModel;
        vc.viewController =self;
//        vc.type = @"7";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- 创建tableView
-(void)createTableView:(UITableView*)tableView index:(int)index
{
    tableView.frame=CGRectMake(index*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - 64-49-40);
//    分隔线隐藏
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tag = index;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    //设置刷新控件
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    tableView.mj_header.automaticallyChangeAlpha = YES;
//    [tableView.mj_header beginRefreshing];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
//    tableView.mj_footer.hidden = YES;
    tableView.mj_footer.automaticallyHidden = NO;
    
    [_subViewScrollView addSubview:tableView];
}
#pragma mark -刷新控件
-(void)nextPage
{
    if (_tableViewSelected == 1) {
        _lastInvestPage = _investPage;
        _investPage ++;
        if (_lastInvestPage != _investPage) {
            [self startLoadData];
        }
    }
    
    if (_tableViewSelected == 2) {
        _lastOrganizationPage = _organizationPage;
        _organizationPage ++;
        if (_lastOrganizationPage != _organizationPage) {
            [self startLoadData];
        }
    }
    if (_tableViewSelected == 3) {
        _lastTankPage = _tankPage;
        _tankPage ++;
        if (_lastTankPage != _tankPage) {
            [self startLoadData];
        }
    }
}

-(void)refreshHttp
{
    if (_tableViewSelected == 1) {
        _investPage = 0;
    }
    if (_tableViewSelected == 2) {
        _organizationPage = 0;
    }
    if (_tableViewSelected == 3) {
        _tankPage = 0;
    }
    
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}

#pragma mark -投资人cell---delegate-----------------

-(void)didClickCommitBtn:(InvestPersonCell *)cell andModel:(InvestListModel *)model andIndexPath:(NSIndexPath *)indexPath
{

        InvestCommitProjectVC *vc = [InvestCommitProjectVC new];
        
        vc.model = model;
        vc.viewController = self;
        
        [self.navigationController pushViewController:vc animated:YES];
  
}




-(void)didClickAttentionBtn:(InvestPersonCell *)cell andModel:(InvestListModel *)model andIndexPath:(NSIndexPath *)indexPath
{

       klistModel = model;
       klistCell = cell;
       
       model.collected = !model.collected;
       NSString *flag;
       if (model.collected) {
           //关注
           flag = @"1";
           
       }else{
           //quxiao关注
           flag = @"2";
           
       }
       
       switch (_tableViewSelected) {
           case 1:{
               InvestListModel * model = (InvestListModel*)klistModel;
               InvestPersonCell * cell = (InvestPersonCell*)klistCell;
               if (model.collected) {
                   //刷新cell
                   model.collectCount ++;
                   [cell.collectBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                   [cell.collectBtn setBackgroundColor:btnCray];
               }else{
                   //刷新cell
                   
                   [cell.collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                   [cell.collectBtn setBackgroundColor:btnGreen];
               }
           }
               break;
           case 2:{
               OrganizationSecondModel * model = (OrganizationSecondModel*)klistModel;
               InvestOrganizationSecondCell * cell = (InvestOrganizationSecondCell*)klistCell;
               if (model.collected) {
                   
                   //刷新cell
                   model.collectCount++;
                   
                   [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                   [cell.attentionBtn setBackgroundColor:btnCray];
               }else{
                   //关注数量减1
                   
                   //刷新cell
                   [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                   [cell.attentionBtn setBackgroundColor:btnGreen];
               }
           }
               break;
           case 3:{
               InvestListModel * model = (InvestListModel*)klistModel;
               ThinkTankCell * cell = (ThinkTankCell*)klistCell;
               if (model.collected) {
                   //刷新cell
                   model.collectCount ++;
                   [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                   [cell.attentionBtn setBackgroundColor:btnCray];
               }else{
                   //关注数量减1
                   
                   //刷新cell
                   
                   [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                   [cell.attentionBtn setBackgroundColor:btnGreen];
               }
           }
               break;
           default:
               break;
       }
    
       [self.tableView reloadData];
       
       NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.investorCollectPartner,@"partner",model.userId,@"userId",flag,@"flag", nil];
       //开始请求
       [self.httpUtil getDataFromAPIWithOps:REQUEST_INVESTOR_COLLECT postParam:dic type:0 delegate:self sel:@selector(requestInvestorCollect:)];
    
}

-(void)requestInvestorCollect:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
//            _collectSuccess = YES;
//            
//            if (_collectSuccess) {
//                
//            }
            
//            NSLog(@"关注成功");
        }else{
//            NSLog(@"关注失败");
        }
    }
}

#pragma mark -----投资机构InvestOrganizationSecondCellDelegate-------------------
-(void)didClickCommitBtn:(InvestOrganizationSecondCell *)cell andModel:(InvestListModel *)model
{

        InvestCommitProjectVC *vc = [InvestCommitProjectVC new];
        vc.model = model;
        
        [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)didClickAttentionBtn:(InvestOrganizationSecondCell *)cell andModel:(InvestListModel *)model
{

         klistModel = model;
         klistCell = cell;
         
         model.collected = !model.collected;
         NSString *flag;
         if (model.collected) {
             //关注
             flag = @"1";
             
         }else{
             //quxiao关注
             flag = @"2";
             
         }
         
         switch (_tableViewSelected) {
             case 1:{
                 InvestListModel * model = (InvestListModel*)klistModel;
                 InvestPersonCell * cell = (InvestPersonCell*)klistCell;
                 if (model.collected) {
                     //刷新cell
                     model.collectCount ++;
                     [cell.collectBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                     [cell.collectBtn setBackgroundColor:btnCray];
                 }else{
                     //刷新cell
                     
                     [cell.collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                     [cell.collectBtn setBackgroundColor:btnGreen];
                 }
             }
                 break;
             case 2:{
                 OrganizationSecondModel * model = (OrganizationSecondModel*)klistModel;
                 InvestOrganizationSecondCell * cell = (InvestOrganizationSecondCell*)klistCell;
                 if (model.collected) {
                     
                     //刷新cell
                     model.collectCount++;
                     
                     [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                     [cell.attentionBtn setBackgroundColor:btnCray];
                 }else{
                     //关注数量减1
                     
                     //刷新cell
                     [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                     [cell.attentionBtn setBackgroundColor:btnGreen];
                 }
             }
                 break;
             case 3:{
                 InvestListModel * model = (InvestListModel*)klistModel;
                 ThinkTankCell * cell = (ThinkTankCell*)klistCell;
                 if (model.collected) {
                     //刷新cell
                     model.collectCount ++;
                     [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                     [cell.attentionBtn setBackgroundColor:btnCray];
                 }else{
                     //关注数量减1
                     
                     //刷新cell
                     
                     [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                     [cell.attentionBtn setBackgroundColor:btnGreen];
                 }
             }
                 break;
             default:
                 break;
         }
         
         
         
         [self.tableView reloadData];
         
         
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.investorCollectPartner,@"partner",model.userId,@"userId",flag,@"flag", nil];
         //开始请求
         [self.httpUtil getDataFromAPIWithOps:REQUEST_INVESTOR_COLLECT postParam:dic type:0 delegate:self sel:@selector(requestInvestorCollect:)];

}

#pragma mark -智囊团  ThinkTankCellDelegate -------------------------
-(void)didClickAttentionBtnInCell:(ThinkTankCell*)cell andModel:(InvestListModel*)model
{

        klistModel = model;
        klistCell = cell;
        
        model.collected = !model.collected;
        NSString *flag;
        if (model.collected) {
            //关注
            flag = @"1";
            
        }else{
            //quxiao关注
            flag = @"2";
            
        }
        
        switch (_tableViewSelected) {
            case 1:{
                InvestListModel * model = (InvestListModel*)klistModel;
                InvestPersonCell * cell = (InvestPersonCell*)klistCell;
                if (model.collected) {
                    //刷新cell
                    model.collectCount ++;
                    [cell.collectBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                    [cell.collectBtn setBackgroundColor:btnCray];
                }else{
                    //刷新cell
                    
                    [cell.collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                    [cell.collectBtn setBackgroundColor:btnGreen];
                }
            }
                break;
            case 2:{
                OrganizationSecondModel * model = (OrganizationSecondModel*)klistModel;
                InvestOrganizationSecondCell * cell = (InvestOrganizationSecondCell*)klistCell;
                if (model.collected) {
                    
                    //刷新cell
                    model.collectCount++;
                    
                    [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                    [cell.attentionBtn setBackgroundColor:btnCray];
                }else{
                    //关注数量减1
                    
                    //刷新cell
                    [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                    [cell.attentionBtn setBackgroundColor:btnGreen];
                }
            }
                break;
            case 3:{
                InvestListModel * model = (InvestListModel*)klistModel;
                ThinkTankCell * cell = (ThinkTankCell*)klistCell;
                if (model.collected) {
                    //刷新cell
                    model.collectCount ++;
                    [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                    [cell.attentionBtn setBackgroundColor:btnCray];
                }else{
                    //关注数量减1
                    
                    //刷新cell
                    
                    [cell.attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",--model.collectCount] forState:UIControlStateNormal];
                    [cell.attentionBtn setBackgroundColor:btnGreen];
                }
            }
                break;
            default:
                break;
        }
        
        
        
        [self.tableView reloadData];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.investorCollectPartner,@"partner",model.userId,@"userId",flag,@"flag", nil];
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:REQUEST_INVESTOR_COLLECT postParam:dic type:0 delegate:self sel:@selector(requestInvestorCollect:)];
}

#pragma mark- 视图即将显示
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadOffLineData];
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
