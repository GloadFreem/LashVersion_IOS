//
//  ActivityListCell.m
//  company
//
//  Created by Eugene on 16/8/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityListCell.h"

@implementation ActivityListCell

{
    UIImageView *_photoImage;
    UILabel *_titleLabel;
    UIView *_partLine;
    UIImageView *_timeImage;
    UILabel *_timeLabel;
    UIImageView *_personImage;
    UILabel *_personLabel;
    UILabel *_feeLabel;
    UIImageView *_addressImage;
    UILabel *_addressLabel;
    UIView *_bottomView;
    UIImageView *_expiredImage;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setup
{
    _photoImage = [UIImageView new];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [TDUtil colorWithHexString:@"1b1b1b"];
    _titleLabel.font = BGFont(17);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    _partLine = [UIView new];
    _partLine.backgroundColor = [TDUtil colorWithHexString:@"aaaaaa"];
    
    _timeImage = [UIImageView new];
    _timeImage.image = [UIImage imageNamed:@"iconfont_leftTime"];
    
    _timeLabel = [UILabel new];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = color74;
    
    _personImage = [UIImageView new];
    _personImage.image = [UIImage imageNamed:@"iconfont_person"];
    
    _personLabel = [UILabel new];
    _personLabel.textColor = color74;
    _personLabel.textAlignment = NSTextAlignmentLeft;
    _personLabel.font = BGFont(12);
    
    _feeLabel = [UILabel new];
    _feeLabel.text = @"免费";
    _feeLabel.font = BGFont(12);
    _feeLabel.textAlignment = NSTextAlignmentCenter;
    _feeLabel.backgroundColor = [TDUtil colorWithHexString:@"7098e3"];
    _feeLabel.textColor = [UIColor whiteColor];
    _feeLabel.layer.cornerRadius = 2;
    _feeLabel.layer.masksToBounds = YES;
    
    _addressImage = [UIImageView new];
    _addressImage.image = [UIImage imageNamed:@"iconfont_address"];
    
    _addressLabel = [UILabel new];
    _addressLabel.textColor = color74;
    _addressLabel.font = BGFont(12);
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [TDUtil colorWithHexString:@"e6e6e6"];
    
    _expiredImage = [UIImageView new];
    _expiredImage.image = [UIImage imageNamed:@"activity_guoqi.png"];
    
    NSArray *views = @[_photoImage, _titleLabel, _partLine, _timeImage, _timeLabel, _personImage, _personLabel, _feeLabel, _addressImage, _addressLabel, _bottomView, _expiredImage];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _photoImage.sd_layout
    .leftSpaceToView(contentView, 8)
    .rightSpaceToView(contentView, 8)
    .topSpaceToView(contentView, 10)
    .heightIs(175);
    
    _titleLabel.sd_layout
    .leftEqualToView(_photoImage)
    .rightEqualToView(_photoImage)
    .topSpaceToView(_photoImage, 10)
    .heightIs(17);
    
    _partLine.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_titleLabel, 10)
    .heightIs(0.5);
    
    _timeImage.sd_layout
    .leftSpaceToView(contentView, 15)
    .topSpaceToView(_partLine, 10)
    .widthIs(16)
    .heightIs(16);
    
    _timeLabel.sd_layout
    .leftSpaceToView(_timeImage, 5)
    .centerYEqualToView(_timeImage)
    .rightSpaceToView(contentView, 15)
    .heightIs(12);
    
    _personImage.sd_layout
    .leftEqualToView(_timeImage)
    .topSpaceToView(_timeImage, 10)
    .widthIs(16)
    .heightIs(16);
    
    _personLabel.sd_layout
    .leftSpaceToView(_personImage, 5)
    .centerYEqualToView(_personImage)
    .heightIs(12);
    [_personLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _feeLabel.sd_layout
    .leftSpaceToView(_personLabel, 10)
    .centerYEqualToView(_personImage)
    .heightIs(20)
    .widthIs(40);
    
    _addressImage.sd_layout
    .leftEqualToView(_timeImage)
    .topSpaceToView(_personImage, 10)
    .widthIs(16)
    .heightIs(16);
    
    _addressLabel.sd_layout
    .leftSpaceToView(_addressImage, 5)
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(_addressImage)
    .heightIs(12);
    
    _expiredImage.sd_layout
    .widthIs(104)
    .heightIs(67)
    .topSpaceToView(_partLine, 15)
    .rightSpaceToView(contentView, 22);
    
    _bottomView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_addressImage, 10)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:_bottomView bottomMargin:0];
}

-(void)setModel:(ActivityViewModel *)model
{
    if (model) {
        _model = model;
        
        [_photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.imgUrl]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        
        _titleLabel.text = model.name;
        
        if (model.isExpired) {
            [_expiredImage setHidden:NO];
//            NSLog(@"内部过期");
        }else{
            [_expiredImage setHidden:YES];
//            NSLog(@"内部未过期");
        }
        if (model.type == 0) { //0:付费  1:免费
            _feeLabel.text = @"付费";
        }
        //地址
        [_addressLabel setText:_model.address];
        //人数限制
        [_personLabel setText:STRING(@"%ld人", (long)_model.memberLimit)];
        [_personLabel sizeToFit];
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
        [_timeLabel setText:[NSString stringWithFormat:@"%@%@%@",dateStr,week,time]];
        
        
    }

}
@end
