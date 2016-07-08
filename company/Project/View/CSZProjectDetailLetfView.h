//
//  CSZProjectDetailLetfView.h
//  company
//
//  Created by air on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailLeftTeamView.h"

#import "ProjectDetailBaseMOdel.h"
#import "ProjectDetailLeftHeaderModel.h"
#import "ProjectDetailLeftTeamModel.h"

@class CSZProjectDetailLetfView;

@protocol CSZProjectDetailLetfViewDelegate <NSObject>

@optional

-(void)transportTeamModel:(DetailTeams*)team;

-(void)transportExrModel:(DetailExtr*)extr;

@end

@interface CSZProjectDetailLetfView : UIView<ProjectDetailLeftTeamViewDelegate>

@property (nonatomic,assign) id<CSZProjectDetailLetfViewDelegate>delegate;

@property (nonatomic, strong) ProjectDetailLeftTeamModel *teamModel;
@property (nonatomic, strong) ProjectDetailLeftHeaderModel *headerModel;
@property (nonatomic, strong) ProjectDetailBaseMOdel *model;
@property (nonatomic, copy) void (^moreButtonClickedBlock)(Boolean flag);

@property (nonatomic, assign) BOOL isPrepare;

@end
