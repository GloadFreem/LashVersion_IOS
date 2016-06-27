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
    UIView *_topContainerView;
    UIImageView *_calenderImage;
    UILabel *_yearLabel;
    UILabel *_monthLabel;
    UILabel *_timeLabel;
    UIImageView *_bottomLine;
    
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
    _topContainerView = [UIView new];
    _topContainerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _topLine = [UIImageView new];
    _topLine.image = [UIImage imageNamed:@"mine_goldline"];
    [_topContainerView addSubview:_topLine];
    
    _calenderImage = [UIImageView new];
    _calenderImage.image = [UIImage imageNamed:@"mine_gold_calender"];
    [_topContainerView addSubview:_calenderImage];
    CGSize size = _calenderImage.image.size;
    
     _bottomLine= [UIImageView new];
    _bottomLine.image = [UIImage imageNamed:@"mine_goldline"];
    [_topContainerView addSubview:_bottomLine];
    
    //年份
    _yearLabel = [UILabel new];
    _yearLabel.textColor = [UIColor blackColor];
    _yearLabel.textAlignment = NSTextAlignmentLeft;
    _yearLabel.font = BGFont(17);
    [_topContainerView addSubview:_yearLabel];
    
    _topLine.sd_layout
    .centerXEqualToView(_calenderImage)
    .bottomSpaceToView(_calenderImage,0)
    .widthIs(1)
    .topEqualToView(self.contentView);
    
    _calenderImage.sd_layout
    .leftSpaceToView(_topContainerView,60)
    .topSpaceToView(_topContainerView,19)
    .heightIs(28)
    .widthIs(28);
    
    _yearLabel.sd_layout
    .leftSpaceToView(_calenderImage,5)
    .centerYEqualToView(_calenderImage)
    .heightIs(17);
    [_yearLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _bottomLine.sd_layout
    .centerXEqualToView(_calenderImage)
    .topSpaceToView(_calenderImage,0)
    .bottomSpaceToView(_topContainerView,0)
    .widthIs(1);
    
    [self.contentView addSubview:_topContainerView];
    _topContainerView.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView);  //高度显示在 setModel里边设置
    
    
    //月份
    _monthLabel = [UILabel new];
    _monthLabel.font = BGFont(12);
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.textAlignment = NSTextAlignmentRight;
    [_monthLabel setSingleLineAutoResizeWithMaxWidth:150];
    //时间
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = [UIColor blackColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
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
    
    CGFloat width = size.width / 2;
    _pointImage.sd_layout
    .leftSpaceToView(self.contentView,57 + width)
    .topSpaceToView(_topContainerView,15)
    .widthIs(4)
    .heightIs(4);
    
    _lineImage.sd_layout
    .topSpaceToView(_topContainerView,0)
    .centerXEqualToView(_pointImage)
    .bottomEqualToView(self.contentView)
    .widthIs(1);
    
    _monthLabel.sd_layout
    .rightSpaceToView(_pointImage,5)
    .centerYEqualToView(_pointImage)
    .heightIs(14);
    
    _timeLabel.sd_layout
    .centerXEqualToView(_monthLabel)
    .topSpaceToView(_monthLabel,5)
    .heightIs(12);
    
    _whiteImage.sd_layout
    .topSpaceToView(_topContainerView,12)
    .leftSpaceToView(_pointImage,5)
    .rightSpaceToView(self.contentView,10);//.heightIs(64) 高度在setModel设置
    
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
    
    _iconImage = [UIImageView new];
    _iconImage.layer.cornerRadius = 15;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    
    _projectLabel = [UILabel new];
    _projectLabel.textColor = color74;
    _projectLabel.textAlignment = NSTextAlignmentLeft;
    _projectLabel.font = BGFont(17);
    
    NSArray *view = @[_reasonLabel, _billLabel, _iconImage, _projectLabel, _wanLabel, _numberLabel, _rmbLabel, _statusLabel, _iconImage, _projectLabel];
    [_whiteImage sd_addSubviews:view];
    
    _reasonLabel.sd_layout
    .leftSpaceToView(_whiteImage,9)
    .topSpaceToView(_whiteImage,10)
    .heightIs(19);
    [_reasonLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _billLabel.sd_layout
    .leftEqualToView(_reasonLabel)
    .heightIs(14)
    .topSpaceToView(_reasonLabel,5);
    [_billLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _wanLabel.sd_layout
    .rightSpaceToView(_whiteImage,10)
    .bottomEqualToView(_reasonLabel)
    .heightIs(10);
    [_wanLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _numberLabel.sd_layout
    .rightSpaceToView(_wanLabel,3)
    .bottomEqualToView(_reasonLabel)
    .heightIs(18);
    [_numberLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _rmbLabel.sd_layout
    .rightSpaceToView(_numberLabel,3)
    .heightIs(10)
    .bottomEqualToView(_reasonLabel);
    [_rmbLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _statusLabel.sd_layout
    .rightEqualToView(_wanLabel)
    .heightIs(14)
    .bottomEqualToView(_billLabel);
    [_statusLabel setSingleLineAutoResizeWithMaxWidth:100];
    
}
-(void)setModel:(BillDetailCellModel *)model
{
    _model = model;
    NSArray *arr = [model.record.tradeDate componentsSeparatedByString:@" "];
    NSArray *array = [arr[0] componentsSeparatedByString:@"-"];
    
    if (model.img.length || model.name.length) {
        _whiteImage.image =[UIImage imageNamed:@"bill_whitebg2"];
        _whiteImage.sd_layout.heightIs(110);
        _iconImage.sd_layout
        .leftEqualToView(_reasonLabel)
        .topSpaceToView(_billLabel,10)
        .widthIs(30)
        .heightIs(30);
        
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.img]] placeholderImage:[UIImage new]];
        
        _projectLabel.sd_layout
        .leftSpaceToView(_iconImage,8)
        .centerYEqualToView(_iconImage)
        .heightIs(17);
        [_projectLabel setSingleLineAutoResizeWithMaxWidth:150];
        
        _projectLabel.text = model.name;
        [_projectLabel sizeToFit];
    }else{
        _whiteImage.image =[UIImage imageNamed:@"bill_whitebg1"];
        _whiteImage.sd_layout.heightIs(72);
    }
    
    _yearLabel.text = [NSString stringWithFormat:@"%@年",array[0]];
    [_yearLabel sizeToFit];
    _monthLabel.text = [NSString stringWithFormat:@"%@月%@日",array[1],array[2]];
    [_monthLabel sizeToFit];
    _reasonLabel.text = model.record.tradetype.name;
    [_reasonLabel sizeToFit];
    _billLabel.text = model.record.tradeCode;
    [_billLabel sizeToFit];
    _numberLabel.text = [NSString stringWithFormat:@"%ld",model.record.amount];
    [_numberLabel sizeToFit];
    _statusLabel.text = model.record.tradestatus.name;
    _statusLabel.textColor = color74;
    if ([model.record.tradestatus.name isEqualToString:@"认投失败"]) {
        _statusLabel.textColor = [UIColor redColor];
    }
    [_statusLabel sizeToFit];
    
    
    
    
    if (_model.isShow == YES) {
        //        NSLog(@"设置高度");
        _calenderImage.hidden = NO;
        _topContainerView.sd_layout.heightIs(45);
    }else{
        //        NSLog(@"高度为0");
        _calenderImage.hidden = YES;
        _topContainerView.fixedHeight = @0;
        _topContainerView.sd_layout.heightIs(0);
    }
    
    [self setupAutoHeightWithBottomView:_whiteImage bottomMargin:0];
}
@end
