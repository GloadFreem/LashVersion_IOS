//
//  ActivityDetailExiciseContentCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailExiciseContentCell.h"

@implementation ActivityDetailExiciseContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ActivityViewModel *)model
{
    _model = model;
    
    if(_model)
    {
        //地址
        [self.addressLabel setText:_model.address];
        //人数限制
        [self.countLabel setText:STRING(@"%ld人", (long)_model.memberLimit)];
        //时间
        //获取时间
        NSDate *date = [TDUtil dateFromString:_model.startTime];
        NSString * dateStr = [TDUtil stringFromDate:date];
        //获取星期
        NSString * week = [TDUtil weekOfDate:dateStr];
        //时间:HS
        NSString * time = [TDUtil dateTimeFromString:_model.startTime];
        
        //时间
        [self.timeLabel setText:[NSString stringWithFormat:@"%@%@%@",dateStr,week,time]];
        
        
        //收费情况
        NSString * status = @"免费";
        if(model.type==0){
            status = @"收费";
        }
        [self.statusButton setTitle:status forState:UIControlStateNormal];
        
    }
}

@end
