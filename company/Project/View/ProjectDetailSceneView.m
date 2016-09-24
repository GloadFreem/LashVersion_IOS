//
//  ProjectDetailSceneView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/16.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailSceneView.h"
#import "ProjectDetailSceneMessageCell.h"
#import "ProjectSceneOtherCell.h"

#import "MusicModel.h"
#import "ProjectSceneModel.h"
#import "ProjectDetailSceneCellModel.h"
#import "ProjectSceneCommentModel.h"
#import "ProjectPPTModel.h"

#define REQUESTSCENE @"requestScene"
#define REQUESTSCENECOMMENT @"requestProjectSceneCommentList"
#define REQUESTPPT @"requestRecorData"
@implementation ProjectDetailSceneView
{
    id _playTimeObserver; // 播放进度观察者
    BOOL isRemoveNot; // 是否移除通知
    AVPlayerItem *playerItem;
    UIButton * startBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //初始化网络请求对象
        self.httpUtil  =[[HttpUtils alloc]init];
        [self createUI];
        _isFirst = YES;
        _page = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"stopTimer" object:nil];
        
        _scenePartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSCENE];
        _commentPartner = [TDUtil encryKeyWithMD5:KEY action: REQUESTSCENECOMMENT];
        _pptPartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTPPT];
        
        if (!_dataArray) {
            _dataArray = [NSMutableArray array];
        }
        if (!_pptArray) {
            _pptArray = [NSMutableArray array];
        }
        if (!_imageUrlArray) {
            _imageUrlArray = [NSMutableArray array];
        }
        if (!_nextPageArray) {
            _nextPageArray = [NSMutableArray array];
        }
        
        if (!_player) {
            _player=[[MP3Player alloc]init];
            _player.isPlayMusic = NO;
        }
    }
    return self;
}


-(void)setProjectId:(NSInteger)projectId
{
    _projectId = projectId;
    //加载数据
    [self loadData];
}


-(void)loadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",_scenePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_SCENE postParam:dic type:0 delegate:self sel:@selector(requestProjectScene:)];
}


-(void)requestProjectScene:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *modelArray = [ProjectSceneModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            if (modelArray.count) {
                ProjectSceneModel *model = modelArray[0];
                
                _url = model.audioPath;
//                NSLog(@"打印语音链接---%@",_url);
                _sceneId = model.sceneId;
                _totoalTime = [self getTime:model.totlalTime];
//                NSLog(@"语音时长---%ld",model.totlalTime);
                [self initialControls];
                
                [self startLoadComment];
                
                if (_isFirst) {
                    [self startLoadPPT];
                    [self startPlay];
                    _isFirst = NO;
                }
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadDataRegular) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
           [_timer setFireDate:[NSDate distantPast]];
            
        }else{
//            [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(NSString*)getTime:(NSInteger)time
{
    time = time/1000;
    
    NSString *timeStr;
    if (time <= 59) {
        timeStr = [NSString stringWithFormat:@"00:00:%ld",(long)time];
    }else if (60 < time  && time <= 3599 ){
        NSInteger minute = time / 60;
        NSInteger second = time % 60;
        timeStr = [NSString stringWithFormat:@"00:%.2ld:%.2ld",(long)minute,(long)second];
    }else{
        NSInteger hour = time / 3600;
        NSInteger minute = (time % 3600) / 60;
        NSInteger second = time % 3600 % 60;
        timeStr = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)second];
        
    }
    return timeStr;
}
-(void)loadDataRegular
{
//    _page = 0;
    [self startLoadComment];
}


