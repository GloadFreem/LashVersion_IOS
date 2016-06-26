//
//  ProjectDetailLeftTeamCell.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftTeamView.h"

@implementation ProjectDetailLeftTeamView
{
    UIScrollView *_scrollView1;
    UIScrollView *_scrollView2;
    UIView *_topView;
    UIImageView *_teamImage;
    UILabel *_teamLabel;
    UIView *_partLine;
    UIView *_bottomView1;
     UIView *_bottomView2;
}
-(instancetype)init
{
    if (self = [super init]) {
        [self setup];
        
//        [self loadData];
    }
    return self;
}


-(void)setup
{
    _topView = [UIView new];
    _topView.backgroundColor = colorGray;
    [self.contentView addSubview:_topView];
    
    _topView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(10);
    
    UIImage *teamImage = [UIImage imageNamed:@"friends"];
    _teamImage = [[UIImageView alloc]initWithImage:teamImage];
    _teamImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_teamImage];
    
    _teamImage.sd_layout
    .widthIs(20)
    .heightIs(20)
    .leftSpaceToView(self.contentView,13)
    .topSpaceToView(_topView,15);
    
    _teamLabel = [UILabel new];
    _teamLabel.text = @"团队";
    _teamLabel.textColor = [UIColor blackColor];
    _teamLabel .textAlignment = NSTextAlignmentLeft;
    _teamLabel.font = BGFont(18);
    [self.contentView addSubview:_teamLabel];
    
    _teamLabel.sd_layout
    .centerYEqualToView(_teamImage)
    .leftSpaceToView(_teamImage,6)
    .heightIs(18);
    
    [_teamLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _partLine = [UIView new];
    _partLine.backgroundColor = colorGray;
    [self.contentView addSubview:_partLine];
    
    _partLine.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(_teamImage,10)
    .heightIs(0.5);
    
    
    _scrollView1 = [UIScrollView new];
    _scrollView1.delegate = self;
    [self.contentView addSubview:_scrollView1];
    
    _scrollView1.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(_partLine,10)
    .heightIs(120);
    
    _bottomView1 = [UIView new];
    _bottomView1.backgroundColor = colorGray;
    [self.contentView addSubview:_bottomView1];
    
    
    _bottomView1.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_scrollView1,15)
    .rightEqualToView(self.contentView)
    .heightIs(10);
    
    _scrollView2 = [UIScrollView new];
    _scrollView2.delegate = self;
    [self.contentView addSubview:_scrollView2];
    
    _scrollView2.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(_bottomView1,10)
    .heightIs(120);
    
    
    _bottomView2 = [UIView new];
    _bottomView2.backgroundColor = colorGray;
    [self.contentView addSubview:_bottomView2];
    
    
    _bottomView2.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(_scrollView2,15)
    .rightEqualToView(self.contentView)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:_bottomView2 bottomMargin:0];
}

-(void)setTeamModelArray:(NSMutableArray *)teamModelArray
{
    _teamModelArray = teamModelArray;
    
    NSInteger i = 0;
    CGFloat width = 50;
    CGFloat spaceMargin = 26;
    UILabel *positionLabel;
    for (; i < teamModelArray.count; i++) {
        DetailTeams *team  = teamModelArray[i];
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0 + i*(width + spaceMargin), 23, width, width);
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        
//        [btn setBackgroundImage:IMAGENAMED(@"Avatar-sample-165") forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",team.icon]] forState:UIControlStateNormal placeholderImage:[UIImage new]];
        [_scrollView1 addSubview:btn];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = color47;
        nameLabel.font = BGFont(13);
        
        nameLabel.text = [NSString stringWithFormat:@"%@",team.name];
        
        [_scrollView1 addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(12);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(13);
        }];
        
        positionLabel = [UILabel new];
        positionLabel.textAlignment = NSTextAlignmentCenter;
        positionLabel.textColor = color74;
        positionLabel.font = BGFont(11);
        
        positionLabel.text = [NSString stringWithFormat:@"%@",team.position];
        
        [_scrollView1 addSubview:positionLabel];
        [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(11);
        }];
    }
    
    CGFloat widOff = 30 + (width + spaceMargin) * i + 30;
    _scrollView1.contentSize = CGSizeMake(widOff, 120);
}

