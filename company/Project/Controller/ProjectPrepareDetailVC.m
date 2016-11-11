//
//  ProjectPrepareDetailVC.m
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPrepareDetailVC.h"
#import "ProjectPrepareCommentVC.h"
#import "RenzhengViewController.h"

#import "ShareToCircleView.h"

#import "CircleShareBottomView.h"

#import "ProjectPrepareDetailHeaderView.h"
#import "CSZProjectDetailLetfView.h"
#import "ProjectPrepareFooterCommentView.h"
#import "ProjectPreparePhotoView.h"
#import "ProjectDetailLeftTeamView.h"

#import "PingTaiWebViewController.h"

#import "ProjectDetailBaseMOdel.h"
#import "ProjectPrepareDetailHeaderModel.h"
#import "ProjectDetailLeftHeaderModel.h"
#import "ProjectDetailLeftFooterModel.h"

#define SHARETOCIRCLE @"shareContentToFeeling"
#define CUSTOMSERVICE @"customServiceSystem"
#define PROJECTCOLLECT @"requestProjectCollect"
#define PROJECTDETAIL @"requestProjectDetail"
#define PROJECTSHARE @"requestProjectShare"
@interface ProjectPrepareDetailVC ()<UIScrollViewDelegate,ProjectPrepareFooterCommentViewDelagate,CircleShareBottomViewDelegate,ProjectDetailLeftTeamViewDelegate,ShareToCircleViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIView *navBar;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ProjectPrepareDetailHeaderView *headerView;
@property (nonatomic, strong) CSZProjectDetailLetfView *leftView;
@property (nonatomic, strong) ProjectPrepareFooterCommentView *footerView;
@property (nonatomic, strong) ProjectDetailLeftTeamView *teamView;
@property (nonatomic, strong) ProjectPreparePhotoView *photoView;

@property (nonatomic, strong) ProjectDetailBaseMOdel *baseModel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, assign) BOOL isCollect;            //是否关注
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, copy) NSString *collectPartner;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic, strong) ShareToCircleView *shareCircleView;
@property (nonatomic, copy) NSString *circlePartner;

@property (nonatomic, copy) NSString *servicePartner;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@end

@implementation ProjectPrepareDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
//    NSLog(@"认证状态---%@",_authenticName);
    
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTDETAIL];
    self.collectPartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCOLLECT];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTSHARE];
    self.circlePartner = [TDUtil encryKeyWithMD5:KEY action:SHARETOCIRCLE];
    
    //客服
    self.servicePartner = [TDUtil encryKeyWithMD5:KEY action:CUSTOMSERVICE];
    
    //设置加载视图大小
    self.loadingViewFrame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    
    [self startLoadData];
    
//    [self setupNav];
    
    [self loadShareData];
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

-(void)startLoadData
{
    self.startLoading = YES;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_projectId],@"projectId", nil];
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
            ProjectDetailBaseMOdel *baseModel = [ProjectDetailBaseMOdel mj_objectWithKeyValues:jsonDic[@"data"]];
            
            _baseModel = baseModel;
            _collectCount = baseModel.project.collectionCount;
            _isCollect = _baseModel.project.collected;
            
            [self createScrollView];
            
            [self createBottomView];
            
            self.startLoading = NO;
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }else{
        self.isNetRequestError = YES;
    }
}

-(void)refresh
{
    [self startLoadData];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
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
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _shareurl  = dic[@"url"];
            _shareImage = dic[@"image"];
            _shareContent = dic[@"content"];
            _shareTitle = dic[@"title"];
        }
    }
}

