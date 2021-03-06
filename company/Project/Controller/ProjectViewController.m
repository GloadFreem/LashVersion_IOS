//
//  ProjectViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectViewController.h"
#import "NetStatusViewController.h"

#import "DataBaseHelper.h"

#import "LoginRegistViewController.h"

#import "UpProjectViewController.h"
#import "ProjectLetterViewController.h"

#import "ProjectListCell.h"
#import "ProjectNoRoadCell.h"

#import "ProjectBannerView.h"
#import "ProjectBannerModel.h"
#import "ProjectBannerListModel.h"
#import "ProjectBannerDetailVC.h"

#import "ProjectListProBaseModel.h"
#import "ProjectListProModel.h"

#import "ProjectDetailController.h"
#import "ProjectPrepareDetailVC.h"

#import "ProjectSearchController.h"


#define PROJECTLIST @"requestProjectList"
#define BANNERSYSTEM @"bannerSystem"
#define VERSIONINFO @"versionInfoSystem"
#define GOLDCOUNT @"requestUserGoldGetInfo"

#define BannerHeight  SCREENWIDTH * 0.5 + 45
@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectBannerViewDelegate>

{
    ProjectBannerView * _bannerView;
    DataBaseHelper *_dataBase;
    CAEmitterLayer * _fireEmitter;//发射器对象
    UIImageView *imageView;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UITableViewCustomView *tableView;

@property (nonatomic, assign) NSInteger selectedCellNum;//选择显示cell的类型

@property (nonatomic, copy) NSString *bannerPartner; 
@property (nonatomic, strong) NSMutableArray *bannerModelArray; //banner数组
@property (nonatomic, strong) NSMutableArray *projectModelArray;
@property (nonatomic, strong) NSMutableArray *roadModelArray;
@property (nonatomic, strong) NSMutableArray *tempProArray;
@property (nonatomic, strong) NSMutableArray *tempRoadArray;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger projectPage;
@property (nonatomic, assign) NSInteger lastProjectPage;
@property (nonatomic, assign) NSInteger roadPage;
@property (nonatomic, assign) NSInteger lastRoadPage;
@property (nonatomic, copy) NSString *type;

//版本更新
@property (nonatomic, copy) NSString *versionStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isForce;
@property (nonatomic, copy) NSString *versionPartner;

//金条
@property (nonatomic, copy) NSString *goldPartner;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger tomorrowCount;
@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) UILabel *tomorrowLabel;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSInteger second;
@property (nonatomic, assign) NSInteger secondLeave;

@property (nonatomic, assign) BOOL haveData;   //是否有离线数据

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_bannerModelArray) {
        _bannerModelArray = [NSMutableArray array];
    }
    if (!_projectModelArray) {
        _projectModelArray = [NSMutableArray array];
    }
    if (!_roadModelArray) {
        _roadModelArray = [NSMutableArray array];
    }
    if (!_tempProArray) {
        _tempProArray = [NSMutableArray array];
    }
    if (!_tempRoadArray) {
        _tempRoadArray =[NSMutableArray array];
    }
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _selectedCellNum = 20;
    _page = 0;
    _projectPage = 0;
    _lastProjectPage = 0;
    _roadPage = 0;
    _lastRoadPage = 0;
    _type = @"0";
    
    
    //获得partner
    self.bannerPartner = [TDUtil encryKeyWithMD5:KEY action:BANNERSYSTEM];
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTLIST];
    
    //版本更新
    self.versionPartner = [TDUtil encryKeyWithMD5:KEY action:VERSIONINFO];
    //金条
    self.goldPartner = [TDUtil encryKeyWithMD5:KEY action:GOLDCOUNT];
    
    //设置 加载视图界面
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    
    [self setNav];
    
    [self createUI];
    
    //添加监听
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGold) name:@"comeBack" object:nil];
//    

    
}
-(void)setNav
{
    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
//    search.tag = 0;
    //通过判断返回数据状态来决定背景图片
    [search setBackgroundImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    search.size = search.currentBackgroundImage.size;
    [search addTarget:self action:@selector(searchCilck) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:search];
}

-(void)searchCilck
{
    ProjectSearchController *search = [[ProjectSearchController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}
-(void)saveDate
{
    NSString *firstLogin = [TDUtil CurrentDay];
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    [data setValue:firstLogin forKey:@"firstLogin"];
    [data synchronize];
}
-(void)compareTime
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isLaunchedByNotification) {
        
    }else{
        NSString *currentTime = [TDUtil CurrentDay];
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *firstDate = [data objectForKey:@"firstLogin"];
        if ([currentTime isEqualToString:firstDate]) {
            [self loadVersion];
        }else{
            [self loadGoldCount];
        }
    }
}

-(void)loadGold
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *currentTime = [TDUtil CurrentDay];
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *firstDate = [data objectForKey:@"firstLogin"];
        if ([currentTime isEqualToString:firstDate]) {
            
        }else{
            [self loadGoldCount];
        }
    });
}

