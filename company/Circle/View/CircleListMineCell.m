//
//  CircleListMineCell.m
//  company
//
//  Created by Eugene on 16/8/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleListMineCell.h"

@implementation CircleListMineCell

{
    UIView *_topView;
    UIImageView *_iconImage;
    UILabel *_titleLabel;
    UIImageView *_arrowImage;
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
    [_topView setBackgroundColor:colorGray];
    [self.contentView addSubview:_topView];
    
    _topView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(10);
    
    _iconImage = [UIImageView new];
    _iconImage.layer.cornerRadius = 40;
    _iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImage];
    
    _iconImage.sd_layout
    .leftSpaceToView(self.contentView,8)
    .centerYEqualToView(self.contentView)
    .widthIs(40)
    .heightIs(40);
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"我的话题";
    _titleLabel.font = BGFont(19);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = color(50, 50, 50, 1);
    [self.contentView addSubview:_titleLabel];
    
    _titleLabel.sd_layout
    .leftSpaceToView(_iconImage,10)
    .centerYEqualToView(_iconImage)
    .heightIs(19);
    
    _arrowImage = [UIImageView new];
    _arrowImage.image = [UIImage imageNamed:@"icon_right"];
    [self.contentView addSubview:_arrowImage];
    
    _arrowImage.sd_layout
    .rightSpaceToView(self.contentView,12)
    .centerYEqualToView(_iconImage)
    .widthIs(9)
    .heightIs(15);
    
}

-(void)setIconStr:(NSString *)iconStr
{
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",iconStr]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
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
