//
//  ProjectTagCell.m
//  company
//
//  Created by Eugene on 2016/11/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectTagCell.h"

@implementation ProjectTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [TDUtil colorWithHexString:@"f5f5f5"];
        
    }
    return self;
}

-(void)setup
{
    _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, SCREENWIDTH, 15)];
    _categoryLabel.font = BGFont(14);
    _categoryLabel.textColor = [TDUtil colorWithHexString:@"474747"];
    _categoryLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_categoryLabel];
    
    _tagView = [SKTagView new];
    [self.contentView addSubview:_tagView];
}

-(CGFloat)getCellHeight
{
    return _cellHeight + 40;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
