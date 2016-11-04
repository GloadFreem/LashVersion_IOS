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
#define LOGINUSER @"isLoginUser"
#define DENGLU @"loginUser"

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

@property (nonatomic, copy) NSString *authenPartner;
@property (nonatomic, assign) NSInteger selectedCellNum;//选择显示cell的类型

@property (nonatomic, copy) NSString *bannerPartner; 
@property (nonatomic, strong) NSMutableArray *bannerModelArray; //banner数组
@property (nonatomic, strong) NSMutableArray *projectModelArray;
@property (nonatomic, strong) NSMutableArray *roadModelArray;
@property (nonatomic, strong) NSMutableArray *tempProArray;
@property (nonatomic, strong) NSMutableArray *tempRoadArray;

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

//登录状态
@property (nonatomic, assign)BOOL hasLogin;
@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, assign) BOOL haveData;   //是否有离线数据

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
    
    //自动登录
    if ([TDUtil checkNetworkState] != NetStatusNone)
    {
        [self isLogin];
    }

    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setLetterStatus:) name:@"setLetterStatus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netNotEnable) name:@"netNotEnable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netEnable) name:@"netEnable" object:nil];
}

-(void)netEnable
{
//    [self isLogin];
    if (_netView) {
        [_netView removeFromSuperview];
    }
    if (!_hasLogin && !_isSuccess) {
        [self autoLogin];
    }
}

-(void)netNotEnable
{
    [self.view addSubview:_netView];
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
        
    }else{
        [self loadGoldCount];
    }
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
//        NSLog(@"个人数据返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
//            NSLog(@"打印字典---%@",dataDic);
            AuthenticInfoBaseModel *baseModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
//            authenticModel = baseModel;
//            NSLog(@"打印个人信息：----%@",baseModel);
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            
            [data setValue:baseModel.headSculpture forKey:USER_STATIC_HEADER_PIC];
            [data setValue:baseModel.telephone forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:[NSString stringWithFormat:@"%ld",(long)baseModel.userId] forKey:USER_STATIC_USER_ID];
            
            NSMutableString *areaStr = [[NSMutableString alloc]init];
            if (baseModel.areas.count) {
                for (NSInteger i = 0; i < baseModel.areas.count; i++) {
                    if (i!= baseModel.areas.count - 1) {
                        [areaStr appendFormat:@"%@ | ",baseModel.areas[i]];
                    }else{
                        [areaStr appendFormat:@"%@",baseModel.areas[i]];
                    }
                }
            }
            [data setValue:areaStr forKey:USER_STATIC_INVEST_AREAS];
            
            NSArray *authenticsArray = baseModel.authentics;
            if (authenticsArray.count) {
                ProjectAuthentics *authentics = authenticsArray[0];
                [data setObject:authentics.city.name forKey:USER_STATIC_CITY];
                [data setObject:authentics.city.province.name forKey:USER_STATIC_PROVINCE];
                [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
                [data setValue:authentics.name forKey:USER_STATIC_NAME];
                [data setValue:authentics.identiyCarA forKey:USER_STATIC_IDPIC];
                [data setValue:authentics.identiyCarNo forKey:USER_STATIC_IDNUMBER];
                [data setValue:authentics.position forKey:USER_STATIC_POSITION];
                [data setValue:authentics.authenticstatus.name forKey:USER_STATIC_USER_AUTHENTIC_STATUS];
                [data setValue:[NSString stringWithFormat:@"%ld",(long)authentics.identiytype.identiyTypeId] forKey:USER_STATIC_USER_AUTHENTIC_TYPE];
                [data setValue:[NSString stringWithFormat:@"%@",authentics.identiytype.name] forKey:USER_STATIC_USER_AUTHENTIC_NAME];
                [data setValue:[NSString stringWithFormat:@"%ld",(long)authentics.authId] forKey:USER_STATIC_AUTHID];
                [data setValue:authentics.introduce forKey:USER_STATIC_INTRODUCE];
                [data setValue:authentics.companyIntroduce forKey:USER_STATIC_COMPANYINTRODUCE];
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

            //结束刷新
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
        }else{
            //结束刷新
//            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        self.startLoading = NO;
    }else{
        self.isNetRequestError = YES;
    }
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
            
            if ([jsonDic[@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
                dictM[@"data"] = jsonString;
                [self saveDataToBaseTable:BANNERTABLE data:dictM];
            }
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            //解析banner数据
            [self analysisBannerData:dataArray];
            
            [self startLoadData];
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }else{
        self.isNetRequestError  =YES;
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
    _bannerView.modelArray = _bannerModelArray;
    _bannerView.imageCount = _bannerModelArray.count;
    [_bannerView relayoutWithModelArray:_bannerModelArray];
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

    [self createBanner];
    self.navigationItem.title = @"项目";
    
     _netView  = [noNetView new];
     _netView.frame = CGRectMake(0, 0, SCREENWIDTH, 40);
    _netView.delegate = self;
     if ([TDUtil checkNetworkState] == NetStatusNone)
     {
         [self.view addSubview:_netView];
     }
    
    //设置站内信状态
    [self setLetterStatus:nil];

    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
}
#pragma mark-------------没有网络点击事件处理--------------
-(void)didClickBtnInView
{
//    NSLog(@"没有网络事件处理");
    NetStatusViewController *netStatus =[NetStatusViewController new];
    [self.navigationController pushViewController:netStatus animated:YES];
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
    }else{
        [_tableView reloadData];
//        [_tableView beginUpdates];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//        [_tableView endUpdates];
    }
    if (_selectedCellNum == 21 && !_roadModelArray.count) {
        [self startLoadData];
    }else{
        
        [_tableView reloadData];
//        [_tableView beginUpdates];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//        [_tableView endUpdates];
    }
    
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
    vc.titleStr = model.name;
    vc.model = model;
    vc.image = model.image;
    vc.titleText = model.name;
    vc.contentText = model.desc;
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
//            _versionStr = @"1.2.0";
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
    }else{
        if ([TDUtil checkNetworkState] != NetStatusNone)
        {
            [self startLoadBannerData];
        }
    }
}


