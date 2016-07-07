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

#import "ProjectDetailBannerView.h"

#import "ProjectDetailMemberView.h"

#import "CircleShareBottomView.h"

#import "ProjectDetailSceneView.h"


#import "ProjectDetailBaseMOdel.h"
#import "ProjectDetailMemberModel.h"
#import "ProjectSceneModel.h"

#import "AuthenticInfoBaseModel.h"

#import "ProjectDetailInvestVC.h"
#import "ProjectSceneCommentVC.h"

#import "CSZProjectDetailLetfView.h"

#define AUTHENINFO @"authenticInfoUser"

#define REQUESTDETAIL @"requestProjectDetail"

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


@interface ProjectDetailController ()<ProjectDetailBannerViewDelegate,UIScrollViewDelegate,UITextViewDelegate,ProjectDetailSceneViewDelegate,CircleShareBottomViewDelegate,UITextFieldDelegate>
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

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

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

@property (nonatomic, copy) NSString *collectPartner;

@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *shareImage;

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

@property (nonatomic, copy) NSString *servicePartner;
@property (nonatomic, copy) NSString *servicePhone;

@end

@implementation ProjectDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:REQUESTDETAIL];
    _scenePartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSCENECOMMENT];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTSHARE];
    self.collectPartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCOLLECT];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    //客服
    self.servicePartner = [TDUtil encryKeyWithMD5:KEY action:CUSTOMSERVICE];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //下载详情数据
    [self startLoadData];
    [self loadShareData];
    [self loadSceneData];
    //下载认证信息
    [self loadAuthenData];
    
    _heightArray = [NSMutableArray array];                  //子视图高度数组
    
    _scrollView.bounces = NO;                               //关闭弹性
    
    _scrollView.autoresizingMask = UIViewAutoresizingNone;
    //添加广告栏
    //下载客服电话
    [self loadServicePhone];
    

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


#pragma mark -下载认证信息
-(void)loadAuthenData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.authenPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:AUTHENTIC_INFO postParam:dic type:0 delegate:self sel:@selector(requestAuthenInfo:)];
}

-(void)requestAuthenInfo:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            AuthenticInfoBaseModel *baseModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
            authenticModel = baseModel;
//            NSLog(@"打印个人信息：----%@",baseModel);
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:baseModel.headSculpture forKey:USER_STATIC_HEADER_PIC];
            [data setValue:baseModel.telephone forKey:USER_STATIC_TEL];
            [data setValue:[NSString stringWithFormat:@"%ld",(long)baseModel.userId] forKey:USER_STATIC_USER_ID];
            
            NSArray *authenticsArray = baseModel.authentics;
            ProjectAuthentics *authentics = authenticsArray[0];
            
            [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
            [data setValue:authentics.name forKey:USER_STATIC_NAME];
            [data setValue:authentics.identiyCarA forKey:USER_STATIC_IDPIC];
            [data setValue:authentics.identiyCarNo forKey:USER_STATIC_IDNUMBER];
            [data setValue:authentics.position forKey:USER_STATIC_POSITION];
            [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
            [data setValue:authentics.authenticstatus.name forKey:USER_STATIC_USER_AUTHENTIC_STATUS];
            
            [data synchronize];
            
            if ([authentics.authenticstatus.name isEqualToString:@"已认证"]) {
                _isAuthentic = YES;
            }
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
                _shareurl  = dic[@"url"];
                _shareImage = dic[@"image"];
                _shareContent = dic[@"content"];
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
    [_scrollView addSubview:self.titleScrollView];
            //添加点击按钮
    [_scrollView addSubview:self.subViewScrollView];        //添加最下边scrollview
    
    [_scrollView setupAutoContentSizeWithBottomView:_subViewScrollView bottomMargin:0];
    [_scrollView setupAutoHeightWithBottomView:_subViewScrollView bottomMargin:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLayoutNotification) name:@"updateLayout" object:nil];
}


-(void)createBannerView:(NSArray*)arr
{
    //广告栏视图
    bannerView= [[ProjectDetailBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.75)];
    
    [bannerView relayoutWithModelArr:arr];
    
    [_scrollView addSubview:bannerView];
}
-(void)startLoadData
{
    [SVProgressHUD show];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestProjectDetail:)];
}

