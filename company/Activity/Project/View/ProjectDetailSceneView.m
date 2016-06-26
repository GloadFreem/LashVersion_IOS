//
//  ProjectDetailSceneView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/16.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailSceneView.h"
#import "ProjectDetailSceneMessageCell.h"
#import "ProjectDetailSceneRightCell.h"

@implementation ProjectDetailSceneView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


-(void)createUI
{
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [_tableView setTableHeaderView:[self createHeaderView]];
    [_tableView setTableFooterView:[self createFooterView]];
}
-(UIView*)createHeaderView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView * lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    lightView.backgroundColor = [UIColor lightGrayColor];
    lightView.alpha = 0.3;
    [headerView addSubview:lightView];
    
    UIButton * startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
    startBtn.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27);
        make.centerY.mas_equalTo(headerView.mas_centerY).offset(10);
        
    }];
    
    UISlider *slider =[[UISlider alloc]init];
    [headerView addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(startBtn.mas_right).offset(20);
        make.centerY.mas_equalTo(headerView.mas_centerY).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    UILabel *label =[[UILabel alloc]init];
    label.text = @"01:12:23";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.font =[UIFont systemFontOfSize:12];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(slider.mas_right).offset(10);
        make.centerY.mas_equalTo(headerView.mas_centerY).offset(10);
    }];
    
    return headerView;
}

-(UIView*)createFooterView
{
    UIView * footer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    UITextView * text = [[UITextView alloc]init];
    [footer addSubview:text];
    
    UIButton * btn =[[UIButton alloc]init];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [footer addSubview:btn];
    
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(btn.mas_left).offset(5);
    }];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footer.mas_top);
        make.right.mas_equalTo(footer.mas_right);
        make.bottom.mas_equalTo(footer.mas_bottom);
        make.width.mas_equalTo(75);
    }];
    return footer;
    
}

#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"ProjectDetailSceneMessageCell";
    ProjectDetailSceneMessageCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        
    }
    return cell;
    
}

@end
