//
//  ProjectViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectViewController.h"

#import "UpProjectViewController.h"
#import "ProjectLetterViewController.h"

#import "ProjectListCell.h"
#import "ProjectNoRoadCell.h"

#import "ProjectBannerView.h"
#import "ProjectBannerModel.h"
#import "ProjectBannerListModel.h"
#import "ProjectBannerDetailVC.h"
#import "AuthenticInfoBaseModel.h"
#import "ProjectListProBaseModel.h"
#import "ProjectListProModel.h"

#import "ProjectDetailController.h"
#import "ProjectPrepareDetailVC.h"

#define HASMESSAGE @"requestHasMessageInfo"
#define AUTHENINFO @"authenticInfoUser"
#define PROJECTLIST @"requestProjectList"
#define BANNERSYSTEM @"bannerSystem"
#define VERSIONINFO @"versionInfoSystem"
#define GOLDCOUNT @"requestUserGoldGetInfo"

#define BannerHeight  SCREENWIDTH * 0.5 + 45
@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectBannerViewDelegate>

{
    CAEmitterLayer * _fireEmitter;//发射器对象
    UIImageView *imageView;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *authenPartner;
@property (nonatomic, assign) NSInteger selectedCellNum;//选择显示cell的类型

@property (nonatomic, copy) NSString *bannerPartner; 
@property (nonatomic, strong) NSMutableArray *bannerModelArray; //banner数组
@property (nonatomic, strong) NSMutableArray *projectModelArray;
@property (nonatomic, strong) NSMutableArray *roadModelArray;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger projectPage;
@property (nonatomic, assign) NSInteger roadPage;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *hasMessagePartner;
@property (nonatomic, assign) BOOL hasMessage;
@property (nonatomic, strong) UIButton *letterBtn;

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

@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
    if (!_bannerModelArray) {
        _bannerModelArray = [NSMutableArray array];
    }
    if (!_projectModelArray) {
        _projectModelArray = [NSMutableArray array];
    }
    if (!_roadModelArray) {
        _roadModelArray = [NSMutableArray array];
    }
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _selectedCellNum = 20;
    _page = 0;
    _projectPage = 0;
    _roadPage = 0;
    _type = @"0";
    
    _second = 0;
    _secondLeave = 3;
    //获得partner
    self.bannerPartner = [TDUtil encryKeyWithMD5:KEY action:BANNERSYSTEM];
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTLIST];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    //站内信
    self.hasMessagePartner = [TDUtil encryKeyWithMD5:KEY action:HASMESSAGE];
    //版本更新
    self.versionPartner = [TDUtil encryKeyWithMD5:KEY action:VERSIONINFO];
    //金条
    self.goldPartner = [TDUtil encryKeyWithMD5:KEY action:GOLDCOUNT];
    
    //设置 加载视图界面
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    
    [self createUI];
    
    [self startLoadBannerData];
    
    //下载认证信息
    [self loadAuthenData];

    [self loadMessage];
    
    [self loadVersion];
    
    
//    [self createGoldView];
    //保存登录时间
    [self compareTime];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setLetterStatus:) name:@"setLetterStatus" object:nil];
    
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
    NSString *currentTime = [TDUtil CurrentDay];
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    NSString *firstDate = [data objectForKey:@"firstLogin"];
    if ([currentTime isEqualToString:firstDate]) {
        [SVProgressHUD dismiss];
    }else{
        [self loadGoldCount];
    }
}
-(void)loadGoldCount
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.goldPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_USER_GOLD_GETCOUNT postParam:dic type:1 delegate:self sel:@selector(requestGoldCount:)];
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
            
            [SVProgressHUD dismiss];
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
        //        timer.fireDate = [NSDate distantPast];
        [[NSRunLoop currentRunLoop] run];
        
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

/*
#pragma mark-------创建金条掉落动画视图-------粒子动画-------废弃-------
-(void)createGoldView
{
    UIView *background = [UIView new];
    [background setBackgroundColor:[UIColor blackColor]];
    background.alpha = 0.5;
    
    background.tag=1000;
//    [self.view addSubview:background];
    [[UIApplication sharedApplication].windows[0] addSubview:background];
    
    //测试
    [self.view bringSubviewToFront:background];
    [background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    //初始化发射器
    _fireEmitter = [[CAEmitterLayer alloc]init];
    _fireEmitter.emitterPosition = CGPointMake(self.view.frame.size.width/2, -20);
    _fireEmitter.emitterSize = CGSizeMake(self.view.frame.size.width/4, 20);
    _fireEmitter.renderMode = kCAEmitterLayerLine;
    _fireEmitter.emitterShape = kCAEmitterLayerLine;
    //发射单元
    CAEmitterCell *goldCell = [CAEmitterCell emitterCell];
    goldCell.contents=(id)[[UIImage imageNamed:@"logo-shezhi@2x.png"]CGImage];
    //产生数量美妙
    goldCell.birthRate=5;
    goldCell.lifetime=50.0;
    
//    goldCell.lifetimeRange=1.5;
//    goldCell.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
    [goldCell setName:@"fire"];
    //秒速
    goldCell.velocity=160;
    goldCell.velocityRange=80;
    goldCell.emissionLongitude=M_PI+M_PI_2;
    // 掉落角度范围
    goldCell.emissionRange=M_PI;
    //缩放比例
    goldCell.scale = 0.05;
//    goldCell.scaleSpeed=0.3;
    goldCell.scaleRange = 0.5;
    //旋转速度
    goldCell.spin=0.2;
    
    _fireEmitter.emitterCells=[NSArray arrayWithObjects:goldCell,nil];
    [background.layer addSublayer:_fireEmitter];
    
}
 */
