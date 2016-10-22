//
//  HeadlineBottomImgCell.m
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeadlineBottomImgCell.h"
#import "Headline.h"

const CGFloat marginLeft = 17;

@interface HeadlineBottomImgCell ()
/** 标题 */
@property (nonatomic, strong) UILabel *titleL;
/** 信息类型 */
@property (nonatomic, strong) UILabel *typeL;
/** 来源和日期 */
@property (nonatomic, strong) UILabel *sourceAndDateL;
/** 底部的图片 */
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation HeadlineBottomImgCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HeadlineBottomImgCell";
    HeadlineBottomImgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HeadlineBottomImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 10, SCREENWIDTH-marginLeft*2, 30)];
        _titleL.font = [UIFont systemFontOfSize:17];
        _titleL.numberOfLines = 0;
        _titleL.textColor = RGBCOLOR(0, 0, 0);
        [self.contentView addSubview:_titleL];
        
        _typeL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.x, CGRectGetMaxY(_titleL.frame)+5, 80, 25)];
        _typeL.font = [UIFont systemFontOfSize:11];
        _typeL.textAlignment = NSTextAlignmentCenter;
        _typeL.layer.cornerRadius = _typeL.height*0.5;
        _typeL.layer.masksToBounds = YES;
        _typeL.layer.borderWidth = 1;
        [self.contentView addSubview:_typeL];
        
        CGFloat dateLW = 200;
        _sourceAndDateL = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - marginLeft-dateLW, _typeL.y, dateLW, _typeL.height)];
        _sourceAndDateL.font = [UIFont systemFontOfSize:12];
        _sourceAndDateL.textAlignment = NSTextAlignmentRight;
        _sourceAndDateL.textColor = RGBCOLOR(116, 116, 116);
        [self.contentView addSubview:_sourceAndDateL];
        
        CGFloat imgViewX = 8;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, CGRectGetMaxY(_typeL.frame)+5, SCREENWIDTH-imgViewX*2, 170)];
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
