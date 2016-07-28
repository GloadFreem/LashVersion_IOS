//
//  InvestCommitProjectPCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestCommitProjectPCell.h"

@implementation InvestCommitProjectPCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 29;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.borderWidth = 0.5;
    _iconImage.layer.borderColor = color(224, 224, 224, 1).CGColor;
    
}

-(void)setModel:(ProjectListProModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.startPageImage]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    //根据状态判断 状态图片
    if (!model.status) {
        _statusImage.hidden = YES;
    }
    if ([model.status isEqualToString:@"待路演"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_noroad"];
    }
    if ([model.status isEqualToString:@"路演中"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_roading"];
    }
    if ([model.status isEqualToString:@"预选"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_yuxuan"];
    }
    
    _nameLabel.text = model.abbrevName;
    _companyLabel.text = model.fullName;
    _titleLabel.text = model.desc;
    
    _personNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.collectionCount];
    _timeLabel.text = [NSString stringWithFormat:@"%ld天",(long)model.timeLeft];
    _moneyLabel.text = [NSString stringWithFormat:@"%ld万",(long)model.financeTotal];
}

#pragma mark ----计算时间差
-(NSString*)getDateCha:(NSString*)endDate
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.0";
    //当前时间字符串格式
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    //截止时间date格式
    NSDate *expireDate = [dateFormatter dateFromString:endDate];
    //当前时间date格式
    nowDate = [dateFormatter dateFromString:nowDateStr];
    //当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    
    //年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
    
    return [NSString stringWithFormat:@"%ld",(long)dateCom.day];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