-(void)loadGoldCount
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.goldPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_USER_GOLD_GETCOUNT postParam:dic type:0 delegate:self sel:@selector(requestGoldCount:)];
}
-(void)requestGoldCount:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _count = [dataDic[@"count"] integerValue];
            _tomorrowCount = [dataDic[@"countTomorrow"] integerValue];
            
            [self saveDate];
            
            [self createGoldImageView];
        }else{
        
        }
    }
}
-(void)createGoldImageView
{
    UIView *background = [UIView new];
    [background setBackgroundColor:[UIColor blackColor]];
    background.alpha = 0.7;
    
    [[UIApplication sharedApplication].windows[0] addSubview:background];
    
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    _background = background;
    
    _timeLabel = [UILabel new];
    _timeLabel.font = BGFont(12);
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.layer.cornerRadius = 15;
    _timeLabel.layer.masksToBounds = YES;
    _timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _timeLabel.layer.borderWidth = 0.5;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%lds",(long)_secondLeave]];
    [attributeString addAttribute:NSFontAttributeName value:BGFont(20) range:NSMakeRange(0, 1)];
    
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:1];
    
    _timeLabel.attributedText = attributeString;
    [[UIApplication sharedApplication].windows[0] addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.mas_equalTo(background.mas_right).offset(-30);
        make.top.mas_equalTo(55);
    }];
    
    imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].windows[0] addSubview:imageView];
    
    
    NSMutableArray *imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i =0; i < 36; i ++) {
        NSString * name = [NSString stringWithFormat:@"jintiao%.2ld",(long)i];
//        NSLog(@"filename:%@",name);
        UIImage *image = [UIImage imageNamed:name];
        [imageArr addObject:image];
    }
    
    imageView.animationImages = imageArr;
    imageView.animationRepeatCount = 1;
    imageView.animationDuration = 1.5;
    [imageView startAnimating];
    [self performSelector:@selector(setImage) withObject:self afterDelay:1.51];
    
    UIButton *certainBtn = [UIButton new];
    certainBtn.backgroundColor = [UIColor clearColor];
    [certainBtn setTitle:@"确定" forState:UIControlStateNormal];
    [certainBtn setTitleColor:color(255, 204, 0, 1) forState:UIControlStateNormal];
    certainBtn.titleLabel.font = BGFont(16);
    [certainBtn addTarget:self action:@selector(disBackground) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.layer.cornerRadius = 4;
    certainBtn.layer.masksToBounds = YES;
    certainBtn.layer.borderColor = color(255, 204, 0, 1).CGColor;
    certainBtn.layer.borderWidth = 1;
    [[UIApplication sharedApplication].windows[0] addSubview:certainBtn];
    [certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(background.mas_centerX);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(background.mas_bottom).offset(-70*HEIGHTCONFIG);
    }];
    
    _certainBtn = certainBtn;
    _tomorrowLabel = [UILabel new];
    _tomorrowLabel.textColor = [UIColor whiteColor];
    _tomorrowLabel.font = BGFont(16);
    _tomorrowLabel.textAlignment = NSTextAlignmentCenter;
