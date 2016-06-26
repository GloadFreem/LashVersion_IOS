//
//  ActivityViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewModel.h"
#import "ActivityDetailHeaderModel.h"
@interface ActivityCommentListViewController : RootViewController
@property (nonatomic, strong) ActivityDetailHeaderModel * headerModel;
@property(nonatomic, retain)ActivityViewModel * activityModel;
@end
