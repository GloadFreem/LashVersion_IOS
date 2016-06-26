//
//  InvestCommitProjectVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestCommitProjectVC.h"
#import "InvestCommitProjectReasonCell.h"
#import "InvestCommitProjectPersonCell.h"
#import "InvestCommitProjectPCell.h"

@interface InvestCommitProjectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *certainBtn;    //

@end

@implementation InvestCommitProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    
    [self setUpNavBar];
    
    [self createTableView];
    
}

#pragma mark- 设置导航栏
-(void)setUpNavBar
{
    
    self.view.backgroundColor = colorGray;
    self.navigationItem.title = @"个人资料";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
    
    UIButton * serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn.tag = 1;
    [serviceBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kefu"] forState:UIControlStateNormal];
    serviceBtn.size = serviceBtn.currentBackgroundImage.size;
    [serviceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:serviceBtn];
    
}

#pragma mark -初始化tableView
-(void)createTableView
{
    _tableView = [UITableView new];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(505);
    }];
    
    _certainBtn = [UIButton new];
    _certainBtn.tag = 2;
    _certainBtn.backgroundColor = colorBlue;
    [_certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _certainBtn.titleLabel.font = BGFont(23);
    [_certainBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_certainBtn];
    
    [_certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).offset(18);
        make.centerX.mas_equalTo(_tableView.mas_centerX);
        make.width.mas_equalTo(300*WIDTHCONFIG);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark- btnClick
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1) {
        NSLog(@"呼叫客服");
    }
}
#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 105;
    }
    return 200;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellId= @"InvestCommitProjectPersonCell";
        InvestCommitProjectPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *cellId = @"InvestCommitProjectReasonCell";
        InvestCommitProjectReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        return cell;
    }
    
    static NSString *cellId = @"InvestCommitProjectPCell";
    InvestCommitProjectPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
