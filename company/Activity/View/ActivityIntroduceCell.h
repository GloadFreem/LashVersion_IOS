//
//  ActivityIntroduceCell.h
//  company
//
//  Created by LiLe on 16/8/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionIntroduceFrame;
@class ActionIntroduce;

@interface ActivityIntroduceCell : UITableViewCell

@property (nonatomic, strong) ActionIntroduceFrame *actionIntroF;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

@interface ActivityIntroduceImgCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) ActionIntroduce *actionIntro;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
