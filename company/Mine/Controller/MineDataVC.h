//
//  MineDataVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineViewController.h"

@interface MineDataVC : RootViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) UIImage *iconImg;

@property (nonatomic, assign) NSInteger identiyTypeId;

@property (nonatomic, copy) NSString *authId;

@property (nonatomic, strong) MineViewController *mineVC;

@end
