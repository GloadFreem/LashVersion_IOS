//
//  ProjectPrepareDetailHeaderView.h
//  company
//
//  Created by Eugene on 16/6/22.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDetailBaseMOdel.h"

@interface ProjectPrepareDetailHeaderView : UIView

@property (nonatomic, strong) ProjectDetailBaseMOdel *model;


@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *projectName;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *address;

@end
