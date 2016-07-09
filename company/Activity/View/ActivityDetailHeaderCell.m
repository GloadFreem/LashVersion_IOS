//
//  ActivityDetailHeaderCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailHeaderCell.h"

#import "PictureContainerView.h"
CGFloat maxContentLabelHeight = 0; //根据具体font来定
CGFloat maxPictureViewHeight = 0;  //根据具体情况来定

@implementation ActivityDetailHeaderCell

{
    UIView *_orangeView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    PictureContainerView *_pictureContainerView;
    UIButton *_moreBtn;
    BOOL _shouldOpen;
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
    _shouldOpen = NO;
    //橙色背景
    _orangeView = [[UIView alloc]init];
    _orangeView.backgroundColor = color(247, 101, 1, 1);
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = BGFont(20);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //内容
    _contentLabel  = [UILabel new];
    _contentLabel.font = BGFont(14);
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    //图片
    _pictureContainerView = [PictureContainerView new];
    _pictureContainerView.identityStr = @"activity";
//    _pictureContainerView.backgroundColor =[UIColor redColor];
//    if (maxPictureViewHeight == 0) {
//        maxPictureViewHeight = 84;
//    }

    
    //更多
    _moreBtn = [UIButton new];
    [_moreBtn setImage:[UIImage imageNamed:@"icon_acticity_more"] forState:UIControlStateNormal];


    [_moreBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *views =@[_orangeView,_titleLabel,_contentLabel,_pictureContainerView,_moreBtn];
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    
    _orangeView.sd_layout
    .leftSpaceToView(contentView,0)
    .topSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(115*HEIGHTCONFIG);
    
    _titleLabel.sd_layout
    .leftSpaceToView(contentView,23*WIDTHCONFIG)
    .topSpaceToView(contentView, 19*HEIGHTCONFIG)
    .rightSpaceToView(contentView,23*WIDTHCONFIG)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .rightEqualToView(_titleLabel)
    .topSpaceToView(_orangeView,17*HEIGHTCONFIG)
    .autoHeightRatio(0);
    
//   //测试
//    testView.sd_layout
//    .leftEqualToView(_titleLabel)
//    .topSpaceToView(_contentLabel,10)
//    .rightEqualToView(_titleLabel)
//    .heightIs(50);
    
    _pictureContainerView.sd_layout
    .leftEqualToView(_contentLabel);//内部实现高度自适应，top值是具体有无图片在setModel里边设置的
    
    _moreBtn.sd_layout
    .centerXEqualToView(_contentLabel)
    .topSpaceToView(_pictureContainerView,16*HEIGHTCONFIG)
    .widthIs(SCREENHEIGHT)
    .heightIs(23);
    
}

-(void)setModel:(ActivityDetailHeaderModel *)model
{
    _model = model;
    
    _shouldOpen = NO;
    
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    
    //默认显示一行数组
    NSMutableArray *picArray = [NSMutableArray array];
    
    if (model.shouldShowMoreButton) { //如果文字高度超过三行
        
        if (model.isOpen) {  //如果展开
            _pictureContainerView.pictureStringArray = model.pictureArray;

            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
//            _pictureContainerView.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreBtn setImage:[UIImage imageNamed:@"icon_acticity_close"] forState:UIControlStateNormal];
        }else{
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
//            _pictureContainerView.sd_layout.maxHeightIs(maxPictureViewHeight);
            [_moreBtn setImage:[UIImage imageNamed:@"icon_acticity_more"] forState:UIControlStateNormal];
            
        }
    }
    
    
    if(!model.isOpen)
    {
        if(model.pictureArray && model.pictureArray.count>0)
        {
            for (NSInteger i =0; i<3; i++) {
                [picArray addObject:model.pictureArray[i]];
            }
        }
       
        _pictureContainerView.pictureStringArray = picArray;
    }else{
        _pictureContainerView.pictureStringArray = model.pictureArray;
    }
    
    
    CGFloat pictureContainerTopMargin = 0;
    if (model.pictureArray.count) {
        pictureContainerTopMargin = 10;
    }
    
    _pictureContainerView.sd_layout
    .topSpaceToView(_contentLabel,pictureContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.pictureArray.count) {
        bottomView = _contentLabel;
    }else{
        bottomView = _pictureContainerView;
    }
    
    [self setupAutoHeightWithBottomView:_moreBtn bottomMargin:15];
    
}
-(void)btnClick:(UIButton*)btn
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
    
}
@end