#pragma mark--------------------是否站内信未读--------------------
-(void)loadMessage
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.hasMessagePartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_HASMESSAGE_INFO postParam:dic type:1 delegate:self sel:@selector(requestMessageInfo:)];
    
}
-(void)requestMessageInfo:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status =[jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data = jsonDic[@"data"];
            _hasMessage = [data[@"flag"] boolValue];
            
        }else{
        
        }
    }
}
#pragma mark -------------------下载认证信息--------------------------
-(void)loadAuthenData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.authenPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:AUTHENTIC_INFO postParam:dic type:0 delegate:self sel:@selector(requestAuthenInfo:)];
}

-(void)requestAuthenInfo:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            AuthenticInfoBaseModel *baseModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
//            authenticModel = baseModel;
            //            NSLog(@"打印个人信息：----%@",baseModel);
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:baseModel.headSculpture forKey:USER_STATIC_HEADER_PIC];
            [data setValue:baseModel.telephone forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:[NSString stringWithFormat:@"%ld",(long)baseModel.userId] forKey:USER_STATIC_USER_ID];
            
            NSArray *authenticsArray = baseModel.authentics;
            if (authenticsArray.count) {
                ProjectAuthentics *authentics = authenticsArray[0];
                
                [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
                [data setValue:authentics.name forKey:USER_STATIC_NAME];
                [data setValue:authentics.identiyCarA forKey:USER_STATIC_IDPIC];
                [data setValue:authentics.identiyCarNo forKey:USER_STATIC_IDNUMBER];
                [data setValue:authentics.position forKey:USER_STATIC_POSITION];
                //            [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
                [data setValue:authentics.authenticstatus.name forKey:USER_STATIC_USER_AUTHENTIC_STATUS];
                
                [data setValue:[NSString stringWithFormat:@"%ld",(long)authentics.identiytype.identiyTypeId] forKey:USER_STATIC_USER_AUTHENTIC_TYPE];
            }
            
            [data synchronize];
            
//            if ([authentics.authenticstatus.name isEqualToString:@"已认证"]) {
//                _isAuthentic = YES;
//            }
        }
    }
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
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_LIST postParam:dic type:1 delegate:self sel:@selector(requestProjectList:)];
}

-(void)requestProjectList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (_page == 0) {
        if (_selectedCellNum == 20) {
            [_projectModelArray removeAllObjects];
        }else{
            [_roadModelArray removeAllObjects];
        }
    }
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSArray *dataArray = [Project mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            if (_selectedCellNum == 20) {
                
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
                    
                    [_projectModelArray addObject:listModel];
                }
                
            }else{
            
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
//                    NSLog(@"领域 ----%@",project.industoryType);
                    listModel.collectionCount = project.collectionCount;
                    Roadshows *roadshows = project.roadshows[0];
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    
                    [_roadModelArray addObject:listModel];
                }
            }
            [self.tableView reloadData];
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
        
        self.startLoading = NO;
    }else{
        self.isNetRequestError = YES;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [self startLoadBannerData];
}

#pragma mark----------------------------请求banner数据----------------------
-(void)startLoadBannerData
{

//    [SVProgressHUD showWithStatus:@"加载中..."];
    //设置加载动画
    self.startLoading = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.bannerPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:BANNER_SYSTEM postParam:dic type:1 delegate:self sel:@selector(requestBannerList:)];
    
}

-(void)requestBannerList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            
            NSArray *bannerModelArray = [ProjectBannerModel mj_objectArrayWithKeyValuesArray:dataArray];
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
//                NSLog(@"打印数组个数---%ld",_bannerModelArray.count);
            }
            //搭建banner
            [self createBanner];
            
            [self startLoadData];
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }else{
        self.isNetRequestError  =YES;
    }
}
#pragma mark------------------------------创建banner------------------------
-(void)createBanner
{
    _selectedCellNum = 20;
    
    ProjectBannerView * bannerView = [[ProjectBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, BannerHeight)];
    [bannerView setSelectedNum:20];
    bannerView.modelArray = _bannerModelArray;
    
    bannerView.imageCount = _bannerModelArray.count;
    [bannerView relayoutWithModelArray:_bannerModelArray];
    bannerView.delegate = self;
    _tableView.tableHeaderView = bannerView;
}
#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setHidden:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setHidden:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:NO animated:NO];
        }
    }
    
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [SVProgressHUD dismiss];
}

