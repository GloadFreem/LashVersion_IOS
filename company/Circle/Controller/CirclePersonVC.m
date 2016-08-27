//
//  CirclePersonVC.m
//  company
//
//  Created by Eugene on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CirclePersonVC.h"
#import "CircleListCell.h"
#import "CircleListModel.h"
#import "CircleBaseModel.h"
#import "CircleShareBottomView.h"
#import "CircleDetailVC.h"

#define CIRCLE_CONTENT @"requestFeelingList"
#define CIRCLE_PRAISE @"requestPriseFeeling"
#define DELETELIST @"requestPublicContentDelete"
#define CIRCLE_SHARE @"requestShareFeeling"
#define CIRCLE_USER @"requestUsersFeelingList"
@interface CirclePersonVC ()<UITableViewDelegate,UITableViewDataSource,CircleListCellDelegate,CircleShareBottomViewDelegate>

{
    id kcell;
    id kmodel;
    
//    AuthenticInfoBaseModel * authenticInfoModel;
}

@property (nonatomic, copy) NSString *userPartner;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *flag;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic, copy) NSString *praisePartner;
@property (nonatomic, assign) BOOL praiseSuccess;

@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl; //分享地址
@property (nonatomic, copy) NSString *contentText;

@property (nonatomic, copy) NSString *deletePartner;
@property (nonatomic, strong) CircleListModel *deleteModel;

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, copy) NSString *selfId;//本人ID
@end

@implementation CirclePersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _selfId = [data objectForKey:USER_STATIC_USER_ID];
    
    //获得内容partner
    self.userPartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_CONTENT];
    //获得点赞partner
    self.praisePartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_PRAISE];
    //获得状态分享partner
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_SHARE];
    //删除
    self.deletePartner = [TDUtil encryKeyWithMD5:KEY action:DELETELIST];
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 0;
    _isFirst = YES;
    [self setupNav];
    [self createTableView];
    
    
    self.userPartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_USER];
    //设置加载视图范围
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    [self loadData];
}


#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.tag = 0;
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    
    
    self.navigationItem.title = _titleStr;
}
-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -创建tableView
-(void)createTableView
{
    _tableView  = [UITableViewCustomView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.tableHeaderView = self.headerView;
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    
    [self.view addSubview:_tableView];
    _tableView.frame = self.view.frame;
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_left);
//        make.top.mas_equalTo(self.view.mas_top);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//    }];
}

-(void)nextPage
{
    _page ++;
    [self loadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page = 0;
    
    [self loadData];
    //    NSLog(@"下拉刷新");
}

-(void)loadData
{
    if (_isFirst) {
        self.startLoading = YES;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.userPartner,@"partner",self.userId,@"userId",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CYCLE_USER_LIST postParam:dic type:0 delegate:self sel:@selector(requestCircleUserList:)];
}

-(void)requestCircleUserList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            
            if (_page == 0) {
                [_tempArray removeAllObjects];
            }
            if (_isFirst) {
                _isFirst = NO;
            }
            [self analysisCircleListData:dataArray];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }
        self.startLoading = NO;
    }else{
        self.isNetRequestError = YES;
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)analysisCircleListData:(NSArray*)array
{
    for (NSInteger i =0; i < array.count; i ++) {
        //实例化圈子模型
        CircleListModel *listModel = [CircleListModel new];
        
        //实例化返回数据baseModel
        CircleBaseModel *baseModel = [CircleBaseModel mj_objectWithKeyValues:array[i]];
        //一级模型赋值
        listModel.timeSTr = baseModel.publicDate;              //发布时间
        listModel.iconNameStr = baseModel.users.headSculpture; //发布者头像
        listModel.nameStr = baseModel.users.name;              //发布者名字
        listModel.userId = baseModel.users.userId;
        listModel.msgContent = baseModel.content;
        listModel.publicContentId = baseModel.publicContentId; //帖子ID
        listModel.shareCount = baseModel.shareCount;           //分享数量
        listModel.commentCount = baseModel.commentCount;       //评论数量
        listModel.priseCount = baseModel.priseCount;           //点赞数量
        listModel.flag = baseModel.flag;
        //新增数据
        listModel.contentText = baseModel.contentshare.desc;
        listModel.contentImage = baseModel.contentshare.image;
        listModel.url = baseModel.contentshare.content;
        listModel.titleText = baseModel.contentshare.contenttype.name;
        listModel.feelingTypeId = baseModel.feeingtype.feelingTypeId;
        
        //拿到usrs认证数组
        NSArray *authenticsArray = [NSArray arrayWithArray:baseModel.users.authentics];
        //实例化认证人模型
        if (authenticsArray.count) {
            CircleUsersAuthenticsModel *usersAuthenticsModel =authenticsArray[0];
            listModel.addressStr = usersAuthenticsModel.city.name;
            listModel.companyStr = usersAuthenticsModel.companyName;
            listModel.positionStr = usersAuthenticsModel.position;
            listModel.identiyTypeId = usersAuthenticsModel.identiytype.identiyTypeId;
        }
        
        NSMutableArray *picArray = [NSMutableArray array];
        for (NSInteger i = 0; i < baseModel.contentimageses.count; i ++) {
            CircleContentimagesesModel *imageModel = baseModel.contentimageses[i];
            [picArray addObject:imageModel.url];
        }
        listModel.picNamesArray = [NSArray arrayWithArray:picArray];
        //                NSLog(@"照片数组---%@",listModel.picNamesArray);
        //将model加入数据数组
        [_tempArray addObject:listModel];
        
    }
    self.dataArray = _tempArray;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (_dataArray.count <= 0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
    }
    [self.tableView reloadData];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
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
    [self loadData];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataArray[indexPath.row];
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleListCell class] contentViewWidth:[self cellContentViewWith]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CircleListCell";
    CircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CircleListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.indexPath = indexPath;
    __weak typeof (self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            CircleListModel *model =weakSelf.dataArray[indexPath.row];
            model.isOpening  = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    cell.delegate = self;
    if (self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
        if (cell.model.userId == [_selfId integerValue]) {
            [cell.deleteBtn setHidden:NO];
        }else{
            [cell.deleteBtn setHidden:YES];
        }
    }
    return cell;
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

#pragma mark---------------- CircleListCellDelegate------------
#pragma mark-----------------点击头像----------------
-(void)didClickIconBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"进入个人中心");
}
#pragma mark-----------------点击contentBtn---------
-(void)didClickContentBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"处理点击事件");
}

