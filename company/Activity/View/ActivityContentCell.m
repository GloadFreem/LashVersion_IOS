//
//  ActivityContentCell.m
//  company
//
//  Created by Eugene on 2016/9/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityContentCell.h"

@implementation ActivityContentCell
{
    UIView *_lastView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    
    }
    return self;
}

-(void)setup
{
    
}
-(void)setModel:(ActionDetailModel *)model
{
    _model = model;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