//    _tomorrowLabel.text = [NSString stringWithFormat:@"明天登录即可获得%ld根金条",(long)_tomorrowCount];
    [[UIApplication sharedApplication].windows[0] addSubview:_tomorrowLabel];
    [_tomorrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(background.mas_centerX);
        make.height.mas_equalTo(16);
        make.bottom.mas_equalTo(background.mas_bottom).offset(-175*HEIGHTCONFIG);
    }];
    
    _todayLabel = [UILabel new];
    _todayLabel.textColor = color(255, 204, 0, 1);
    _todayLabel.font = BGFont(24);
    _todayLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"恭喜获得 %ld根金条",(long)_count]];
    NSRange range = NSMakeRange(5, 1);
    if (_count > 9) {
        range = NSMakeRange(5, 2);
    }
    [attributeStr addAttribute:NSFontAttributeName value:BGFont(32) range:range];
    _todayLabel.attributedText = attributeStr;
    [[UIApplication sharedApplication].windows[0] addSubview:_todayLabel];
    [_todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(background.mas_centerX);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(_tomorrowLabel.mas_top).offset(-16);
    }];
}

-(void)startTimer
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
        [timer fire];
        [[NSRunLoop currentRunLoop] run];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    });
}

-(void)disBackground
{
    if (_background !=nil) {
        [_background removeFromSuperview];
        [imageView removeFromSuperview];
        [_todayLabel removeFromSuperview];
        [_tomorrowLabel removeFromSuperview];
        [_certainBtn removeFromSuperview];
        [_timeLabel removeFromSuperview];
        
    }
}

-(void)setTime
{
    _secondLeave--;
    if (_second == 3) {
        
        [self disBackground];
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
    }else{//设置label数字
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%lds",(long)_secondLeave]];
      _timeLabel.attributedText = attributeString;
    }
    _second ++;
}

-(void)setImage
{
    [imageView stopAnimating];
    UIImage * image =[UIImage imageNamed:@"jintiao35"];
    imageView.image = image;
}



#pragma mark---------------------------请求表格数据---------------------------
-(void)startLoadData
{
    if (_selectedCellNum == 20) {
        _type = @"0";
        _page = _projectPage;
    }else{
        _type = @"1";
        _page = _roadPage;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_page],@"page",[NSString stringWithFormat:@"%@",_type],@"type", nil];

        [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_LIST postParam:dic type:0 delegate:self sel:@selector(requestProjectList:)];
    
}

-(void)requestProjectList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            
            NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
            dictM[@"data"] = jsonString;
            
            
            if (_selectedCellNum == 20) {
                
                if (_page == 0) {
                    [_tempProArray removeAllObjects];
                    [self saveDataToBaseTable:PROJECTTABLE data:dictM];
                }
                [self analysisProjectListData:dataArray];
                
            }else{

                if (_page == 0) {
                    [_tempRoadArray removeAllObjects];
                    [self saveDataToBaseTable:ROADTABLE data:dictM];
                }
                [self analysisNoRoadListData:dataArray];
            }
            
            [self.tableView reloadData];


        }else{
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.startLoading = NO;
    }else{
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
//        self.isNetRequestError = YES;
    }
}
#pragma mark-----解析项目列表路演------
-(void)analysisProjectListData:(NSArray*)array
{
    
    NSArray *dataArray = [Project mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger i =0; i < dataArray.count; i ++) {
        ProjectListProModel *listModel = [ProjectListProModel new];
        Project *project = (Project*)dataArray[i];
        listModel.startPageImage = project.startPageImage;
        listModel.abbrevName = project.abbrevName;
        listModel.address = project.address;
        listModel.fullName = project.fullName;
        listModel.status = project.financestatus.name;
        listModel.projectId = project.projectId;
        listModel.timeLeft = project.timeLeft;
        
        listModel.areas = [project.industoryType componentsSeparatedByString:@"，"];
        listModel.collectionCount = project.collectionCount;
        if (project.roadshows.count) {
            Roadshows *roadshows = project.roadshows[0];
            listModel.financedMount = roadshows.roadshowplan.financedMount;
            listModel.financeTotal = roadshows.roadshowplan.financeTotal;
            listModel.endDate = roadshows.roadshowplan.endDate;
        }
//        for (ProjectListProModel *model in _tempProArray) {
//            if (model) {
//                if (project.projectId == model.projectId) {
//                    NSLog(@"相等");
//                }else{
//                    NSLog(@"不等");
//                    [_tempProArray addObject:listModel];
//                }
//            }else{
//                [_tempProArray addObject:listModel];
//            }
//            
//        }
        [_tempProArray addObject:listModel];
    }
    self.projectModelArray = _tempProArray;
}

