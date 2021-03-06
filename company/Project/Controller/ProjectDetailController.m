//
//  ProjectDetailController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailController.h"
#import "AppDelegate.h"
#import "MeasureTool.h"
#import "ShareToCircleView.h"
#import "LQQMonitorKeyboard.h"
#import "JTabBarController.h"

#import "ProjectDetailBannerView.h"

#import "ProjectDetailMemberView.h"

#import "CircleShareBottomView.h"

#import "ProjectDetailSceneView.h"

#import "RenzhengViewController.h"

#import "ProjectDetailBaseMOdel.h"
#import "ProjectDetailMemberModel.h"
#import "ProjectSceneModel.h"

#import "AuthenticInfoBaseModel.h"

#import "PingTaiWebViewController.h"

#import "ProjectDetailInvestVC.h"
#import "ProjectSceneCommentVC.h"

#import "CSZProjectDetailLetfView.h"

#define AUTHENINFO @"authenticInfoUser"

#define REQUESTDETAIL @"requestProjectDetail"

#define SHARETOCIRCLE @"shareContentToFeeling"

#define CUSTOMSERVICE @"customServiceSystem"
#define REQUESTSCENECOMMENT @"requestSceneComment"
#define REQUESTRECORDATA @"requestRecorData"
#define REQUESTPROJECTCOMMENT @"requestProjectComment"
#define PROJECTSHARE @"requestProjectShare"
#define PROJECTCOLLECT @"requestProjectCollect"

#define defaultLineColor [UIColor blueColor]
#define selectTitleColor orangeColor
#define unselectTitleColor [UIColor blackColor]
#define titleFont [UIFont systemFontOfSize:16]


@interface ProjectDetailController ()<CSZProjectDetailLetfViewDelegate,ProjectDetailBannerViewDelegate,UIScrollViewDelegate,UITextViewDelegate,ProjectDetailSceneViewDelegate,CircleShareBottomViewDelegate,UITextFieldDelegate,ShareToCircleViewDelegate,UITextViewDelegate>
{
    ProjectDetailMemberView * member;
    ProjectDetailBannerView * bannerView;
    ProjectDetailSceneView *scene;
    
    NSString *_scenePartner;
    NSString *_recorDataPartner;
    BOOL memberLoadData;
    
    NSInteger currentPageIndex; //当前页索引
    
    AuthenticInfoBaseModel *authenticModel;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  UIButton *collectBtn;

@property (nonatomic,strong) CSZProjectDetailLetfView * leftView;
@property (nonatomic,strong) UIScrollView *titleScrollView;     //切换按钮
@property (nonatomic,strong) NSArray *titleArray;               // 切换按钮数组
@property (nonatomic,strong) UIView *lineView;                  // 下划线视图
@property (nonatomic,strong) UIScrollView *subViewScrollView;   // 下边子滚动视图
@property (nonatomic,strong) NSMutableArray *heightArray;       // subviewScrollView子视图高度数组
@property (nonatomic,strong) NSMutableArray *btArray;           //点击切换按钮数组

@property (nonatomic, strong) UIView *bottomView;   //底部按钮视图
@property (nonatomic, strong) UIButton *kefuBtn;  //客服按钮
@property (nonatomic, strong) UIButton *investBtn;   //投资按钮

@property (nonatomic, strong) UIView * footer;
@property (nonatomic, strong) ProjectDetailBaseMOdel*model;
@property (nonatomic, copy) NSString *commentStr; //评论内容
@property (nonatomic, assign) NSInteger sceneId;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, copy) NSString *collectPartner;

@property (nonatomic, copy) NSString *circlePartner;
@property (nonatomic, strong) ShareToCircleView *shareCircleView;
@property (nonatomic, copy) NSString *sharePartner;    //分享的部分内容
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic,strong)UIView *bottomview;

@property (nonatomic, assign) BOOL isCollect;

@property (nonatomic, copy) NSString *profit;
@property (nonatomic, assign) float limitAmount;
@property (nonatomic, copy) NSString *borrowerUserNumber;
@property (nonatomic, copy) NSString *abbrevName;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *startPageImage;

