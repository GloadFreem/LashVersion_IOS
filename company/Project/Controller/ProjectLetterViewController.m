//
//  ProjectLetterViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectLetterViewController.h"
#import "ProjectLetterCell.h"
#import "ProjectLetterModel.h"

#import "PingTaiWebViewController.h"
#import "LetterDetailViewController.h"

#import "LetterBaseModel.h"
#define READMESSAGE @"requestHasReadMessage"
#define DELETEMESSAGE @"requestDeleteInnerMessage"
#define INNERMESSAGE @"requestInnerMessageList"
@interface ProjectLetterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableViewCustomView *tableView; //列表
@property (nonatomic, strong) NSMutableArray *dataArray;    //数据

@property (nonatomic, strong) NSMutableArray *deleteArray;

@property (nonatomic, strong) UIView *bottomView;   //底部视图
@property (nonatomic, strong) UIButton *allSelectedBtn;    //全选按钮
@property (nonatomic, strong) UIButton *deleteBtn;      //删除按钮
@property (nonatomic, strong) UIButton *operateBtn;    // 编辑按钮

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *messagePartner;
@property (nonatomic, copy) NSString *deletePartner;
@property (nonatomic, copy) NSString *readPartner;

@property (nonatomic,strong) LetterBaseModel *readModel;

@end

@implementation ProjectLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //获得partner
    self.messagePartner = [TDUtil encryKeyWithMD5:KEY action:INNERMESSAGE];
    self.deletePartner = [TDUtil encryKeyWithMD5:KEY action:DELETEMESSAGE];
    self.readPartner = [TDUtil encryKeyWithMD5:KEY action:READMESSAGE];
    
    _page = 0;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self startLoadData];
    
    [self createTableView];
    
    [self setupNav];
    
    [self setupBottomView];
}

-(void)startLoadData
{
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.messagePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    self.startLoading = YES;
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_INNER_MESSAGE postParam:dic type:0 delegate:self sel:@selector(requestMessageList:)];
}
-(void)requestMessageList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            self.startLoading = NO;
            
            if (_page == 0) {
                [_dataArray removeAllObjects];
                [_deleteArray removeAllObjects];
            }
            NSMutableArray *tempArray = [NSMutableArray new];
            NSArray *modelArray = [LetterBaseModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            for (NSInteger i = 0; i < modelArray.count; i ++) {
                LetterBaseModel *baseModel = modelArray[i];
                [tempArray addObject:baseModel];
            }
            self.dataArray = tempArray;
        
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            //结束刷新
            self.startLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
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
    [self startLoadData];
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count <= 0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
    }
    [self.tableView reloadData];
}
#pragma mark -创建tableView
-(void)createTableView
{
    _tableView = [[UITableViewCustomView alloc]init];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate =self;
    _tableView.dataSource =self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
   
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom).offset(0);
//        make.height.mas_equalTo(SCREENHEIGHT-64);
    }];
    self.loadingViewFrame = self.tableView.frame;
}

-(void)nextPage
{
    _page ++;
    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page = 0;
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}


#pragma mark -导航栏设置
-(void)setupNav
{
    //返回按钮
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    //编辑按钮
    UIButton * operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operateBtn.tag = 1;
    [operateBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [operateBtn.titleLabel setFont:BGFont(17)];
    [operateBtn setTitle:@"完成" forState:UIControlStateSelected];
    [operateBtn setBackgroundColor:[UIColor clearColor]];
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    operateBtn.size = CGSizeMake(36, 18);
    [operateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:operateBtn];
    _operateBtn = operateBtn;
//    标题视图
    UIView *titleView = [UIView new];
//    [titleView setBackgroundColor:[UIColor greenColor]];
    titleView.frame = CGRectMake(0, 0, 80, 25);
    
    UILabel *label = [UILabel new];
    label.text = @"站内信";
    label.font = BGFont(20);
    
//    label.backgroundColor = [UIColor orangeColor];
    label.textColor  = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleView);
        make.centerY.mas_equalTo(titleView);
    }];
    
    self.navigationItem.titleView = titleView;
}
#pragma mark -底部视图设置
-(void)setupBottomView
{
    //初始化底部视图
    _bottomView = [UIView new];
    _bottomView.hidden = YES;
    [_bottomView setBackgroundColor:color(61, 69, 78, 1)];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
    //初始化全选按钮
    _allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allSelectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [_allSelectedBtn setImage:[UIImage imageNamed:@"LetterUnselected"] forState:UIControlStateNormal];
    [_allSelectedBtn setTitle:@"全选" forState:UIControlStateNormal];
    _allSelectedBtn.titleLabel.textColor = [UIColor whiteColor];
    _allSelectedBtn.titleLabel.font = BGFont(17);
    
    [_allSelectedBtn setTag:5];
    [_allSelectedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_allSelectedBtn setImage:[UIImage imageNamed:@"LetterSelected"] forState:UIControlStateSelected];
    [_bottomView addSubview:_allSelectedBtn];
    [_allSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView);
        make.left.mas_equalTo(_bottomView.mas_left);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(35);
    }];

    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTag:6];
    [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_deleteBtn.titleLabel setFont:BGFont(17)];
    [_bottomView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomView.mas_right).offset(-(23*WIDTHCONFIG));
        make.centerY.mas_equalTo(_bottomView);
        make.height.mas_equalTo(17*HEIGHTCONFIG);
    }];
    
    
}

