//
//  CircleDetailVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleViewController.h"
@interface CircleDetailVC : RootViewController

@property (nonatomic, assign) NSInteger publicContentId;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, retain)NSIndexPath * indexPath;

@property (nonatomic, assign)CircleViewController * viewController;

@end