-(void)startLoadPPT
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",_pptPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_sceneId],@"sceneId",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_RECORDATA postParam:dic type:0 delegate:self sel:@selector(requestScenePPT:)];
}
-(void)requestScenePPT:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *modelArray= [ProjectPPTModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            
//            if (_pptArray.count) {
//                [_pptArray removeAllObjects];
//            }
            
            for (NSInteger i =0; i < modelArray.count; i ++) {
                [_pptArray addObject:modelArray[i]];
                ProjectPPTModel *model = modelArray[i];
                if (model.imageUrl) {
                   [_imageUrlArray addObject:model.imageUrl];
                }
//                NSLog(@"实时下载最新数据");
            }
            
//            for (NSInteger i = 0; i < _pptArray.count; i ++) {
//                ProjectPPTModel *model = _pptArray[i];
//                [_imageUrlArray addObject:model.imageUrl];
//            }
            [_bannerView relayoutWithModelArr:_imageUrlArray];
            
//            NSLog(@"打印数组个数---%ld",(unsigned long)_nextPageArray.count);
            
            _isPPT  = YES;
            
        }else{
//        [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)startLoadComment
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",_commentPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_sceneId],@"sceneId",@"0",@"page",@"1",@"platform", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_SCENE_COMMENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestSceneComment:)];
}
-(void)requestSceneComment:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *modelArray = [ProjectSceneCommentModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            NSMutableArray * array = [NSMutableArray new];
            for (NSInteger i = 0; i < modelArray.count; i ++) {
                ProjectSceneCommentModel *model = modelArray[i];
                ProjectDetailSceneCellModel *cellModel = [ProjectDetailSceneCellModel new];
                cellModel.flag = model.flag;
                cellModel.iconImage = model.users.headSculpture;
                cellModel.name = model.users.name;
                cellModel.content = model.content;
                cellModel.time = model.commentDate;
                
                //计算时间差
                if (i!=0) {
                    ProjectSceneCommentModel *model1 = modelArray[i-1];
                    int timerInterval = [TDUtil getDateSinceFromDate:cellModel.time toDate:model1.commentDate];
                    if (timerInterval>5) {
                        cellModel.isShowTime  = YES;
                    }else{
                        cellModel.isShowTime  = NO;
                    }
                }else{
                    cellModel.isShowTime  = YES;
                }
                
                [array insertObject:cellModel atIndex:0];

            }
             self.dataArray = [NSMutableArray arrayWithArray:array];
            
            if (_dataArray.count > 1) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
        }else{
//            [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
-(void)createUI
{
    [self createHeaderView];
    
    _tableView = [[UITableViewCustomView alloc]init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor  = color(237, 238, 239, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(60);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-50);
    }];
    
    _moreBtn = [UIButton new];
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"icon_sceneMore"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn setAdjustsImageWhenHighlighted:NO];
    [self addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-self.frame.size.height/4);
    }];
    
}

-(void)moreClick:(UIButton*)btn
{
    if ([self.delegate respondsToSelector:@selector(didClickMoreBtn)]) {
        [self.delegate didClickMoreBtn];
    }
}
-(void)createHeaderView
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView * lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    lightView.backgroundColor = [UIColor lightGrayColor];
    lightView.alpha = 0.3;
    [headerView addSubview:lightView];
    [self addSubview:headerView];
    
    startBtn = [[UIButton alloc]init];
    
    [startBtn setImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
//    //暂停播放图片
//    [startBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateSelected];
    
    //播放图片
    [startBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    
    startBtn.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(headerView.mas_centerY).offset(10);
        make.width.height.mas_equalTo(30);
    }];
    
    UILabel *label =[[UILabel alloc]init];
    label.text = _totoalTime;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor darkGrayColor];
    label.font =[UIFont systemFontOfSize:12];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerView.mas_right).offset(-27);
        make.centerY.mas_equalTo(headerView.mas_centerY).offset(10);
    }];
    _label = label;
    
    _slider =[[UISlider alloc]init];
    _slider.continuous = YES;
    [_slider setUserInteractionEnabled:YES];
    [_slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    
    [_slider setThumbImage:[UIImage imageNamed:@"icon_slider_point"] forState:UIControlStateNormal];
    [headerView addSubview:_slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(startBtn.mas_right).offset(20);
        make.centerY.mas_equalTo(headerView.mas_centerY).offset(10);
        make.right.mas_equalTo(label.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    
}


#pragma mark----初始化 播放
-(void)startPlay
{
    if (isRemoveNot) {
        //如果已经存在 移除通知。kvo 初始化控件属性
        [self removeObserverAndNotification];
        [self initialControls];
        isRemoveNot = NO;
    }
    
    if (!_player.isPlayMusic) {
        NSString *path = [NSString stringWithFormat:@"%@",_url];
        NSURL *url =[NSURL URLWithString:path];
        
        playerItem = [[AVPlayerItem alloc]initWithURL:url];
        
        _player.player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
//        [_player.player replaceCurrentItemWithPlayerItem:playerItem];
        //增加观察者 监听status属性
       [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        //进度  帧数 帧率
        __weak AVPlayer *Wplayer = _player.player;

        __weak ProjectDetailSceneView *weakSelf = self;
        
        _playTimeObserver = [_player.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            
            NSInteger current = CMTimeGetSeconds(time);
            
            if (current) {
            
                [weakSelf updateTimeLabel:current];
                
            }
            //实时监听遍历是否换页
//            [weakSelf updatePPT:current];
            //当前时间
            CMTime currentTime=Wplayer.currentItem.currentTime;
            //总时间
            CMTime duration=Wplayer.currentItem.duration;
            //进度＝当前时间/总时间
            float pro = CMTimeGetSeconds(currentTime)/CMTimeGetSeconds(duration);
            [weakSelf updateVideoSlider:pro];
            
        }];
    }
    
//    [self addEndTimeNotification];
//
    isRemoveNot = YES;
}

// 各控件设初始值
- (void)initialControls{
    [self stop];
    _label.text = _totoalTime;
}
#pragma mark ------------是否播放-------------------
-(void)playClick:(UIButton*)btn
{
        if (_player.isPlayMusic) {
            [self stop];
        }else{
            [self play];
        }
}


-(void)play
{
    if (![_url isEqualToString:@""]) {
        _player.isPlayMusic = YES;
        [self.player.player play];
//        _bannerView.scrollView.scrollEnabled = YES;
        [startBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }else{
     [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:@"该项目暂无音频"];
    }
    
}
- (void)stop{
    _player.isPlayMusic = NO;
    [self.player.player pause];
//    _bannerView.scrollView.scrollEnabled = YES;
    [startBtn setImage:[UIImage imageNamed:@"iconfont-bofang"] forState:UIControlStateNormal];
}

#pragma mark - KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
//            NSLog(@"AVPlayerStatusReadyToPlay");
//            CMTime duration = item.duration;// 获取音频总长度
//            [self setMaxDuratuin:CMTimeGetSeconds(duration)];
//            [self play];
            _slider.userInteractionEnabled = YES;
        }else if([playerItem status] == AVPlayerStatusFailed) {
            _slider.userInteractionEnabled = NO;
            
//            NSLog(@"AVPlayerStatusFailed");
            [self stop];
            
        }
    }
}

