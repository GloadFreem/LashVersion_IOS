//
//  CircleDetailCommentCell.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleDetailCommentCell.h"
#import "TDUtil.h"
@implementation CircleDetailCommentCell
{
    UIImageView *_iconImage;
    UILabel *_namelabel;
    UILabel *_timelabel;
    UILabel *_contentLabel;
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
    _iconImage = [UIImageView new];
    _iconImage.layer.cornerRadius = 17;
    _iconImage.layer.masksToBounds = YES;
    
    _namelabel = [UILabel new];
    _namelabel.font = BGFont(13);
    _namelabel.textColor = [UIColor blackColor];
    _namelabel.textAlignment = NSTextAlignmentLeft;
    
    _timelabel = [UILabel new];
    _timelabel.font = BGFont(10);
    _timelabel.textColor = color74;
    _timelabel.textAlignment = NSTextAlignmentLeft;
    
    _contentLabel = [UILabel new];
    _contentLabel.font = BGFont(13);
    _contentLabel.textColor = color47;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    
    _bottomLine = [UIView new];
    [_bottomLine setBackgroundColor:color74];
    
    _bottomView = [UIView new];
    [_bottomView setBackgroundColor:colorGray];
    
    NSArray *views = @[_iconImage, _namelabel, _timelabel, _contentLabel,_bottomLine,_bottomView];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _iconImage.sd_layout
    .leftSpaceToView(contentView, 12*WIDTHCONFIG)
    .topSpaceToView(contentView, 12*HEIGHTCONFIG)
    .widthIs(35)
    .heightIs(35);
    
    _namelabel.sd_layout
    .leftSpaceToView(_iconImage, 10*WIDTHCONFIG)
    .topSpaceToView(contentView, 11*HEIGHTCONFIG)
    .heightIs(13);
    [_namelabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _timelabel.sd_layout
    .leftEqualToView(_namelabel)
    .topSpaceToView(_namelabel, 5*HEIGHTCONFIG)
    .heightIs(10);
    [_timelabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _contentLabel.sd_layout
    .leftEqualToView(_namelabel)
    .topSpaceToView(_timelabel, 10*HEIGHTCONFIG)
    .rightSpaceToView(contentView,12)
    .autoHeightRatio(0);
    
    _bottomLine.sd_layout
    .leftSpaceToView(contentView,12)
    .bottomEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(0.5);
    
    _bottomView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(10)
    .bottomEqualToView(contentView);
}

-(void)setModel:(CircleDetailCommentModel *)model
{
    _model = model;
    
    //头像
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.iconImageStr]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    
    _namelabel.text = model.nameStr;
    [_namelabel sizeToFit];
    
    NSString *str = [TDUtil getDateCha:model.publicDate];
    _timelabel.text = str;
    [_timelabel sizeToFit];
    
    _contentLabel.text = model.contentStr;
    
    [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:15*HEIGHTCONFIG];
}

@end