-(void)setProjectModelArray:(NSMutableArray *)projectModelArray
{
    self->_projectModelArray = projectModelArray;
    if (_projectModelArray.count <= 0) {
        self.tableView.isNone = YES;
//        NSLog(@"表一无数据");
    }else{
        self.tableView.isNone = NO;
        
    }
}
#pragma mark------解析预选项目---------
-(void)analysisNoRoadListData:(NSArray*)array
{
    NSArray *dataArray = [Project mj_objectArrayWithKeyValuesArray:array];
    
    for (NSInteger i =0; i < dataArray.count; i ++) {
        ProjectListProModel *listModel = [ProjectListProModel new];
        Project *project = (Project*)dataArray[i];
        listModel.startPageImage = project.startPageImage;
        listModel.abbrevName = project.abbrevName;
        listModel.address = project.address;
        listModel.fullName = project.fullName;
        listModel.status = project.financestatus.name;
        listModel.projectId = project.projectId;
        //少一个areas数组
        listModel.areas = [project.industoryType componentsSeparatedByString:@"，"];
        //NSLog(@"领域 ----%@",project.industoryType);
        listModel.collectionCount = project.collectionCount;
        Roadshows *roadshows = project.roadshows[0];
        listModel.financedMount = roadshows.roadshowplan.financedMount;
        listModel.financeTotal = roadshows.roadshowplan.financeTotal;
        listModel.endDate = roadshows.roadshowplan.endDate;
//        for (ProjectListProModel *model in _tempRoadArray) {
//            if (model) {
//                if (project.projectId == model.projectId) {
//                    
//                }else{
//                    [_tempRoadArray addObject:listModel];
//                }
//            }else{
//                 [_tempRoadArray addObject:listModel];
//            }
//            
//        }
        [_tempRoadArray addObject:listModel];
    }
    self.roadModelArray = _tempRoadArray;
}

-(void)setRoadModelArray:(NSMutableArray *)roadModelArray
{
    self->_roadModelArray = roadModelArray;
    if (_roadModelArray.count <= 0) {
        self.tableView.isNone = YES;
//        NSLog(@"表二无数据");
    }else{
        self.tableView.isNone = NO;
        
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"报错---%@",request);
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"报错返回:%@",jsonString);
    
    if ([TDUtil checkNetworkState] != NetStatusNone)
    {
        self.startLoading = YES;
        self.isNetRequestError = YES;
    }
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)refresh
{
    [self startLoadBannerData];
}

#pragma mark----------------------------请求banner数据----------------------
-(void)startLoadBannerData
{
    //设置加载动画
    if (!_haveData) {
        self.startLoading = YES;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.bannerPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:BANNER_SYSTEM postParam:dic type:0 delegate:self sel:@selector(requestBannerList:)];
}

