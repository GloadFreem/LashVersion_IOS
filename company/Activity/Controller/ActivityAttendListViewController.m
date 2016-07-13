//
//  ActivityViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityAttendListViewController.h"
#import "ActionComment.h"
#import "ActivityDetailVC.h"
#import "ActionDetailModel.h"
#import "ActivityAttendModel.h"
#import "ActivityDetailHeaderModel.h"
#import "ActivityDetailExerciseCell.h"
#import "ActivityDetailListCell.h"
#import "ActivityDetailFooterView.h"
#import "ActivityDetailCommentCellModel.h"
#import "ActivityDetailExiciseContentCell.h"

#define ACTIONATTEND @"requestAttendListAction"
#define kActivityDetailHeaderCellId @"ActivityDetailHeaderCell"


@interface ActivityAttendListViewController ()<UITableViewDelegate,UITableViewDataSource,ActivityDetailFooterViewDelegate,UITextFieldDelegate>
@property (nonatomic, copy) NSString * actionAttendPartner;
@property (nonatomic, copy) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *dataAttendSource;


@end

@implementation ActivityAttendListViewController
{
    CGFloat _totalKeybordHeight;
    NSInteger page;
    Boolean isRefresh;
    Boolean isNoMoreData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setUpNavBar];
    //初始化 控件
    [self createUI];
    
    //生成请求partner
    self.actionAttendPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONATTEND];
    
    //获取项目参加人数
//    [self loadActionAttendData];
    
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"活动报名"];
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

#pragma mark -初始化控件
-(void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = YES;
//    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01f)];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

-(void)refreshData
{
    page  = 0;
    isRefresh = YES;
    isNoMoreData = false;
    
    //加载数据
    [self loadActionAttendData];
}

-(void)loadMoreData
{
    isRefresh = NO;
    
    if (!isNoMoreData) {
        page ++;
    }
    
    
    [self loadActionAttendData];
}
/**
 *  获取报名人数
 */

-(void)loadActionAttendData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionAttendPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",STRING(@"%ld", (long)page),@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_ATTEND postParam:dic type:0 delegate:self sel:@selector(requestActionAttendList:)];
}

-(void)requestActionAttendList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            ActivityAttendModel * baseModel;
            if (isRefresh) {
                 self.dataAttendSource = [NSMutableArray new];
            }
            
            if(!self.dataAttendSource)
            {
                self.dataAttendSource = [NSMutableArray new];
            }
            
            for(NSDictionary * dic in dataArray)
            {
                //解析
                baseModel =[ActivityAttendModel mj_objectWithKeyValues:dic];
                //替换模型
                [self.dataAttendSource addObject:baseModel];
            }
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else if ([status integerValue] == 201)
        {
            isNoMoreData = true;
            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
       
    }
}




-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAttendSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ActivityDetailListCell";
    ActivityDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
    }
    
    //设置模型
    cell.model = [self.dataAttendSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -btnAction
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES]
    ;
//    AppDelegate * delegate =[UIApplication sharedApplication].delegate;
//    
//    [delegate.tabBar tabBarHidden:NO animated:NO];
    self.navigationController.navigationBar.hidden = NO;
    
}

@end
