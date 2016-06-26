//
//  BillDetailCell.m
//  company
//
//  Created by Eugene on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "BillDetailCell.h"

@implementation BillDetailCell
{
    UILabel *_monthLabel;
    UILabel *_timeLabel;
    UIImageView *_pointImage;
    UIImageView *_lineImage;
    UIImageView *_whiteImage;
    UILabel *_reasonLabel;
    UILabel *_wanLabel;
    UILabel *_numberLabel;
    UILabel *_rmbLabel;
    UILabel *_billLabel;
    UILabel *_statusLabel;
    UIImageView *_iconImage;
    UILabel *_projectLabel;
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
    //月份
    _monthLabel = [UILabel new];
    _monthLabel.font = BGFont(12);
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.textAlignment = NSTextAlignmentRight;
    
    //事件
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    //点
    _pointImage = [UIImageView new];
    _pointImage.image = [UIImage imageNamed:@"mine_gold_point"];
    
    //竖线
    _lineImage = [UIImageView new];
    _lineImage.image = [UIImage imageNamed:@"mine_goldline"];
    
    //白色背景
    _whiteImage = [UIImageView new];
    
    NSArray *views = @[_monthLabel, _timeLabel, _pointImage, _lineImage, _whiteImage];
    [self.contentView sd_addSubviews:views];
    
    //理由名字
    _reasonLabel = [UILabel new];
//    _reasonLabel.font = BGFont(19);
    _reasonLabel.font = [UIFont boldSystemFontOfSize:19];
    _reasonLabel.textColor = [UIColor blackColor];
    _reasonLabel.textAlignment = NSTextAlignmentLeft;
    //账单号
    _billLabel = [UILabel new];
    _billLabel.textColor = color74;
    _billLabel.font = BGFont(14);
    _billLabel.textAlignment = NSTextAlignmentLeft;
    
    //头像
    _iconImage = [UIImageView new];
    _iconImage.layer.cornerRadius = 29;
    _iconImage.layer.masksToBounds = YES;
    //项目名字
    _projectLabel = [UILabel new];
    _projectLabel.textColor = color74;
    _projectLabel.font = BGFont(17);
    
    //万
    _wanLabel = [UILabel new];
    _wanLabel.text = @"万";
    _wanLabel.textColor = [UIColor blackColor];
    _wanLabel.textAlignment = NSTextAlignmentRight;
    _wanLabel.font = BGFont(10);
    
    //数字
    _numberLabel = [UILabel new];
    _numberLabel.textColor = [UIColor blackColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:18];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    
    //人民币
    _rmbLabel = [UILabel new];
    _rmbLabel.text = @"￥";
    _rmbLabel.font = BGFont(10);
    _rmbLabel.textColor = [UIColor blackColor];
    _rmbLabel.textAlignment = NSTextAlignmentRight;
    
    //状态   颜色在 设置模型时  判断
    _statusLabel = [UILabel new];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = BGFont(14);
    
    NSArray *view = @[_reasonLabel, _billLabel, _iconImage, _projectLabel, _wanLabel, _numberLabel, _rmbLabel, _statusLabel];
    [_whiteImage sd_addSubviews:view];
    
    
}
@end
