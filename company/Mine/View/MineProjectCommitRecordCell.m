//
//  MineProjectCommitRecordCell.m
//  company
//
//  Created by Eugene on 16/6/30.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineProjectCommitRecordCell.h"

@implementation MineProjectCommitRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconImage.layer.cornerRadius = 25;
    _iconImage.layer.masksToBounds = YES;
    
}

-(void)setModel:(MineProjectCommitRecordBaseModel *)model
{
    _model = model;
    CommitAuthentics *authentics = model.user.authentics[0];
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.user.headSculpture]] placeholderImage:[UIImage new]];
    _nameLabel.text = authentics.name;
    _positionLabel.text = authentics.position;
    _timeLabel.text = model.record.recordDate;
    
    _statuslabel.text = model.record.status.name;
    if ([model.record.status.name isEqualToString:@"未查看"]) {
        _statuslabel.textColor = [UIColor redColor];
    }else{
        _statuslabel.textColor = [UIColor darkGrayColor];;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
