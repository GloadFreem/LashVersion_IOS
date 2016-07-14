//
//  ActivityDetailListCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailListCell.h"

@implementation ActivityDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _headerImgView.layer.cornerRadius = 25;
    _headerImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ActivityAttendModel *)model
{
    _model = model;
    
    if(_model)
    {
        if(_model.users.authentics && _model.users.authentics.count>0)
        {
            ActivityAuthentics * authentic = [_model.users.authentics objectAtIndex:0];
            
            [self.nameLabel setText:authentic.name];
            [self.positionLabel setText:[NSString stringWithFormat:@"%@%@",authentic.companyName,authentic.position]];
            [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:model.users.headSculpture]];
            
            //时间
            NSString * str = [TDUtil dateTimeFromString:model.enrollDate];
            [self.timeLabel setText:str];
        }
        
        
    }
}

@end