@property (nonatomic, copy) NSString *authenPartner;
@property (nonatomic, assign) BOOL isAuthentic;
@property (nonatomic, copy) NSString *authenticName;
@property (nonatomic, copy) NSString *identiyTypeId;

@property (nonatomic, copy) NSString *servicePartner;
@property (nonatomic, copy) NSString *servicePhone;
@property (nonatomic, assign) BOOL isSucess;
@end

@implementation ProjectDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadLogin) name:@"hasLogin" object:nil];
//    [self.view bringSubviewToFront:_navView];
    // Do any additional setup after loading the view from its nib.
    [self setNav];
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:REQUESTDETAIL];
    _scenePartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSCENECOMMENT];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTSHARE];
    self.collectPartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCOLLECT];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    //客服
    self.servicePartner = [TDUtil encryKeyWithMD5:KEY action:CUSTOMSERVICE];
    //分享圈子
    self.circlePartner = [TDUtil encryKeyWithMD5:KEY action:SHARETOCIRCLE];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //设置加载视图范围
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    //下载认证信息
    [self readAuthenData];
    
    //下载详情数据
    [self startLoadData];
    
    _heightArray = [NSMutableArray array];                  //子视图高度数组
    
    _scrollView.bounces = NO;                               //关闭弹性
    
    _scrollView.autoresizingMask = UIViewAutoresizingNone;
    
    //下载客服电话
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadServicePhone];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadShareData];
    });
    
    
}
-(void)loadLogin
{
    self.isSucess = YES;
}
#pragma mark---导航栏
-(void)setNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    UIButton *shareBtn = [UIButton new];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share_btn"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.size = CGSizeMake(35, 35);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
//    self.navigationItem.title = self.titleStr;
}

-(void)addCollectBtn
{
    UIButton *collectBtn = [UIButton new];
    if (_isCollect) {
        [collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    }else{
        [collectBtn setImage:[UIImage imageNamed:@"icon_uncollect"] forState:UIControlStateNormal];
    }
    [collectBtn addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    collectBtn.frame = CGRectMake(SCREENWIDTH - 100, 7, 30, 30);
    [self.navigationController.navigationBar addSubview:collectBtn];
    _collectBtn = collectBtn;
//    NSLog(@"加一次");
}

#pragma mark---返回按钮
-(void)leftBack
{
    if (!_isCollect) {
        NSInteger index = [_attentionVC.projectArray indexOfObject:_listModel];
        [_attentionVC.projectArray removeObject:_listModel];
        [_attentionVC.statusArray removeObjectAtIndex:index];
        [_tableView reloadData];
    }
    [scene removeObserverAndNotification];
    [self cancleRequest];
    //销毁计时器通知
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimer" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---分享按钮
-(void)shareBtnClick
{
    [self startShare];
}

#pragma mark---读取认证信息
-(void)readAuthenData
{
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _authenticName = [data objectForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [data objectForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
}
#pragma mark--- 收藏
-(void)collect
{
    _isCollect = !_isCollect;
    NSString *flag;
    if (_isCollect) {
        flag = @"1";
    }else{
        flag = @"2";
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.collectPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",flag,@"flag", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_COLLECT postParam:dic type:0 delegate:self sel:@selector(requestProjectCollect:)];
}

-(void)loadServicePhone
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.servicePartner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CUSTOM_SERVICE_SYSTEM postParam:dic type:0 delegate:self sel:@selector(requestServicePhone:)];
}
-(void)requestServicePhone:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = jsonDic[@"data"];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setObject:dataDic[@"tel"] forKey:@"servicePhone"];
            [data synchronize];
            
        }else{
            
        }
    }
}


-(void)loadShareData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",@"1",@"type", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUESTPROJECTSHARE postParam:dic type:0 delegate:self sel:@selector(requestShare:)];
}
-(void)requestShare:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            if (jsonDic[@"data"]) {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
//                NSLog(@"打印分项数据---%@",dic);
                _shareurl  = dic[@"url"];
                _shareImage = dic[@"image"];
                _shareContent = dic[@"content"];
                _shareTitle = dic[@"title"];
            }
        }
           
    }
}

