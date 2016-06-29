//
//  ActivityDetailCommentView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityDetailCommentView.h"

#import "ActivityDetailCommentCellModel.h"

#import "MLLinkLabel.h"

@interface ActivityDetailCommentView ()<MLLinkLabelDelegate>

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) MLLinkLabel *likeLabel;


@property (nonatomic, strong) NSMutableArray *commentLabelsArray;


@end

@implementation ActivityDetailCommentView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    }
    return self;
}


-(void)setupViews
{
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = BGFont(12);
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : orangeColor};
    [self addSubview:_likeLabel];
    
}

-(void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    //初始化commentLabelsArray
    if(!self.commentLabelsArray){
        self.commentLabelsArray = [NSMutableArray new];
    }
    
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        label.tag = i;
        UIColor *highLightColor = orangeColor;
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelTapped:)];
        [label addGestureRecognizer:tap];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        ActivityDetailCellCommentItemModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        label.attributedText = [self generateAttributedStringWithCommentItemModel:model];
    }
}

-(void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"iconfont_zan"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeItemsArray.count; i++) {
        ActivityDetailCellLikeItemModel *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        [attributedText appendAttributedString:[self generateAttributedStringWithLikeItemModel:model]];
        ;
    }
    
    _likeLabel.attributedText = [attributedText copy];
}

-(NSMutableArray*)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray array];
        
    }
    return _commentLabelsArray;
}


-(void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (_commentLabelsArray.count) {
        [_commentLabelsArray enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL  *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES;  //重用时先隐藏原来评论label，然后根据评论个数显示label
        }];
    }
    
    CGFloat margin = 5;
    
    UIView *lastTopView = nil;
    
    if (likeItemsArray.count) {
        _likeLabel.sd_resetLayout
        .leftSpaceToView(self, margin)
        .rightSpaceToView(self, margin)
        .topSpaceToView(lastTopView, 10)
        .autoHeightRatio(0);
        
        _likeLabel.isAttributedContent = YES;
        
        lastTopView = _likeLabel;
        
    } else {
        _likeLabel.sd_resetLayout
        .heightIs(0);
    }
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        CGFloat topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 5;
        label.sd_layout
        .leftSpaceToView(self, 8)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, topMargin)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


#pragma mark - private actions
- (void)commentLabelTapped:(UITapGestureRecognizer *)tap
{
    if (self.didClickCommentLabelBlock) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [tap.view.superview convertRect:tap.view.frame toView:window];
        ActivityDetailCellCommentItemModel *model = self.commentItemsArray[tap.view.tag];
        self.didClickCommentLabelBlock(model.firstUserId, model.firstUserName, rect);
    }
}
- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(ActivityDetailCellCommentItemModel *)model
{
    NSString *text = model.firstUserName;
    if (model.secondUserName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.commentString]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    
    UIColor *highLightColor = orangeColor;
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
    
    if (model.secondUserName) {
        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.secondUserName} range:[text rangeOfString:model.secondUserName]];
    }
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(ActivityDetailCellLikeItemModel *)model
{
    NSString *text = model.userName;
    if(![text isKindOfClass:NSNull.class])
    {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
        UIColor *highLightColor = orangeColor;
        [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.userId} range:[text rangeOfString:model.userName]];
        
        return attString;
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@""];
    return attString;
   
}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}

@end
