//
//  DetailAreaViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineDataVC.h"

@interface DetailAreaViewController : RootViewController

@property (nonatomic, strong) MineDataVC *dataVc;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *province;



@end