//-(void)setMaxDuratuin:(float)duration
//{
//    self.slider.maximumValue = duration;
//}

-(void)updatePPT:(NSInteger)current
{
    for (NSInteger i = 0; i < _pptArray.count; i ++) {
//        ProjectPPTModel *model = _pptArray[i];
//        if (current >= model.startTime && current <= model.endTime) {
        
          //NSLog(@"当前ppt页数----%ld",(long)model.sortIndex);
            NSInteger currentPage = _bannerView.scrollView.contentOffset.x/SCREENWIDTH;
            if (currentPage == _pptArray.count -2) {
                [self startLoadMore];
//            }
//            [_bannerView nextPage: model.sortIndex];
//            NSLog(@"翻到-----%ld页",(long)model.sortIndex);
        }
    }
}

#pragma mark----更新进度条----
-(void)updateVideoSlider:(CGFloat)currentTime
{
    [_slider setValue:currentTime animated:YES];
    
//    NSLog(@"更新进度条------%lf",currentTime);
}
#pragma mark----更新时间----
-(void)updateTimeLabel:(NSInteger)currentTime
{
    if (currentTime <= 59) {
        _label.text = [NSString stringWithFormat:@"00:00:%ld",(long)currentTime];
    }else if (60 < currentTime  && currentTime <= 3599 ){
        NSInteger minute = currentTime / 60;
        NSInteger second = currentTime % 60;
        _label.text = [NSString stringWithFormat:@"00:%.2ld:%.2ld",(long)minute,(long)second];
    }else{
        NSInteger hour = currentTime / 3600;
        NSInteger minute = (currentTime % 3600) / 60;
        NSInteger second = currentTime % 3600 % 60;
        _label.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hour,(long)minute,(long)second];
        
    }
}

-(void)startLoadMore
{
    _page ++;
    [self startLoadPPT];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (_dataArray.count <= 0 ) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
        [self.tableView reloadData];
    }
}


#pragma mark---------- slider的进度事件
-(void)valueChanged
{
    CMTime currentTime=CMTimeMultiplyByFloat64(_player.player.currentItem.duration, _slider.value);
    [_player.player seekToTime:currentTime];
}


-(void)addEndTimeNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"音频播放完成.");
    
}
#pragma mark - 移除通知&KVO
- (void)removeObserverAndNotification{
    [self.player.player replaceCurrentItemWithPlayerItem:nil];
    
    [playerItem removeObserver:self forKeyPath:@"status"];
    
    [self.player.player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
//    _player.player = nil;
}

#pragma mark -UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  
//{
//    return [self createHeaderView];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectDetailSceneCellModel *model = self.dataArray[indexPath.row];
    if (model.flag) {
        return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ProjectDetailSceneMessageCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ProjectSceneOtherCell class] contentViewWidth:[self cellContentViewWith]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        ProjectDetailSceneCellModel *model = _dataArray[indexPath.row];
        
        if (model.flag) {
            static NSString *cellId = @"ProjectDetailSceneMessageCell";
            ProjectDetailSceneMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[ProjectDetailSceneMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
            cell.model = model;
            return cell;
        }
        
        static NSString *cellId = @"ProjectSceneOtherCell";
        ProjectSceneOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ProjectSceneOtherCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.model = model;
        return cell;
    }
    return nil;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)stopTimer{
    
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

@end
