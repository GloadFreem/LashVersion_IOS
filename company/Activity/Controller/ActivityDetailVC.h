//
//  ActivityDetailVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityViewController.h"
@class ActivityViewModel;
@interface ActivityDetailVC : RootViewController
@property(nonatomic, retain)ActivityViewModel * activityModel;

@property (nonatomic, strong) ActivityViewController *viewController;
@property (nonatomic, assign) NSInteger actionId;

@property (nonatomic, assign) BOOL isExpired;

@end