#pragma mark -tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        static NSString *cellId = @"ProjectLetterCell";
        ProjectLetterCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
        //如果编辑按钮未点击
        if (!_operateBtn.selected) {
            cell.selectImage.hidden = YES;
            //        [cell relayoutCellWithModel:_dataArray[indexPath.row]];
            //        return cell;
        }else{   // 出于编辑状态下
            cell.selectImage.hidden = NO;
            cell.titleLeftSpace.constant =41;
            
        }
        [cell relayoutCellWithModel:_dataArray[indexPath.row]];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_operateBtn.selected) {
        LetterBaseModel *model = _dataArray[indexPath.row];
        model.isRead = YES;
        _readModel = model;
        //刷新当前行
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        //标记已读请求数据
        [self readMessage];
        //根据type值显示不同的界面类型 messageTypeId
        if (model.messagetype.messageTypeId == 1) {//进入webView
            PingTaiWebViewController *web =[PingTaiWebViewController new];
            web.url = model.url;
            web.titleStr = @"详情";
            [self.navigationController pushViewController:web animated:YES];
        }else{//进入自定义界面
            LetterDetailViewController *detail = [LetterDetailViewController new];
            detail.model = model;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }else{   //在编辑状态下
        LetterBaseModel *model = _dataArray[indexPath.row];
        model.selectedStatus = !model.selectedStatus;  //改变model的选中状态
        [_deleteArray addObject:model];          //将选中的model加入删除数组
        //刷新表格
        [_tableView beginUpdates];
        //刷新当前行
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1) {
        btn.selected = !btn.selected;
        _bottomView.hidden = !_bottomView.hidden;
        
        //判断tableView的长度
        if (!_bottomView.hidden) {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(SCREENHEIGHT-48-64);
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(-48);
            }];
        }else{
            _tableView.height = SCREENHEIGHT-64;
        }
        //刷新tableView
        [_tableView reloadData];
    }
    if (btn.tag == 5) {
        _allSelectedBtn.selected = !_allSelectedBtn.selected;
        //清空删除数组内容
        [_deleteArray removeAllObjects];
        //改变model的选中状态
        for (NSInteger i=0; i<_dataArray.count; i++) {
            LetterBaseModel *model =_dataArray[i];
            model.selectedStatus = btn.selected;
            //将model加入删除数组
            if (model.selectedStatus) {
                [_deleteArray addObject:model];
            }
            //刷新表格
            [_tableView reloadData];
        }
    }
    //删除按钮 点击事件
    if (btn.tag == 6) {
        
        [self deleteMessage];
        //将删除数组从原数组移除
        for (NSInteger i=0; i < _deleteArray.count; i++) {
            [_dataArray removeObject:_deleteArray[i]];
        }
        //将全选按钮职位常态
        if (_allSelectedBtn.selected) {
            _allSelectedBtn.selected = NO;
        }
        //刷新表格
        [_tableView reloadData];
    }
}
#pragma mark----已读
-(void)readMessage
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.readPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_readModel.messageId],@"messageId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_HAS_READ_MESSAGE postParam:dic type:0 delegate:self sel:@selector(requestReadMessage:)];
}
-(void)requestReadMessage:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSLog(@"标记已读");
        }else{
        
        }
    }
}
#pragma mark----删除信息
-(void)deleteMessage
{
    NSMutableString *mesStr = [[NSMutableString alloc]init];
    for (NSInteger i =0; i < _deleteArray.count; i ++) {
        LetterBaseModel *model = _deleteArray[i];
        if (i == _deleteArray.count - 1) {
        [mesStr appendFormat:@"%ld",(long)model.messageId];
        }else{
        [mesStr appendFormat:@"%ld,",(long)model.messageId];
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.deletePartner,@"partner",mesStr,@"messageId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_DELETE_INNER_MESSAGE postParam:dic type:0 delegate:self sel:@selector(requestDeleteMessage:)];
}
-(void)requestDeleteMessage:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //            NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }else{
        
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _dataArray = nil;
    _deleteArray = nil;
    
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