#pragma mark-------------------站内信通知信息----------------------
-(void)setLetterStatus:(NSNotification*)notification
{
    UIButton * letterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    letterBtn.tag = 0;
    if (notification) {
        _hasMessage = YES;
    }
    
    //通过判断返回数据状态来决定背景图片
    //    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    if (_hasMessage) {//message_new@2x
        [letterBtn setBackgroundImage:[UIImage imageNamed:@"message_new"] forState:UIControlStateNormal];
    }else{
        [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    }
    
    letterBtn.size = letterBtn.currentBackgroundImage.size;
    [letterBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:letterBtn];
    _letterBtn = letterBtn;
}


-(void)createUI
{
    self.navigationItem.title = @"项目";
    
    //设置站内信状态
    [self setLetterStatus:nil];

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
        _projectPage ++;
    }else{
        _roadPage ++;
    }
    
    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    if (_selectedCellNum == 20) {
        _projectPage = 0;
    }else{
        _roadPage = 0;
    }
    
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}

#pragma mark- navigationBar --------- button的点击事件--------------
-(void)buttonCilck:(UIButton*)button
{
    if (button.tag == 0) {
        //改变已读
        [_letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
        
        ProjectLetterViewController *letter = [ProjectLetterViewController new];
        
        [self.navigationController pushViewController:letter animated:YES];
        
    }
    if (button.tag == 1) {
        
        UpProjectViewController *up = [UpProjectViewController new];
        
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
    }
    
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

#pragma mark -tableView的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectListProModel *model = [ProjectListProModel new];
    
    //反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectedCellNum == 20) {
        
        ProjectDetailController * detail = [[ProjectDetailController alloc]init];
        model = _projectModelArray[indexPath.row];
        detail.projectId = model.projectId;
        
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        
        ProjectPrepareDetailVC *detail = [ProjectPrepareDetailVC new];
        model = _roadModelArray[indexPath.row];
        
        detail.projectId = model.projectId;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark- ProjectBannerCellDelegate 代理方法
-(void)transportProjectBannerView:(ProjectBannerView *)view andTagValue:(NSInteger)tagValue
{
    _selectedCellNum  = tagValue;//将传过来的tag赋值给_selectedCellNum来决定显示cell的类型
    
    if (_selectedCellNum == 20 && !_projectModelArray.count) {
        [self startLoadData];
    }
    if (_selectedCellNum == 21 && !_roadModelArray.count) {
        [self startLoadData];
    }
    [_tableView reloadData];
    //tableView开始更新
//    [_tableView beginUpdates];
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    [_tableView endUpdates];
}

-(void)clickBannerImage:(ProjectBannerListModel *)model
{
    if ([model.type isEqualToString:@"Project"]) {
        if ([model.status isEqualToString:@"预选项目"]) {
            ProjectPrepareDetailVC *detail = [ProjectPrepareDetailVC new];
            
            detail.projectId = model.projectId;
            
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            ProjectDetailController * detail = [[ProjectDetailController alloc]init];
            detail.projectId = model.projectId;
            
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else{
    ProjectBannerDetailVC *vc = [ProjectBannerDetailVC new];
    vc.url = model.url;
    vc.model = model;
    
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
            _contentStr = dataDic[@"content"];
            _url = dataDic[@"url"];
            _isForce = [dataDic[@"isForce"] boolValue];
            //利用key取到对应的版本（当前版本）
            NSString * version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if (_isForce) {//强更
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:_contentStr delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
                alertView.delegate =self;
                alertView.tag = 20;
                [alertView show];
            }else{
                NSArray *currentArray = [version componentsSeparatedByString:@"."];
//                NSLog(@"本地----%@",currentArray);
                NSArray *upArray = [_versionStr componentsSeparatedByString:@"."];
                if ([currentArray[0] integerValue] < [upArray[0] integerValue]) {
                    [self alertViewShow];
                }else{
                    if ([upArray[1] integerValue] > [currentArray[1] integerValue]) {
                        [self alertViewShow];
                    }else{
                        if ([upArray[2] integerValue] > [currentArray[2] integerValue]) {
                            [self alertViewShow];
                            
                        }else{
//                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"当前版本为最新版本，无需更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                            //                            alertView.delegate =self;
//                            //                            alertView.tag = 20;
//                            [alertView show];
                            
                        }
                        
                        
                    }
                }
                
            }
        }
    }
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

@end