#pragma mark-------------------------自动登录-----------------------
-(void)isLogin
{
    _loginPartner = [TDUtil encryKeyWithMD5:KEY action:LOGINUSER];
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.loginPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ISLOGINUSER postParam:dic type:0 delegate:self sel:@selector(requestIsLogin:)];
    
}
-(void)requestIsLogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
//        NSLog(@"登陆状态在线");
            //下载认证信息
            [self loadAuthenData];
            
            _hasLogin = YES;
            [self startLoadBannerData];
            
            [self loadOtherData];
        }else{
            //自动登录
            [self autoLogin];
        }
    }
    
}

-(void)loadOtherData
{
    if (_hasLogin || _isSuccess) {
        [self loadVersion];
        
        [self loadMessage];
        
        // [self createGoldView];
        //保存登录时间
        [self compareTime];
    }
}

-(void)autoLogin
{
    //获取缓存数据
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    NSString *password = [data valueForKey:STATIC_USER_PASSWORD];
    //激光推送Id
    NSString *regId = [JPUSHService registrationID];
    
    NSString * string = [AES encrypt:DENGLU password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",phoneNumber,@"telephone",password,@"password",PLATFORM,@"platform", regId,@"regId",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
}
-(void)requestLogin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
//            NSLog(@"登陆成功");
            //下载认证信息
            [self loadAuthenData];
            
            _isSuccess = YES;
            [self startLoadBannerData];
            
            [self loadOtherData];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            
            [data setValue:[jsonDic[@"data"] valueForKey:@"userId"] forKey:USER_STATIC_USER_ID];
            [data setValue:[jsonDic[@"data"] valueForKey:@"extUserId"] forKey:USER_STATIC_EXT_USER_ID];
            
        }else{
            LoginRegistViewController * login = [[LoginRegistViewController alloc]init];
            [self.navigationController pushViewController:login animated:NO];
        }
        
    }
}

#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.translucent=NO;
    
//    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netEnable" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netNotEnable" object:nil];
}

@end
