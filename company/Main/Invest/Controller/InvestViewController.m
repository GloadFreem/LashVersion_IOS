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

#define defaultLineColor [UIColor blueColor]
#define selectTitleColor orangeColor
#define unselectTitleColor [UIColor blackColor]
#define titleFont [UIFont systemFontOfSize:16]

@interface InvestViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSMutableArray *btArray;           //点击切换按钮数组
@property (nonatomic,strong) UIScrollView *titleScrollView;     //切换按钮
@property (nonatomic,strong) NSArray *titleArray;              // 切换按钮名字数组
@property (nonatomic,strong) NSArray *imageArray;              //切换按钮图标
@property (nonatomic,strong) UIView *lineView;                  // 下划线视图
@property (nonatomic,strong) UIScrollView *subViewScrollView;   // 下边子滚动视图
@property (nonatomic,strong) UITableView *investPersonTableView; //投资人视图
@property (nonatomic, strong) NSMutableArray *investPersonArray; //投资人模型数组

@property (nonatomic, strong) UITableView *investOrganizationTableView; //投资机构视图
@property (nonatomic, strong) NSMutableArray *investOrganizationArray; //投资机构模型数组

@property (nonatomic, strong) UITableView *thinkTankTableView; //智囊团视图
@property (nonatomic, strong) NSMutableArray *thinkTankArray; //智囊团模型数组

@property (nonatomic, assign) NSInteger tableViewSelected; //当前显示tableView

@end

@implementation InvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    _tableViewSelected =1;
    //初始化模型数组
    _investPersonArray = [NSMutableArray array];
    _investOrganizationArray = [NSMutableArray array];
    _thinkTankArray = [NSMutableArray array];
    
    _titleArray = @[@" 投资人",@" 投资机构",@" 智囊团"];
    _imageArray = @[@"touziren-icon",@"iconfont-jigouT",@"iconfont-danaoT"];
    _lineColor = orangeColor;
    _type = 0;
    [self.view addSubview:self.titleScrollView];          //添加点击按钮
    [self.view addSubview:self.subViewScrollView];        //添加最下边scrollview
}

-(void)createUI
{
//    UILabel * titleLabel =[[UILabel alloc]init];
//    titleLabel.text = @"项目";
//    [titleLabel sizeToFit];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    self.navigationItem.titleView=titleLabel;
    self.navigationItem.title = @"投资人";
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
        _investPersonTableView = [[UITableView alloc]init];
        [self createTableView:_investPersonTableView index:0];
        
        _investOrganizationTableView = [[UITableView alloc]init];
        [self createTableView:_investOrganizationTableView index:1];
        
        _thinkTankTableView = [[UITableView alloc]init];
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
    //下载数据
    [self loadData];

    
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
        //下载数据
        [self loadData];
        
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

#pragma mark -tableViewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableViewSelected == 1) {
        return 150;
    }else if (_tableViewSelected == 2){
        if (indexPath.row < 3) {
            return 110;
        }
        return 155;
    }
    return 150;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableViewSelected == 1) {
//        return _investPersonArray.count;
        return 8;
    }else if (_tableViewSelected == 2){
//        return _investOrganizationArray.count;
        return 8;
    }
//    return _thinkTankArray.count;
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //投资人
    if (_tableViewSelected == 1) {
        tableView = _investPersonTableView;
        InvestPersonCell *cell = [InvestPersonCell cellWithTableView:tableView];
        
        return cell;
    }else if (_tableViewSelected == 2){ // 投资机构
        tableView = _investOrganizationTableView;
        if (indexPath.row < 3) {
            InvestOrganizationCell * cell = [InvestOrganizationCell cellWithTableView:tableView];
            
            return cell;
        }
        
        InvestOrganizationSecondCell * cell = [InvestOrganizationSecondCell cellWithTableView:tableView];
        
        return cell;
    };
    //智囊团
    tableView = _thinkTankTableView;
    ThinkTankCell *  cell = [ThinkTankCell cellWithTableView:tableView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_tableViewSelected == 1) {
        InvestPersonDetailViewController *vc = [InvestPersonDetailViewController new];
        //隐藏tabbar
        AppDelegate * delegate =[UIApplication sharedApplication].delegate;
        
        [delegate.tabBar tabBarHidden:YES animated:NO];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (_tableViewSelected == 3) {
        InvestThinkTankDetailVC * vc = [InvestThinkTankDetailVC new];
        //隐藏tabbar
        AppDelegate * delegate =[UIApplication sharedApplication].delegate;
        
        [delegate.tabBar tabBarHidden:YES animated:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -下载数据
-(void)loadData
{
    if (_tableViewSelected == 1) {
        [_investPersonTableView reloadData];
    }
    if (_tableViewSelected == 2) {
        [_investOrganizationTableView reloadData];
    }
    if (_tableViewSelected == 3) {
        [_thinkTankTableView reloadData];
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
    tableView.backgroundColor=[UIColor whiteColor];
    [_subViewScrollView addSubview:tableView];
}

#pragma mark- 视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
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
