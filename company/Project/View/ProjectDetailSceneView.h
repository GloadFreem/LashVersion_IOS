//
//  ProjectDetailSceneView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/16.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MP3Player.h"

#import "HttpUtils.h"
#import "DialogUtil.h"

#import "ProjectDetailBannerView.h"

@class ProjectDetailSceneView;

@protocol ProjectDetailSceneViewDelegate <NSObject>

@optional
-(void)didClickMoreBtn;


@end
@interface ProjectDetailSceneView : UIView<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic, weak) id<ProjectDetailSceneViewDelegate>delegate;

@property (nonatomic, strong) ProjectDetailBannerView *bannerView;

@property(retain,nonatomic)HttpUtils* httpUtil; //网络请求对象

@property (nonatomic, assign) NSInteger projectId;

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic ,copy) NSString *url;
-(void)startLoadComment;

@end
