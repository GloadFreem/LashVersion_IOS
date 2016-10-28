//
//  HeaderNoneImageCell.m
//  company
//
//  Created by Eugene on 2016/10/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeaderNoneImageCell.h"

@implementation HeaderNoneImageCell

{
    UILabel *_titleLabel;
    UILabel *_typeLabel;
    UILabel *_timeLabel;
    UIImageView *_imageView;
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
    
    _typeLabel = [UILabel new];
    _typeLabel.font = BGFont(11);
    _typeLabel.layer.cornerRadius = 3;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.borderWidth = 0.5;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(11);
    _timeLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor  = [TDUtil colorWithHexString:@"dcdcdc"];
    
    
    NSArray *views = @[_titleLabel, _typeLabel, _timeLabel, _bottomLine];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat leftMargin = 17;
//    CGFloat topMargin = 9;
    CGFloat bottomMargin = 15;
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, leftMargin*WIDTHCONFIG)
    .topSpaceToView(contentView, 15*HEIGHTCONFIG)
    .rightSpaceToView(contentView, leftMargin*WIDTHCONFIG)
    .autoHeightRatio(0);
    
    _typeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .topSpaceToView(_titleLabel, 7*HEIGHTCONFIG)
    .heightIs(16*HEIGHTCONFIG);
    [_typeLabel setSingleLineAutoResizeWithMaxWidth:80*WIDTHCONFIG];
    
    _timeLabel.sd_layout
    .leftSpaceToView(_typeLabel,6*WIDTHCONFIG)
    .centerYEqualToView(_typeLabel)
    .heightIs(11);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120*WIDTHCONFIG];
    
    _bottomLine.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .heightIs(0.5)
    .topSpaceToView(_typeLabel, bottomMargin*HEIGHTCONFIG);
    
}

-(void)setPointModel:(TankPointModel *)pointModel
{
    if (pointModel) {
        _pointModel = pointModel;
        _titleLabel.text = pointModel.title;
        [_titleLabel sizeToFit];
        
        _typeLabel.text = [NSString stringWithFormat:@" %@ ",pointModel.oringl];
//        [_typeLabel sizeToFit];
        
        if ([pointModel.oringl isEqualToString:@"观点"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"5bc934"].CGColor;
            _typeLabel.textColor = [TDUtil colorWithHexString:@"5bc934"];
        }
        if ([pointModel.oringl isEqualToString:@"分析"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"2083ff"].CGColor;
            _typeLabel.textColor = [TDUtil colorWithHexString:@"2083ff"];
        }
        if ([pointModel.oringl isEqualToString:@"报告"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"ea8888"].CGColor;
            _typeLabel.textColor = [TDUtil colorWithHexString:@"ea8888"];
        }

        _timeLabel.text = [TDUtil getDateCha:pointModel.publicDate];
        [_timeLabel sizeToFit];
        
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }

}
-(void)setHeaderModel:(TankHeaderModel *)headerModel
{
    if (headerModel) {
        _headerModel = headerModel;
        _titleLabel.text = headerModel.title;
        [_titleLabel sizeToFit];
        
        _typeLabel.text = [NSString stringWithFormat:@" %@ ",headerModel.contenttype.name];
        if ([headerModel.contenttype.name isEqualToString:@"投资建议"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"5bc934"].CGColor;
            _typeLabel.textColor = [TDUtil colorWithHexString:@"5bc934"];
        }
        if ([headerModel.contenttype.name isEqualToString:@"投资学院"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"2083ff"].CGColor;
            _typeLabel.textColor = [TDUtil colorWithHexString:@"2083ff"];
        }
        if ([headerModel.contenttype.name isEqualToString:@"金日投条"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"ea8888"].CGColor;
            _typeLabel.textColor = [TDUtil colorWithHexString:@"ea8888"];
        }
        
        _timeLabel.text = [TDUtil getDateCha:headerModel.createDate];
        [_timeLabel sizeToFit];
        
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
