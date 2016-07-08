//
//  ProjectBannerDetailVC.h
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectBannerListModel.h"

@interface ProjectBannerDetailVC : UIViewController

@property (nonatomic, strong) ProjectBannerListModel *model;

@property (nonatomic, copy) NSString *url;

@end