-(void)requestProjectDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            [SVProgressHUD dismiss];
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
            }
            
            
            
        }else{
        [SVProgressHUD dismiss];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)loadSceneData
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
            if (jsonDic[@"data"] && [jsonDic[@"data"] count]) {
                NSArray *modelArray = [ProjectSceneModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                if (modelArray.count) {
                    ProjectSceneModel *model = modelArray[0];
                    _sceneId = model.sceneId;
                }
            }
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
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
    }
    
    for (int i = 0; i<_titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(SCREENWIDTH/3*i, 0, SCREENWIDTH/3, 40)];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:titleFont];
        button.tag = i+10;
        
        i==2 ? [button setTitleColor:selectTitleColor forState:UIControlStateNormal] : [button setTitleColor: unselectTitleColor forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:button];
        [_btArray addObject:button];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [_lineView setBackgroundColor:self.lineColor ? _lineColor : defaultLineColor];
    
    if (self.type == 0) {
        
        _lineView.frame = CGRectMake(2*SCREENWIDTH/3, CGRectGetHeight(_titleScrollView.frame)-2, SCREENWIDTH/3, 2);
        [_titleScrollView addSubview:_lineView];
        
    }else{
        
//        _lineView.frame = CGRectMake(0, 0, 80, CGRectGetMaxX(_titleScrollView.frame));
//        [_titleScrollView insertSubview:_lineView atIndex:0];
    }
    
    
    return _titleScrollView;
}

#pragma mark -  初始化内部scrollView布局
- (UIScrollView *)subViewScrollView{
    
    if (!_subViewScrollView) {
        //        _subViewScrollView.backgroundColor = [UIColor greenColor];
        _subViewScrollView = [[UIScrollView alloc]init];
        
        _subViewScrollView.bounces = NO;
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
        [_subViewScrollView addSubview:_leftView];
        
        _leftView.frame = CGRectMake(0, 0, SCREENWIDTH, _leftView.height);
        
        __weak ProjectDetailController * wself = self;
        [_leftView setMoreButtonClickedBlock:^(Boolean flag) {
            if (!flag) {
//                NSLog(@"取消");
                [wself.scrollView setContentOffset:CGPointMake(0, wself.scrollView.contentOffset.y-1) animated:YES];
            }
        }];
        
        _subViewScrollView.y = POS_Y(_titleScrollView);
        _subViewScrollView.height = _leftView.height;
        _subViewScrollView.width = SCREENWIDTH;
        
        
        [_heightArray addObject:[NSNumber numberWithFloat:_leftView.height]];
        
        //实例化底部按钮视图
//        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH, 50)];
        _bottomView = [UIView new];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(SCREENHEIGHT - 50);
        }];
        _kefuBtn = [UIButton new];
        [_kefuBtn setBackgroundImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
        [_kefuBtn setBackgroundImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateHighlighted];
        [_kefuBtn setTag:0];
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
        member.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, member.viewHeight);
        [_heightArray addObject:[NSNumber numberWithFloat:member.viewHeight]];
        [_subViewScrollView addSubview:member];
        
        
        //实例化现场界面
         scene =[[ProjectDetailSceneView alloc]initWithFrame:CGRectMake(2*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT-CGRectGetMaxY(_titleScrollView.frame))];
        scene.projectId = self.projectId;
        scene.delegate = self;
        scene.bannerView = bannerView;
        [_subViewScrollView addSubview:scene];
        
        //加底部回复框
        _footer =[[UIView alloc]init];
//        _footer.backgroundColor = [UIColor redColor];
        _footer.frame = CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50);
        _footer.hidden = YES;
        [self.view addSubview:_footer];
        
        _textField = [[UITextField alloc]init];
        _textField.layer.cornerRadius = 2;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _textField.layer.borderWidth = 0.5;
        _textField.delegate = self;
        _textField.font = BGFont(15);
        _textField.returnKeyType = UIReturnKeyDone;
        [_footer addSubview:_textField];
        
        UIButton * btn =[[UIButton alloc]init];
        [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:colorBlue];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_footer addSubview:btn];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(btn.mas_left).offset(-5);
        }];
        
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_footer.mas_top);
            make.right.mas_equalTo(_footer.mas_right);
            make.bottom.mas_equalTo(_footer.mas_bottom);
            make.width.mas_equalTo(75);
        }];
    }
    
    [_footer setHidden:NO];
    [_bottomView setHidden:YES];
    _subViewScrollView.contentOffset=CGPointMake(SCREENWIDTH*2, 0);
    
    return _subViewScrollView;
}

