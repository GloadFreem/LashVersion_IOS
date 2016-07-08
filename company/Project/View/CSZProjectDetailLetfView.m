//
//  CSZProjectDetailLetfView.m
//  company
//
//  Created by air on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CSZProjectDetailLetfView.h"
#import "ProjectDetailLeftHeaderView.h"
#import "ProjectDetailLeftTeamView.h"
@implementation CSZProjectDetailLetfView
{
    ProjectDetailLeftHeaderView * headerView;
    ProjectDetailLeftTeamView * teamView;
}
-(id)init
{
    if (self = [super init]) {
        //开始布局
        [self setup];
    }
    
    return self;
}

-(void)setModel:(ProjectDetailBaseMOdel *)model
{
    _model = model;
    _headerModel   = [ProjectDetailLeftHeaderModel new];
    _headerModel.projectStr = model.project.abbrevName;
    NSArray *roadshowsArray = model.project.roadshows;
    DetailRoadshows *roadShow = roadshowsArray[0];
    
    _headerModel.financedMount = roadShow.roadshowplan.financedMount;
    _headerModel.financeTotal = roadShow.roadshowplan.financeTotal;
    
    _headerModel.goalStr = [NSString stringWithFormat:@"%ld万",(long)roadShow.roadshowplan.financeTotal];
    _headerModel.achieveStr = [NSString stringWithFormat:@"%ld万",(long)roadShow.roadshowplan.financedMount];
//    _headerModel.timeStr =
    NSString *startTime = [roadShow.roadshowplan.beginDate componentsSeparatedByString:@" "][0];
    NSString *endTime = [roadShow.roadshowplan.endDate componentsSeparatedByString:@" "][0];
    startTime = [startTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    endTime = [endTime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    _headerModel.timeStr = [NSString stringWithFormat:@"%@—%@",startTime,endTime];
    _headerModel.addressStr = model.project.address;
    _headerModel.statusStr = model.project.financestatus.name;
    _headerModel.content = model.project.desc;
    
    NSMutableArray *photoArr = [NSMutableArray array];
    NSArray *picArray = [NSArray arrayWithArray:model.project.projectimageses];
    for (NSInteger i = 0; i < picArray.count; i ++) {
        DetailProjectimageses *image = picArray[i];
        [photoArr addObject:image.imageUrl];
    }
    _headerModel.pictureArray = [NSArray arrayWithArray:photoArr];
    headerView.model = _headerModel;
    
//    teamView.teamModelArray = [NSMutableArray array];
//    NSArray *teamModelArray = [NSArray arrayWithArray:model.project.teams];
//    for (NSInteger i =0; i < teamModelArray.count; i ++) {
//        [teamView.teamModelArray addObject:teamModelArray[i]];
//    }
    
    teamView.teamModelArray = [NSMutableArray arrayWithArray:model.project.teams];
    teamView.extrModelArray = [NSMutableArray arrayWithArray:model.extr];
//    NSArray *extrArray = [NSArray arrayWithArray:model.extr];
//    for (NSInteger i = 0; i < extrArray.count; i ++) {
//        [teamView.extrModelArray addObject:extrArray[i]];
//    }
}
/**
 *  布局洁面
 */
-(void)setup
{
    //1.初始化控件
    headerView = [ProjectDetailLeftHeaderView new];
    
    teamView = [ProjectDetailLeftTeamView new];
    teamView.delegate = self;
    
    //2.添加到View
    [self addSubview:headerView];
    [self addSubview:teamView];
    //3.设置属性
    [headerView setMoreButtonClickedBlock:^(Boolean flag)
    {
        if(self.moreButtonClickedBlock)
        {
            self.moreButtonClickedBlock(flag);
        }
    }];
    
    
    //4.设置布局
    headerView.sd_layout
    .topSpaceToView(self,0)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(300);
    
    teamView.sd_layout
    .topSpaceToView(headerView,0)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0)
    .heightIs(320);
    
    [self setupAutoHeightWithBottomView:teamView bottomMargin:50];
    //立即布局
    [headerView updateLayout];
}

-(void)didClickBtnInTeamViewWithModel:(DetailTeams *)team
{
    if ([self.delegate respondsToSelector:@selector(transportTeamModel:)]) {
        [self.delegate transportTeamModel:team];
    }
}
-(void)didClickBtnInTeamExrViewWithModel:(DetailExtr *)extr
{
    if ([self.delegate respondsToSelector:@selector(transportExrModel:)]) {
        [self.delegate transportExrModel:extr];
    }
}

@end
