//
//  HeadlineDetailViewController.h
//  company
//
//  Created by LiLe on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "RootViewController.h"

@interface HeadlineDetailViewController : RootViewController

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *contentText;
@end
