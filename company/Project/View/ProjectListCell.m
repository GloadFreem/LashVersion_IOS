//
//  ProjectListCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectListCell.h"

@implementation ProjectListCell

- (void)awakeFromNib {
    // Initialization codeor
    _iconImage.layer.cornerRadius = 30;
    _iconImage.layer.masksToBounds = YES;
    
    _leftLabel.layer.cornerRadius = 3;
    _leftLabel.layer.masksToBounds = YES;
    _leftLabel.layer.borderWidth = 0.5;
    _leftLabel.layer.borderColor = colorBlue.CGColor;
    
    _middleLabel.layer.cornerRadius = 3;
    _middleLabel.layer.masksToBounds = YES;
    _middleLabel.layer.borderWidth = 0.5;
    _middleLabel.layer.borderColor = colorBlue.CGColor;
    _rightLabel.layer.cornerRadius = 3;
    _rightLabel.layer.masksToBounds = YES;
    _rightLabel.layer.borderWidth = 0.5;
    _rightLabel.layer.borderColor = colorBlue.CGColor;
}

-(void)setModel:(ProjectListProModel *)model
{
    _model = model;
    
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.startPageImage]] placeholderImage:[UIImage new]];
    
    //根据状态判断 状态图片
//    if (!model.status) {
//        _statusImage.hidden = YES;
//    }
    if ([model.status isEqualToString:@"待路演"]) {
        _statusImage.image = [UIImage imageNamed:@"icon_noroad"];
    }
    
    if ([model.status isEqualToString:@"路演中"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_roading"];
    }
    
//    if ([model.status isEqualToString:@"预选"]) {
//        _statusImage.image = [UIImage imageNamed:@"invest_yuxuan"];
//    }
    
    if ([model.status isEqualToString:@"融资中"]) {
        //
        UIImage * image = [UIImage imageNamed:@"icon_raising"];
        _statusImage.image =  image;
    }
    
    if ([model.status isEqualToString:@"融资成功"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_raisefund"];
    }
    if ([model.status isEqualToString:@"融资失败"]) {
        _statusImage.image = [UIImage imageNamed:@"invest_failed@3x"];
    }
   
    
    //隐藏多余的 label
    for (NSInteger i =model.areas.count; i < _labelArray.count; i ++) {
        UILabel *label = (UILabel *)_labelArray[i];
        label.hidden = YES;
    }
    //赋值
    for (NSInteger i =0; i < model.areas.count; i ++) {
        UILabel *label = (UILabel *)_labelArray[i];
        label.text = model.areas[i];
    }
    CGFloat finalCount = model.financedMount;
    CGFloat percent = finalCount / model.financeTotal * 100;
    _progressView.percent = percent;
    _progressView.title = @"已融资";
    _progressView.percentUnit = @"%";
    _progressView.lineColor = orangeColor;
    _progressView.loopColor = [UIColor lightGrayColor];
    NSLog(@"剩余时间---%@",model.endDate);
    
    _timeLabel.text = [self getDateCha:model.endDate];
    _projectLabel.text = model.abbrevName;
    _addressLabel.text = model.address;
    _companyLabel.text = model.fullName;
    _personNumLabel.text = [NSString stringWithFormat:@"%ld",model.collectionCount];
    _moneyLabel.text = [NSString stringWithFormat:@"%ld万",model.financeTotal];
    
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
