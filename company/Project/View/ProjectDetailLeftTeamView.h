//
//  ProjectDetailLeftTeamCell.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDetailLeftTeamModel.h"
#import "ProjectDetailLeftFooterModel.h"

#import "ProjectDetailBaseMOdel.h"

@class ProjectDetailLeftTeamView;

@protocol ProjectDetailLeftTeamViewDelegate <NSObject>

@optional

-(void)didClickBtnInTeamViewWithModel:(DetailTeams*)team;

-(void)didClickBtnInTeamExrViewWithModel:(DetailExtr*)extr;

-(void)didClickCoverBtn;

@end


@interface ProjectDetailLeftTeamView : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, assign) id<ProjectDetailLeftTeamViewDelegate>delegate;

@property (nonatomic, copy) NSString *authenticName;
@property (nonatomic, strong) NSMutableArray *extrModelArray;
@property (nonatomic, strong) ProjectDetailLeftTeamModel *model;
@property (nonatomic, strong) NSMutableArray *teamModelArray;

@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, assign) CGFloat midHeight;
@property (nonatomic, assign) CGFloat botHeight;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat scrollHeightFirst;
@property (nonatomic, assign) CGFloat scrollHeightSecond;

@end