-(void)setupNav
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREENWIDTH, 66)];
    [navView setBackgroundColor:color(61, 153, 130, 1)];
    [self.navigationController.navigationBar addSubview:navView];
    _navBar = navView;
    
    UIButton *leftBtn = [UIButton new];
    [leftBtn setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [leftBtn setTag:0];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [navView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(navView.centerY).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share_btn"] forState:UIControlStateNormal];
    [shareBtn setTag:1];
    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.size = shareBtn.currentBackgroundImage.size;
    [navView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftBtn.mas_centerY);
        make.right.mas_equalTo(-22);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
}

-(void)createScrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        [self.view addSubview:_scrollView];
        _scrollView.sd_layout
        .leftEqualToView(self.view)
        .topSpaceToView(self.view, -2)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view,50);
        
        _headerView = [ProjectPrepareDetailHeaderView new];
        _headerView.model= _baseModel;
        [_scrollView addSubview:_headerView];
        _headerView.sd_layout
        .leftEqualToView(_scrollView)
        .topEqualToView(_scrollView)
        .rightEqualToView(_scrollView);
        
        //创建照片容器
        _photoView = [ProjectPreparePhotoView new];
        
        ProjectDetailLeftHeaderModel *headerModel = [ProjectDetailLeftHeaderModel new];
        headerModel.projectStr = _baseModel.project.abbrevName;
        headerModel.content = _baseModel.project.desc;
        headerModel.projectIcon = _baseModel.project.startPageImage;
        
        NSMutableArray *photoArr = [NSMutableArray array];
        NSArray *picArray = [NSArray arrayWithArray:_baseModel.project.projectimageses];
        for (NSInteger i = 0; i < picArray.count; i ++) {
            DetailProjectimageses *image = picArray[i];
            [photoArr addObject:image.imageUrl];
        }
        headerModel.pictureArray = [NSArray arrayWithArray:photoArr];
        _photoView.model = headerModel;
        
        [_scrollView addSubview:_photoView];
        
        _photoView.sd_layout
        .leftEqualToView(_scrollView)
        .rightEqualToView(_scrollView)
        .topSpaceToView(_headerView,0);
        
        _teamView = [ProjectDetailLeftTeamView new];
        _teamView.delegate = self;
        
        _teamView.authenticName = _authenticName;
        [_scrollView addSubview:_teamView];
        
        _teamView.sd_layout
        .leftEqualToView(_scrollView)
        .rightEqualToView(_scrollView)
        .topSpaceToView(_photoView,0);
        //    .autoHeightRatio(0);
        //    .heightIs(365);
        if (_baseModel.project.teams.count <= 0 && _baseModel.extr.count <= 0) {
            _teamView.sd_layout.heightIs(0);
            _teamView.imageHeight = 0;
            _teamView.scrollHeightFirst = 0;
            _teamView.scrollHeightSecond = 0;
            _teamView.topHeight = 0;
            _teamView.midHeight = 0;
            _teamView.botHeight = 0;
        }
        if (_baseModel.project.teams.count <= 0 && _baseModel.extr.count > 0) {
            _teamView.sd_layout.heightIs(365 - 130);
            _teamView.imageHeight = 20;
            _teamView.scrollHeightSecond = 130;
            _teamView.scrollHeightFirst = 0;
            _teamView.extrModelArray = [NSMutableArray arrayWithArray:_baseModel.extr];
            _teamView.topHeight = 10;
            _teamView.midHeight = 0;
            _teamView.botHeight = 10;
        }
        if (_baseModel.project.teams.count > 0 && _baseModel.extr.count <= 0) {
            _teamView.sd_layout.heightIs(365 - 130);
            _teamView.imageHeight = 20;
            _teamView.scrollHeightFirst = 130;
            _teamView.scrollHeightSecond = 0;
            _teamView.teamModelArray = [NSMutableArray arrayWithArray:_baseModel.project.teams];
            _teamView.topHeight = 10;
            _teamView.midHeight = 0;
            _teamView.botHeight = 10;
        }
        if (_baseModel.project.teams.count > 0 && _baseModel.extr.count > 0) {
            _teamView.sd_layout.heightIs(365);
            _teamView.scrollHeightFirst = 130;
            _teamView.scrollHeightSecond = 130;
            _teamView.imageHeight = 20;
            _teamView.extrModelArray = [NSMutableArray arrayWithArray:_baseModel.extr];
            _teamView.teamModelArray = [NSMutableArray arrayWithArray:_baseModel.project.teams];
            _teamView.topHeight = 10;
            _teamView.midHeight = 10;
            _teamView.botHeight = 10;
        }
        
        _footerView = [ProjectPrepareFooterCommentView new];
        _footerView.projectId = _projectId;
        _footerView.delagate =self;
        [_scrollView addSubview:_footerView];
        _footerView.sd_layout
        .leftEqualToView(_scrollView)
        .rightEqualToView(_scrollView)
        .topSpaceToView(_teamView,0);
        
        [_scrollView setupAutoContentSizeWithBottomView:_footerView bottomMargin:0];
    }
}

