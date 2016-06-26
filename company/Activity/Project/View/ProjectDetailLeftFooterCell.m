//
//  ProjectDetailLeftFooterCell.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftFooterCell.h"

@implementation ProjectDetailLeftFooterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    
    CGFloat leftSpace = 22.5 * WIDTHCONFIG;
    CGFloat width = 50 * WIDTHCONFIG;
    CGFloat space = (SCREENWIDTH - 45 * WIDTHCONFIG  - width * modelArray.count) /(modelArray.count - 1);
    NSInteger i = 0;
    for (; i < modelArray.count; i++) {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(leftSpace + (width + space) * i, 15, width, width);
        [self.contentView addSubview:btn];
        
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = BGFont(12);
        label.numberOfLines = 2;
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn);
            make.top.mas_equalTo(btn.mas_bottom).offset(5);
            make.height.mas_equalTo(28);
            make.width.mas_equalTo(26);
        }];
        
    }
}
@end
