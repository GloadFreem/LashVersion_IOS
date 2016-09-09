//
//  CircleViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleViewController.h"
#import "CirclePersonVC.h"
#import "AuthenticInfoBaseModel.h"

#import "CircleShareBottomView.h"
#import "RenzhengViewController.h"

#import "CircleListModel.h"
#import "CircleListCell.h"
#import "CircleReleaseVC.h"

#import "CircleBaseModel.h"
#import "CircleDetailVC.h"
#import "CircleShareBottomView.h"

#import "InvestPersonDetailViewController.h"
#import "InvestThinkTankDetailVC.h"
#import "HeadlineDetailViewController.h"
#import "ProjectBannerDetailVC.h"
#import "ProjectPrepareDetailVC.h"
#import "ProjectDetailController.h"

#import "ActivityDetailVC.h"

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
@property (nonatomic, copy) NSString *selfIconStr;
@property (nonatomic, copy) NSString *selfName;
@property (nonatomic, copy) NSString *selfPositionStr;
@property (nonatomic, copy) NSString *selfCompanyName;
@property (nonatomic, copy) NSString *selfCity;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) BOOL haveData;   //是否有离线数据

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    _selfId = [defaults objectForKey:USER_STATIC_USER_ID];
    _selfIconStr = [defaults objectForKey:USER_STATIC_HEADER_PIC];
    _selfName = [defaults objectForKey:USER_STATIC_NAME];
    _selfPositionStr = [defaults objectForKey:USER_STATIC_POSITION];
    _selfCompanyName = [defaults objectForKey:USER_STATIC_COMPANY_NAME];
    _selfCity = [defaults objectForKey:USER_STATIC_CITY];
    
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
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
    
    
    
    //设置 加载视图界面
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 49);
    
    _isFirst = YES;
    _page = 0;
    [self setupNav];
    [self createTableView];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishContent:) name:@"publish" object:nil];
    //下载数据
//    [self loadData];
    //下载认证信息
    
}


#pragma mark -发布照片通知
-(void)publishContent:(NSDictionary*)dic
{
    NSMutableArray* uploadFiles =[[dic valueForKey:@"userInfo"] valueForKey:@"uploadFiles"];
    NSString* content = [[dic valueForKey:@"userInfo"] valueForKey:@"content"];
    
    //实例化圈子模型
    CircleListModel *listModel = [CircleListModel new];
    //一级模型赋值
    listModel.timeSTr = [TDUtil CurrentDate];              //发布时间
    listModel.iconNameStr = _selfIconStr; //发布者头像
    listModel.nameStr = _selfName;              //发布者名字
    listModel.msgContent = content;
    listModel.publicContentId = 0; //帖子ID
    listModel.shareCount = 0;           //分享数量
    listModel.commentCount = 0;       //评论数量
    listModel.priseCount = 0;           //点赞数量
    listModel.flag = false;
    listModel.userId = [_selfId integerValue];
    listModel.feelingTypeId = 1;
    
    listModel.addressStr = _selfCity;
    listModel.companyStr = _selfCompanyName;
    listModel.positionStr = _selfPositionStr;
    
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
    _tableView  = [UITableViewCustomView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];

    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

-(UIView*)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 70)];
//        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *topView = [UIView new];
        [topView setBackgroundColor:colorGray];
        [_headerView addSubview:topView];
        
        topView.sd_layout
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .topEqualToView(_headerView)
        .heightIs(8);
        
        UIImageView *iconImage = [UIImageView new];
        iconImage.layer.cornerRadius = 20;
        iconImage.layer.masksToBounds = YES;
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.selfIconStr]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
        
        [_headerView addSubview:iconImage];
        
        iconImage.sd_layout
        .leftSpaceToView(_headerView,8)
        .topSpaceToView(topView, 10)
        .widthIs(40)
        .heightIs(40);

        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"我的话题";
        titleLabel.font = BGFont(19);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = color(50, 50, 50, 1);
        [titleLabel sizeToFit];
        [_headerView addSubview:titleLabel];
        
        titleLabel.sd_layout
        .leftSpaceToView(iconImage,10)
        .centerYEqualToView(iconImage)
        .heightIs(19);
        [titleLabel setSingleLineAutoResizeWithMaxWidth:150];
        
        UIImageView *arrowImage = [UIImageView new];
        arrowImage.image = [UIImage imageNamed:@"icon_right"];
        [_headerView addSubview:arrowImage];
        
        arrowImage.sd_layout
        .rightSpaceToView( _headerView,12)
        .centerYEqualToView(iconImage)
        .widthIs(9)
        .heightIs(15);
        
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(myCircle) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [_headerView addSubview:btn];
        
        btn.sd_layout
        .leftEqualToView(_headerView)
        .topEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .bottomEqualToView(_headerView);
    }
    
    return _headerView;
}

