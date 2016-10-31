//
//  ProjectBannerDetailVC.h
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectBannerListModel.h"

@interface ProjectBannerDetailVC : RootViewController

@property (nonatomic, strong) ProjectBannerListModel *model;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *contentText;

@property (nonatomic, assign) BOOL isActivity;
@property (nonatomic, assign) BOOL isPoint;
@property (nonatomic, assign) BOOL isFast;
@property (nonatomic, assign) BOOL isCircle;
@end
