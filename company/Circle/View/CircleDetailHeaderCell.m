//
//  CircleDetailHeaderCell.m
//  company
//
//  Created by Eugene on 16/6/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleDetailHeaderCell.h"
#import "PictureContainerView.h"

@implementation CircleDetailHeaderCell

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
    
    CircleContentView *_contentView;
    
    PictureContainerView *_picContainerView;
    UIView *_middleView;
    
    UILabel *_praiseLabel;
    UIView *_bottomView;
    UIButton *_copyBtn;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
-(void)setup
{
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
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = color74;
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = color47;
    _contentLabel.font = BGFont(15);
    _contentLabel.numberOfLines = 0;
    
    _contentLabel.userInteractionEnabled = YES;
    _copyBtn = [UIButton new];
    [_copyBtn setImage:[UIImage imageNamed:@"icon_copy"] forState:UIControlStateNormal];
    [_copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加手势
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabelPress:)];
    longPressGr.minimumPressDuration = 1;
    
    //    longPressGr.numberOfTouchesRequired = 1;
    [_contentLabel addGestureRecognizer:longPressGr];
    
    _contentView = [CircleContentView new];
    _contentView.delegate = self;
    
    _picContainerView = [PictureContainerView new];
    
    _middleView = [UIView new];
    _middleView.backgroundColor = colorGray;
    
    _praiseBtn = [UIButton new];
//    [_praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    [_praiseBtn addTarget:self action:@selector(praiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _praiseLabel = [UILabel new];
    _praiseLabel.font = BGFont(12);
    _praiseLabel.textColor = color47;
    _praiseLabel.numberOfLines = 0;
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = colorGray;
    
    
    NSArray *views = @[_topView,_iconView, _nameLabel, _addressLabel, _companyLabel, _shuView, _positionLabel, _timeLabel, _contentLabel,_copyBtn, _contentView,_picContainerView,_middleView, _praiseBtn, _praiseLabel, _bottomView];
    
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
    
    _companyLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,8)
    .heightIs(12);
    [_companyLabel setSingleLineAutoResizeWithMaxWidth:180*WIDTHCONFIG];
    
    _addressLabel.sd_layout
    .leftSpaceToView(_nameLabel,10)
    .bottomEqualToView(_nameLabel)
    .heightIs(12);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:180];
    
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
    
    _copyBtn.sd_layout
    .bottomSpaceToView(_contentLabel, 5)
    .centerXEqualToView(_contentLabel)
    .widthIs(0)
    .heightIs(0);
    
    _contentView.sd_layout
    .leftSpaceToView(contentView,8)
    .rightSpaceToView(contentView,8)
    .topSpaceToView(_contentLabel,5);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);//已经在内部实现宽度和高度的自适应所以不需要在设置高度和宽度，top值是具体有无图片在setmodel方法设置
    //中间灰色分区
    _middleView.sd_layout
    .topSpaceToView(_picContainerView,5)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .heightIs(10);
    
    _praiseBtn.sd_layout
    .leftSpaceToView(contentView, 12*WIDTHCONFIG)
    .topSpaceToView(_middleView, 12*HEIGHTCONFIG)
    .widthIs(25)
    .heightIs(25);
    
    _praiseLabel.sd_layout
    .leftSpaceToView(_praiseBtn, 6*WIDTHCONFIG)
    .topSpaceToView(_middleView, 15*HEIGHTCONFIG)
    .rightSpaceToView(contentView,20)
    .autoHeightRatio(0);
    
//    _bottomView.sd_layout
//    .leftEqualToView(contentView)
//    .rightEqualToView(contentView)
//    .topSpaceToView(_praiseBtn, 12*HEIGHTCONFIG)
//    .heightIs(10*HEIGHTCONFIG);
//
//    [self setupAutoHeightWithBottomView:_bottomView bottomMargin:0];
}
#pragma mark -设置模型
-(void)setModel:(CircleListModel *)model
{
    _model = model;
    //是否点赞
    if (model.flag) {
        [_praiseBtn setImage:[UIImage imageNamed:@"iconfont_dianzan"] forState:UIControlStateNormal];
    }else{
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
    }
    //头像
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.iconNameStr]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    //防止单行文本label在重用时宽度计算不准的问题
    _nameLabel.text = model.nameStr;
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
    NSString *showText = [model.msgContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [TDUtil setLabelMutableText:_contentLabel content:showText lineSpacing:0 headIndent:0];
    _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
    _picContainerView.pictureStringArray = model.picNamesArray;
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10*HEIGHTCONFIG;
    }
    //今日头条
    if (_model.feelingTypeId == 1) {
        _contentView.sd_layout.heightIs(0);
        _contentView.isHidden = YES;
    }else{
        _contentView.sd_layout.heightIs(85);
        _contentView.titleLabelText = model.titleText;
        _contentView.imageName = model.contentImage;
        _contentView.contentLabelText = model.contentText;
        _contentView.isHidden = NO;
    }
    
    _picContainerView.sd_layout.topSpaceToView(_contentView,picContainerTopMargin);
    _praiseLabel.text = model.priseLabel;
    CGFloat height = [_praiseLabel.text commonStringHeighforLabelWidth:SCREENWIDTH -20 -12 -16 - 10 withFontSize:12];
    if (height > _praiseLabel.font.lineHeight * 3) {
        _praiseLabel.sd_layout.maxHeightIs(_contentLabel.font.lineHeight * 3);
    }else{
        _praiseLabel.sd_layout.maxHeightIs(height);
    }
    if (model.priseLabel.length) {
        [_bottomView sd_clearAutoLayoutSettings];
        
        _bottomView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(_praiseLabel, 15*HEIGHTCONFIG)
        .heightIs(10*HEIGHTCONFIG);
        
    }else{
        [_bottomView sd_clearAutoLayoutSettings];
        _bottomView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(_praiseBtn, 12*HEIGHTCONFIG)
        .heightIs(10*HEIGHTCONFIG);
    }
    
    [self setupAutoHeightWithBottomView:_bottomView bottomMargin:0];
    [self updateLayout];
}
-(void)setIsShow:(BOOL)isShow
{
    _isShow = isShow;
    if (_isShow) {
        [UIView animateWithDuration:0.2 animations:^{
            _copyBtn.sd_layout
            .widthIs(50)
            .heightIs(32);
        }];
        _contentLabel.backgroundColor = colorGray;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _copyBtn.sd_layout
            .widthIs(0)
            .heightIs(0);
        }];
        _contentLabel.backgroundColor = [UIColor whiteColor];
    }
}

-(void)contentLabelPress:(UILongPressGestureRecognizer *)gesture
{
    self.isShow= YES;
}

-(void)copyBtnClick
{
    self.isShow = NO;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentLabel.text;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [[DialogUtil sharedInstance]showDlg:window textOnly:@"已复制到剪切板"];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (_isShow) {
        self.isShow = NO;
    }
}


-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

#pragma mark -点赞按钮事件处理
-(void)praiseBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didClickPraiseBtn:model:)]) {
        [self.delegate didClickPraiseBtn:self model:_model];
    }
}

#pragma mark-点击转发详情---
-(void)didClickContentView
{
    if ([self.delegate respondsToSelector:@selector(didClickContentBtnInCell:andModel:)]) {
        //        NSLog(@"点击按钮");
        [self.delegate didClickContentBtnInCell:self andModel:_model];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
