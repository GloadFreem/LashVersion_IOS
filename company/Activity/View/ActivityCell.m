//
//  ActivityCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)AtendAction:(id)sender {
    if([_delegate respondsToSelector:@selector(attendAction:)])
    {
        [_delegate attendAction:self.model];
    }
}

-(void)setModel:(ActivityViewModel *)model
{
    _model = model;
    
    if(_model)
    {
        //标题
        [self.titleLabel setText:_model.name];
        //地址
        [self.addressLabel setText:_model.address];
        //人数限制
        [self.countlabel setText:STRING(@"%ld人", _model.memberLimit)];
        //时间
        //获取时间
        NSDate *date = [TDUtil dateFromString:_model.startTime];
        //年份
        NSString * dateStr = [TDUtil stringFromDate:date];
        //获取星期
        NSString * week = [TDUtil weekOfDate:dateStr];
        //时间:HS
        NSString * time = [TDUtil dateTimeFromString:_model.startTime];
        
        //时间
        [self.timeLabel setText:[NSString stringWithFormat:@"%@%@%@",dateStr,week,time]];
        
        //是否过期
        if(![TDUtil isArrivedTime:_model.endTime])
        {
            [self.expiredImage setHidden:YES];
        }
        
        if(_model.attended)
        {
            [_signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
            [_signUpBtn setBackgroundColor:GrayColor];
            [_signUpBtn setEnabled:NO];
        }
        
        //收费情况
        NSString * status = @"免费";
        if(model.type==0){
            status = @"收费";
        }
        [self.statusLabel setTitle:status forState:UIControlStateNormal];
        
    }
}

@end