-(void)createUI
{
    if (_isCollect) {
        [_collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
        
    }else{
        [_collectBtn setImage:[UIImage imageNamed:@"icon_uncollect"] forState:UIControlStateNormal];
    }
    _titleArray = @[@"详情",@"成员",@"现场"];
    _lineColor = orangeColor;
    _type = 0;
    [_scrollView addSubview:self.titleScrollView];          //添加点击按钮
    [_scrollView addSubview:self.subViewScrollView];        //添加最下边scrollview
    
    [_scrollView setupAutoContentSizeWithBottomView:_subViewScrollView bottomMargin:0];
    [_scrollView setupAutoHeightWithBottomView:_subViewScrollView bottomMargin:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLayoutNotification) name:@"updateLayout" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataLayoutLeftNoti) name:@"updateLeft" object:nil];
}

-(void)updataLayoutLeftNoti
{
    _subViewScrollView.height = _leftView.height + 44;
    [_subViewScrollView setupAutoContentSizeWithBottomView:_leftView bottomMargin:0];
}

-(void)createBannerView:(NSArray*)arr
{
    //广告栏视图
    bannerView= [[ProjectDetailBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.75)];
    bannerView.userInteractionEnabled = YES;
    
    bannerView.scrollView.scrollEnabled = YES;
    
    [bannerView relayoutWithModelArr:arr];
    
    [_scrollView addSubview:bannerView];
}

-(void)startLoadData
{
    self.startLoading = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestProjectDetail:)];
}

-(void)requestProjectDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //容错
            if (jsonDic[@"data"] !=nil) {
                ProjectDetailBaseMOdel *baseModel = [ProjectDetailBaseMOdel mj_objectWithKeyValues:jsonDic[@"data"]];
                
                _model = baseModel;
                NSMutableArray *bannerArr = [NSMutableArray array];
                if (baseModel.project.startPageImage) {
                    [bannerArr addObject:baseModel.project.startPageImage];
                }
                
                _isCollect = baseModel.project.collected;
                NSArray *roadshowsArr = baseModel.project.roadshows;
                DetailRoadshows *roadshows = roadshowsArr[0];
                _limitAmount = roadshows.roadshowplan.limitAmount;
                _borrowerUserNumber = baseModel.project.borrowerUserNumber;
                _abbrevName = baseModel.project.abbrevName;
                _fullName = baseModel.project.fullName;
                _profit = roadshows.roadshowplan.profit;
                _startPageImage = baseModel.project.startPageImage;
                
                [self createBannerView:bannerArr];
                
                scene.bannerView = bannerView;
                
                [self createUI];
                
                [self loadSceneData];
            }
        }else if ([status integerValue] == 401){
//        self.isNetRequestError  =YES;
            [self isAutoLogin];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.loginSucess) {
                    self.loginSucess = NO;
                    [self startLoadData];
                    
                }
            });
        }
    }else{
        self.isNetRequestError  =YES;
    }
}

-(void)loadSceneData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",_scenePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",@"1",@"platform", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_SCENE postParam:dic type:1 delegate:self sel:@selector(requestProjectScene:)];
}
-(void)requestProjectScene:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            if (jsonDic[@"data"] && [jsonDic[@"data"] count]) {
                NSArray *modelArray = [ProjectSceneModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                if (modelArray.count) {
                    ProjectSceneModel *model = modelArray[0];
                    _sceneId = model.sceneId;
                }
            }
            
        }else{
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
        self.startLoading = NO;
    }else{
        self.isNetRequestError  =YES;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [self startLoadData];
}

#pragma mark - 设置下滑条
- (void)setLineColor:(UIColor *)lineColor{
    
    _lineColor = lineColor;
    [_lineView setBackgroundColor:self.lineColor ? _lineColor : defaultLineColor];
}