-(void)requestBannerList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //保存数据
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"banner请求成功"];
            if ([jsonDic[@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
                dictM[@"data"] = jsonString;
                [self saveDataToBaseTable:BANNERTABLE data:dictM];
            }
            if (jsonDic[@"data"]) {
                NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
                if (dataArray.count) {
                    //解析banner数据
                    [self analysisBannerData:dataArray];
                }
            }
            
            [self startLoadData];
        }else{
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }else{
//        self.isNetRequestError  =YES;
    }
}
#pragma mark----------------解析banner数据-----------------
-(void)analysisBannerData:(NSArray*)array
{
    if (_bannerModelArray.count) {
        [_bannerModelArray removeAllObjects];
    }
    NSArray *bannerModelArray = [ProjectBannerModel mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger i = 0; i < bannerModelArray.count; i ++) {
        ProjectBannerModel *baseModel = bannerModelArray[i];
        ProjectBannerListModel *listModel = [ProjectBannerListModel new];
        listModel.type = baseModel.type;
        listModel.image = baseModel.body.image;
        listModel.url = baseModel.body.url;
        listModel.desc = baseModel.body.desc;
        listModel.bannerId = baseModel.body.bannerId;
        listModel.name = baseModel.body.name;
        if ([baseModel.type isEqualToString:@"Project"]) {
            listModel.industoryType = baseModel.extr.industoryType;
            listModel.status = baseModel.extr.financestatus.name;
            listModel.projectId = baseModel.extr.projectId;
            if (baseModel.extr.roadshows.count) {
                BannerRoadshows *roadshows = baseModel.extr.roadshows[0];
                BannerRoadshowplan *roadshowplan = roadshows.roadshowplan;
                listModel.financedMount = roadshowplan.financedMount;
                listModel.financeTotal = roadshowplan.financeTotal;
            }
            
        }
        [_bannerModelArray addObject:listModel];
//            NSLog(@"打印数组个数---%ld",_bannerModelArray.count);
    }
    //搭建banner
    [self setBanner];
}

#pragma mark------------------------------创建banner------------------------
-(void)createBanner
{
    if (!_bannerView) {
        _selectedCellNum = 20;
        _bannerView = [[ProjectBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, BannerHeight)];
        [_bannerView setSelectedNum:20];
        _bannerView.animationDuration = 4;
        _bannerView.delegate = self;
        _tableView.tableHeaderView = _bannerView;
    }
}

-(void)setBanner
{
//    _bannerView.bannerModelArray = [NSMutableArray arrayWithArray:_bannerModelArray];
    _bannerView.modelArray = _bannerModelArray;
    _bannerView.imageCount = _bannerModelArray.count;
    [_bannerView relayoutWithModelArray:_bannerModelArray];
}


-(void)createUI
{

    [self createBanner];
    self.navigationItem.title = @"项目";

    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
}

#pragma mark -刷新控件
-(void)nextPage
{
        if (_selectedCellNum == 20) {
            _lastProjectPage = _projectPage;
            _projectPage ++;
            if (_lastProjectPage != _projectPage) {
                [self startLoadData];
            }
        }else{
            _lastRoadPage = _roadPage;
            _roadPage ++;
            if (_lastRoadPage != _roadPage) {
                [self startLoadData];
            }
        }
}

-(void)refreshHttp
{
        if (_selectedCellNum == 20) {
            _projectPage = 0;
        }else{
            _roadPage = 0;
        }
        
        [self startLoadData];
}

#pragma mark- navigationBar --------- button的点击事件--------------
-(void)buttonCilck:(UIButton*)button
{
    if (button.tag == 1) {
        
        UpProjectViewController *up = [UpProjectViewController new];
        up.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:up animated:YES];
    }
}

