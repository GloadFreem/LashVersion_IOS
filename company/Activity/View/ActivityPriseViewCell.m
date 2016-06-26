//
//  ActivityPriseViewCell.m
//  company
//
//  Created by air on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityPriseViewCell.h"
#import "MLLinkLabel.h"
#import "ActivityDetailCommentCellModel.h"
@interface ActivityPriseViewCell()
{
    
}
@property (nonatomic, strong) NSArray *likeItemsArray;

@property (nonatomic, strong) MLLinkLabel *likeLabel;
@end
@implementation ActivityPriseViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setup];
        
        return self;
    }
    return nil;
}


-(void)setup
{
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = BGFont(12);
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : orangeColor};
    [self.contentView addSubview:_likeLabel];
    
    _likeLabel.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 30)
    .autoHeightRatio(0);
    
    _likeLabel.isAttributedContent = YES;
    
     [self setupAutoHeightWithBottomView:_likeLabel bottomMargin:6];
    
}

-(void)setModel:(ActionLikerModel *)model
{
    _model = model;
    
    [self setupWithLikeItemsArray:_model.likers];
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
    
    [_likeLabel updateLayout];
    [self.contentView updateLayout];
}



-(void)setupWithLikeItemsArray:(NSArray *)likeItemsArray
{
    self.likeItemsArray = likeItemsArray;
    
//    CGFloat margin = 5;
    
//    
//    if (likeItemsArray.count) {
//        _likeLabel.sd_resetLayout
//        .leftSpaceToView(self.contentView, 20)
//        .rightSpaceToView(self.contentView, margin)
//        .topSpaceToView(self.contentView, 30)
//        .autoHeightRatio(0);
//        
//        _likeLabel.isAttributedContent = YES;
//        
//    } else {
//        _likeLabel.sd_resetLayout
//        .heightIs(0);
//    }
    
   
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}


#pragma mark - private actions
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