-(void)myCircle
{
//    NSLog(@"进入我的界面");
    CirclePersonVC *vc = [CirclePersonVC new];
    vc.titleStr = @"我的话题";
    vc.userId = _selfId;
    [self.navigationController pushViewController:vc animated:YES];
    
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


#pragma mark-----加载离线数据
-(void)loadOffLineData
{
    //先从数据库加载 没有数据  则进行数据请求
    NSArray *circleArray = [self getDataFromBaseTable:CIRCLETABLE];
    if (circleArray.count) {
        [self analysisCircleListData:circleArray];
        _haveData = YES;
    }else{
        if ([TDUtil checkNetworkState] != NetStatusNone)
        {
            [self loadData];
        }
    }
}

-(void)loadData
{
    if (!_haveData) {
        self.startLoading = YES;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",VERSION,@"version",[NSString stringWithFormat:@"%ld",(long)_page],@"page",PLATFORM,@"platform", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CONTENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestCircleContentList:)];
}

-(void)requestCircleContentList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            
            //解析数据  将data字典转换为BaseModel
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
            dictM[@"data"] = jsonString;
            
            if (_page == 0) {
                [_tempArray removeAllObjects];
                [self saveDataToBaseTable:CIRCLETABLE data:dictM];
                _haveData = YES;
            }

            [self analysisCircleListData:dataArray];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }
        self.startLoading = NO;
    }else{
        self.isNetRequestError = YES;
    }
    //结束刷新
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
        listModel.msgContent = [baseModel.content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        listModel.publicContentId = baseModel.publicContentId; //帖子ID
        listModel.shareCount = baseModel.shareCount;           //分享数量
        listModel.commentCount = baseModel.commentCount;       //评论数量
        listModel.priseCount = baseModel.priseCount;           //点赞数量
        listModel.flag = baseModel.flag;
        //新增数据
        listModel.contentText = baseModel.contentshare.desc;
        listModel.contentImage = baseModel.contentshare.image;
        listModel.url = baseModel.contentshare.content;
//        NSLog(@"%@",baseModel.contentshare.content);
        listModel.titleText = baseModel.contentshare.tag;
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
        return  [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleListCell class] contentViewWidth:[self cellContentViewWith]];
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
    
    CircleListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isShow) {
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
    
}
#pragma mark --------发布动态
-(void)releaseBtnClick:(UIButton*)btn
{

        CircleReleaseVC *vc = [CircleReleaseVC new];
        
        [self.navigationController pushViewController:vc animated:YES];
    
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
    if ([_selfId integerValue] == model.userId) {
        //    NSLog(@"进入个人中心");
        CirclePersonVC *vc = [CirclePersonVC new];
        vc.titleStr = @"我的话题";
        vc.userId = _selfId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{

    if (model.identiyTypeId == 1 || model.identiyTypeId == 2 || model.identiyTypeId == 3) {
        InvestPersonDetailViewController *vc = [InvestPersonDetailViewController new];
        vc.isCircle = YES;
        vc.investorId = [NSString stringWithFormat:@"%ld",(long)model.userId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.identiyTypeId == 4) {
        InvestThinkTankDetailVC *vc = [InvestThinkTankDetailVC new];
        vc.isCircle = YES;
        vc.investorId = [NSString stringWithFormat:@"%ld",(long)model.userId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    }
    
}
#pragma mark-----------------点击contentBtn---------
-(void)didClickContentBtnInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"处理点击事件");
    if (model.feelingTypeId == 2) {//链接
        ProjectBannerDetailVC *vc = [ProjectBannerDetailVC new];
        vc.url = model.url;
        vc.image = model.contentImage;
        vc.titleText = model.titleText;
        vc.contentText = model.contentText;
        vc.titleStr = model.titleText;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (model.feelingTypeId == 3) {//项目
        NSArray *array = [model.url componentsSeparatedByString:@","];
        if (array.count == 2) {
            if ([array[1] isEqualToString:@"0"]) {//路演
                ProjectDetailController *detail =[ProjectDetailController new];
                detail.projectId = [array[0] integerValue];
                [self.navigationController pushViewController:detail animated:YES];
            }
            
            if ([array[1] isEqualToString:@"1"]) {//预选
                ProjectPrepareDetailVC *detail =[ProjectPrepareDetailVC new];
                detail.projectId = [array[0] integerValue];
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
    }
    if (model.feelingTypeId == 4) {//活动
        NSArray *array = [model.url componentsSeparatedByString:@","];
        ActivityDetailVC *vc =[ActivityDetailVC new];
        vc.actionId = [array[0] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark------------------删除按钮----------------------
-(void)didClickDeleteInCell:(CircleListCell *)cell andModel:(CircleListModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    if (model.publicContentId) {
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.dataArray.count) {
        [self loadOffLineData];
    }
    
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"publish" object:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"publish" object:nil];
}



@end