-(void)createBottomView
{
    if (!_bottomView) {
        UIView *bottomView = [UIView new];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        UIView *line = [UIView new];;
        line.backgroundColor = GrayColor;
        [bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *kefuBtn = [UIButton new];
        [kefuBtn setBackgroundImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
        [kefuBtn setTag:2];
        [kefuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        kefuBtn.size = kefuBtn.currentBackgroundImage.size;
        [bottomView addSubview:kefuBtn];
        [kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(95*WIDTHCONFIG);
        }];
        
        _collectBtn = [UIButton new];
        _collectBtn.layer.cornerRadius = 20;
        _collectBtn.layer.masksToBounds = YES;
        [_collectBtn setBackgroundColor:orangeColor];
        [_collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (_isCollect) {
            [_collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
            
        }else{
            [_collectBtn setImage:[UIImage imageNamed:@"icon_uncollect"] forState:UIControlStateNormal];
        }
        if (_collectCount == 0) {
            [_collectBtn setTitle:[NSString stringWithFormat:@" 关注"] forState:UIControlStateNormal];
        }else{
            [_collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)_collectCount] forState:UIControlStateNormal];
        }
        [_collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_collectBtn];
        [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(kefuBtn.mas_right).offset(45);
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-8);
        }];
        _bottomView = bottomView;
    }
}
#pragma mark---------------------------------- 关注--------------------------------------
-(void)collectClick:(UIButton*)btn
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
-(void)requestProjectCollect:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            if (_isCollect) {
                _collectCount ++;
                [_collectBtn setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
            }else{
                _collectCount --;
                [_collectBtn setImage:[UIImage imageNamed:@"icon_uncollect"] forState:UIControlStateNormal];
            }
            if (_collectCount == 0) {
                [_collectBtn setTitle:[NSString stringWithFormat:@" 关注"] forState:UIControlStateNormal];
            }else{
                [_collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)_collectCount] forState:UIControlStateNormal];
            }
            
        }else{
            
        }
    }
}
#pragma mark ------------------------------导航栏按钮点击事件-------------------
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        if (!_isCollect) {
            NSInteger index = [_attentionVC.projectArray indexOfObject:_model];
            [_attentionVC.projectArray removeObject:_model];
            [_attentionVC.statusArray removeObjectAtIndex:index];
            [_tableView reloadData];
        }
        
        [self.httpUtil requestDealloc];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1) {
            [self startShare];
    }
    if (btn.tag == 2) {
        
        NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
        NSString *tel = [data objectForKey:@"servicePhone"];
        //        NSLog(@"电话---%@",tel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
    }
}

#pragma mark -开始分享

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
    if(self.bottomView != nil)
    {
        [self.bottomView removeFromSuperview];
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
    self.bottomView = share;
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
                
//                NSLog(@"分享圈子");
            }
                break;
            case 1:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareurl;
                    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
//                    [UMSocialData defaultData].extConfig.qzoneData.title = _shareTitle;
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
//                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
//                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
//                NSLog(@"分享到微信");
            }
                break;
            case 3:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
//                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareurl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareurl;
//                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
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
        
        __weak typeof (self) weakSelf = self;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [weakSelf performSelector:@selector(dismissBG) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
                    
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
        [self shareToCircle];
//        NSLog(@"调接口");
        [_shareCircleView removeFromSuperview];
        if ([content isEqualToString:@"说点什么吧..."]) {
            content = @"";
        }
        if (_shareContent.length>200) {
            _shareContent = [_shareContent substringToIndex:200];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.circlePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"contentId",@"7",@"type",content,@"comment",[NSString stringWithFormat:@"%ld,1",(long)self.projectId],@"content",_shareContent,@"description",_shareImage,@"image",@"金指投项目",@"tag",nil];
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
-(void)shareToCircle
{
    
}
#pragma mark-------ProjectPrepareFooterCommentViewDelagate--------
-(void)didClickBtn:(NSMutableArray *)dataArray
{
        ProjectPrepareCommentVC *vc = [ProjectPrepareCommentVC new];
        vc.projectId =self.projectId;
        vc.dataArray = dataArray;
        vc.footerCommentView = _footerView;
        [self.navigationController pushViewController:vc animated:YES];
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
    __block ProjectPrepareDetailVC* blockSelf = self;
    
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
    RenzhengViewController  * renzheng = [RenzhengViewController new];
    renzheng.identifyType = self.identiyTypeId;
    [self.navigationController pushViewController:renzheng animated:YES];
}


#pragma mark-------ProjectDetailLeftTeamViewDelegate----------
-(void)didClickBtnInTeamViewWithModel:(DetailTeams *)team
{

        if (team.url.length) {
            PingTaiWebViewController *vc = [PingTaiWebViewController new];
            vc.url = team.url;
            vc.titleStr = @"详情";
            [self.navigationController pushViewController:vc animated:YES];
        }
  
}

-(void)didClickCoverBtn
{
    if ([_authenticName isEqualToString:@"认证中"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，通过后方可查看！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    if ([_authenticName isEqualToString:@"未认证"] || [_authenticName isEqualToString:@"认证失败"])
    {
        [self presentAlertView];
    }
}

-(void)didClickBtnInTeamExrViewWithModel:(DetailExtr *)extr
{

//        if (![_identiyTypeId isEqualToString:@"1"]) {
//            if (extr.url.length) {
//                PingTaiWebViewController *vc = [PingTaiWebViewController new];
//                vc.url = extr.url;
//                vc.titleStr = extr.content;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }else{
//        
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的身份为项目方，不能查看其他项目方的资料" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//        }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIButton new]];
//    self.navigationController.navigationBar.hidden = YES;
    if (!_navBar) {
        [self setupNav];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_navBar) {
        [_navBar removeFromSuperview];
        _navBar = nil;
    }
}


-(void)dealloc
{
    [_footerView.httpUtil requestDealloc];
    [self cancleRequest];
}
@end
