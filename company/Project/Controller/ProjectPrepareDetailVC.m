//
//  ProjectPrepareDetailVC.m
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPrepareDetailVC.h"
#import "ProjectPrepareCommentVC.h"

#import "CircleShareBottomView.h"

#import "ProjectPrepareDetailHeaderView.h"
#import "CSZProjectDetailLetfView.h"
#import "ProjectPrepareFooterCommentView.h"

#import "ProjectDetailBaseMOdel.h"
#import "ProjectPrepareDetailHeaderModel.h"
#import "ProjectDetailLeftHeaderModel.h"
#import "ProjectDetailLeftFooterModel.h"

#define PROJECTCOLLECT @"requestProjectCollect"
#define PROJECTDETAIL @"requestProjectDetail"
#define PROJECTSHARE @"requestProjectShare"
@interface ProjectPrepareDetailVC ()<UIScrollViewDelegate,ProjectPrepareFooterCommentViewDelagate,CircleShareBottomViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ProjectPrepareDetailHeaderView *headerView;
@property (nonatomic, strong) CSZProjectDetailLetfView *leftView;
@property (nonatomic, strong) ProjectPrepareFooterCommentView *footerView;

@property (nonatomic, strong) ProjectDetailBaseMOdel *baseModel;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, assign) BOOL isCollect;            //是否关注
@property (nonatomic, assign) NSInteger collectCount;
@property (nonatomic, copy) NSString *collectPartner;

@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareurl;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic,strong)UIView * bottomView;

@end

@implementation ProjectPrepareDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTDETAIL];
    self.collectPartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTCOLLECT];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:PROJECTSHARE];
    
    [self startLoadData];
    
    [self setupNav];
    
    [self loadShareData];
    
    
//    NSLog(@"projectId----%ld",self.projectId);
}
-(void)startLoadData
{
    [SVProgressHUD show];
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
            
            [SVProgressHUD dismiss];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
    [SVProgressHUD dismiss];
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
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _shareurl  = dic[@"url"];
            _shareImage = dic[@"image"];
            _shareContent = dic[@"content"];
        }
    }
}

-(void)setupNav
{
    UIView *navView = [UIView new];
    [navView setBackgroundColor:color(61, 153, 130, 1)];
    [self.view addSubview:navView];
    navView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(64)
    .topEqualToView(self.view);
    
    UIButton *leftBtn = [UIButton new];
    [leftBtn setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [leftBtn setTag:0];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(37);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn setImage:[UIImage imageNamed:@"write-拷贝-2"] forState:UIControlStateNormal];
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
    _scrollView = [UIScrollView new];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.view,64)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,50);
    
    _headerView = [ProjectPrepareDetailHeaderView new];
    _headerView.model= _baseModel;
    [_scrollView addSubview:_headerView];
    _headerView.sd_layout
    .leftEqualToView(_scrollView)
    .topEqualToView(_scrollView)
    .rightEqualToView(_scrollView);
    
    _leftView = [CSZProjectDetailLetfView new];
    _leftView.model = _baseModel;
    [_scrollView addSubview:_leftView];
    _leftView.sd_layout
    .leftEqualToView(_scrollView)
    .rightEqualToView(_scrollView)
    .topSpaceToView(_headerView,0);
    
    _footerView = [ProjectPrepareFooterCommentView new];
    _footerView.projectId = _projectId;
    _footerView.delagate =self;
    [_scrollView addSubview:_footerView];
    _footerView.sd_layout
    .leftEqualToView(_scrollView)
    .rightEqualToView(_scrollView)
    .topSpaceToView(_leftView,0);
    
    [_scrollView setupAutoContentSizeWithBottomView:_footerView bottomMargin:10];
}

-(void)createBottomView
{
    UIView *bottomView = [UIView new];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *kefuBtn = [UIButton new];
    [kefuBtn setBackgroundImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
    [kefuBtn setTag:2];
    [kefuBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    kefuBtn.size = kefuBtn.currentBackgroundImage.size;
    [bottomView addSubview:kefuBtn];
    [kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(3);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
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
        make.right.mas_equalTo(-3);
    }];
    
}
#pragma mark------ 关注-------
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
    NSLog(@"返回:%@",jsonString);
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
#pragma mark ---导航栏按钮点击事件
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        
        if (!_isCollect) {
            [_attentionVC.projectArray removeObject:_model];
            [_tableView reloadData];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1) {
       [self startShare];
        
    }
    if (btn.tag == 2) {
        NSLog(@"联系客服");
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
    NSArray *titleList = @[@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareViewWithTitleArray:titleList imageArray:imageList];
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
                    
                    [self performSelector:@selector(dismissBG) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
                    
                    
                });
            }
        }];
    }
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
#pragma mark -moreBtn点击事件 处理
-(void)moreBtnClick:(UIButton*)btn
{
    NSLog(@"进入回复详情页");
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    [SVProgressHUD dismiss];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
}
@end
