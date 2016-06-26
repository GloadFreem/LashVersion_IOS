//
//  ProjectViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectViewController.h"

#import "UpProjectViewController.h"
#import "ProjectLetterViewController.h"

#import "ProjectListCell.h"
#import "ProjectNoRoadCell.h"
#import "ProjectBannerView.h"
#import "ProjectDetailController.h"

#define BannerHeight   235
@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger selectedCellNum;//选择显示cell的类型

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.设置当有导航栏自动添加64的高度的属性为NO
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//
//    [self setKeyScrollView:self.tableView scrolOffsetY:600 options:HYHidenControlOptionTitle];
    
    _selectedCellNum = 20;
    
    ProjectBannerView * bannerView = [[ProjectBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, BannerHeight*HEIGHTCONFIG)];
    [bannerView setSelectedNum:20];
    _tableView.tableHeaderView = bannerView;
     NSArray * arr = [NSArray array];
    [bannerView relayoutWithModelArray:arr];
    
    bannerView.delegate = self;
    [self createUI];
    
    
}
#pragma mark -视图即将显示
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
-(void)createUI
{

    self.navigationItem.title = @"项目";
//    UILabel * titleLabel =[[UILabel alloc]init];
//    titleLabel.text = @"项目";
//    [titleLabel sizeToFit];
//    titleLabel.font = BGFont(18);
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    self.navigationItem.titleView=titleLabel;
   
    UIButton * letterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    letterBtn.tag = 0;
    //通过判断返回数据状态来决定背景图片
//    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    letterBtn.size = letterBtn.currentBackgroundImage.size;
    [letterBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:letterBtn];
    
    UIButton *upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upLoadBtn.tag = 1;
    [upLoadBtn setBackgroundImage:[UIImage imageNamed:@"upLoad"] forState:UIControlStateNormal];
    upLoadBtn.size = upLoadBtn.currentBackgroundImage.size;
    [upLoadBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:upLoadBtn];
    
}

#pragma mark- navigationBar  button的点击事件
-(void)buttonCilck:(UIButton*)button
{
    if (button.tag == 0) {
        
        ProjectLetterViewController *letter = [ProjectLetterViewController new];
        //隐藏tabbar
        AppDelegate *delegate = [[UIApplication  sharedApplication] delegate];
        [delegate.tabBar tabBarHidden:YES animated:NO];
        
        [self.navigationController pushViewController:letter animated:YES];
        
    }
    if (button.tag == 1) {
        
        UpProjectViewController *up = [UpProjectViewController new];
        
        //隐藏tabbar
        AppDelegate * delegate =[UIApplication sharedApplication].delegate;
        
        [delegate.tabBar tabBarHidden:YES animated:NO];
        
        [self.navigationController pushViewController:up animated:YES];
    }
}

#pragma mark - tableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedCellNum == 20) {
        return 172;
    }
    return 172;
}



#pragma mark -设置区头
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ProjectBannerView * bannerView = [[ProjectBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 237)];
//    NSArray * arr = [NSArray array];
//    [bannerView relayoutWithModelArray:arr];
//    [bannerView setSelectedNum:20];
//    return bannerView;
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectedCellNum == 20) {
        
        static NSString * cellId = @"ProjectListCell";
        ProjectListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
        static NSString * cellId =@"ProjectNoRoadCell";
        ProjectNoRoadCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

#pragma mark -tableView的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProjectDetailController * detail = [[ProjectDetailController alloc]init];
    //隐藏tabbar
    AppDelegate * delegate =[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark- ProjectBannerCellDelegate 代理方法
-(void)transportProjectBannerView:(ProjectBannerView *)view andTagValue:(NSInteger)tagValue
{
    _selectedCellNum  = tagValue;//将传过来的tag赋值给_selectedCellNum来决定显示cell的类型
    
    //tableView开始更新
    [_tableView beginUpdates];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}



@end
