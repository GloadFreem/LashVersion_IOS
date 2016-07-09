//
//  ActivityDetailVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityViewController.h"

@interface ActivityDetailVC : RootViewController
@property(nonatomic, retain)ActivityViewModel * activityModel;

@property (nonatomic, strong) ActivityViewController *viewController;
@end
