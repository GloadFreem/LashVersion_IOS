//
//  CircleViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleViewController.h"

#import "AuthenticInfoBaseModel.h"

#import "CircleShareBottomView.h"
#import "RenzhengViewController.h"

#import "CircleForwardVC.h"

#import "CircleListModel.h"
#import "CircleListCell.h"
#import "CircleReleaseVC.h"

#import "CircleBaseModel.h"
#import "CircleDetailVC.h"
#import "CircleShareBottomView.h"

#define DELETELIST @"requestPublicContentDelete"
#define AUTHENINFO @"authenticInfoUser"
#define CIRCLE_CONTENT @"requestFeelingList"
#define CIRCLE_PRAISE @"requestPriseFeeling"
#define CIRCLE_SHARE @"requestShareFeeling"
#define CIRCLE_UPDATE_SHARE @"requestUpdateShareFeeling"
@interface CircleViewController ()<CircleShareBottomViewDelegate,UITableViewDelegate,UITableViewDataSource,CircleListCellDelegate>
{
    id kcell;
    id kmodel;
    
    AuthenticInfoBaseModel * authenticInfoModel;
}

@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic, copy) NSString *authenPartner;
@property (nonatomic, copy) NSString *praisePartner;
@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *updateSharePartner;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, strong) CircleListModel *listModel;
@property (nonatomic, strong) CircleListCell *listCell;
@property (nonatomic, assign) BOOL praiseSuccess;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl; //分享地址
@property (nonatomic, copy) NSString *contentText;

@property (nonatomic, strong) CircleListModel *replaceListModel; //假model

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, copy) NSString *deletePartner;
@property (nonatomic, strong) CircleListModel *deleteModel;
@property (nonatomic, copy) NSString *selfId;//本人ID

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_CONTENT];
    //获得点赞partner
    self.praisePartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_PRAISE];
    //获得状态分享partner
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_SHARE];
    //获得状态分享更新partner
    self.updateSharePartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_UPDATE_SHARE];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    self.deletePartner = [TDUtil encryKeyWithMD5:KEY action:DELETELIST];
    
    
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _selfId = [data objectForKey:USER_STATIC_USER_ID];
    
    _isFirst = YES;
    _page = 0;
    [self setupNav];
    [self createTableView];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishContent:) name:@"publish" object:nil];
    //下载数据
    [self loadData];
    //下载认证信息
    [self loadAuthenData];
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
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            authenticInfoModel = [AuthenticInfoBaseModel mj_objectWithKeyValues:dataDic];
//            NSLog(@"打印个人信息：----%@",authenticInfoModel);
//
        }
    }
}

#pragma mark -发布照片通知
-(void)publishContent:(NSDictionary*)dic
{
    NSMutableArray* uploadFiles =[[dic valueForKey:@"userInfo"] valueForKey:@"uploadFiles"];
    NSString* content = [[dic valueForKey:@"userInfo"] valueForKey:@"content"];
    
    //实例化圈子模型
    CircleListModel *listModel = [CircleListModel new];
    //拿到usrs认证数组
    NSArray *authenticsArray = [NSArray arrayWithArray:authenticInfoModel.authentics];
    //实例化认证人模型
    CircleUsersAuthenticsModel *usersAuthenticsModel =authenticsArray[0];
    //一级模型赋值
    listModel.timeSTr = [TDUtil CurrentDate];              //发布时间
    listModel.iconNameStr = authenticInfoModel.headSculpture; //发布者头像
    listModel.nameStr = usersAuthenticsModel.name;              //发布者名字
    listModel.msgContent = content;
    listModel.publicContentId = 0; //帖子ID
    listModel.shareCount = 0;           //分享数量
    listModel.commentCount = 0;       //评论数量
    listModel.priseCount = 0;           //点赞数量
    listModel.flag = false;
    listModel.userId = [_selfId integerValue];
    
    listModel.addressStr = usersAuthenticsModel.companyAddress;
    listModel.companyStr = usersAuthenticsModel.companyName;
    listModel.positionStr = usersAuthenticsModel.position;
    NSMutableArray *picArray = [NSMutableArray array];
    for (NSInteger i = 0; i < uploadFiles.count; i ++) {
        [picArray addObject:uploadFiles[i]];
    }
    listModel.picNamesArray = [NSArray arrayWithArray:picArray];
    
    [_dataArray insertObject:listModel atIndex:0];
    
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

  
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",content,@"content", nil];
    [self.httpUtil getDataFromAPIWithOps:CIRCLE_PUBLIC_FEELING postParam:dict files:uploadFiles postName:@"images" type:0 delegate:self sel:@selector(requestPublishContent:)];
    
}

-(void)reloadData
{
    [self.tableView reloadData];
}
-(void)requestPublishContent:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
//            [self refreshHttp];
        }else{
            //        self.startLoading = NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网速不好，请手动刷新"];
        }
    }
}