#pragma mark - 初始化切换按钮
- (UIScrollView *)titleScrollView{
    
    if (!_titleScrollView) {
        
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,SCREENWIDTH*0.75, SCREENWIDTH, 40)];
        _titleScrollView.contentSize = CGSizeMake(SCREENWIDTH*_titleArray.count/3, 0);
        _titleScrollView.scrollEnabled = YES;
        _titleScrollView.showsHorizontalScrollIndicator = YES;
        
        for (int i = 0; i<_titleArray.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setFrame:CGRectMake(SCREENWIDTH/3*i, 0, SCREENWIDTH/3, 40)];
            [button setTitle:_titleArray[i] forState:UIControlStateNormal];
            [button.titleLabel setFont:titleFont];
            button.tag = i+10;
            //默认选中现场界面
            i==0 ? [button setTitleColor:selectTitleColor forState:UIControlStateNormal] : [button setTitleColor: unselectTitleColor forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_titleScrollView addSubview:button];
            [_btArray addObject:button];
        }
        
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        [_lineView setBackgroundColor:self.lineColor ? _lineColor : defaultLineColor];
        //默认停留现场界面
        if (self.type == 0) {
            
            _lineView.frame = CGRectMake(0*SCREENWIDTH/3, CGRectGetHeight(_titleScrollView.frame)-2, SCREENWIDTH/3, 2.1);
            [_titleScrollView addSubview:_lineView];
            
        }else{
            
            //        _lineView.frame = CGRectMake(0, 0, 80, CGRectGetMaxX(_titleScrollView.frame));
            //        [_titleScrollView insertSubview:_lineView atIndex:0];
        }
        

        
    }
    
        return _titleScrollView;
}

#pragma mark -  初始化内部scrollView布局
- (UIScrollView *)subViewScrollView{
    
    if (!_subViewScrollView) {
        
        _subViewScrollView = [[UIScrollView alloc]init];
        _subViewScrollView.bounces = NO;
        _subViewScrollView.scrollEnabled = NO;
        _subViewScrollView.showsHorizontalScrollIndicator = NO;
        _subViewScrollView.showsVerticalScrollIndicator = NO;
        _subViewScrollView.contentSize = CGSizeMake(SCREENWIDTH*_titleArray.count, 0);
        _subViewScrollView.delegate = self;
        _subViewScrollView.alwaysBounceVertical = NO;
        _subViewScrollView.pagingEnabled = YES;
        //方向锁
        _subViewScrollView.directionalLockEnabled = YES;
        
        //实例化详情分页面
        _leftView = [[CSZProjectDetailLetfView alloc]init];
        _leftView.model = _model;
        _leftView.delegate = self;
        [_subViewScrollView addSubview:_leftView];
        _leftView.frame = CGRectMake(0, 0, SCREENWIDTH, _leftView.height + 44);
        
        __weak ProjectDetailController * wself = self;
        [_leftView setMoreButtonClickedBlock:^(Boolean flag) {
            if (!flag) {
//                NSLog(@"取消");
                [wself.scrollView setContentOffset:CGPointMake(0, wself.scrollView.contentOffset.y - 1) animated:YES];
            }
        }];
        
        [_heightArray addObject:[NSNumber numberWithFloat:_leftView.height + 44]];
        
        //实例化底部按钮视图
        _bottomView = [UIView new];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        UIView *line = [UIView new];;
        line.backgroundColor = btnCray;
        [_bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        _kefuBtn = [UIButton new];
        [_kefuBtn setBackgroundImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
        [_kefuBtn setBackgroundImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateHighlighted];
        [_kefuBtn setTag:0];
//        _kefuBtn.enabled = NO;
        [_kefuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_kefuBtn];
        [_kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomView.mas_centerY);
            make.left.mas_equalTo(_bottomView.mas_left).offset(8);
            make.top.mas_equalTo(_bottomView.mas_top).offset(5);
            make.bottom.mas_equalTo(_bottomView.mas_bottom).offset(-5);
            make.width.mas_equalTo(100*WIDTHCONFIG);
        }];
        //认投按钮
        _investBtn = [UIButton new];
        [_investBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-rocket"] forState:UIControlStateNormal];
        [_investBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-rocket"] forState:UIControlStateHighlighted];
        [_investBtn setTag:1];
//        _investBtn.enabled = NO;
        [_investBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_investBtn];
        [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_kefuBtn.mas_centerY);
            make.left.mas_equalTo(_kefuBtn.mas_right).offset(24*WIDTHCONFIG);
            make.right.mas_equalTo(_bottomView.mas_right).offset(-8*WIDTHCONFIG);
            make.height.mas_equalTo(_kefuBtn.mas_height);
        }];

        //实例化成员分页面
        member = [ProjectDetailMemberView instancetationProjectDetailMemberView];
        member.projectId = self.projectId;
        member.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, member.viewHeight +64);
        [_heightArray addObject:[NSNumber numberWithFloat:member.viewHeight]];
        [_subViewScrollView addSubview:member];
        
        
        //实例化现场界面
         scene =[[ProjectDetailSceneView alloc]initWithFrame:CGRectMake(2*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(_titleScrollView.frame) - 64)];
        scene.projectId = self.projectId;
        scene.delegate = self;
        scene.authenticName = self.authenticName;
        scene.bannerView = bannerView;
        [_heightArray addObject:[NSNumber numberWithFloat:scene.height]];
        [_subViewScrollView addSubview:scene];
        
        _subViewScrollView.y = POS_Y(_titleScrollView);
        _subViewScrollView.height = _leftView.height + 44 + 44 + 44;
        _subViewScrollView.width = SCREENWIDTH;
        
        //加底部回复框
        [self.view addSubview:self.footer];
        [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        
    }
    
    [_footer setHidden:YES];
    [_bottomView setHidden:NO];
    _subViewScrollView.contentOffset=CGPointMake(SCREENWIDTH*0, 0);
    
    return _subViewScrollView;
}

