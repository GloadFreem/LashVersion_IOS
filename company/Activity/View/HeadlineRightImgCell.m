//
//  HeadlineRightImgCell.m
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeadlineRightImgCell.h"
#import "Headline.h"

const CGFloat marginleft = 13;

@interface HeadlineRightImgCell ()
/** 标题 */
@property (nonatomic, strong) UILabel *titleL;
/** 信息类型 */
@property (nonatomic, strong) UILabel *typeL;
/** 来源和日期 */
@property (nonatomic, strong) UILabel *sourceAndDateL;
/** 底部的图片 */
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation HeadlineRightImgCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HeadlineRightImgCell";
    HeadlineRightImgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HeadlineRightImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = color(239, 239, 244, 1);
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat imgViewW = 130;
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(marginleft, 15, SCREENWIDTH-marginleft*2-8-imgViewW, 45)];
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.numberOfLines = 0;
        [self.contentView addSubview:_titleL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.x, CGRectGetMaxY(_titleL.frame)+5, 80, 25)];
        _typeL.font = [UIFont systemFontOfSize:11];
        _typeL.textAlignment = NSTextAlignmentCenter;
        _typeL.layer.cornerRadius = _typeL.height*0.5;
        _typeL.layer.masksToBounds = YES;
        _typeL.layer.borderWidth = 1;
        [self.contentView addSubview:_typeL];
        
        _sourceAndDateL = [[UILabel alloc] initWithFrame:CGRectMake(_typeL.x, CGRectGetMaxY(_typeL.frame)+10, _titleL.width, _typeL.height)];
        _sourceAndDateL.font = [UIFont systemFontOfSize:12];
        _sourceAndDateL.textColor = RGBCOLOR(116, 116, 116);
        [self.contentView addSubview:_sourceAndDateL];
        
        CGFloat imgViewX = SCREENWIDTH - 8 - imgViewW;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, _titleL.y, imgViewW, 100)];
        [self.contentView addSubview:_imgView];
        
    }
    return self;
}

- (void)setHeadline:(Headline *)headline
{
    _headline = headline;
    
    _titleL.text = _headline.title;
    _typeL.text = _headline.name;
    if ([_typeL.text isEqualToString:@"投条建议"]) {
        _typeL.textColor = RGBCOLOR(125, 198, 134);
    } else if ([_typeL.text isEqualToString:@"金日投条"]){
        _typeL.textColor = RGBCOLOR(215, 125, 129);
    } else {
        _typeL.textColor = RGBCOLOR(124, 157, 126);
    }
    _typeL.layer.borderColor = [_typeL.textColor CGColor];
    NSString *sourceAndDateStr = [NSString stringWithFormat:@"%@  %@", _headline.source, _headline.date];
    _sourceAndDateL.text = sourceAndDateStr;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:headline.imgName] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}
@end
