//
//  ProjectDetailLeftHeaderCell.m
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftHeaderView.h"
#import "PictureContainerView.h"
#import "ProjectDetailLeftTeamModel.h"

#import "ZMProgressView.h"
CGFloat __maxContentLabelHeight = 0; //根据具体font来定


@implementation ProjectDetailLeftHeaderView
{
    UIView *_topView;                //顶部阴影区
    UIImageView *_iconImage;         //项目图标
    UILabel *_projectLabel;          //项目名字
    UIView *_partLine;               //分隔线
    UIImageView *_statusImage;       //状态图标
    UILabel *_statusLabel;            //状态语
    
    UIImageView *_goalImage;         //融资图标
    UILabel *_goalLabel;
    UILabel *_goalNumber;
    
    UIImageView *_achieveImage;      //已融金额
    UILabel *_achieveLabel;
    UILabel *_achieveNumber;
    
    UIImageView *_timeImage;         //起止时间
    UILabel *_timeLabel;
    UILabel *_timeNumber;
    
    UIImageView *_addressImage;      //所在地
    UILabel *_addressLabel;
    UILabel *_addressContent;
    
    UILabel *_contentLabel;          //详细介绍
    PictureContainerView *_picContainerView;   //照片容器
    UIButton *_moreBtn;
    BOOL _shouldOpen;
    
    ZMProgressView *_progress;
    
    BOOL isFirst;
    
    BOOL _first;
    BOOL _second;
    
}
-(instancetype)init
{
    if (self = [super init]) {
        [self setup];
        isFirst = YES;
    }
    return self;
}

