//
//  TankRightImageCell.m
//  company
//
//  Created by Eugene on 2016/10/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankRightImageCell.h"

@implementation TankRightImageCell

{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_originalLabel;
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
    _imageView = [UIImageView new];
    _imageView .contentMode = UIViewContentModeScaleToFill;
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [TDUtil colorWithHexString:@"323232"];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
    
    _originalLabel = [UILabel new];
    _originalLabel.font  = BGFont(11);
    _originalLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [TDUtil colorWithHexString:@"747474"];
    _timeLabel.font = BGFont(11);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor  = [TDUtil colorWithHexString:@"dcdcdc"];
    
    NSArray *views = @[_titleLabel, _imageView, _timeLabel, _bottomLine, _originalLabel];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _imageView.sd_layout
    .rightSpaceToView(contentView, 17*HEIGHTCONFIG)
    .topSpaceToView(contentView, 15*HEIGHTCONFIG)
    .widthIs(110 *WIDTHCONFIG)
    .heightIs(77*HEIGHTCONFIG);
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 17*WIDTHCONFIG)
    .topSpaceToView(contentView, 8*HEIGHTCONFIG)
    .rightSpaceToView(_imageView, 10*WIDTHCONFIG)
    .heightIs(60);
    
    _originalLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_imageView)
    .heightIs(11);
    [_originalLabel setSingleLineAutoResizeWithMaxWidth:160*WIDTHCONFIG];
    
    _timeLabel.sd_layout
    .leftSpaceToView(_originalLabel, 0)
    .centerYEqualToView(_originalLabel)
    .heightIs(11);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120*WIDTHCONFIG];
    
    _bottomLine.sd_layout
    .leftEqualToView(_titleLabel)
    .rightSpaceToView(contentView, 17*WIDTHCONFIG)
    .heightIs(0.5)
    .topSpaceToView(_imageView, 15*HEIGHTCONFIG);
    
}

-(void)setModel:(TankModel *)model
{
    if (model) {
        _model = model;
        _titleLabel.text = model.title;
//        [_titleLabel sizeToFit];
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
        
        NSString *imageUrl;
        if (model.images.count) {
            imageUrl = [NSString stringWithFormat:@"%@",model.images[0]];
        }
//        NSLog(@"图片---%@",imageUrl);
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