#pragma mark--------------底部回复框--------------
-(UIView*)footer
{
    if (!_footer) {
        _footer =[[UIView alloc]init];
        _footer.backgroundColor = [UIColor whiteColor];
        
        _textField = [[UITextField alloc]init];
        _textField.layer.cornerRadius = 2;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _textField.layer.borderWidth = 0.5;
        _textField.delegate = self;
        _textField.font = BGFont(15);
        _textField.returnKeyType = UIReturnKeySend;
        [_footer addSubview:_textField];
        
        UIButton * btn =[[UIButton alloc]init];
        [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:colorBlue];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        _sendBtn = btn;
        [_footer addSubview:btn];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(btn.mas_left).offset(-5);
        }];
        
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textField.mas_top);
            make.bottom.mas_equalTo(_textField.mas_bottom);
            make.right.mas_equalTo(_footer.mas_right).offset(-5);
            make.width.mas_equalTo(70);
        }];
    }
    return _footer;
}
#pragma mark -----------------发送信息---------------------
-(void)sendMessage:(UIButton*)btn
{
    [self.textField resignFirstResponder];
    
        if (self.sceneId) {
            if (self.textField.text && ![self.textField.text isEqualToString:@""]) {
                
                _sendBtn.enabled = NO;
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",_scenePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.sceneId],@"sceneId",[NSString stringWithFormat:@"%@",self.textField.text],@"content", nil];
                //开始请求
                [self.httpUtil getDataFromAPIWithOps:REQUEST_SCENE_COMMENT postParam:dic type:0 delegate:self sel:@selector(requestSceneComment:)];
                
            }else{
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"评论内容不能内空"];
                return;
            }
        }else{
            self.textField.text = @"";
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"路演现场暂未开放评论"];
        }

}

-(void)requestSceneComment:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
        
        self.textField.text = @"";
        [self.textField resignFirstResponder];
