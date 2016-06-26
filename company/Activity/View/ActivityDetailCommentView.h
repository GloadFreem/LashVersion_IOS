//
//  ActivityDetailCommentView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailCommentView : UIView


-(void)setupWithLikeItemsArray:(NSArray*)likeItemsArray commentItemsArray:(NSArray*)commentItemsArray;

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);

@end
