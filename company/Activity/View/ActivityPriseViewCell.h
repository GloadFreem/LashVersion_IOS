//
//  ActivityPriseViewCell.h
//  company
//
//  Created by air on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionLikerModel.h"
@interface ActivityPriseViewCell : UITableViewCell
@property (nonatomic, strong) ActionLikerModel *model;
@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);
@end