#pragma mark - tableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedCellNum == 20) {
        return _projectModelArray.count;
    }
    return _roadModelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedCellNum == 20) {
        return 172;
    }
    return 172;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectedCellNum == 20) {
        
        static NSString * cellId = @"ProjectListCell";
        ProjectListCell * cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectListCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_projectModelArray.count) {
            cell.model = _projectModelArray[indexPath.row];
        }
        return cell;
    }else{
    
        static NSString * cellId =@"ProjectNoRoadCell";
        ProjectNoRoadCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            
        }
        if (_roadModelArray.count) {
            cell.model = _roadModelArray[indexPath.row];
        }
       [cell.statusImage setHidden:YES];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
    }
    return nil;
}

#pragma mark -tableView的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListProModel *model = [ProjectListProModel new];
    
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedCellNum == 20) {
        
        ProjectDetailController * detail = [[ProjectDetailController alloc]init];
        model = _projectModelArray[indexPath.row];
        detail.isPush = YES;
        detail.projectId = model.projectId;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        
        ProjectPrepareDetailVC *detail = [ProjectPrepareDetailVC new];
        model = _roadModelArray[indexPath.row];
        
        detail.projectId = model.projectId;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark- ProjectBannerCellDelegate 代理方法
-(void)transportProjectBannerView:(ProjectBannerView *)view andTagValue:(NSInteger)tagValue
{
    _selectedCellNum  = tagValue;//将传过来的tag赋值给_selectedCellNum来决定显示cell的类型
    
//    if (_selectedCellNum == 20 && !_projectModelArray.count) {
//        [self startLoadData];
//    }else{
//        [_tableView reloadData];
//    }
//    if (_selectedCellNum == 21 && !_roadModelArray.count) {
//        [self startLoadData];
//    }else{
//        [_tableView reloadData];
//    }
    
    if (_selectedCellNum == 20) {
        if (!_projectModelArray.count) {
            [self startLoadData];
        }else{
            [_tableView reloadData];
        }
    }
    
    if (_selectedCellNum == 21) {
        if (!_roadModelArray.count) {
            [self startLoadData];
        }else{
            [_tableView reloadData];
        }
    }
}

-(void)clickBannerImage:(ProjectBannerListModel *)model
{
    if ([model.type isEqualToString:@"Project"]) {
        if ([model.status isEqualToString:@"预选项目"]) {
            ProjectPrepareDetailVC *detail = [ProjectPrepareDetailVC new];
            
            detail.projectId = model.projectId;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            ProjectDetailController * detail = [[ProjectDetailController alloc]init];
            detail.projectId = model.projectId;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else{
    ProjectBannerDetailVC *vc = [ProjectBannerDetailVC new];
    vc.url = model.url;
    vc.titleStr = model.name;
    vc.model = model;
    vc.image = model.image;
    vc.titleText = model.name;
    vc.contentText = model.desc;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark--------版本更新----------
-(void)loadVersion
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.versionPartner,@"partner",@"1",@"platform", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:VERSIONINFOSYSTEM postParam:dic type:0 delegate:self sel:@selector(requestVersion:)];
}
-(void)requestVersion:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = jsonDic[@"data"];
            _versionStr = dataDic[@"versionStr"];
//            _versionStr = @"4.0.0";
            _contentStr = dataDic[@"content"];
            _url = dataDic[@"url"];
            _isForce = [dataDic[@"isForce"] boolValue];
            //利用key取到对应的版本（当前版本）
            NSString * version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSArray *currentArray = [version componentsSeparatedByString:@"."];
//                NSLog(@"本地----%@",currentArray);
                NSArray *upArray = [_versionStr componentsSeparatedByString:@"."];
//            NSLog(@"返回版本号----%@",upArray);
            //比较版本号
            if ([upArray[0] integerValue] > [currentArray[0] integerValue]) {
                if (_isForce) {
                    [self forceUpdateAlertView];
                }else{
                    [self alertViewShow];
                }
                return;
            }
            
            if ([upArray[0] integerValue] == [currentArray[0] integerValue]) {
                //第二位
                if ([upArray[1] integerValue] > [currentArray[1] integerValue]) {
                    if (_isForce) {
                        [self forceUpdateAlertView];
                    }else{
                        [self alertViewShow];
                    }
                    return;
                }
                if ([upArray[1] integerValue] == [currentArray[1] integerValue]) {
                    //第三位
                    if ([upArray[2] integerValue] > [currentArray[2] integerValue]) {
                        if (_isForce) {
                            [self forceUpdateAlertView];
                        }else{
                            [self alertViewShow];
                        }
                        return;
                    }
                }
                
            }
            
        }
    }
}

