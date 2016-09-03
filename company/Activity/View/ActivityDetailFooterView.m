//
//  ActivityDetailFooterView.m
//  JinZhiT
//
//  Created by Eugene on 16/6/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailFooterView.h"
#import "ActivityDetailCommentView.h"

@interface ActivityDetailFooterView()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *leftLine;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIButton *totalBtn;
@property (nonatomic, strong) UIView *partLine;
@property (nonatomic, strong) ActivityDetailCommentView *commentView;
@property (nonatomic, strong) UILabel *moreL;
@end
@implementation ActivityDetailFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        [self setupViews];
        self.backgroundColor = RGBCOLOR(255, 255, 255);
    }
    return self;
}

-(void)setupViews
{
    UIView *topView = [UIView new];
    topView.backgroundColor = colorGray;
    [self addSubview:topView];
    topView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(10)
    .topEqualToView(self);
    
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topView];
    _topView.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(topView,0)
    .rightEqualToView(self)
    .heightIs(35);
    
    UIImage *lineImage = [UIImage imageNamed:@"icon_shuline"];
    _leftLine = [[UIImageView alloc]initWithImage:lineImage];
    [_topView addSubview:_leftLine];
    _leftLine.sd_layout
    .leftSpaceToView(_topView, 14)
    .centerYEqualToView(_topView)
    .widthIs(4)
    .heightIs(17);
    
    _leftLabel = [UILabel new];
    _leftLabel.font = BGFont(17);
    _leftLabel.textAlignment = NSTextAlignmentLeft;
    _leftLabel.textColor = color47;
    _leftLabel.text = @"点赞评论";
    [_topView addSubview:_leftLabel];
    _leftLabel.sd_layout
    .leftSpaceToView(_leftLine, 3)
    .centerYEqualToView(_topView)
    .heightIs(17);
    [_leftLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _totalBtn = [UIButton new];
    [_totalBtn setBackgroundImage:[UIImage imageNamed:@"icon_rightArrow"] forState:UIControlStateNormal];
    _totalBtn.size = _totalBtn.currentBackgroundImage.size;
    [_totalBtn addTarget:self action:@selector(showAllAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_totalBtn];
    _totalBtn.sd_layout
    .centerYEqualToView(_topView)
    .rightSpaceToView(_topView, 12)
    .widthIs(7)
    .heightIs(12);
    
    _totalLabel = [UILabel new];
    _totalLabel.text = @"查看全部";
    _totalLabel.textColor = orangeColor;
    _totalLabel.font = BGFont(13);
    _totalLabel.textAlignment = NSTextAlignmentRight;
    [_topView addSubview:_totalLabel];
    _totalLabel.sd_layout
    .rightSpaceToView(_totalBtn, 6)
    .centerYEqualToView(_topView)
    .heightIs(13);
    [_totalLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    [_topView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllAction)]];
    
    _partLine = [UIView new];
    _partLine.backgroundColor = colorGray;
    [_topView addSubview:_partLine];
    _partLine.sd_layout
    .leftEqualToView(_topView)
    .bottomEqualToView(_topView)
    .rightEqualToView(_topView)
    .heightIs(0.5);
    
    __weak typeof(self) weakSelf = self;
    _commentView = [ActivityDetailCommentView new];
    _commentView.backgroundColor = RGBCOLOR(255, 255, 255);
    [_commentView setDidClickCommentLabelBlock:^(NSString *commentId,NSString * repleyName,  CGRect rectInWindow) {
        if (weakSelf.didClickCommentLabelBlock) {
            weakSelf.didClickCommentLabelBlock(commentId,repleyName, rectInWindow);
        }
    }];
    [self addSubview:_commentView];
    _commentView.sd_layout
    .leftSpaceToView(self, 17)
    .rightSpaceToView(self, 17)
    .topSpaceToView(_topView, 13);
    
    _moreL = [[UILabel alloc] init];
    _moreL.text = @"...";
    _moreL.backgroundColor = [UIColor whiteColor];
    _moreL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_moreL];
    _moreL.sd_layout.topSpaceToView(_commentView, 0).widthIs(150).heightIs(30).leftSpaceToView(self, 58);
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = RGBCOLOR(227, 227, 227);
    [self addSubview:bottomView];
    bottomView.sd_layout.topSpaceToView(_moreL, 0).widthIs(SCREENWIDTH).heightIs(10);
}

-(void)setModel:(ActivityDetailCommentCellModel *)model
{
    _model = model;
    
    _commentView.frame = CGRectZero;
    
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
//    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
//        _commentView.fixedWith = @0; // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
//        _commentView.fixedHeight = @0; // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
//        _commentView.sd_layout.topSpaceToView(_partLine, 0);
//    }else{
        _commentView.fixedHeight = nil; // 取消固定宽度约束
        _commentView.fixedWith = nil; // 取消固定高度约束
        _commentView.sd_layout.topSpaceToView(_partLine, 13);
//    }
    
    if (model.commentItemsArray.count < 6) {
        [_moreL removeFromSuperview];
    }
    
    [_topView layoutSubviews];
    
    [self setupAutoHeightWithBottomView:_moreL bottomMargin:10];
    
}

-(void)setIsShowTopView:(Boolean)isShowTopView
{
    _isShowTopView = isShowTopView;
    if(!_isShowTopView)
    {
        [_topView removeFromSuperview];
        
        _partLine.sd_layout
        .topEqualToView(self);
        
        _commentView.sd_layout
        .topSpaceToView(_partLine,13);
    }
}

/**
 *  查看全部
 */
-(void)showAllAction
{
    if([_delegate respondsToSelector:@selector(didClickShowAllButton)])
    {
        [_delegate didClickShowAllButton];
    }
}

@end
