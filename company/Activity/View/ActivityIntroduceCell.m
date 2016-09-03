//
//  ActivityIntroduceCell.m
//  company
//
//  Created by LiLe on 16/8/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityIntroduceCell.h"
#import "ActionIntroduceFrame.h"
#import "ActionIntroduce.h"

@interface ActivityIntroduceCell ()
{
    UILabel *contextL;
}

@end
@implementation ActivityIntroduceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"actionIntro";
    ActivityIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ActivityIntroduceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        contextL = [[UILabel alloc] init];
        contextL.numberOfLines = 0;
        contextL.font = [UIFont systemFontOfSize:13];
        contextL.textColor = RGBCOLOR(71, 71, 71);
        [self.contentView addSubview:contextL];
    }
    return self;
}

- (void)setActionIntroF:(ActionIntroduceFrame *)actionIntroF
{
    _actionIntroF = actionIntroF;
    
    [_actionIntroF setActionIntro:_actionIntroF.actionIntro];
    
    ActionIntroduce *actionIntro = _actionIntroF.actionIntro;
    
//    self.backgroundColor = [UIColor yellowColor];
    contextL.text = actionIntro.content;
    contextL.frame = _actionIntroF.contextLF;
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:actionIntro.content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:12];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [actionIntro.content length])];
    contextL.attributedText = attributedString;
    
//    if (actionIntro.introduceId == 1) {
//        contextL.frame = CGRectMake(contextL.x, contextL.y+15, contextL.width, contextL.height);
//    }
//    
}


@end

@interface ActivityIntroduceImgCell ()
{
    UIImageView *imgV;
}

@end

@implementation ActivityIntroduceImgCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"actionIntroImg";
    ActivityIntroduceImgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ActivityIntroduceImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 170)];
        [self.contentView addSubview:imgV];
        
    }
    return self;
}

- (void)setActionIntro:(ActionIntroduce *)actionIntro
{
    _actionIntro = actionIntro;
    // http://img4.imgtn.bdimg.com/it/u=42046925,1559346389&fm=11&gp=0.jpg
    [imgV sd_setImageWithURL:[NSURL URLWithString:_actionIntro.content] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
}



@end