#pragma mark -设置导航栏
-(void)setupNav
{
    
    UIButton * releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn setBackgroundImage:[UIImage imageNamed:@"icon_circle_add"] forState:UIControlStateNormal];
    releaseBtn.size = releaseBtn.currentBackgroundImage.size;
    [releaseBtn addTarget:self action:@selector(releaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn] ;
    self.navigationItem.title = @"圈子";
}
#pragma mark -创建tableView
-(void)createTableView
{
    _tableView  = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];

    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
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
        [SVProgressHUD show];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CONTENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestCircleContentList:)];
}

-(void)requestCircleContentList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (_page == 0) {
        [_dataArray removeAllObjects];
    }
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            
            //解析数据  将data字典转换为BaseModel
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
//            NSLog(@"shuzu------%@",dataArray[0]);
            for (NSInteger i =0; i < dataArray.count; i ++) {
                //实例化圈子模型
                CircleListModel *listModel = [CircleListModel new];
                
                //实例化返回数据baseModel
                CircleBaseModel *baseModel = [CircleBaseModel mj_objectWithKeyValues:dataArray[i]];
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
                
                //拿到usrs认证数组
                NSArray *authenticsArray = [NSArray arrayWithArray:baseModel.users.authentics];
                //实例化认证人模型
                if (authenticsArray.count) {
                    CircleUsersAuthenticsModel *usersAuthenticsModel =authenticsArray[0];
                    listModel.addressStr = usersAuthenticsModel.companyAddress;
                    listModel.companyStr = usersAuthenticsModel.companyName;
                    listModel.positionStr = usersAuthenticsModel.position;
                }
                
                NSMutableArray *picArray = [NSMutableArray array];
                for (NSInteger i = 0; i < baseModel.contentimageses.count; i ++) {
                    CircleContentimagesesModel *imageModel = baseModel.contentimageses[i];
                    [picArray addObject:imageModel.url];
                }
                listModel.picNamesArray = [NSArray arrayWithArray:picArray];
//                NSLog(@"照片数组---%@",listModel.picNamesArray);
                //将model加入数据数组
                [_dataArray addObject:listModel];
                
            }
//            NSLog(@"数组个数---%ld",_dataArray.count);
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (_isFirst) {
                [SVProgressHUD dismiss];
                _isFirst = NO;
            }
            
        }else{
            
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }
        
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //进入详情页
    CircleListModel *listModel = _dataArray[indexPath.row];
    
    
    if (listModel.publicContentId) {
        CircleDetailVC *detail = [CircleDetailVC new];
        detail.indexPath = indexPath;
        detail.viewController = self;
        detail.publicContentId  =listModel.publicContentId;//帖子ID
        detail.page = 0;
        detail.circleModel = listModel;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}
#pragma mark -发布动态
-(void)releaseBtnClick:(UIButton*)btn
{
    if ([_authenticName isEqualToString:@"已认证"])
    {
        CircleReleaseVC *vc = [CircleReleaseVC new];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([_authenticName isEqualToString:@"认证中"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    if ([_authenticName isEqualToString:@"未认证"])
    {
        [self presentAlertView];
    }
}

-(void)presentAlertView
{
    //没有认证 提醒去认证
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有实名认证，请先实名认证" preferredStyle:UIAlertControllerStyleAlert];
    __block CircleViewController* blockSelf = self;
    
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
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma mark---------------- CircleListCellDelegate--------------
#pragma mark------------------------删除按钮----------------------
-(void)didClickDeleteInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    _deleteModel = model;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    __block CircleViewController* blockSelf = self;
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [blockSelf btnCertainClick:nil];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

#pragma maerk -分享按钮
-(void)didClickShareBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model
{
    if ([_authenticName isEqualToString:@"已认证"]){
        if (model.publicContentId) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",@"2",@"type",[NSString stringWithFormat:@"%ld",(long)model.publicContentId],@"contentId", nil];
            
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:CIRCLE_FEELING_SHARE postParam:dic type:0 delegate:self sel:@selector(requestShareStatus:)];
        }
    }
    
    if ([_authenticName isEqualToString:@"认证中"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    if ([_authenticName isEqualToString:@"未认证"])
    {
        [self presentAlertView];
    }
    
    
}
#pragma mark -分享请求网址
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
                    [UMSocialData defaultData].extConfig.qzoneData.title = _shareTitle;
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
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
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
#pragma mark -评论按钮
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
#pragma mark -点赞按钮
-(void)didClickPraiseBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    if ([_authenticName isEqualToString:@"已认证"])
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
    
    if ([_authenticName isEqualToString:@"认证中"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    if ([_authenticName isEqualToString:@"未认证"])
    {
        [self presentAlertView];
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

#pragma mark -视图即将显示
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationController.navigationBar.translucent=NO;
    
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"publish" object:nil];
    //    隐藏tabbar
//    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
   
//    [delegate.tabBar tabBarHidden:YES animated:NO];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"publish" object:nil];
}



@end
