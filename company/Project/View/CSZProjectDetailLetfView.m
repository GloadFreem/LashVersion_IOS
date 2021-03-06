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
    
    if (model.project.teams.count <= 0 && model.extr.count <= 0) {
        teamView.sd_layout.heightIs(0);
        teamView.imageHeight = 0;
        teamView.scrollHeightFirst = 0;
        teamView.scrollHeightSecond = 0;
        teamView.topHeight = 0;
        teamView.midHeight = 0;
        teamView.botHeight = 0;
    }
    if (model.project.teams.count <= 0 && model.extr.count > 0) {
        teamView.sd_layout.heightIs(360 - 130);
        teamView.imageHeight = 20;
        teamView.scrollHeightSecond = 130;
        teamView.scrollHeightFirst = 0;
        teamView.extrModelArray = [NSMutableArray arrayWithArray:model.extr];
        teamView.topHeight = 10;
        teamView.midHeight = 0;
        teamView.botHeight = 10;
    }
    if (model.project.teams.count > 0 && model.extr.count <= 0) {
        teamView.sd_layout.heightIs(360 - 130);
        teamView.imageHeight = 20;
        teamView.scrollHeightFirst = 130;
        teamView.scrollHeightSecond = 0;
        teamView.teamModelArray = [NSMutableArray arrayWithArray:model.project.teams];
        teamView.topHeight = 10;
        teamView.midHeight = 0;
        teamView.botHeight = 10;
    }
    if (model.project.teams.count > 0 && model.extr.count > 0) {
        teamView.sd_layout.heightIs(360);
        teamView.scrollHeightFirst = 130;
        teamView.scrollHeightSecond = 130;
        teamView.imageHeight = 20;
        teamView.extrModelArray = [NSMutableArray arrayWithArray:model.extr];
        teamView.teamModelArray = [NSMutableArray arrayWithArray:model.project.teams];
        teamView.topHeight = 10;
        teamView.midHeight = 10;
        teamView.botHeight = 10;
    }

//    teamView.teamModelArray = [NSMutableArray arrayWithArray:model.project.teams];
//    teamView.extrModelArray = [NSMutableArray arrayWithArray:model.extr];
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
    teamView.authenticName = self.authenticName;
    teamView.delegate = self;
    
    //2.添加到View
    [self addSubview:headerView];
    [self addSubview:teamView];
    __weak typeof(self) weakself = self;
    
    //3.设置属性
    [headerView setMoreButtonClickedBlock:^(Boolean flag)
    {
        if(weakself.moreButtonClickedBlock)
        {
            weakself.moreButtonClickedBlock(flag);
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
    .rightSpaceToView(self,0);
//    .heightIs(360);
    
    [self setupAutoHeightWithBottomView:teamView bottomMargin:10];
    //立即布局
    [headerView updateLayout];
    
    [self layoutSubviews];
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

-(void)didClickCoverBtn
{
    if ([self.delegate respondsToSelector:@selector(transportCoverClick)]) {
        [self.delegate transportCoverClick];
    }
}
@end
