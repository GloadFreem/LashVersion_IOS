//
//  ProjectDetailController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineAttentionVC.h"
#import "ProjectListProModel.h"


typedef enum{
    
    SegmentSelectLine = 0,//选中时为横线的样式
    SegmentCaver = 1,//选中时view的状态
    
}SelectType;

@interface ProjectDetailController : RootViewController


@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) SelectType type;

@property (assign, nonatomic) CGFloat viewHeight;

@property (assign, nonatomic) CGFloat detailHeight;
@property (assign, nonatomic) CGFloat memberHeight;
@property (assign, nonatomic) CGFloat sceneHeight;

@property (nonatomic, assign) BOOL isMine;

@property (nonatomic, strong) MineAttentionVC *attentionVC;

@property (nonatomic, strong) ProjectListProModel *listModel;

@property (nonatomic, strong) UITableView *tableView;

@end
