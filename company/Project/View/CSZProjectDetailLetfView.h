//
//  CSZProjectDetailLetfView.h
//  company
//
//  Created by air on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailBaseMOdel.h"
#import "ProjectDetailLeftHeaderModel.h"
#import "ProjectDetailLeftTeamModel.h"
@interface CSZProjectDetailLetfView : UIView
@property (nonatomic, strong) ProjectDetailLeftTeamModel *teamModel;
@property (nonatomic, strong) ProjectDetailLeftHeaderModel *headerModel;
@property (nonatomic, strong) ProjectDetailBaseMOdel *model;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(Boolean flag);

@property (nonatomic, assign) BOOL isPrepare;

@end
