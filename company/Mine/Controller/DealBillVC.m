//
//  DealBillVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "DealBillVC.h"

@interface DealBillVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DealBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark -表头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80*HEIGHTCONFIG;
}
#pragma mark- 表头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
    
    UIImageView *firstLineImage = [UIImageView new];
    firstLineImage.image = [UIImage imageNamed:@"bill_line"];
    [headerView addSubview:firstLineImage];
    
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"bill_calendar"];
    [headerView addSubview:imageView];
    //蓝线
    UIImageView *lineImage = [UIImageView new];
    lineImage.image = [UIImage imageNamed:@"bill_line"];
    [headerView addSubview:lineImage];
    //年
    UILabel *label = [UILabel new];
    label.text = @"2016年";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = BGFont(17);
    [headerView addSubview:label];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_top).offset(38);
        make.left.mas_equalTo(headerView.mas_left).offset(62);
    }];
    
    if (section != 0) {
        [firstLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.top.mas_equalTo(headerView.mas_top);
            make.bottom.mas_equalTo(imageView.mas_top);
        }];
    }else{
        [firstLineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView);
        make.left.mas_equalTo(imageView.mas_right).offset(5);
        make.height.mas_equalTo(17);
    }];
    
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom);
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(5);
    }];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark -cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
