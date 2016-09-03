//
//  HeadlineCell.h
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Headline;

@interface HeadlineBottomImgCell : UITableViewCell

@property (nonatomic, strong) Headline *headline;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
