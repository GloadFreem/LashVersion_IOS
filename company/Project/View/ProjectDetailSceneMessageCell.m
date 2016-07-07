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
    
    _contentLabel = [UILabel new];
    _contentLabel.font = BGFont(14);
    
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.layer.cornerRadius = 2;
    _contentLabel.layer.masksToBounds = YES;
    
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor lightGrayColor];
    _timeLabel.layer.cornerRadius = 2;
    _timeLabel.layer.masksToBounds = YES;
    
    NSArray *views = @[_iconImage, _nameLabel, _contentLabel, _timeLabel];
    [self.contentView sd_addSubviews:views];
}

-(void)setModel:(ProjectDetailSceneCellModel *)model
{
    _model = model;
    //如果不是自己  靠左布局
    
    //头像
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.iconImage]] placeholderImage:[UIImage new]];
    _nameLabel.text = model.name;
    [_nameLabel sizeToFit];
    _contentLabel.text = model.content;
    
    //    NSLog(@"--------%@",model.time);
    NSArray *arr1 = [model.time componentsSeparatedByString:@" "];
    NSString *str1 = arr1[1];
    NSString *str2 = [str1 substringToIndex:5];
    _timeLabel.text = str2;
    [_timeLabel sizeToFit];
    
//    if (_model.flag) {
    
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
        
        _contentLabel.sd_layout
        .topSpaceToView(self.contentView,25)
        .rightSpaceToView(_iconImage,15)
        .autoHeightRatio(0)
        .widthIs(240*WIDTHCONFIG);
    
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        
        _contentLabel.backgroundColor = colorBlue;
        _contentLabel.textColor = [UIColor whiteColor];
//        NSLog(@"自己说的");
    
//    }else{
//        _iconImage.sd_layout
//        .leftSpaceToView(self.contentView,17)
//        .topSpaceToView(self.contentView,20)
//        .widthIs(33)
//        .heightIs(33);
//        
//        _nameLabel.sd_layout
//        .centerXEqualToView(_iconImage)
//        .heightIs(12)
//        .topSpaceToView(_iconImage,5);
//        [_nameLabel setSingleLineAutoResizeWithMaxWidth:100];
//        
//        
//        _contentLabel.sd_layout
//        .topSpaceToView(self.contentView,25)
//        .leftSpaceToView(_iconImage,15)
//        .widthIs(240*WIDTHCONFIG)
//        .autoHeightRatio(0);
//        _contentLabel.textAlignment = NSTextAlignmentLeft;
//        _contentLabel.textColor = [UIColor blackColor];
//        _contentLabel.backgroundColor = [UIColor whiteColor];
//        NSLog(@"别人说的");
//    }
    
    _timeLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .widthIs(50)
    .heightIs(18)
    .topSpaceToView(_contentLabel,25);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    [_contentLabel sizeToFit];
    
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:10*HEIGHTCONFIG];
    
    [self layoutSubviews];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
