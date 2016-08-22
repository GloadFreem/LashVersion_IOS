//
//  CircleListCell.m
//  JinZhiT
//
//  Created by Eugene on 16/5/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleListCell.h"

#import "PictureContainerView.h"


const CGFloat _contentLabelFontSize = 15;
CGFloat _maxContentLabelHeight = 0; //根据具体font而定

@implementation CircleListCell

{
    UIView *_topView;
    UIImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_addressLabel;
    UILabel *_companyLabel;
    
    UIView *_shuView;
    UILabel *_positionLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIButton *_moreBtn;
    PictureContainerView *_picContainerView;
    UIView *_partLine;
    UIButton *_shareBtn;
    UIView *_firstShuView;
    UIButton *_commentBtn;
    UIView*_secondShuView;
    
    BOOL _shouldOpenContentLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
//[UIFont fontWithName:@"PingFangSC-Regular" size:17]
-(void)setup
{
    _shouldOpenContentLabel = NO;
    
    _topView = [UIView new];
    [_topView setBackgroundColor:colorGray];
    
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    _nameLabel.textColor = color47;
    
    _addressLabel = [UILabel new];
    _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    _addressLabel.textColor = color74;
    
    _companyLabel = [UILabel new];
    _companyLabel.font = BGFont(12);
    _addressLabel.textColor = color74;
    
    _shuView = [UIView new];
    _shuView.backgroundColor = color74;
    
    _positionLabel = [UILabel new];
    _positionLabel.font = BGFont(12);
    _positionLabel.textColor = color74;
    
    _deleteBtn = [UIButton new];
    [_deleteBtn setImage:[UIImage imageNamed:@"icon_dustbin"] forState:UIControlStateNormal];
    _deleteBtn.contentMode = UIViewContentModeRight;
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = color74;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = color47;
    _contentLabel.font = [UIFont systemFontOfSize:_contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (_maxContentLabelHeight == 0) {
        _maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreBtn = [UIButton new];
    [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_moreBtn setTitleColor: orangeColor forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.titleLabel.font = BGFont(14);
    
    _picContainerView = [PictureContainerView new];
    
    _partLine = [UIView new];
    _partLine.backgroundColor = color74;
    
    _shareBtn =[UIButton new];
    [_shareBtn setImage:[UIImage imageNamed:@"iconfont_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.titleLabel.font = BGFont(14);
    [_shareBtn setTitleColor:color74 forState:UIControlStateNormal];
    
    _firstShuView = [UIView new];
    [_firstShuView setBackgroundColor:colorGray];
    
    _commentBtn = [UIButton new];
    [_commentBtn setImage:[UIImage imageNamed:@"iconfont_pinglun"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn.titleLabel.font = BGFont(14);
    [_commentBtn setTitleColor:color74 forState:UIControlStateNormal];
    
    _secondShuView = [UIView new];
    [_secondShuView setBackgroundColor:colorGray];
    
    _praiseBtn = [UIButton new];
//    [_praiseBtn setTitle:@"250" forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:color74 forState:UIControlStateNormal];
    [_praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _praiseBtn.titleLabel.font = BGFont(14);
    
    NSArray *views = @[_topView,_iconView, _nameLabel, _addressLabel, _companyLabel, _shuView, _positionLabel,_deleteBtn, _timeLabel, _contentLabel, _moreBtn, _picContainerView, _partLine,_shareBtn,_firstShuView,_commentBtn,_secondShuView,_praiseBtn];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 8;
    
    _topView.sd_layout
    .leftEqualToView(contentView)
    .topEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(8);
    
    _iconView.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(_topView,margin)
    .widthIs(40)
    .heightIs(40);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView,9)
    .topSpaceToView(_topView,8)
    .heightIs(17);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _addressLabel.sd_layout
    .leftSpaceToView(_nameLabel,10)
    .bottomEqualToView(_nameLabel)
    .heightIs(12);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _companyLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,5)
    .heightIs(12);
    [_companyLabel setSingleLineAutoResizeWithMaxWidth:180];
    
    _shuView.sd_layout
    .leftSpaceToView(_companyLabel,5)
    .centerYEqualToView(_companyLabel)
    .heightIs(12)
    .widthIs(0.5);
    
    _positionLabel.sd_layout
    .leftSpaceToView(_shuView,5)
    .bottomEqualToView(_companyLabel)
    .heightIs(12);
    [_positionLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    _deleteBtn.sd_layout
    .rightEqualToView(contentView)
    .centerYEqualToView(_nameLabel)
    .widthIs(50)
    .heightIs(40);
    
    _timeLabel.sd_layout
    .rightSpaceToView(contentView,margin)
    .bottomEqualToView(_companyLabel)
    .heightIs(12);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    _contentLabel.sd_layout
    .leftSpaceToView(contentView,17)
    .topSpaceToView(_iconView,12)
    .rightSpaceToView(contentView,margin)
    .autoHeightRatio(0);
    //moreBtn的告诉在setModel里边设置
    _moreBtn.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel,0)
    .widthIs(40);
    
    _picContainerView.sd_layout
    .centerXEqualToView(self.contentView);//已经在内部实现宽度和高度的自适应所以不需要在设置高度和宽度，top值是具体有无图片在setmodel方法设置
    _partLine.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_picContainerView,10)
    .heightIs(0.5);
    
    CGFloat width = (SCREENWIDTH-2)/3;
    CGFloat height = 42;
    _shareBtn.sd_layout
    .leftEqualToView(contentView)
    .topSpaceToView(_partLine,0)
    .widthIs(width)
    .heightIs(height);
    
    _firstShuView.sd_layout
    .leftSpaceToView(_shareBtn,0)
    .widthIs(1)
    .heightIs(18)
    .centerYEqualToView(_shareBtn);
    
    _commentBtn.sd_layout
    .leftSpaceToView(_firstShuView,0)
    .centerYEqualToView(_shareBtn)
    .heightIs(height)
    .widthIs(width);
    
    _secondShuView.sd_layout
    .leftSpaceToView(_commentBtn,0)
    .heightIs(18)
    .centerYEqualToView(_shareBtn)
    .widthIs(1);
    
    _praiseBtn.sd_layout
    .leftSpaceToView(_secondShuView,0)
    .centerYEqualToView(_shareBtn)
    .widthIs(width)
    .heightIs(height);
    
}

-(void)setModel:(CircleListModel *)model
{
    _model = model;
    _shouldOpenContentLabel = NO;
    if (model.flag) {
        [_praiseBtn setImage:[UIImage imageNamed:@"iconfont_dianzan"] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
//    NSLog(@"图片地址---%@",model.iconNameStr);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.iconNameStr]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    _nameLabel.text = model.nameStr;
    //防止单行文本label在重用时宽度计算不准的问题
    [_nameLabel sizeToFit];
    
    _addressLabel.text = model.addressStr;
    [_addressLabel sizeToFit];
    
    _companyLabel.text = model.companyStr;
    [_companyLabel sizeToFit];
    
    _positionLabel.text = model.positionStr;
    [_positionLabel sizeToFit];
    if ([model.positionStr isEqualToString:@""]) {
        [_shuView setHidden:YES];
    }else{
        [_shuView setHidden:NO];
    }
    
    _timeLabel.text = [TDUtil getDateCha:model.timeSTr];
    
    [_timeLabel sizeToFit];
    
//    _contentLabel.text = model.msgContent;
    [TDUtil setLabelMutableText:_contentLabel content:model.msgContent lineSpacing:5 headIndent:0];
    _picContainerView.pictureStringArray = model.picNamesArray;
//    NSLog(@"-----zhaopian---%@",model.picNamesArray);
    if (model.shouldShowMoreBtn) { //如果文字高度超过60
        _moreBtn.sd_layout.heightIs(20);
        _moreBtn.hidden = NO;
        if (model.isOpening) {//如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            _contentLabel.sd_layout.maxHeightIs(_maxContentLabelHeight);
            [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
    }else{
        _moreBtn.sd_layout.heightIs(0);
        _moreBtn.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    //设置底部操作按钮标题
    [_shareBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.shareCount] forState:UIControlStateNormal];
    [_commentBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.commentCount] forState:UIControlStateNormal];
    [_praiseBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.priseCount] forState:UIControlStateNormal];
    _picContainerView.sd_layout.topSpaceToView(_moreBtn,picContainerTopMargin);
    
    [self setupAutoHeightWithBottomView:_shareBtn bottomMargin:5];
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}
-(void)moreBtnClick
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

-(void)shareBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickShareBtnInCell:andModel:)]) {
        [self.delegate didClickShareBtnInCell:self andModel:_model];
    }
}

-(void)commentBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickCommentBtnInCell:andModel:andIndexPath:)]) {
        [self.delegate didClickCommentBtnInCell:self andModel:_model andIndexPath:_indexPath];
    }
}

-(void)praiseBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickPraiseBtnInCell:andModel:andIndexPath:)]) {
        [self.delegate didClickPraiseBtnInCell:self andModel:_model andIndexPath:_indexPath];
    }
    
}

-(void)deleteBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickDeleteInCell:andModel:andIndexPath:)]) {
        [self.delegate didClickDeleteInCell:self andModel:_model andIndexPath:_indexPath];
    }
}
@end
