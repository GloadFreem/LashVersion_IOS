//
//  MineGoldMingxiCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineGoldMingxiCell.h"

@implementation MineGoldMingxiCell
{
    UIImageView *_calenderImage;
    UIImageView *_lineImage;
    UILabel *_yearlabel;
    UILabel *_dayLabel;
    UIImageView *_whiteImage;
    UILabel *_titleLabel;
    UILabel *_numLabel;
    UILabel *_contentLabel;
    UIImageView *_secondLine;
    UIImageView *_point;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

-(void)setup
{
    _topContainerView = [UIView new];
    _topContainerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _topLine = [UIImageView new];
    _topLine.image = [UIImage imageNamed:@"mine_goldline"];
    [_topContainerView addSubview:_topLine];
    
    _calenderImage = [UIImageView new];
    _calenderImage.image = [UIImage imageNamed:@"mine_gold_calender"];
    [_topContainerView addSubview:_calenderImage];
    CGSize size = _calenderImage.image.size;
    
    _yearlabel = [UILabel new];
    _yearlabel.font = BGFont(17);
//    _yearlabel.backgroundColor = [UIColor orangeColor];
    [_topContainerView addSubview:_yearlabel];
    
    _lineImage = [UIImageView new];
    _lineImage.image = [UIImage imageNamed:@"mine_goldline"];
    [_topContainerView addSubview:_lineImage];
    
    _topLine.sd_layout
    .centerXEqualToView(_calenderImage)
    .bottomSpaceToView(_calenderImage,0)
    .widthIs(1)
    .topEqualToView(self.contentView);
    
    _calenderImage.sd_layout
    .leftSpaceToView(_topContainerView,40)
    .topSpaceToView(_topContainerView,19)
    .heightIs(28)
    .widthIs(28);
    
    _yearlabel.sd_layout
    .leftSpaceToView(_calenderImage,5)
    .centerYEqualToView(_calenderImage)
    .heightIs(17);
    [_yearlabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _lineImage.sd_layout
    .centerXEqualToView(_calenderImage)
    .topSpaceToView(_calenderImage,0)
    .heightIs(23)
    .widthIs(1);
    
    [self.contentView addSubview:_topContainerView];
    
    _topContainerView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView);  //高度显示在 setModel里边设置
    
    _point = [UIImageView new];
    _point.image = [UIImage imageNamed:@"mine_gold_point"];
    
    _dayLabel = [UILabel new];
    _dayLabel.font = BGFont(14);
    _dayLabel.textAlignment = NSTextAlignmentRight;
    
    _whiteImage = [UIImageView new];
    _whiteImage.image = [UIImage imageNamed:@"mine_gold_whitebg"];
    
    _secondLine = [UIImageView new];
    _secondLine.image = [UIImage imageNamed:@"mine_goldline"];
    
    [self.contentView sd_addSubviews:@[_dayLabel,_point,_secondLine,_whiteImage]];
    
    CGFloat width = size.width / 2;
   
    _point.sd_layout
    .leftSpaceToView(self.contentView,37 + width)
    .topSpaceToView(_topContainerView,5)
    .widthIs(4)
    .heightIs(4);
    
    _secondLine.sd_layout
    .topSpaceToView(_topContainerView,0)
    .centerXEqualToView(_point)
    .bottomEqualToView(self.contentView)
    .widthIs(1);
    
    _dayLabel.sd_layout
    .rightSpaceToView(_point,5)
    .centerYEqualToView(_point)
    .heightIs(14);
    
    _whiteImage.sd_layout
    .topSpaceToView(_topContainerView,5)
    .leftSpaceToView(_point,5)
    .heightIs(64)
    .rightSpaceToView(self.contentView,20);
    
    _titleLabel = [UILabel new];
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.font = BGFont(19);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = orangeColor;
    
    _numLabel = [UILabel new];
    _numLabel.font = BGFont(19);
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = orangeColor;
    
    _contentLabel = [UILabel new];
//    _contentLabel.backgroundColor = [UIColor greenColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = BGFont(14);
    
    [_whiteImage sd_addSubviews:@[_titleLabel,_numLabel,_contentLabel]];
    
    _titleLabel.sd_layout
    .leftSpaceToView(_whiteImage,9)
    .topSpaceToView(_whiteImage,10)
    .heightIs(19);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _numLabel.sd_layout
    .topSpaceToView(_whiteImage,12)
    .rightSpaceToView(_whiteImage,15)
    .heightIs(19);
    
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel,8)
    .heightIs(14);
    [_contentLabel setSingleLineAutoResizeWithMaxWidth:200];
}

-(void)setModel:(MineGoldMingxiModel *)model
{
    _model  = model;
    NSArray *arr = [model.tradeDate componentsSeparatedByString:@" "];
    NSArray *array = [arr[0] componentsSeparatedByString:@"-"];
    
    _yearlabel.text = [NSString stringWithFormat:@"%@年%@月",array[0],array[1]];
    if (array[2]) {
        _dayLabel.text = [NSString stringWithFormat:@"%@日",array[2]];
    }
    
    _titleLabel.text = model.rewardtradetype.name;
    _numLabel.text = [NSString stringWithFormat:@"+ %ld",model.count];
//    _contentLabel.text = model.contentStr;
    
    if (_model.isShow == YES) {
//        NSLog(@"设置高度");
        _calenderImage.hidden = NO;
        _topContainerView.sd_layout.heightIs(62);
    }else{
//        NSLog(@"高度为0");
        _calenderImage.hidden = YES;
        _topContainerView.fixedHeight = @0;
        _topContainerView.sd_layout.heightIs(0);
    }
    
    [self setupAutoHeightWithBottomView:_whiteImage bottomMargin:0];
}

@end
