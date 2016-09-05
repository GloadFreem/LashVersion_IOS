//
//  ActivityCommentCell.m
//  company
//
//  Created by air on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityCommentCell.h"
#import "MLLinkLabel.h"

@interface ActivityCommentCell()<MLLinkLabelDelegate>
{
    MLLinkLabel *label ;
    UIImageView *commentImgView;
}
@end
@implementation ActivityCommentCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        commentImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_answer"]];
        [self.contentView addSubview:commentImgView];
        
        
        label = [MLLinkLabel new];
        UIColor *highLightColor = orangeColor;
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        label.isAttributedContent = YES;
        [self.contentView addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentLabelTapped:)];
        [self addGestureRecognizer:tap];
        
        label.sd_layout
        .topSpaceToView(self.contentView,5)
        .leftSpaceToView(self.contentView,50)
        .rightSpaceToView(self.contentView,20)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:label bottomMargin:5];
    }
    
    return self;
}

- (void)setRow:(NSInteger)row
{
    _row = row;
    if (1 == _row) {
        commentImgView.hidden = NO;
        commentImgView.sd_layout.leftSpaceToView(self.contentView, 20)
        .topSpaceToView(self.contentView, 10)
        .widthIs(16)
        .heightIs(16);
        
        label.sd_layout.topSpaceToView(self.contentView, 10);
    } else{
        commentImgView.hidden = YES;
    }
}

-(void)setModel:(ActivityDetailCellCommentItemModel *)model
{
    _model = model;
    if(_model)
    {
        self.model.commentString = [self.model.commentString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        label.attributedText = [self generateAttributedStringWithCommentItemModel:self.model];
        
        [label updateLayout];
    }
    
}

#pragma mark - private actions
- (void)commentLabelTapped:(UITapGestureRecognizer *)tap
{
    if (self.didClickCommentLabelBlock) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [tap.view.superview convertRect:tap.view.frame toView:window];
        self.didClickCommentLabelBlock(self.model.firstUserId,self.model.firstUserName, rect,_model);
    }
}

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(ActivityDetailCellCommentItemModel *)model
{
    if (model.firstUserName) {
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
            [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
        }
        return attString;

    }
    return nil;
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
