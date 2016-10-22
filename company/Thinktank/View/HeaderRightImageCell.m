//
//  HeaderRightImageCell.m
//  company
//
//  Created by Eugene on 2016/10/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeaderRightImageCell.h"

@implementation HeaderRightImageCell

{
    UILabel *_titleLabel;
    UILabel *_typeLabel;
    
    UILabel *_timeLabel;
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
    _rightImage = [UIImageView new];
    _rightImage .contentMode = UIViewContentModeScaleToFill;
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.numberOfLines = 2;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [TDUtil colorWithHexString:@"323232"];
    
    _typeLabel = [UILabel new];
    _typeLabel.font = BGFont(11);
    _typeLabel.layer.cornerRadius = 3;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.layer.borderWidth = 0.5;
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    _timeLabel.font = BGFont(11);
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor  = [TDUtil colorWithHexString:@"dcdcdc"];
    
    NSArray *views = @[_titleLabel, _typeLabel, _timeLabel, _rightImage, _bottomLine];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
//    CGFloat leftMargin = 17;
    //    CGFloat topMargin = 9;
//    CGFloat bottomMargin = 15;
    
    _rightImage.sd_layout
    .rightSpaceToView(contentView, 17*HEIGHTCONFIG)
    .topSpaceToView(contentView, 15*HEIGHTCONFIG)
    .widthIs(110 *WIDTHCONFIG)
    .heightIs(77*HEIGHTCONFIG);
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 17*WIDTHCONFIG)
    .topSpaceToView(contentView, 8*HEIGHTCONFIG)
    .rightSpaceToView(_rightImage, 10*WIDTHCONFIG)
    .heightIs(60);
    
    _typeLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_rightImage)
    .heightIs(16*HEIGHTCONFIG);
    [_typeLabel setSingleLineAutoResizeWithMaxWidth:80*WIDTHCONFIG];
    
    _timeLabel.sd_layout
    .leftSpaceToView(_typeLabel,6*WIDTHCONFIG)
    .centerYEqualToView(_typeLabel)
    .heightIs(11);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120*WIDTHCONFIG];
    
    _bottomLine.sd_layout
    .leftEqualToView(_titleLabel)
    .rightSpaceToView(contentView, 17*WIDTHCONFIG)
    .heightIs(0.5)
    .topSpaceToView(_typeLabel, 15*HEIGHTCONFIG);
    
}

-(void)setPointModel:(TankPointModel *)pointModel
{
    if (pointModel) {
        _pointModel = pointModel;
        _titleLabel.text = pointModel.title;
//        [_titleLabel sizeToFit];
        
        _typeLabel.text = [NSString stringWithFormat:@" %@ ",pointModel.oringl];
//        [_typeLabel sizeToFit];
        if ([pointModel.oringl isEqualToString:@"观点"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"5bc934"].CGColor;
        }
        if ([pointModel.oringl isEqualToString:@"分析"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"2083ff"].CGColor;
        }
        if ([pointModel.oringl isEqualToString:@"报告"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"ea8888"].CGColor;
        }

        _timeLabel.text = [TDUtil getDateCha:pointModel.publicDate];
        [_timeLabel sizeToFit];
        NSString *imageUrl;
        if (pointModel.originalImgs.count) {
            imageUrl = [NSString stringWithFormat:@"%@",pointModel.originalImgs[0][@"url"]];
        }
        [_rightImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }
}

-(void)setHeaderModel:(TankHeaderModel *)headerModel
{
    if (headerModel) {
        _headerModel = headerModel;
        _titleLabel.text = headerModel.title;
//        [_titleLabel sizeToFit];
        
        _typeLabel.text = [NSString stringWithFormat:@" %@ ",headerModel.contenttype.name];
        if ([headerModel.contenttype.name isEqualToString:@"投资建议"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"5bc934"].CGColor;
        }
        if ([headerModel.contenttype.name isEqualToString:@"投资学院"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"2083ff"].CGColor;
        }
        if ([headerModel.contenttype.name isEqualToString:@"今日投条"]) {
            _typeLabel.layer.borderColor = [TDUtil colorWithHexString:@"ea8888"].CGColor;
        }
        
        _timeLabel.text = [TDUtil getDateCha:headerModel.createDate];
        [_timeLabel sizeToFit];
        NSString *imageUrl;
        if (headerModel.webcontentimageses.count) {
            imageUrl = [NSString stringWithFormat:@"%@",headerModel.webcontentimageses[0][@"url"]];
        }
        [_rightImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