-(void)forceUpdateAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:_contentStr delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
    alertView.delegate =self;
    alertView.tag = 20;
    [alertView show];
}
-(void)alertViewShow
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:_contentStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
    alertView.tag = 21;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //强更
    if (alertView.tag == 20) {
        if (buttonIndex == 0) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_url]];
        }
    }
    
    if (alertView.tag == 21) {
        if (buttonIndex == 0) {
            
        }else{
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_url]];
        }
    }
}

#pragma mark----------------loadOffLineData---加载离线数据----------------
-(void)loadOffLineData
{
    //先从数据库加载 没有数据  则进行数据请求
    NSArray *bannerArray = [self getDataFromBaseTable:BANNERTABLE];
    if (bannerArray.count) {
        [self analysisBannerData:bannerArray];
        
        NSArray *projectArray = [self getDataFromBaseTable:PROJECTTABLE];
        if (projectArray.count) {
//                NSLog(@"%@-----%ld",projectArray,projectArray.count);
        [self analysisProjectListData:projectArray];
        [self.tableView reloadData];
        }
        NSArray *noRoadArray = [self getDataFromBaseTable:ROADTABLE];
        if (noRoadArray.count) {
            [self analysisNoRoadListData:noRoadArray];
        }
        _haveData = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([TDUtil checkNetworkState] != NetStatusNone){
            [self.tableView.mj_header beginRefreshing];
            [self startLoadBannerData];
            }
        });
    }else{
        if ([TDUtil checkNetworkState] != NetStatusNone)
        {
            [self startLoadBannerData];
        }
    }
}


-(void)loadOtherData
{
    if (_hasLogin || _isSuccess) {

        //保存登录时间
        [self compareTime];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadVersion];
        });
        
    }
}

//-(void)autoLogin
//{
//    //获取缓存数据
//    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
//    NSString *phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
//    NSString *password = [data valueForKey:STATIC_USER_PASSWORD];
//    //激光推送Id
//    NSString *regId = [JPUSHService registrationID];
//    
//    NSString * string = [AES encrypt:DENGLU password:KEY];
//    self.partner = [TDUtil encryptMD5String:string];
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",phoneNumber,@"telephone",password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
//    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
//}
//-(void)requestLogin:(ASIHTTPRequest *)request
//{
//    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
////        NSLog(@"返回:%@",jsonString);
//    NSMutableDictionary* jsonDic = [jsonString JSONValue];
//    
//    if (jsonDic!=nil) {
//        NSString *status = [jsonDic valueForKey:@"status"];
//        if ([status intValue] == 200) {
////            NSLog(@"登陆成功");
//            //下载认证信息
//            [self loadAuthenData];
//            _isSuccess = YES;
//            self.loginSucess = YES;
////            NSLog(@"登陆成功%@",self.loginSucess ? @"1" : @"0");
//            [self startLoadBannerData];
//            [self loadOtherData];
//            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
//            
//            [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
//            [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
//            
//        }else{
//            LoginRegistViewController * login = [[LoginRegistViewController alloc]init];
//            
//            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            
//            delegate.nav = [[UINavigationController alloc] initWithRootViewController:login];
//            
//            delegate.window.rootViewController = delegate.nav;
//        }
//        
//    }
//}

#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
    self.navigationController.navigationBar.hidden = NO;
//    
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setHidden:NO];
    
    if (!self.bannerModelArray.count) {
        [self loadOffLineData];
    }
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
