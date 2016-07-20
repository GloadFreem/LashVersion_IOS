//
//  MineProjectCenterVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineProjectCenterVC.h"
#import "MineProjectCenterPersonSecondCell.h"
#import "MineProjectCenterHeaderCell.h"

#define PROJECTCENTER @"requestProjectCenter"
@interface MineProjectCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MineProjectCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }

    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCENTER];
    [self startLoadData];
    
    [self setupNav];
    
    [self createTableView];
}

-(void)startLoadData
{
    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:LOGO_PROJECT_CENTER postParam:dic type:0 delegate:self sel:@selector(requestGoldInfo:)];
}


#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"项目中心";
}

-(void)createTableView
{
    _tableView  = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
//    _tableView.backgroundColor = [UIColor redColor];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
}
-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250*HEIGHTCONFIG;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MineProjectCenterPersonSecondCell";
    MineProjectCenterPersonSecondCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MineProjectCenterPersonSecondCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
