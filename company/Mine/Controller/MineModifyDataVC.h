//
//  MineModifyDataVC.h
//  company
//
//  Created by Eugene on 2016/9/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineDataVC.h"
@interface MineModifyDataVC : RootViewController

@property (nonatomic, strong) MineDataVC *dataVC;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *placorText;

@end
