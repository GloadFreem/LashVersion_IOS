//
//  ProjectDetailLeftTeamCell.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftTeamCell.h"

@implementation ProjectDetailLeftTeamCell
{
    UIScrollView *_scrollView;
    UIView *_topView;
    UIImageView *_teamImage;
    UILabel *_teamLabel;
    UIView *_partLine;
    UIView *_bottomView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


-(void)setup
{
    _topView = [UIView new];
    _topView.backgroundColor = colorGray;
    [self.contentView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UIImage *teamImage = [UIImage imageNamed:@"friends"];
    _teamImage = [[UIImageView alloc]initWithImage:teamImage];
    _teamImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_teamImage];
    [_teamImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(_topView.mas_bottom).offset(15);
    }];
    
    _teamLabel = [UILabel new];
    _teamLabel.text = @"团队";
    _teamLabel.textColor = [UIColor blackColor];
    _teamLabel .textAlignment = NSTextAlignmentLeft;
    _teamLabel.font = BGFont(18);
    [self.contentView addSubview:_teamLabel];
    [_teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_teamImage);
        make.left.mas_equalTo(_teamImage.mas_right).offset(6);
        make.height.mas_equalTo(18);
    }];
    
    _partLine = [UIView new];
    _partLine.backgroundColor = colorGray;
    [self.contentView addSubview:_partLine];
    [_partLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(_teamImage.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_partLine.mas_bottom);
        make.height.mas_equalTo(120);
    }];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = colorGray;
    [self.contentView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_scrollView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
}

-(void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
   
     NSInteger i = 0;
    CGFloat width = 50;
    CGFloat spaceMargin = 26;
    for (; i < modelArray.count; i++) {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(30 + i*(width + spaceMargin), 23, width, width);
        btn.layer.cornerRadius = 25;
        btn.layer.masksToBounds = YES;
        
        [_scrollView addSubview:btn];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = color47;
        nameLabel.font = BGFont(13);

        [_scrollView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(12);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(13);
        }];
        
        UILabel *positionLabel = [UILabel new];
        positionLabel.textAlignment = NSTextAlignmentCenter;
        positionLabel.textColor = color74;
        positionLabel.font = BGFont(11);
        
        [_scrollView addSubview:positionLabel];
        [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(btn);
            make.height.mas_equalTo(11);
        }];
        
    }
    CGFloat widOff = 30 + (width + spaceMargin) * i + 30;
    _scrollView.contentSize = CGSizeMake(widOff, 0);
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
