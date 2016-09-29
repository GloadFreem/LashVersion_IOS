//
//  ActivityInfoCell.h
//  company
//
//  Created by LiLe on 16/8/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionIntroduce;
@class ActionIntroduceFrame;

@interface ActivityInfoCell : UITableViewCell

@property (nonatomic, strong) NSArray<ActionIntroduceFrame *> *actionIntroFs;

@property (nonatomic, assign) CGFloat tableViewH;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
