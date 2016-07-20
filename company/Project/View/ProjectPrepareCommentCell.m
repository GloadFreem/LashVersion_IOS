//
//  ProjectPrepareCommentCell.m
//  company
//
//  Created by Eugene on 16/6/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPrepareCommentCell.h"

@implementation ProjectPrepareCommentCell

{
    UIImageView *_icon;
    UILabel *_name;
    UILabel *_time;
    UILabel *_content;
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
    _icon = [UIImageView new];
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    _icon.layer.cornerRadius = 16.5;
    _icon.layer.masksToBounds = YES;
    
    _name = [UILabel new];
    _name.font = BGFont(14);
    _name.textColor = [UIColor darkTextColor];
    _name.textAlignment = NSTextAlignmentLeft;
    
    _time = [UILabel new];
    _time.textAlignment = NSTextAlignmentLeft;
    _time.textColor = color74;
    _time.font = BGFont(10);
    
    _content = [UILabel new];
    _content.textColor = color47;
    _content.textAlignment = NSTextAlignmentLeft;
    _content.font = BGFont(14);
    
    NSArray *views = @[_icon, _name, _time, _content];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _icon.sd_layout
    .leftSpaceToView(contentView,17*WIDTHCONFIG)
    .topSpaceToView(contentView,25)
    .widthIs(33)
    .heightIs(33);
    
    _name.sd_layout
    .leftSpaceToView(_icon,10*WIDTHCONFIG)
    .topSpaceToView(contentView,23)
    .heightIs(14);
    [_name setSingleLineAutoResizeWithMaxWidth:150];
    
    _time.sd_layout
    .leftEqualToView(_name)
    .topSpaceToView(_name,5)
    .heightIs(10);
    [_time setSingleLineAutoResizeWithMaxWidth:200];
    
    _content.sd_layout
    .leftEqualToView(_name)
    .topSpaceToView(_time,11)
    .rightSpaceToView(contentView,10)
    .autoHeightRatio(0);

    [self setupAutoHeightWithBottomView:_content bottomMargin:20];
}

-(void)setModel:(ProjectSceneCommentModel *)model
{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.users.headSculpture]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    _name.text = model.users.name;
    [_name sizeToFit];
    _time.text = model.commentDate;
    [_time sizeToFit];
    _content.text = model.content;
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