#pragma mark ---------刷新表格-----------
        [scene.dataArray removeAllObjects];
        [scene startLoadComment];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
         //将视图移到当前位置
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
    _sendBtn.enabled = YES;
}
#pragma mark ------------------ProjectDetailSceneViewDelegate--------------
-(void)didClickMoreBtn
{
    ProjectSceneCommentVC *vc = [ProjectSceneCommentVC new];
    vc.sceneId = self.sceneId;
    vc.scenePartner = _scenePartner;
    vc.scene = scene;
    vc.authenticName = _authenticName;
    vc.identiyTypeId = self.identiyTypeId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark------------------CSZProjectDetailLetfViewDelegate--------------
-(void)transportTeamModel:(DetailTeams *)team
{
        if (team.url.length) {
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = team.url;
            vc.titleStr = @"详情";
            [self.navigationController pushViewController:vc animated:YES];
        }
}

-(void)transportExrModel:(DetailExtr *)extr
{
    if ([_authenticName isEqualToString:@"已认证"])
    {
        if (![_identiyTypeId isEqualToString:@"1"]) {
            if (extr.url.length) {
                PingTaiWebViewController *vc = [PingTaiWebViewController new];
                vc.url = extr.url;
                vc.titleStr = extr.content;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的身份为项目方，不能查看其他项目方的资料!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
    if ([_authenticName isEqualToString:@"认证中"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    if ([_authenticName isEqualToString:@"未认证"] || [_authenticName isEqualToString:@"认证失败"]){
        [self presentAlertView];
    }
}

#pragma mark - 按钮数组
- (NSMutableArray *)btArray{
    
    if (!_btArray) {
        
        _btArray = [NSMutableArray array];
    }
    return _btArray;
}

#pragma mark- 切换按钮的点击事件
- (void)buttonAction:(UIButton *)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _lineView.frame = CGRectMake(sender.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
    }];
    for (int i = 0; i<_titleArray.count; i++) {
        UIButton *bt = (UIButton *)[_titleScrollView viewWithTag:10+i];
        sender.tag == (10+i) ? [bt setTitleColor:selectTitleColor forState:UIControlStateNormal] : [bt setTitleColor:unselectTitleColor forState:UIControlStateNormal];
        
    }
    //子scrollView的偏移量
//    NSLog(@"移动%f",SCREENWIDTH*(sender.tag-10));
    _subViewScrollView.contentOffset=CGPointMake(SCREENWIDTH*(sender.tag-10), 0);
    
    //重置子scrollView的大小  以及父scrollView的contentSize
//    CGFloat valueY = CGRectGetMaxY(_titleScrollView.frame);
    switch (sender.tag) {
        case 10:
        {
            [_bottomView setHidden:NO];
            [_footer setHidden:YES];
            [_textField resignFirstResponder];
            _subViewScrollView.height = _leftView.height + 44;
            [_subViewScrollView setupAutoContentSizeWithBottomView:_leftView bottomMargin:0];
        }
            break;
        case 11:
        {
            [_bottomView setHidden:YES];
            [_footer setHidden:YES];
            [_textField resignFirstResponder];
            _subViewScrollView.height = member.height;
            [_subViewScrollView setupAutoContentSizeWithBottomView:member bottomMargin:0];
        }
            break;
        case 12:
        {
            [_bottomView setHidden:YES];
            [_footer setHidden:NO];
            _subViewScrollView.height = scene.height;
            [_subViewScrollView setupAutoContentSizeWithBottomView:scene bottomMargin:0];
        }
            break;
        default:
            break;
    }
    [_scrollView setupAutoContentSizeWithBottomView:_subViewScrollView bottomMargin:0];
    [_scrollView setupAutoHeightWithBottomView:_subViewScrollView bottomMargin:0];
    [_subViewScrollView setContentOffset:CGPointMake(_subViewScrollView.contentOffset.x,0) animated:YES];
    //更新布局
    [_scrollView layoutSubviews];
    
}

/*
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _subViewScrollView) {
        
        CGFloat offSetX = scrollView.contentOffset.x;
        NSInteger index = offSetX/SCREENWIDTH;
        UIButton *bt = (UIButton *)[_scrollView viewWithTag:(index+10)];
        _lineView.frame = CGRectMake(bt.frame.origin.x, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
        [bt setTitleColor:selectTitleColor forState:UIControlStateNormal];
        
        _titleScrollView.contentOffset = CGPointMake(index/4*SCREENWIDTH, 0);
        
        for (int i = 0; i<_titleArray.count; i++) {
            UIButton *bt = (UIButton *)[_titleScrollView viewWithTag:10+i];
            10+index == (10+i) ? [bt setTitleColor:selectTitleColor forState:UIControlStateNormal] : [bt setTitleColor:unselectTitleColor forState:UIControlStateNormal];
            
        }
        //重置子scrollView的大小  以及父scrollView的contentSize
//        CGFloat valueY = CGRectGetMaxY(_titleScrollView.frame);
        switch (index) {
            case 0:
            {
                [_bottomView setHidden:NO];
                [_footer setHidden:YES];
                _subViewScrollView.height = _leftView.height + 44;
                [_subViewScrollView setupAutoHeightWithBottomView:_leftView bottomMargin:10];
                [_subViewScrollView setupAutoContentSizeWithBottomView:_leftView bottomMargin:0];
            }
                break;
            case 1:
            {
                [_bottomView setHidden:YES];
                [_footer setHidden:YES];
                _subViewScrollView.height = member.height;
                [_subViewScrollView setupAutoContentSizeWithBottomView:member bottomMargin:0];
            }
                break;
            case 2:
            {
                [_bottomView setHidden:YES];
                [_footer setHidden:NO];
                _subViewScrollView.height = scene.height;
                [_subViewScrollView setupAutoContentSizeWithBottomView:scene bottomMargin:0];
            }
                break;
            default:
                break;
        }
    }
    [_scrollView setupAutoContentSizeWithBottomView:_subViewScrollView bottomMargin:0];
    [_scrollView setupAutoHeightWithBottomView:_subViewScrollView bottomMargin:0];
    [_subViewScrollView setContentOffset:CGPointMake(_subViewScrollView.contentOffset.x,0) animated:YES];
    //更新布局
    [_scrollView layoutSubviews];
}
*/

-(void)updateLayoutNotification
{
    _subViewScrollView.height = _leftView.height + 44;
    [_subViewScrollView setupAutoContentSizeWithBottomView:_leftView bottomMargin:0];
}

#pragma mark ---------------------- 底部按钮点击事件------------------
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *tel = [data objectForKey:@"servicePhone"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}
#pragma mark -----------------------进入投资界面---------------------
    if (btn.tag == 1) {
        if ([_authenticName isEqualToString:@"已认证"]) {
            ProjectDetailInvestVC *vc = [ProjectDetailInvestVC new];
            vc.limitAmount = _limitAmount;
            vc.projectId = self.projectId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([_authenticName isEqualToString:@"认证中"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，通过后方可查看！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        if ([_authenticName isEqualToString:@"未认证"] || [_authenticName isEqualToString:@"认证失败"]){
            [self presentAlertView];
        }
    }
}

-(void)presentAlertView
{
    //没有认证 提醒去认证
    NSString *message;
    if ([_authenticName isEqualToString:@"未认证"]) {
        message = @"您还没有实名认证，请先实名认证";
    }else{
        message = @"您的实名认证未通过，请继续认证";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    __block ProjectDetailController* blockSelf = self;
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf btnCertain:nil];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)btnCertain:(id)sender
{
    //销毁播放器
    [scene removeObserverAndNotification];
    RenzhengViewController  * renzheng = [RenzhengViewController new];
    renzheng.identifyType = self.identiyTypeId;
    [self.navigationController pushViewController:renzheng animated:YES];
    
}
#pragma mark ------------------------------开始分享---------------------------------

- (UIView*)topView {
    UIViewController *recentView = self;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

/**
 *  点击空白区域shareView消失
 */

- (void)dismissBG
{
    if(self.bottomview != nil)
    {
        [self.bottomview removeFromSuperview];
    }
}

-(void)startShare
{
    NSArray *titleList = @[@"圈子",@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_circle@2x",@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareCircleViewWithTitleArray:titleList imageArray:imageList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBG)];
    [share addGestureRecognizer:tap];
    [[self topView] addSubview:share];
    self.bottomview = share;
    share.delegate = self;
}

-(void)sendShareBtnWithView:(CircleShareBottomView *)view index:(int)index
{
    //分享
    if (view.tag == 1) {
        //得到用户SID
        NSString * shareImage = _shareImage;
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_shareContent];
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                [self dismissBG];
                [self createShareCircleView];
                
                NSLog(@"分享圈子");
            }
                break;
                
            case 1:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareurl;
                    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
                break;
            case 2:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 3:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到朋友圈");
            }
                break;
            case 4:{
                // 短信
                arr = @[UMShareToSms];
                shareContent = shareContentString;
                
                //                NSLog(@"分享短信");
            }
                break;
            case 100:{
                [self dismissBG];
            }
                break;
            default:
                break;
        }
        if(arr == nil)
        {
            return;
        }
        if ([[arr objectAtIndex:0] isEqualToString:UMShareToSms]) {
            shareImage = nil;
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_shareTitle,_shareContent,_shareurl];
        }
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            shareImage];
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self performSelector:@selector(dismissBG) withObject:nil afterDelay:1.0];
                    
//                });
            }
        }];
    }
}
-(void)createShareCircleView
{
    ShareToCircleView *shareView =[[[NSBundle mainBundle] loadNibNamed:@"ShareToCircleView" owner:nil options:nil] lastObject];
    shareView.backgroundColor = [UIColor clearColor];
    [shareView instancetationShareToCircleViewWithimage:_shareImage title:_shareTitle content:_shareContent];
    shareView.tag = 1000;
    [[UIApplication sharedApplication].windows[0] addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    shareView.textView.delegate = self;
    shareView.delegate = self;
    _shareCircleView = shareView;
}

#pragma mark-------ShareToCircleViewDelegate--------
-(void)clickBtnInView:(ShareToCircleView *)view andIndex:(NSInteger)index content:(NSString *)content
{
    if (index == 0) {
        [view removeFromSuperview];
    }else{
       
        //        NSLog(@"调接口");
        [_shareCircleView removeFromSuperview];
        
        if ([content isEqualToString:@"说点什么吧..."]) {
            content = @"";
        }
        if (_shareContent.length > 200) {
            _shareContent = [_shareContent substringToIndex:200];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.circlePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"contentId",@"7",@"type",content,@"comment",[NSString stringWithFormat:@"%ld,0",(long)self.projectId],@"content",_shareContent,@"description",_shareImage,@"image",@"金指投项目",@"tag",nil];
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:SHARE_TO_CIRCLE postParam:dic type:0 delegate:self sel:@selector(requestShareToCircle:)];
    }
}