#pragma mark -发送信息
-(void)sendMessage:(UIButton*)btn
{
    if (self.sceneId) {
        if (self.textField.text && ![self.textField.text isEqualToString:@""]) {
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
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
#pragma mark ------------------ProjectDetailSceneViewDelegate--------------
-(void)didClickMoreBtn
{
    ProjectSceneCommentVC *vc = [ProjectSceneCommentVC new];
    vc.sceneId = self.sceneId;
    vc.scenePartner = _scenePartner;
    vc.scene = scene;
    [self.navigationController pushViewController:vc animated:YES];
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
    NSLog(@"移动%f",SCREENWIDTH*(sender.tag-10));
    _subViewScrollView.contentOffset=CGPointMake(SCREENWIDTH*(sender.tag-10), 0);
    
    //重置子scrollView的大小  以及父scrollView的contentSize
//    CGFloat valueY = CGRectGetMaxY(_titleScrollView.frame);
    switch (sender.tag) {
        case 10:
        {
            
            [_bottomView setHidden:NO];
            [_footer setHidden:YES];
            _subViewScrollView.height = _leftView.height;
            [_subViewScrollView setupAutoContentSizeWithBottomView:_leftView bottomMargin:0];
            
//            NSLog(@"点击了第%ld个",sender.tag-10);
        }
            break;
        case 11:
        {
            [_bottomView setHidden:YES];
            [_footer setHidden:YES];
            _subViewScrollView.height = member.height;
            [_subViewScrollView setupAutoContentSizeWithBottomView:member bottomMargin:0];
//            NSLog(@"点击了第%ld个",sender.tag-10);
            
            
        }
            break;
        case 12:
        {
            [_bottomView setHidden:YES];
            [_footer setHidden:NO];
            _subViewScrollView.height = scene.height;
            [_subViewScrollView setupAutoContentSizeWithBottomView:scene bottomMargin:0];
//            NSLog(@"点击了第%ld个",sender.tag-10);
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
                _subViewScrollView.height = _leftView.height;
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

-(void)updateLayoutNotification
{
    _subViewScrollView.height = _leftView.height;
    [_subViewScrollView setupAutoContentSizeWithBottomView:_leftView bottomMargin:0];
    
}


#pragma mark - 底部按钮点击事件
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
//        NSLog(@"拨打电话");
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *tel = [data objectForKey:@"servicePhone"];
//        NSLog(@"电话---%@",tel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
        
    }
#pragma mark ---------------进入投资界面---------------------
    if (btn.tag == 1) {
        if (_isAuthentic) {
            ProjectDetailInvestVC *vc = [ProjectDetailInvestVC new];
            vc.limitAmount = _limitAmount;
            vc.projectId = self.projectId;
            vc.borrowerUserNumber = _borrowerUserNumber;
            vc.authenticModel = authenticModel;
            vc.abbrevName = _abbrevName;
            vc.fullName = _fullName;
            vc.profit = _profit;
            vc.startPageImage = _startPageImage;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
        }
    }
}
- (IBAction)leftBack:(UIButton *)sender {
    [SVProgressHUD dismiss];
    if (!_isCollect) {
        [_attentionVC.projectArray removeObject:_listModel];
        [_tableView reloadData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -分享
- (IBAction)shareBtn:(UIButton *)sender {
    
    [self startShare];
}
#pragma mark ---------------开始分享------------------------

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
    NSArray *titleList = @[@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareViewWithTitleArray:titleList imageArray:imageList];
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
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareurl;
                    [UMSocialData defaultData].extConfig.qqData.title = @"金指投投融资";
                    [UMSocialData defaultData].extConfig.qzoneData.title = @"金指投投融资";
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
                break;
            case 1:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"金指投投融资";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"金指投投融资";
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"金指投投融资";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"金指投投融资";
                
                //                NSLog(@"分享到朋友圈");
            }
                break;
            case 3:{
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
        }
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            shareImage];
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self performSelector:@selector(dismissBG) withObject:nil afterDelay:1.0];
                    
                });
            }
        }];
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

#pragma mark -收藏
- (IBAction)collectBtn:(UIButton *)sender {
    
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

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
    }
    NSLog(@"结束编辑");
}


#pragma mark- textView  delegate
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        self.textField.text = textView.text;
    }
    NSLog(@"正在编辑");
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        self.textField.text = textView.text;
    }
    NSLog(@"结束编辑");
    
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent=NO;
    self.navigationController.navigationBar.hidden = YES;
    
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
    [self performSelector:@selector(updateLayoutNotification) withObject:nil afterDelay:0.5];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
    MP3Player *player = [[MP3Player alloc]init];
    [player.player pause];
    
    
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
}

-(void)dealloc
{
    MP3Player *player = [[MP3Player alloc]init];
    player = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