-(void)setExtrModelArray:(NSMutableArray *)extrModelArray
{
    _extrModelArray = extrModelArray;
    NSInteger i = 0;
    CGFloat width = 50;
    CGFloat spaceMargin = 26;
    for (; i < extrModelArray.count; i++) {
        DetailExtr *extr = extrModelArray[i];
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0 + i*(width + spaceMargin), 23, width, width);
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        
//        [btn setBackgroundImage:IMAGENAMED(@"Avatar-sample-165") forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",extr.icon]] forState:UIControlStateNormal placeholderImage:[UIImage new]];
        [_scrollView2 addSubview:btn];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = color47;
        nameLabel.font = BGFont(13);
        nameLabel.numberOfLines = 2;
        NSString *start = [extr.content substringToIndex:2];
        NSString *end = [extr.content substringFromIndex:2];
        
        nameLabel.text = [NSString stringWithFormat:@"%@\n%@",start,end];
        
        [_scrollView2 addSubview:nameLabel];
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(btn.mas_bottom).offset(12);
//            make.centerX.mas_equalTo(btn);
//            make.height.mas_equalTo(26);
//            make.width.mas_equalTo(width);
//        }];
        nameLabel.sd_layout
        .topSpaceToView(btn,12)
        .centerXEqualToView(btn)
        .widthIs(width)
        .autoHeightRatio(0);
        
    }
    
    CGFloat widOff = (width + spaceMargin) * i - spaceMargin;
    _scrollView2.contentSize = CGSizeMake(widOff, 120);
}
-(void)setModel:(ProjectDetailLeftTeamModel *)model
{
    _model = model;
    NSInteger i = 0;
    CGFloat width = 50;
    CGFloat spaceMargin = 26;
    UILabel *positionLabel;
    for (; i < 10; i++) {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0 + i*(width + spaceMargin), 23, width, width);
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        
        [btn setBackgroundImage:IMAGENAMED(@"Avatar-sample-165") forState:UIControlStateNormal];
        
        [_scrollView1 addSubview:btn];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = color47;
        nameLabel.font = BGFont(13);
        
        nameLabel.text = @"王明";
        
        [_scrollView1 addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(12);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(13);
        }];
        
        positionLabel = [UILabel new];
        positionLabel.textAlignment = NSTextAlignmentCenter;
        positionLabel.textColor = color74;
        positionLabel.font = BGFont(11);
        
        positionLabel.text = @"经理";
        
        [_scrollView1 addSubview:positionLabel];
        [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(11);
        }];
    }
    
    CGFloat widOff = 30 + (width + spaceMargin) * i + 30;
    _scrollView1.contentSize = CGSizeMake(widOff, 120);
    
    i = 0;
    width = 50;
    spaceMargin = 26;
    for (; i < 10; i++) {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0 + i*(width + spaceMargin), 23, width, width);
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        
        [btn setBackgroundImage:IMAGENAMED(@"Avatar-sample-165") forState:UIControlStateNormal];
        
        [_scrollView2 addSubview:btn];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = color47;
        nameLabel.font = BGFont(13);
        
        nameLabel.text = @"商业";
        
        [_scrollView2 addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(12);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(13);
        }];
        
        positionLabel = [UILabel new];
        positionLabel.textAlignment = NSTextAlignmentCenter;
        positionLabel.textColor = color74;
        positionLabel.font = BGFont(11);
        
        positionLabel.text = @"计划";
        
        [_scrollView2 addSubview:positionLabel];
        [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(11);
        }];
    }
    
    widOff = 30 + (width + spaceMargin) * i + 30;
    _scrollView2.contentSize = CGSizeMake(widOff, 120);
}


-(void)loadData
{
    ProjectDetailLeftTeamModel * model = [ProjectDetailLeftTeamModel new];
    
    [self setModel:model];
}

@end
