//
//  MineAttentionVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineAttentionVC.h"
#import "ProjectListCell.h"
#import "ProjectNoRoadCell.h"

#import "MineAttentionInvestCell.h"
#import "MineAttentionInvestOrganizationCell.h"
#import "MineAttentionInvestThinkTankCell.h"

#import "ProjectListProModel.h"
#import "MineCollectionProjectModel.h"


#import "MineCollectionInvestModel.h"

#import "MineCollectionInvestorBaseModel.h"
#import "MineCollectionListModel.h"

#import "ProjectPrepareDetailVC.h"
#import "ProjectDetailController.h"

#import "InvestPersonDetailViewController.h"
#import "InvestThinkTankDetailVC.h"

#define LOGOATTENTION @"requestMineCollection"

@interface MineAttentionVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *projectBtn;    //
@property (nonatomic, strong) UIButton *investBtn;    //

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *projectTableView;  //项目视图
@property (nonatomic, assign) NSInteger selectedTableView;  //选择要加载的视图
@property (nonatomic, strong) UITableView *investTableView;  //投资视图

@property (nonatomic, copy) NSString *identyType;  //身份类型
@property (nonatomic, assign) NSInteger page;  //当前页
@property (nonatomic, assign) NSInteger projectPage;
@property (nonatomic, assign) NSInteger investPage;




@property (nonatomic, strong) NSMutableArray *identifyArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation MineAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_projectTableView) {
        _projectArray = [NSMutableArray array];
    }
    if (!_investArray) {
        _investArray  = [NSMutableArray array];
    }
    if (!_identifyArray) {
        _identifyArray = [NSMutableArray array];
    }
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    _selectedTableView = 0;  //默认显示第一个视图
    _identyType = @"0";       //默认请求项目
    _projectPage = 0;
    _investPage = 0;
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:LOGOATTENTION];
    
    [self startLoadData];
    
    //创建基本布局
    [self setupNav];
    [self createUI];
    
    
}
#pragma mark--下载数据
-(void)startLoadData
{
    if (_selectedTableView == 0) {
        _identyType = @"0";
        _page = _projectPage;
        self.tableView = _projectTableView;
    }
    
    if (_selectedTableView == 1) {
        _identyType = @"1";
        _page = _investPage;
        self.tableView = _investTableView;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",_identyType,@"type",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_ATTENTION_LIST postParam:dic type:0 delegate:self sel:@selector(requestInvestList:)];
}

-(void)requestInvestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    //如果刷新到顶部  移除原来数组数据
    if (_page == 0) {
        if (_selectedTableView == 0) {
            [_projectArray removeAllObjects];
        }
        if (_selectedTableView == 1) {
            [_investArray removeAllObjects];
            [_identifyArray removeAllObjects];
        }
    }
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //项目
            if (_selectedTableView == 0) {
                NSArray *dataArray = [MineCollectionProjectModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i = 0; i < dataArray.count; i ++) {
                    ProjectListProModel *listModel = [ProjectListProModel new];
                    MineCollectionProjectModel *baseModel = dataArray[i];
                    listModel.startPageImage = baseModel.startPageImage;
                    listModel.abbrevName = baseModel.abbrevName;
                    listModel.address = baseModel.address;
                    listModel.fullName = baseModel.fullName;
                    listModel.status = baseModel.financestatus.name;
                    listModel.projectId  = baseModel.projectId;
                    
                    //少一个areas 数组
                    listModel.areas = [baseModel.industoryType componentsSeparatedByString:@"，"];
                    listModel.collectionCount = baseModel.collectionCount;
                    MineRoadshows *roadshows = baseModel.roadshows[0];
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    
                    [_statusArray addObject:baseModel.financestatus.name];
                    [_projectArray addObject:listModel];
                    
                }
                
            }
//            NSLog(@"数组个数---%ld",_projectArray.count);
            //投资
            if (_selectedTableView == 1) {
                NSArray *dataArray = [MineCollectionInvestModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i =0; i < dataArray.count; i ++) {
                    MineCollectionInvestModel *baseModel = dataArray[i];
                    MineCollectionListModel *listModel = [MineCollectionListModel new];
                    listModel.headSculpture = baseModel.usersByUserCollectedId.headSculpture;
//                    listModel.name = baseModel.usersByUserId.name;
                    MAuthentics *authentics = baseModel.usersByUserCollectedId.authentics[0];
                    listModel.name = authentics.name;
                    listModel.position = authentics.position;
                    listModel.identiyTypeId = authentics.identiytype.name;
                    listModel.companyName = authentics.companyName;
                    NSString *city = authentics.city.name;
                    NSString *province = authentics.city.province.name;
                    listModel.companyAddress = [NSString stringWithFormat:@"%@ | %@",province,city];
                    listModel.areas = [authentics.industoryArea componentsSeparatedByString:@"，"];
                    listModel.introduce = authentics.introduce;
                    listModel.userId = baseModel.usersByUserCollectedId.userId;
//                    listModel.collected = 
                    //身份
                    [_identifyArray addObject:authentics.identiytype.name];
                    [_investArray addObject:listModel];
                }
            }
            
            [self.tableView reloadData];
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}