#pragma maerk ---------分享按钮
-(void)didClickShareBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model
{
    
    if (model.publicContentId) {
        
        if (_currentIndexPath == cell.indexPath) {
            [self startShare];
        }else{
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",@"2",@"type",[NSString stringWithFormat:@"%ld",(long)model.publicContentId],@"contentId", nil];
            
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:CIRCLE_FEELING_SHARE postParam:dic type:0 delegate:self sel:@selector(requestShareStatus:)];
        }
        
    }
}
#pragma mark ---------分享请求网址
-(void)requestShareStatus:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            _shareUrl = dataDic[@"url"];
            _shareImage = dataDic[@"image"];
            _contentText = dataDic[@"content"];
            _shareTitle = dataDic[@"title"];
            //开始分享
            [self startShare];
        }
        
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }
}

#pragma mark -开始分享

#pragma mark  转发

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
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_contentText];
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
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
            case 1:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                //                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                //                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                //                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                //                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
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
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_shareTitle,_contentText,_shareUrl];
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

#pragma mark------------------删除按钮----------------------
-(void)didClickDeleteInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    if (model.publicContentId) {
        _deleteModel = model;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        __block CirclePersonVC* blockSelf = self;
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [blockSelf btnCertainClick:nil];
        }];
        
        [alertController addAction:cancleAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)btnCertainClick:(id)sender
{
    [_dataArray removeObject:_deleteModel];
    [self.tableView reloadData];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.deletePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_deleteModel.publicContentId],@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CIRCLE_LIST_DELETE postParam:dic type:0 delegate:self sel:@selector(requestDeleteList:)];
}
-(void)requestDeleteList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"删除成功"];
        }
    }
}


#pragma mark -------------------评论按钮-------------------
-(void)didClickCommentBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    //进入详情页
    CircleListModel *listModel = _dataArray[indexPath.row];
    if (listModel.publicContentId) {
        CircleDetailVC *detail = [CircleDetailVC new];
        detail.publicContentId  =listModel.publicContentId;//帖子ID
        detail.page = 0;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark -------------------点赞按钮--------------------
-(void)didClickPraiseBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    if (model.publicContentId) {
        kcell = cell;
        kmodel = model;
        
        model.flag = !model.flag;
        
        if (model.flag) {
            //        [cell.praiseBtn setImage:[UIImage imageNamed:@"iconfont-dianzan"] forState:UIControlStateNormal];
            _flag = @"1";
            
        }else{
            //        [cell.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
            _flag = @"2";
        }
        //请求更新数据数据
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.praisePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)model.publicContentId],@"contentId",_flag,@"flag", nil];
        
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:CYCLE_CELL_PRAISE postParam:dic type:0 delegate:self sel:@selector(requestPraiseStatus:)];
    }
}

-(void)requestPraiseStatus:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            _praiseSuccess = YES;
            
            CircleListModel *model = (CircleListModel*)kmodel;
            CircleListCell *cell = (CircleListCell*)kcell;
            if (model.flag) {
                [cell.praiseBtn setImage:[UIImage imageNamed:@"iconfont_dianzan"] forState:UIControlStateNormal];
                model.priseCount ++;
                [cell.praiseBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.priseCount] forState:UIControlStateNormal];
            }else{
                [cell.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
                model.priseCount --;
                [cell.praiseBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.priseCount] forState:UIControlStateNormal];
            }
            [_tableView reloadData];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
