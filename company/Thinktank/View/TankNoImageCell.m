//
//  TankNoImageCell.m
//  company
//
//  Created by Eugene on 2016/10/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankNoImageCell.h"

@implementation TankNoImageCell

{
    UILabel * _titleLabel;
    UILabel * _originalLabel;
    UILabel * _timeLabel;
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
    
    _originalLabel = [UILabel new];
    _originalLabel.font  = BGFont(11);
    _originalLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(11);
    _timeLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor  = [TDUtil colorWithHexString:@"dcdcdc"];
    
    NSArray *views = @[_titleLabel, _originalLabel, _timeLabel, _bottomLine];
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
    .heightIs(11*HEIGHTCONFIG)
    .centerYEqualToView(_originalLabel);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120*WIDTHCONFIG];
    
    _bottomLine.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(0.5)
    .topSpaceToView(_originalLabel, bottomMargin*HEIGHTCONFIG);
    
    
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
        
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
