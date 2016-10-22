//
//  TankMoreImageCell.m
//  company
//
//  Created by Eugene on 2016/10/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankMoreImageCell.h"

@implementation TankMoreImageCell

{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel * _originalLabel;
    UIImageView *_leftImage;
    UIImageView *_middleImage;
    UIImageView *_rightImage;
    UIView *_bottomLine;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //        self.layer.borderColor = colorGray.CGColor;
        //        self.layer.borderWidth = 0.01f;
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setup
{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [TDUtil colorWithHexString:@"323232"];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(11);
    _timeLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    
    _originalLabel = [UILabel new];
    _originalLabel.font  = BGFont(11);
    _originalLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    
    _leftImage = [UIImageView new];
    _leftImage.contentMode = UIViewContentModeScaleToFill;
    
    _middleImage = [UIImageView new];
    _middleImage.contentMode = UIViewContentModeScaleToFill;
    
    _rightImage = [UIImageView new];
    _rightImage.contentMode = UIViewContentModeScaleToFill;
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor  = [TDUtil colorWithHexString:@"dcdcdc"];
    
    NSArray *views = @[_titleLabel, _timeLabel, _originalLabel,_leftImage, _middleImage, _rightImage, _bottomLine];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat leftMargin = 17;
    CGFloat topMargin = 9;
    CGFloat bottomMargin = 15;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, leftMargin*WIDTHCONFIG)
    .topSpaceToView(contentView, 15*HEIGHTCONFIG)
    .rightSpaceToView(contentView, leftMargin*WIDTHCONFIG)
    .autoHeightRatio(0);
    
    _originalLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, topMargin*HEIGHTCONFIG)
    .heightIs(11);
    [_originalLabel setSingleLineAutoResizeWithMaxWidth:160*WIDTHCONFIG];
    
    _timeLabel.sd_layout
    .leftSpaceToView(_originalLabel, 0)
    .centerYEqualToView(_originalLabel)
    .heightIs(11*HEIGHTCONFIG);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120*WIDTHCONFIG];
    
    _leftImage.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_timeLabel, 10*HEIGHTCONFIG)
    .widthIs(110*WIDTHCONFIG)
    .heightIs(77*HEIGHTCONFIG);
    
    _rightImage.sd_layout
    .rightEqualToView(_titleLabel)
    .topEqualToView(_leftImage)
    .widthIs(110*WIDTHCONFIG)
    .heightIs(77*HEIGHTCONFIG);
    
    _middleImage.sd_layout
    .topEqualToView(_leftImage)
    .bottomEqualToView(_leftImage)
    .leftSpaceToView(_leftImage, 5.5*WIDTHCONFIG)
    .rightSpaceToView(_rightImage, 5.5*WIDTHCONFIG);
    
    _bottomLine.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(0.5)
    .topSpaceToView(_leftImage, bottomMargin*HEIGHTCONFIG);
    
}

-(void)setModel:(TankModel *)model
{
    if (model) {
        _model = model;
        _titleLabel.text = model.title;
        [_titleLabel sizeToFit];
        
        NSString *str;
        if (model.oringl.length > 0) {
            str = [model.oringl stringByAppendingString:@" · "];
        }
        _originalLabel.text = str;
        [_originalLabel sizeToFit];
        
        NSString *time = [TDUtil getDateCha:model.publicDate];
        if (time.length <= 0) {
            time = model.publicDate;
        }
        _timeLabel.text = time;
        [_timeLabel sizeToFit];
        
        NSString *leftUrl;
        NSString *middleUrl;
        NSString *rightUrl;
        if (model.images[0]) {
            leftUrl = [NSString stringWithFormat:@"%@",model.images[0]];
        }
        [_leftImage sd_setImageWithURL:[NSURL URLWithString:leftUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        if (model.images[1]) {
            middleUrl = [NSString stringWithFormat:@"%@",model.images[1]];
        }
        [_middleImage sd_setImageWithURL:[NSURL URLWithString:middleUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        if (model.images[2]) {
            rightUrl = [NSString stringWithFormat:@"%@",model.images[2]];
        }
        [_rightImage sd_setImageWithURL:[NSURL URLWithString:rightUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
