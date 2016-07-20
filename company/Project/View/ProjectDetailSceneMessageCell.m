//
//  ProjectDetailSceneMessageCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailSceneMessageCell.h"

@implementation ProjectDetailSceneMessageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = color(237, 238, 239, 1);
    }
    return self;
}
-(void)setup
{
    _iconImage = [UIImageView new];
    _iconImage.layer.cornerRadius = 16.5;
    _iconImage.layer.masksToBounds = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.font = BGFont(12);
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _contentBGView = [UIView new];
    _contentBGView.backgroundColor = colorBlue;
    _contentBGView.layer.cornerRadius = 3;
    
    _contentLabel = [UILabel new];
    _contentLabel.font = BGFont(14);
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor whiteColor];

    [_contentBGView addSubview:_contentLabel];
    
    
    _timeBGView = [UIView new];
    _timeBGView.backgroundColor = [UIColor lightGrayColor];
    _timeBGView.layer.cornerRadius = 3;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.layer.cornerRadius = 2;
    _timeLabel.layer.masksToBounds = YES;
    
    [_timeBGView addSubview:_timeLabel];
    
    NSArray *views = @[_iconImage, _nameLabel, _contentBGView, _timeBGView];
    [self.contentView sd_addSubviews:views];
    
    _iconImage.sd_layout
    .rightSpaceToView(self.contentView,17)
    .topSpaceToView(self.contentView,20)
    .widthIs(33)
    .heightIs(33);
    
    _nameLabel.sd_layout
    .centerXEqualToView(_iconImage)
    .heightIs(12)
    .topSpaceToView(_iconImage,5);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _contentBGView.sd_layout
    .topSpaceToView(self.contentView,15)
    .rightSpaceToView(_iconImage,15)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .topSpaceToView(_contentBGView,10)
    .leftSpaceToView(_contentBGView,10)
    .autoHeightRatio(0);
    
    [_contentLabel setSd_maxWidth:[NSNumber numberWithFloat:240*WIDTHCONFIG]];
    
    [_contentBGView setupAutoWidthWithRightView:_contentLabel rightMargin:10];
    [_contentBGView setupAutoHeightWithBottomView:_contentLabel bottomMargin:10];
    
    _timeBGView.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(_contentBGView,20);
    
    _timeLabel.sd_layout
    .topSpaceToView(_timeBGView,3)
    .leftSpaceToView(_timeBGView,8)
    .autoHeightRatio(0);
    
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    [_timeBGView setupAutoWidthWithRightView:_timeLabel rightMargin:8];
    [_timeBGView setupAutoHeightWithBottomView:_timeLabel bottomMargin:3];

}

-(void)setModel:(ProjectDetailSceneCellModel *)model
{
    _model = model;
    //头像
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.iconImage]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    _nameLabel.text = model.name;
    [_nameLabel sizeToFit];
    _contentLabel.text = model.content;
    
    NSArray *arr1 = [model.time componentsSeparatedByString:@" "];
    NSString *str1 = arr1[1];
    NSString *str2 = [str1 substringToIndex:5];
    _timeLabel.text = str2;
    [_timeLabel sizeToFit];
    
    if (!model.isShowTime) {
        _timeBGView.height = 0;
    }
    [self setupAutoHeightWithBottomView:_timeBGView bottomMargin:10*HEIGHTCONFIG];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
