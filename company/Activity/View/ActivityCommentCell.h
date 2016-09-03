//
//  ActivityCommentCell.h
//  company
//
//  Created by air on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailCommentCellModel.h"
@interface ActivityCommentCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, retain) ActivityDetailCellCommentItemModel * model;
@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString * userId,NSString *name, CGRect rectInWindow);
@end
