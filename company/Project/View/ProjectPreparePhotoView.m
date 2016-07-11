//
//  ProjectPreparePhotoView.m
//  company
//
//  Created by Eugene on 16/7/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPreparePhotoView.h"
#import "PictureContainerView.h"

CGFloat ___maxContentLabelHeight = 0; //根据具体font来定

@implementation ProjectPreparePhotoView

{
    UIImageView *_imageView;
    UILabel *_projectLabel;
    UIView *_partLine;
    UILabel *_contentLabel;
    PictureContainerView *_picContainerView;
    UIButton *_moreBtn;
    BOOL _shouldOpen;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self setup];
        
        //        [self loadData];
    }
    return self;
}

-(void)setup
{
    _shouldOpen = NO;
    
    //项目图标
    UIImage *projectImage = [UIImage imageNamed:@"drafts"];
    _imageView = [[UIImageView alloc]initWithImage:projectImage];
    
    
    //项目名字
    _projectLabel  = [UILabel new];
    _projectLabel.textColor = [UIColor blackColor];
    _projectLabel.font = BGFont(18);
    _projectLabel.textAlignment = NSTextAlignmentLeft;
    
    //第一条分隔线
    _partLine = [UIView new];
    _partLine.backgroundColor  = colorGray;
    
    //项目简介
    _contentLabel = [UILabel new];
    _contentLabel.textColor = color74;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = BGFont(14);
    if (___maxContentLabelHeight == 0) {
        ___maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
//    NSLog(@"-----------------行高-----%lf",___maxContentLabelHeight);
    //图片
    _picContainerView = [PictureContainerView new];
    //morebtn
    _moreBtn = [UIButton new];
    [_moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *views = @[_imageView, _projectLabel, _partLine, _contentLabel, _picContainerView, _moreBtn];
    [self sd_addSubviews:views];
    
    _imageView.sd_layout
    .leftSpaceToView(self, 13)
    .topSpaceToView(self, 13)
    .widthIs(16)
    .heightIs(20);
    
    _projectLabel.sd_layout
    .leftSpaceToView(_imageView, 6)
    .centerYEqualToView(_imageView)
    .heightIs(18);
    [_projectLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _partLine.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(_imageView, 13)
    .rightSpaceToView(self, 0)
    .heightIs(0.5);
    
    _contentLabel.sd_layout
    .leftSpaceToView(self, 30)
    .rightSpaceToView(self, 30)
    .topSpaceToView(_partLine, 23)
    .autoHeightRatio(0);
    
    _picContainerView.sd_layout
    .leftSpaceToView(self,8);
    
    
    _moreBtn.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(_picContainerView,10*HEIGHTCONFIG)
    .rightEqualToView(self)
    .heightIs(28);

}

-(void)setModel:(ProjectDetailLeftHeaderModel *)model
{
    _model = model;
    _shouldOpen = NO;
    
    _projectLabel.text = model.projectStr;
    _contentLabel.text = model.content;
    
    //默认显示一行数组
    NSMutableArray *picArray = [NSMutableArray array];
    
    
    if (model.shouldShowMoreButton) { //如果文字高度超过三行
        _moreBtn.sd_layout.heightIs(28);
        if (model.isOpen) {  //如果展开
            _picContainerView.pictureStringArray = model.pictureArray;
            
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            //            _pictureContainerView.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreBtn setImage:[UIImage imageNamed:@"icon_more_close"] forState:UIControlStateNormal];
        }else{
            _contentLabel.sd_layout.maxHeightIs(___maxContentLabelHeight);
            //            _pictureContainerView.sd_layout.maxHeightIs(maxPictureViewHeight);
            [_moreBtn setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
            
        }
    }else{
        _moreBtn.sd_layout.heightIs(0);
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
    
    [self setupAutoHeightWithBottomView:_moreBtn bottomMargin:10];
}

-(void)btnClick
{
    _shouldOpen = !_shouldOpen;
    [_model setIsOpen:_shouldOpen];
    [self setModel:_model];
    
    if(self.moreButtonClickedBlock)
    {
        self.moreButtonClickedBlock(_shouldOpen);
    }
    
//    //发送通知
//    [self performSelector:@selector(updateLayoutnotification) withObject:nil afterDelay:0.01];
}

@end
