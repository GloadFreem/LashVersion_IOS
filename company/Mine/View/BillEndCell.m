//
//  BillEndCell.m
//  company
//
//  Created by Eugene on 16/7/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "BillEndCell.h"

@implementation BillEndCell
{
    UILabel *_endLabel;
    UIImageView *_calenderImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

-(void)setup
{
    _calenderImage = [UIImageView new];
    _calenderImage.image = [UIImage imageNamed:@"mine_gold_calender"];
    CGSize size = _calenderImage.image.size;
    
    _endLabel = [UILabel new];
    _endLabel.text = @"end";
    _endLabel.textColor = colorBlue;
    _endLabel.textAlignment = NSTextAlignmentCenter;
    _endLabel.font = BGFont(15);
    [_endLabel sizeToFit];
    //    _endLabel.backgroundColor = [UIColor greenColor];
    //    _endLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_endLabel];
    
    CGFloat width = size.width / 2;
    
    _endLabel.sd_layout
    .centerYEqualToView(self.contentView)
    .heightIs(15)
    .centerXIs(58+width);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
