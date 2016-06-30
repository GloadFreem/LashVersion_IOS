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

#define AUTHENINFO @"authenticInfoUser"
#define PROJECTLIST @"requestProjectList"
#define BANNERSYSTEM @"bannerSystem"
#define BannerHeight  SCREENWIDTH * 0.5 + 45
@interface ProjectViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectBannerViewDelegate>
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
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _selectedCellNum = 20;
    _page = 0;
    _projectPage = 0;
    _roadPage = 0;
    _type = @"0";
    //获得partner
    self.bannerPartner = [TDUtil encryKeyWithMD5:KEY action:BANNERSYSTEM];
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROJECTLIST];
    //获得认证partner
    self.authenPartner = [TDUtil encryKeyWithMD5:KEY action:AUTHENINFO];
    
    [self startLoadBannerData];
    
    [self startLoadData];
    //下载认证信息
    [self loadAuthenData];

    [self createUI];
    
    
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
//            authenticModel = baseModel;
            //            NSLog(@"打印个人信息：----%@",baseModel);
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:baseModel.headSculpture forKey:USER_STATIC_HEADER_PIC];
            [data setValue:baseModel.telephone forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:[NSString stringWithFormat:@"%ld",(long)baseModel.userId] forKey:USER_STATIC_USER_ID];
            
            NSArray *authenticsArray = baseModel.authentics;
            ProjectAuthentics *authentics = authenticsArray[0];
            
            [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
            [data setValue:authentics.name forKey:USER_STATIC_NAME];
            [data setValue:authentics.identiyCarA forKey:USER_STATIC_IDPIC];
            [data setValue:authentics.identiyCarNo forKey:USER_STATIC_IDNUMBER];
            [data setValue:authentics.position forKey:USER_STATIC_POSITION];
//            [data setValue:authentics.companyName forKey:USER_STATIC_COMPANY_NAME];
            [data setValue:authentics.authenticstatus.name forKey:USER_STATIC_USER_AUTHENTIC_STATUS];
            
            [data synchronize];
            
//            if ([authentics.authenticstatus.name isEqualToString:@"已认证"]) {
//                _isAuthentic = YES;
//            }
        }
    }
}

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
    NSLog(@"返回:%@",jsonString);
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
                    //少一个areas数组
                    listModel.areas = [project.industoryType componentsSeparatedByString:@"，"];
                    listModel.collectionCount = project.collectionCount;
                    Roadshows *roadshows = project.roadshows[0];
                    listModel.financedMount = roadshows.roadshowplan.financedMount;
                    listModel.financeTotal = roadshows.roadshowplan.financeTotal;
                    listModel.endDate = roadshows.roadshowplan.endDate;
                    
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
                    NSLog(@"领域 ----%@",project.industoryType);
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
    }
}
-(void)startLoadBannerData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.bannerPartner,@"partner", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:BANNER_SYSTEM postParam:dic type:0 delegate:self sel:@selector(requestBannerList:)];
    
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
                    listModel.projectId = baseModel.extr.projectId;
                    BannerRoadshows *roadshows = baseModel.extr.roadshows[0];
                    BannerRoadshowplan *roadshowplan = roadshows.roadshowplan;
                    listModel.financedMount = roadshowplan.financedMount;
                    listModel.financeTotal = roadshowplan.financeTotal;
                    
                }
                [_bannerModelArray addObject:listModel];
//                NSLog(@"打印数组个数---%ld",_bannerModelArray.count);
            }
            //搭建banner
            [self createBanner];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
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
    //不隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
    
}
#pragma mark -视图即将消失
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)createUI
{

    self.navigationItem.title = @"项目";

   
    UIButton * letterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    letterBtn.tag = 0;
    //通过判断返回数据状态来决定背景图片
//    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [letterBtn setBackgroundImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    letterBtn.size = letterBtn.currentBackgroundImage.size;
    [letterBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:letterBtn];
    
//    UIButton *upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    upLoadBtn.tag = 1;
//    [upLoadBtn setBackgroundImage:[UIImage imageNamed:@"upLoad"] forState:UIControlStateNormal];
//    upLoadBtn.size = upLoadBtn.currentBackgroundImage.size;
//    [upLoadBtn addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:upLoadBtn];
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [_tableView.mj_header beginRefreshing];
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

#pragma mark- navigationBar  button的点击事件
-(void)buttonCilck:(UIButton*)button
{
    if (button.tag == 0) {
        
        ProjectLetterViewController *letter = [ProjectLetterViewController new];
        //隐藏tabbar
        AppDelegate *delegate = (AppDelegate*)[[UIApplication  sharedApplication] delegate];
        [delegate.tabBar tabBarHidden:YES animated:NO];
        
        [self.navigationController pushViewController:letter animated:YES];
        
    }
    if (button.tag == 1) {
        
        UpProjectViewController *up = [UpProjectViewController new];
        
        //隐藏tabbar
//        AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//        
//        [delegate.tabBar tabBarHidden:YES animated:NO];
        
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



#pragma mark -设置区头
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ProjectBannerView * bannerView = [[ProjectBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 237)];
//    NSArray * arr = [NSArray array];
//    [bannerView relayoutWithModelArray:arr];
//    [bannerView setSelectedNum:20];
//    return bannerView;
//}
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
        //隐藏tabbar
        AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [delegate.tabBar tabBarHidden:YES animated:NO];
        
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        
        ProjectPrepareDetailVC *detail = [ProjectPrepareDetailVC new];
        model = _roadModelArray[indexPath.row];
        
        detail.projectId = model.projectId;
        //隐藏tabbar
        AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [delegate.tabBar tabBarHidden:YES animated:NO];
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
}
#pragma mark- ProjectBannerCellDelegate 代理方法
-(void)transportProjectBannerView:(ProjectBannerView *)view andTagValue:(NSInteger)tagValue
{
    _selectedCellNum  = tagValue;//将传过来的tag赋值给_selectedCellNum来决定显示cell的类型
    
    [self startLoadData];
    //tableView开始更新
//    [_tableView beginUpdates];
//    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    [_tableView endUpdates];
}

-(void)clickBannerImage:(ProjectBannerListModel *)model
{
    ProjectBannerDetailVC *vc = [ProjectBannerDetailVC new];
    vc.url = model.url;
    //隐藏tabbar
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
