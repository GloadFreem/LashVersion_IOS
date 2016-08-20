//
//  ProjectDetailSceneView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/16.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MP3Player.h"
#import "MyAVAudioPlayer.h"
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

@property (strong, nonatomic) UITableViewCustomView * tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic ,copy) NSString *url;

@property (nonatomic, copy) NSString *totoalTime;

@property (nonatomic, copy) NSString *scenePartner;
@property (nonatomic, copy) NSString *commentPartner;
@property (nonatomic, copy) NSString *pptPartner;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) BOOL isRun;
@property (nonatomic, assign) BOOL isPPT;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *pptArray;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) NSMutableArray *nextPageArray;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) MP3Player *player;

@property (nonatomic, copy) NSString *authenticName;

/*
 NSString *_scenePartner;
 NSString *_commentPartner;
 NSString *_pptPartner;
 UISlider *_slider;
 BOOL _isRun;
 BOOL _isPPT;
 MusicModel *_musicModel;
 UILabel *_label;
 NSInteger _sceneId;
 NSInteger _page;
 NSMutableArray *_pptArray;
 NSMutableArray *_imageUrlArray;
 NSMutableArray *_nextPageArray;
 UIButton *_moreBtn;
 NSTimer *_timer;
 BOOL _isFirst;
 MP3Player*_player;
 
 */
-(void)startLoadComment;
- (void)removeObserverAndNotification;

@end