#pragma mark -导航栏设置
-(void)setupNav
{
    
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 2;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(32, 20);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 144, 30)];
    titleView.layer.cornerRadius = 5;
    titleView.layer.masksToBounds = YES;
    titleView.layer.borderColor = [UIColor whiteColor].CGColor;
    titleView.layer.borderWidth = 0.5;
    _titleView = titleView;
    
    UIButton *projectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [projectBtn setTitle:@"项目" forState:UIControlStateNormal];
    [projectBtn setTag:0];
    [projectBtn setTitle:@"项目" forState:UIControlStateSelected];
    [projectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [projectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    projectBtn.titleLabel.font = BGFont(14);
    [projectBtn setBackgroundColor:[UIColor whiteColor]];
    [titleView addSubview:projectBtn];
    _projectBtn = projectBtn;
    
    [projectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleView.mas_left);
        make.top.mas_equalTo(titleView.mas_top);
        make.bottom.mas_equalTo(titleView.mas_bottom);
        make.right.mas_equalTo(titleView.mas_centerX);
    }];
    
    UIButton *investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [investBtn setTag:1];
    [investBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [investBtn setTitle:@"投资" forState:UIControlStateNormal];
    [investBtn setTitle:@"投资" forState:UIControlStateSelected];
    [investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    investBtn.titleLabel.font = BGFont(14);
    [investBtn setBackgroundColor:color(61, 69, 78, 1)];
    [titleView addSubview:investBtn];
    _investBtn = investBtn;
    
    [investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(projectBtn.mas_right);
        make.top.mas_equalTo(projectBtn.mas_top);
        make.bottom.mas_equalTo(projectBtn.mas_bottom);
        make.right.mas_equalTo(titleView.mas_right);
    }];
    
    self.navigationItem.titleView = titleView;
    
}
#pragma mark -titleView  button点击事件
-(void)btnClick:(UIButton*)btn
{
  
    if (btn.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    

        if (btn.tag == 0) {
            [_projectBtn setBackgroundColor:[UIColor whiteColor]];
            [_projectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_investBtn setBackgroundColor:color(61, 69, 78, 1)];
            [_investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if (btn.tag == 1) {
            [_investBtn setBackgroundColor:[UIColor whiteColor]];
            [_investBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_projectBtn setBackgroundColor:color(61, 69, 78, 1)];
            [_projectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    _selectedTableView = btn.tag;
    _scrollView.contentOffset = CGPointMake(SCREENWIDTH*btn.tag, 0);
    [self startLoadData];
    
    }
}

#pragma mark -scrollView的滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollView) {
        
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger index = offSetX/SCREENWIDTH;
        //当前选中tableView
        _selectedTableView = index;
        //重置btn的颜色
        if (index == 0) {
            [_projectBtn setBackgroundColor:[UIColor whiteColor]];
            [_projectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_investBtn setBackgroundColor:color(61, 69, 78, 1)];
            [_investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if (index == 1) {
            [_investBtn setBackgroundColor:[UIColor whiteColor]];
            [_investBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [_projectBtn setBackgroundColor:color(61, 69, 78, 1)];
            [_projectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
       
        //当没有数据才下载数据
        if (!_projectArray.count || !_investArray.count) {
            [self startLoadData];
        }
        
        switch (index) {
            case 0:
            {
                
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)createUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH*2, 0);
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    //方向锁
    _scrollView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollView];
    
    _projectTableView = [UITableView new];
    [self createTableView:_projectTableView index:0];
//    [_projectTableView setBackgroundColor:[UIColor redColor]];
    
    _investTableView = [UITableView new];
    [self createTableView:_investTableView index:1];
//    [_investTableView setBackgroundColor:[UIColor greenColor]];
}


#pragma mark -UItableVlewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedTableView == 0) {
        return _projectArray.count;
    }
    return _investArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedTableView == 0) {
        return 172;
    }
    return 113;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedTableView == 0) {
        
        if (_statusArray.count && _projectArray.count) {
            if ([_statusArray[indexPath.row] isEqualToString:@"预选项目"]) {
                static NSString *cellId = @"ProjectNoRoadCell";
                ProjectNoRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (_projectArray.count) {
                    cell.model = _projectArray[indexPath.row];
                }
                return cell;
            }
            
            static NSString * cellId = @"ProjectListCell";
            ProjectListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:nil options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_projectArray.count) {
                cell.model = _projectArray[indexPath.row];
            }
            
            return cell;
        }
        
    }
    
    if (_identifyArray.count && _investArray.count) {
        
        if ([_identifyArray[indexPath.row] isEqualToString:@"个人投资者"]) {
            static NSString * cellId =@"MineAttentionInvestCell";
            MineAttentionInvestCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                
            }
                cell.model = _investArray[indexPath.row];
           
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if ([_identifyArray[indexPath.row] isEqualToString:@"机构投资者"]) {
            static NSString *cellId = @"MineAttentionInvestOrganizationCell";
            MineAttentionInvestOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            cell.model = _investArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if ([_identifyArray[indexPath.row] isEqualToString:@"智囊团"]) {
            static NSString *cellId = @"MineAttentionInvestThinkTankCell";
            MineAttentionInvestThinkTankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil ] lastObject];
            }
            cell.model = _investArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
   
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectedTableView == 0) {
        if (!_projectArray.count || !_statusArray.count) {
            return;
        }
        ProjectListProModel *model = _projectArray[indexPath.row];
        if ([_statusArray[indexPath.row] isEqualToString:@"预选项目"]) {
            ProjectPrepareDetailVC *vc = [ProjectPrepareDetailVC new];
            vc.attentionVC = self;
            vc.projectId = model.projectId;
            vc.model = model;
            vc.tableView = _projectTableView;
            //隐藏tabbar
            AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
            
            [delegate.tabBar tabBarHidden:YES animated:NO];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ProjectDetailController *vc = [ProjectDetailController new];
            vc.attentionVC = self;
            vc.projectId = model.projectId;
            vc.listModel = model;
            vc.tableView = _projectTableView;
            //隐藏tabbar
            AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
            
            [delegate.tabBar tabBarHidden:YES animated:NO];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (!_investArray.count || !_identifyArray.count) {
        return;
    }
    MineCollectionListModel *model = _investArray[indexPath.row];
    if ([_identifyArray[indexPath.row] isEqualToString:@"个人投资者"]) {
        InvestPersonDetailViewController *vc = [InvestPersonDetailViewController new];
        vc.attentionVC =self;
        vc.titleText = @"个人 · 简介";
        vc.investorId = [NSString stringWithFormat:@"%ld",(long)model.userId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_identifyArray[indexPath.row] isEqualToString:@"机构投资者"]) {
        InvestPersonDetailViewController *vc = [InvestPersonDetailViewController new];
        vc.attentionVC =self;
        vc.titleText = @"机构 · 简介";
        vc.investorId = [NSString stringWithFormat:@"%ld",(long)model.userId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if ([_identifyArray[indexPath.row] isEqualToString:@"智囊团"]) {
        InvestThinkTankDetailVC *vc = [InvestThinkTankDetailVC new];
        vc.investorId = [NSString stringWithFormat:@"%ld",(long)model.userId];
        vc.attentionVC =self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark- 创建tableView
-(void)createTableView:(UITableView*)tableView index:(int)index
{
    tableView.frame=CGRectMake(index*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT - 64);
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
    [tableView.mj_header beginRefreshing];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
//    tableView.mj_footer.hidden = YES;
    [_scrollView addSubview:tableView];
}

#pragma mark -刷新控件
-(void)nextPage
{
    if (_selectedTableView == 0) {
        _projectPage ++;
    }
    if (_selectedTableView == 1) {
        _investPage ++;
    }

    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    if (_selectedTableView == 0) {
        _projectPage = 0;
    }
    if (_selectedTableView == 1) {
        _investPage = 0;
    }
    
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