-(void)requestShareToCircle:(ASIHTTPRequest*)request
{
    
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"分享成功");
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络好像出了点问题，检查一下"];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSetX = scrollView.contentOffset.x;
    NSInteger index = offSetX/SCREENWIDTH;
    
    if(currentPageIndex!=index)
    {
        currentPageIndex = index;
//        [_scrollView setContentOffset:CGPointZero animated:YES];
//        NSLog(@"停止滚动:%ld",currentPageIndex);
    }
    
}


-(void)requestProjectCollect:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            if (_isCollect) {
                [_collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
            }else{
                
                [_collectBtn setImage:[UIImage imageNamed:@"icon_uncollect"] forState:UIControlStateNormal];
            }
        }else{
            
        }
    }
}

#pragma mark -textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.font= BGFont(18);
    textView.textColor = color47;
    if ([textView.text isEqualToString:@"说点什么吧..."]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.font = BGFont(15);
        textView.text = @"说点什么吧...";
    }
}
#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self sendMessage:nil];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_collectBtn) {
        [self addCollectBtn];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
//    [self performSelector:@selector(updateLayoutNotification) withObject:nil afterDelay:0.5];
    
    [LQQMonitorKeyboard LQQAddMonitorWithShowBack:^(NSInteger height) {
        
        _footer.frame = CGRectMake(0, self.view.frame.size.height - 50 - height, SCREENWIDTH, 50);
        //        NSLog(@"键盘出现了 == %ld",(long)height);
//        _scrollView.frame = CGRectMake(0, 64 - height, SCREENWIDTH, SCREENHEIGHT - 64);
        
    } andDismissBlock:^(NSInteger height) {
        
        _footer.frame = CGRectMake(0, self.view.frame.size.height - 50, SCREENWIDTH, 50);
        //        NSLog(@"键盘消失了 == %ld",(long)height);
//        _scrollView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (self.isPush) {
//        self.isPush = NO;
//        [self isAutoLogin];
////        NSLog(@"再次登录");
//    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_collectBtn) {
        [_collectBtn removeFromSuperview];
        _collectBtn = nil;
    }
    
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [member.httpUtil requestDealloc];
    [self cancleRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