-(void)setup
{
    _shouldOpen = NO;
    _topView = [UIView new];
    _topView.backgroundColor = colorGray;
    
    //状态图标
    UIImage *statusImage = [UIImage imageNamed:@"icon_statusbg"];
    _statusImage = [[UIImageView alloc]initWithImage:statusImage];
    
    //状态语
    _statusLabel = [UILabel new];
    _statusLabel.font = BGFont(18);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.numberOfLines = 4;
    
    //进度条
    _progress = [[ZMProgressView alloc]initWithLineColor:orangeColor loopColor:[UIColor lightGrayColor]];
    _progress.backgroundColor = [UIColor clearColor];
    
    //项目图标
    UIImage *projectImage = [UIImage imageNamed:@"drafts"];
    _iconImage = [[UIImageView alloc]initWithImage:projectImage];
    
    //项目名字
    _projectLabel  = [UILabel new];
    _projectLabel.textColor = [UIColor blackColor];
    _projectLabel.font = BGFont(18);
    _projectLabel.textAlignment = NSTextAlignmentLeft;
    
    //第一条分隔线
    _partLine = [UIView new];
    _partLine.backgroundColor  = colorGray;
    
    //融资总额
    UIImage *goalImage = [UIImage imageNamed:@"iconfont-jine"];
    _goalImage = [[UIImageView alloc]initWithImage:goalImage];
    
    _goalLabel = [UILabel new];
    _goalLabel.text = @"融资总额";
    _goalLabel.font = BGFont(14);
    _goalLabel.textAlignment = NSTextAlignmentLeft;
    _goalLabel.textColor = color74;
    
    _goalNumber = [UILabel new];
    _goalNumber.textColor = color47;
    _goalNumber.font = BGFont(14);
    _goalNumber.textAlignment = NSTextAlignmentLeft;
    
    //已融金额
    UIImage *achieveImage = [UIImage imageNamed:@"iconfont-rong"];
    _achieveImage = [[UIImageView alloc]initWithImage:achieveImage];
    
    _achieveLabel = [UILabel new];
    _achieveLabel.text = @"已融金额";
    _achieveLabel.textColor = color74;
    _achieveLabel.textAlignment = NSTextAlignmentLeft;
    _achieveLabel.font = BGFont(14);
    
    _achieveNumber = [UILabel new];
    _achieveNumber.textAlignment = NSTextAlignmentLeft;
    _achieveNumber.textColor = color47;
    _achieveNumber.font = BGFont(14);
    
    //起止时间
    UIImage *timeImage = [UIImage imageNamed:@"iconfont-shengyushijian"];
    _timeImage = [[UIImageView alloc]initWithImage:timeImage];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"起止时间";
    _timeLabel.textColor = color74;
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = BGFont(14);
    
    _timeNumber = [UILabel new];
    _timeNumber.textAlignment = NSTextAlignmentLeft;
    _timeNumber.textColor = color47;
    _timeNumber.font = BGFont(14);
    
    //所在地
    UIImage *addressImage = [UIImage imageNamed:@"地址"];
    _addressImage = [[UIImageView alloc]initWithImage:addressImage];
    
    _addressLabel = [UILabel new];
    _addressLabel.text = @"所在地";
    _addressLabel.textAlignment = NSTextAlignmentLeft;
    _addressLabel.textColor = color74;
    _addressLabel.font = BGFont(14);
    
    _addressContent = [UILabel new];
    _addressContent.textColor = color47;
    _addressContent.textAlignment = NSTextAlignmentLeft;
    _addressContent.font = BGFont(14);
    
    //项目简介
    _contentLabel = [UILabel new];
    _contentLabel.textColor = color74;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = BGFont(14);
    if (__maxContentLabelHeight == 0) {
        __maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    //图片
    _picContainerView = [PictureContainerView new];
//    _picContainerView.backgroundColor = [UIColor redColor];
    
    //morebtn
    _moreBtn = [UIButton new];
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *views = @[_topView, _iconImage, _progress,_projectLabel, _partLine, _statusImage, _statusLabel, _goalImage, _goalLabel, _goalNumber, _achieveImage, _achieveLabel, _achieveNumber, _timeImage, _timeLabel, _timeNumber,  _addressImage, _addressLabel, _addressContent, _contentLabel, _picContainerView, _moreBtn];
    [self sd_addSubviews:views];
    
    _topView.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(10);
    
    _iconImage.sd_layout
    .leftSpaceToView(self, 13)
    .topSpaceToView(_topView, 13)
    .widthIs(16)
    .heightIs(20);
    
    _projectLabel.sd_layout
    .leftSpaceToView(_iconImage, 6)
    .centerYEqualToView(_iconImage)
    .heightIs(18);
    [_projectLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _partLine.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(_iconImage, 13)
    .rightSpaceToView(self, 0)
    .heightIs(0.5);
    
    _progress.sd_layout
    .topSpaceToView(_topView,55)
    .rightSpaceToView(self,85)
    .widthIs(65)
    .heightIs(65);
    
    _statusImage.sd_layout
    .topSpaceToView(self, 5)
    .rightSpaceToView(self, 20)
    .widthIs(56)
    .heightIs(111);
    
    _statusLabel.sd_layout
    .topSpaceToView(self ,10)
    .centerXEqualToView(_statusImage)
    .widthIs(20)
    .heightIs(91);
    
    _goalImage.sd_layout
    .leftSpaceToView(self, 25)
    .topSpaceToView(_partLine, 19)
    .widthIs(16)
    .heightIs(16);
    
    _goalLabel.sd_layout
    .leftSpaceToView(_goalImage, 4)
    .centerYEqualToView(_goalImage)
    .heightIs(14);
    [_goalLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _goalNumber.sd_layout
    .leftSpaceToView(_goalLabel, 14)
    .centerYEqualToView(_goalImage)
    .heightIs(14);
    [_goalNumber setSingleLineAutoResizeWithMaxWidth:100];
    
    _achieveImage.sd_layout
    .topSpaceToView(_goalImage, 20)
    .centerXEqualToView(_goalImage)
    .widthIs(16)
    .heightIs(16);
    
    _achieveLabel.sd_layout
    .leftEqualToView(_goalLabel)
    .centerYEqualToView(_achieveImage)
    .heightIs(14);
    [_achieveLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _achieveNumber.sd_layout
    .leftEqualToView(_goalNumber)
    .centerYEqualToView(_achieveImage)
    .heightIs(14);
    [_achieveNumber setSingleLineAutoResizeWithMaxWidth:100];
    
    _timeImage.sd_layout
    .centerXEqualToView(_goalImage)
    .topSpaceToView(_achieveImage, 20)
    .heightIs(16)
    .heightIs(16);
    
    _timeLabel.sd_layout
    .leftEqualToView(_goalLabel)
    .centerYEqualToView(_timeImage)
    .heightIs(14);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _timeNumber.sd_layout
    .leftEqualToView(_goalNumber)
    .centerYEqualToView(_timeImage)
    .heightIs(14);
    [_timeNumber  setSingleLineAutoResizeWithMaxWidth:200];
    
    _addressImage.sd_layout
    .topSpaceToView(_timeImage, 20)
    .centerXEqualToView(_goalImage)
    .widthIs(16)
    .heightIs(16);
    
    _addressLabel.sd_layout
    .leftEqualToView(_goalLabel)
    .centerYEqualToView(_addressImage)
    .heightIs(14);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _addressContent.sd_layout
    .leftEqualToView(_goalNumber)
    .centerYEqualToView(_addressImage)
    .heightIs(14);
    [_addressContent setSingleLineAutoResizeWithMaxWidth:150];
    
    _contentLabel.sd_layout
    .leftSpaceToView(self, 30)
    .rightSpaceToView(self, 30)
    .topSpaceToView(_addressImage, 23)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftSpaceToView(self,8);
    
    _moreBtn.sd_layout
    .centerXEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView,16*HEIGHTCONFIG)
    .widthIs(21);
}

-(void)setModel:(ProjectDetailLeftHeaderModel *)model
{
    _model = model;
    
    _shouldOpen = NO;
    _projectLabel.text = model.projectStr;
    _goalNumber.text = model.goalStr;
    [_goalNumber sizeToFit];
    _achieveNumber.text = model.achieveStr;
    [_achieveNumber sizeToFit];
    _timeNumber.text = model.timeStr;
    [_timeNumber sizeToFit];
    _addressContent.text = model.addressStr;
    [_addressContent sizeToFit];
    _statusLabel.text = model.statusStr;
    _contentLabel.text = model.content;
    
    if (isFirst) {
        _progress.animatable = YES;
        CGFloat finalCount = model.financedMount;
        CGFloat percent = finalCount / model.financeTotal * 100;
        _progress.percent = percent;
        _progress.title = @"已融资";
        _progress.percentUnit = @"%";
        _progress.lineColor = orangeColor;
        _progress.loopColor = btnCray;
        isFirst = NO;
    }
    //默认显示一行数组
    NSMutableArray *picArray = [NSMutableArray array];
    
    
    if (model.shouldShowMoreButton) { //如果文字高度超过三行
        _first = YES;
        if (model.isOpen) {  //如果展开
            _picContainerView.pictureStringArray = model.pictureArray;
            
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            //            _pictureContainerView.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_more_close"] forState:UIControlStateNormal];
        }else{
            _contentLabel.sd_layout.maxHeightIs(__maxContentLabelHeight);
            //            _pictureContainerView.sd_layout.maxHeightIs(maxPictureViewHeight);
            [_moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
            
        }
    }else{
        _first = NO;
    }
    
    if(!model.isOpen)
    {
        if(model.pictureArray && model.pictureArray.count>0)
        {
            for (NSInteger i =0; i<3; i++) {
                [picArray addObject:model.pictureArray[i]];
            }
        }
        
        _picContainerView.pictureStringArray = picArray;
    }else{
        _picContainerView.pictureStringArray = model.pictureArray;
    }
    
    if (_picContainerView.pictureStringArray.count > 3) {
        _second = YES;
    }else{
        _second = NO;
    }
    
    if (_first || _second) {
        _moreBtn.sd_layout.heightIs(28);
    }else{
        _moreBtn.sd_layout.heightIs(0);
    }
    [_moreBtn updateLayout];
    
    CGFloat picContainerTopMargin = 0;
    if (model.pictureArray.count) {
        picContainerTopMargin = 12;
    }
    
    _picContainerView.sd_layout
    .topSpaceToView(_contentLabel, picContainerTopMargin);
    
    CGFloat pictureContainerTopMargin = 0;
    if (model.pictureArray.count) {
        pictureContainerTopMargin = 10;
    }
    
    [self setupAutoHeightWithBottomView:_moreBtn bottomMargin:15];
    
}

/**
 *  展开
 */
-(void)btnClick
{
    _shouldOpen = !_shouldOpen;
    [_model setIsOpen:_shouldOpen];
    [self setModel:_model];
    
    if(self.moreButtonClickedBlock)
    {
        self.moreButtonClickedBlock(_shouldOpen);
    }
    
    //发送通知
    [self performSelector:@selector(updateLayoutnotification) withObject:nil afterDelay:0.01];
}
-(void)updateLayoutnotification
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateLayout" object:nil];
}
@end
