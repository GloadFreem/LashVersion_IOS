//
//  CircleDetailVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "CircleDetailVC.h"
#import "CircleListCell.h"
#import "CircleDetailCommentCell.h"
#import "CircleDetailCommentModel.h"
#import "CircleListModel.h"
#import "CircleBaseModel.h"
#import "CircleDetailHeaderCell.h"
#import "RenzhengViewController.h"

#define CIRCLE_PRAISE @"requestPriseFeeling"
#define CIRCLEDETAIL @"requestFeelingDetail"
#define CIRCLECOMMENT @"requestCommentFeeling"
#define DELETECOMMENT @"requestContentCommentDelete"
@interface CircleDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CircleDetailHeaderCellDelegate>

{
    CircleListModel *_listModel;
}
@property (nonatomic, copy) NSString *praisePartner;

@property (nonatomic, copy) NSString *commentPartner;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *userId;  //回复人ID
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, strong) NSMutableArray *atUserIdArray; //回复人id数组
@property (nonatomic, assign) BOOL isReplay;  //是否回复

@property (nonatomic, copy) NSString *praiseFlag; //是否点赞标识

@property (nonatomic, assign) BOOL praiseSuccess;  //点赞成功

@property (nonatomic, copy) NSString *beCommentName; //被回复人名字
@property (nonatomic, strong) NSMutableArray *beCommentNameArray;
@property (nonatomic, copy) NSString *selfId; //自己id

@property (nonatomic, assign) NSInteger nameIndex;
@property (nonatomic, assign) NSInteger index;//删除回复人ID
@property (nonatomic, strong) CircleDetailCommentModel *deleteModel; //删除的模型
@property (nonatomic, copy) NSString *deletePartner;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@end

@implementation CircleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    // Do any additional setup after loading the view.
    //获得详情partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:CIRCLEDETAIL];
    //获得状态partner
    self.commentPartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLECOMMENT];
    //获得点赞partner
    self.praisePartner = [TDUtil encryKeyWithMD5:KEY action:CIRCLE_PRAISE];
    self.deletePartner = [TDUtil encryKeyWithMD5:KEY action:DELETECOMMENT];
    
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_atUserIdArray) {
        _atUserIdArray = [NSMutableArray array];
    }
    if (!_beCommentNameArray) {
        _beCommentNameArray = [NSMutableArray array];
    }
    //初始化为0详情页面
    _page = 0;
    _flag = @"1";
    _userId = @"";
    _beCommentName = @"";
    
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _selfId = [data objectForKey:USER_STATIC_USER_ID];
    
    //请求数据
    [self loadData];
    
    //设置导航栏
    [self setupNav];
    
    [self createTableView];
    
}
-(void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.publicContentId],@"feelingId",[NSString stringWithFormat:@"%ld",(long)_page],@"page",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CIRCLE_FEELING_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestCircleDetail:)];
}

#pragma mark -网络请求
-(void)requestCircleDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (_page == 0) {
        [_dataArray removeAllObjects];
        [_atUserIdArray removeAllObjects];
        [_beCommentNameArray removeAllObjects];
    }
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 200) {
            [SVProgressHUD dismiss];
            //解析数据  将data字典转换为BaseModel
//            NSLog(@"data字典---%@",jsonDic[@"data"]);
            
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            //实例化数据模型
            CircleListModel *listModel = [CircleListModel new];
            //基本模型转换
            CircleBaseModel *baseModel = [CircleBaseModel mj_objectWithKeyValues:dataDic];
            //一级模型赋值
            listModel.msgContent  = baseModel.content;  //微博内容
            
            
            listModel.nameStr = baseModel.users.name;
            //回复atUserId
            [_atUserIdArray addObject:@""];
            
            //回复人名字数组
            [_beCommentNameArray addObject:@""];
            
            listModel.iconNameStr = baseModel.users.headSculpture;
            listModel.publicContentId = baseModel.publicContentId; //帖子ID
            listModel.timeSTr = baseModel.publicDate;              //发布时间
            listModel.flag = baseModel.flag;    //是否点赞
            
            //拿到usrs认证数组
            NSArray *authenticsArray = [NSArray arrayWithArray:baseModel.users.authentics];
            if (authenticsArray.count) {
                //实例化认证人模型
                CircleUsersAuthenticsModel *usersAuthenticsModel =authenticsArray[0];
                listModel.addressStr = usersAuthenticsModel.companyAddress;
                listModel.companyStr = usersAuthenticsModel.companyName;
                listModel.positionStr = usersAuthenticsModel.position;
            }
            
            //微博照片
            NSMutableArray *picArray = [NSMutableArray array];
            for (NSInteger i = 0; i < baseModel.contentimageses.count; i ++) {
                CircleContentimagesesModel *imageModel = baseModel.contentimageses[i];
                [picArray addObject:imageModel.url];
            }
            listModel.picNamesArray = [NSArray arrayWithArray:picArray];
            //点赞人名
            NSMutableArray *priseArray = [NSMutableArray array];
            for (NSInteger i =0; i < baseModel.contentprises.count; i ++) {
                CircleContentprisesContentModel *contentModel = baseModel.contentprises[i];
                
                if (contentModel.users.name.length) {
                    [priseArray addObject:contentModel.users.name];
                }
            }
            //将人名转换成字符串
            NSMutableString *nsmStr = [[NSMutableString alloc]init];
            
      
            if (priseArray.count) {
                for (NSInteger i =0; i < priseArray.count; i ++) {
                    if (i != priseArray.count -1) {
                        [nsmStr appendFormat:@"%@，",priseArray[i]];
                    }else{
                        [nsmStr appendFormat:@"%@",priseArray[i]];
                    }
                }
            }
           
            listModel.priseLabel = [nsmStr copy];
            _listModel = listModel;
            
//            NSLog(@"打印listModel-----------%@",_listModel);
            //将模型加入数据数组
            [_dataArray addObject:_listModel];
            //评论模型数据
            //实例化评论cell模型
            
            for (NSInteger i =0; i < baseModel.comments.count; i ++) {
                CircleDetailCommentModel *detailCommentModel = [CircleDetailCommentModel new];
                CircleCommentsModel *commentModel = baseModel.comments[i];
                detailCommentModel.iconImageStr = commentModel.usersByUserId.headSculpture;
                detailCommentModel.nameStr = commentModel.usersByUserId.name;
                detailCommentModel.publicDate = commentModel.publicDate;
                detailCommentModel.commentId = commentModel.commentId;
                //回复人ID
                [_atUserIdArray addObject:commentModel.usersByUserId.userId];
                
                //回复人名字数组
                [_beCommentNameArray addObject:[NSString stringWithFormat:@" 回复：%@",commentModel.usersByUserId.name]];
                
                //如果有回复
                if (commentModel.usersByAtUserId.name) {
                    detailCommentModel.nameStr = [NSString stringWithFormat:@"%@ 回复：%@",commentModel.usersByUserId.name,commentModel.usersByAtUserId.name];
                }else{
                    detailCommentModel.nameStr = commentModel.usersByUserId.name;
                }
                detailCommentModel.contentStr = commentModel.content;
                //将模型加到数据数组中
                [_dataArray addObject:detailCommentModel];
            }
            
//            NSLog(@"dataArray的个数：---%ld",_dataArray.count);
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }else{
            
            [SVProgressHUD dismiss];
            [self.tableView.mj_footer endRefreshing];

            [self.tableView.mj_header endRefreshing];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }
    }
}

#pragma mark -loadMoreData 
-(void)loadMoreData
{
//    [self.tableView.mj_header beginRefreshing];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.publicContentId],@"feelingId",[NSString stringWithFormat:@"%ld",(long)_page],@"page",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CIRCLE_FEELING_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestCircleDetailMore:)];
}
#pragma mark -网络请求
-(void)requestCircleDetailMore:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
      NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            [SVProgressHUD dismiss];
            //解析数据
            //将字典数组转化为模型数组  拿到CircleCommentsModel模型数组
            NSArray *modelArray = [CircleCommentsModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
//            NSLog(@"打印数据----%@",jsonDic[@"data"]);
            
//            NSLog(@"model数组的个数%lu",(unsigned long)modelArray.count);
            for (NSInteger i = 0; i < modelArray.count; i ++) {
                CircleDetailCommentModel *detailCommentModel = [CircleDetailCommentModel new];
                CircleCommentsModel *commentModel = modelArray[i];
//                NSLog(@"commentModel----%@",commentModel);
//                NSLog(@"发布事件---%@",commentModel.publicDate);
//                NSLog(@"dayinusermoxing ---%@",commentModel.usersByUserId);
                detailCommentModel.iconImageStr = commentModel.usersByUserId.headSculpture;
                detailCommentModel.nameStr = commentModel.usersByUserId.name;
                detailCommentModel.publicDate = commentModel.publicDate;
                detailCommentModel.commentId = commentModel.commentId;
                //回复人ID
                [_atUserIdArray addObject:commentModel.usersByUserId.userId];
                //如果有回复
                if (commentModel.usersByAtUserId) {
                    detailCommentModel.nameStr = [NSString stringWithFormat:@"%@回复%@：",commentModel.usersByUserId.name,commentModel.usersByAtUserId.name];
                }else{
                    detailCommentModel.nameStr = commentModel.usersByUserId.name;
                }
                detailCommentModel.contentStr = commentModel.content;
                //将模型加到数据数组中
                [_dataArray addObject:detailCommentModel];
            }
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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
    
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    
    //更新列表点赞状态
    if (_viewController && _indexPath) {
        
        CircleListModel * model = [_viewController.dataArray objectAtIndex:_indexPath.row];
        
        model.flag = _listModel.flag;
        model.priseCount = _listModel.priseCount;
//        model.commentCount = _listModel.commentCount;
        [_viewController.dataArray replaceObjectAtIndex:_indexPath.row withObject:model];
        
        [_viewController.tableView reloadData];
    }
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.tag = 0;
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    
    
    self.navigationItem.title = @"详情";
}

-(void)createTableView
{
    _tableView  = [UITableView new];
    _tableView.backgroundColor = colorGray;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
   
    
    // 回复框
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
//        make.top.equalTo(_tableView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = colorGray;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
    //输入框
    UITextField *field = [UITextField new];
    field.placeholder = @"请输入评论内容";
    field.layer.cornerRadius = 3;
    field.layer.borderColor = colorGray.CGColor;
    field.layer.borderWidth = .5f;
    field.delegate = self;
    [field setValue:color74 forKeyPath:@"_placeholderLabel.textColor"];
    field.textAlignment = NSTextAlignmentLeft;
    field.textColor = [UIColor blackColor];
    field.font = BGFont(14);
    field.returnKeyType = UIReturnKeySend;
    _textField = field;
    CGRect frame = [field frame];
    frame.size.width = 15.0f;
    UIView *leftView = [[UIView alloc]initWithFrame:frame];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(12);
        make.right.mas_equalTo(view.mas_right).offset(-76);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.height.mas_equalTo(36);
    }];
    
    UIButton *answerBtn = [UIButton new];
    [answerBtn setTitle:@"发表" forState:UIControlStateNormal];
    [answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn setBackgroundColor:colorBlue];
    answerBtn.layer.cornerRadius = 3;
    answerBtn.layer.masksToBounds = YES;
    answerBtn.titleLabel.font = BGFont(16);
    [answerBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:answerBtn];
    [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(field.mas_right).offset(5);
        make.height.mas_equalTo(field.mas_height);
        make.centerY.mas_equalTo(field.mas_centerY);
        make.right.mas_equalTo(view.mas_right).offset(-12);
    }];
}

-(void)nextPage
{
    _page ++;
    if (_page < 2) {
        [self loadMoreData];
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
//        NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page = 0;
    
    [self loadData];
    [self.tableView.mj_header beginRefreshing];
    //    NSLog(@"下拉刷新");
}

#pragma mark -导航栏按钮点击事件
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [SVProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -tableViewDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        CircleListModel *listModel = (CircleListModel*)model;
        if (listModel.shouldShowMoreBtn ) {
            if (self.dataArray.count > 1) {
                return [_tableView cellHeightForIndexPath:indexPath model:listModel keyPath:@"model" cellClass:[CircleListCell class] contentViewWidth:[self cellContentViewWith]]+50;
            }else{
            return [_tableView cellHeightForIndexPath:indexPath model:listModel keyPath:@"model" cellClass:[CircleListCell class] contentViewWidth:[self cellContentViewWith]]+26;
            }
        }else{
        return [_tableView cellHeightForIndexPath:indexPath model:listModel keyPath:@"model" cellClass:[CircleListCell class] contentViewWidth:[self cellContentViewWith]]+10;
        }
    }
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleDetailCommentCell class] contentViewWidth:[self cellContentViewWith]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellId = @"CircleDetailHeaderCell";
        CircleDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CircleDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        
        cell.indexPath = indexPath;
//        __weak typeof (self) weakSelf = self;
//        if (!cell.moreButtonClickedBlock) {
//            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
//                CircleListModel *model =weakSelf.dataArray[indexPath.row];
//                model.isOpening  = !model.isOpening;
//                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            }];
//            
//        }
        cell.delegate = self;
        
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
        
    }
    static NSString *cellId = @"CircleDetailCommentCell";
    CircleDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CircleDetailCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (indexPath.row == _dataArray.count-1) {
        cell.bottomLine.hidden = YES;
        cell.bottomView.hidden = NO;
    }else{
        cell.bottomView.hidden = YES;
        cell.bottomLine.hidden = NO;
    }
    
    cell.model = _dataArray[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _flag = @"2";
    
    if (_atUserIdArray[indexPath.row]) {
        _userId = [NSString stringWithFormat:@"%@",_atUserIdArray[indexPath.row]];
        _index = [_atUserIdArray indexOfObject:_userId];
    }
    
    if (_beCommentNameArray[indexPath.row]) {
        _beCommentName = [NSString stringWithFormat:@"%@",_beCommentNameArray[indexPath.row]];
        _nameIndex = [_beCommentNameArray indexOfObject:_beCommentName];
    }
    
    
    if ([_selfId isEqualToString:_userId]) {
        
        
        if ([_authenticName isEqualToString:@"认证中"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的信息正在认证中，认证通过即可享受此项服务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        
        if ([_authenticName isEqualToString:@"未认证"])
        {
            [self presentAlertView];
        }
        if ([_authenticName isEqualToString:@"已认证"])
        {
            _deleteModel = _dataArray[indexPath.row];
            
            //        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"不能回复自己"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
            __block CircleDetailVC* blockSelf = self;
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [blockSelf btnCertain:nil];
            }];
            
            [alertController addAction:cancleAction];
            [alertController addAction:okAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
    }else{
    
    [_textField becomeFirstResponder];
    }
//    NSLog(@"回复人数组----%@",_atUserIdArray);
    
}
#pragma mark---删除评论---
-(void)btnCertain:(id)sender
{
        [_atUserIdArray removeObjectAtIndex:_index];
        [_beCommentNameArray removeObjectAtIndex:_nameIndex];
        [_dataArray removeObject:_deleteModel];
        [self.tableView reloadData];
        
        //    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"删除成功"];
        
        if (_deleteModel.commentId) {
            //更新数据
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.deletePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_deleteModel.commentId],@"commentId", nil];
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:CIRCLE_COMMENT_DELETE postParam:dic type:0 delegate:self sel:@selector(requestDeleteComment:)];
        }
}

-(void)presentAlertView
{
    //没有认证 提醒去认证
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有实名认证，请先实名认证" preferredStyle:UIAlertControllerStyleAlert];
    __block CircleDetailVC* blockSelf = self;
    
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
    RenzhengViewController  * renzheng = [RenzhengViewController new];
    renzheng.identifyType = self.identiyTypeId;
    [self.navigationController pushViewController:renzheng animated:YES];
    
}

-(void)requestDeleteComment:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status =[jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
        }
    }
}


//评论帖子
-(void)sendComment:(UIButton*)btn
{
    [_textField resignFirstResponder];
    
     if ([_authenticName isEqualToString:@"已认证"])
     {
         if ([_textField.text isEqualToString:@""]) {
             [_textField resignFirstResponder];
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"回复内容不能为空"];
             return;
         }
         
         NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
         NSString *icon = [data objectForKey:USER_STATIC_HEADER_PIC];
         NSString *name = [data objectForKey:USER_STATIC_NAME];
         
         //添加 本地数据
         CircleDetailCommentModel *detailCommentModel = [CircleDetailCommentModel new];
         detailCommentModel.iconImageStr = icon;
         detailCommentModel.nameStr = [NSString stringWithFormat:@"%@%@",name,_beCommentName];
         detailCommentModel.contentStr = [NSString stringWithFormat:@"%@",self.textField.text];
         detailCommentModel.publicDate = [TDUtil CurrentDate];
         [_atUserIdArray insertObject:_selfId atIndex:_index];
         [_beCommentNameArray insertObject:name atIndex:_nameIndex];
         [_dataArray insertObject:detailCommentModel atIndex:1];
         
         [self.tableView reloadData];
         
         
         NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.commentPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.publicContentId],@"contentId",[NSString stringWithFormat:@"%@",self.textField.text],@"content",[NSString stringWithFormat:@"%@",_userId],@"atUserId",_flag,@"flag",nil];
         
         
         //开始请求
         [self.httpUtil getDataFromAPIWithOps:CIRCLE_COMMENT_FEELING postParam:dic type:0 delegate:self sel:@selector(requestCircleComment:)];
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

-(void)requestCircleComment:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!= nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            _textField.text = @"";
            [_textField resignFirstResponder];
            //发表成功 刷新tableView
//            [self loadData];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }
    
}
#pragma mark -cell_delegate  点赞按钮事件处理
-(void)didClickPraiseBtn:(CircleDetailHeaderCell *)cell model:(CircleListModel *)model
{
    model.flag = !model.flag;
    if (model.flag) {
        _praiseFlag = @"1";
        
        
    }else{
        _praiseFlag = @"2";
        
    }
    
    //请求更新数据数据
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.praisePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)model.publicContentId],@"contentId",_praiseFlag,@"flag", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CELL_PRAISE postParam:dic type:1 delegate:self sel:@selector(requestPraiseStatus:)];
    
    NSUserDefaults * data = [NSUserDefaults standardUserDefaults];
    NSString *  name =[data valueForKey:USER_STATIC_NAME];
    if (_praiseSuccess) {
        if (model.flag) {
            
           
            if(model.priseLabel.length>0)
            {
                model.priseLabel = [STRING(@"%@，", name) stringByAppendingString:model.priseLabel];
            }else{
                model.priseLabel = [name stringByAppendingString:model.priseLabel];
            }
            
            [cell.praiseBtn setImage:[UIImage imageNamed:@"iconfont-dianzan"] forState:UIControlStateNormal];
            model.priseCount ++;
            [cell.praiseBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.priseCount] forState:UIControlStateNormal];
            
            
            NSInteger index = [_viewController.dataArray indexOfObject:_circleModel];
            _circleModel.flag = model.flag;
            _circleModel.priseCount = model.priseCount;
            [_viewController.dataArray replaceObjectAtIndex:index withObject:_circleModel];
            [_viewController.tableView reloadData];
            
        }else{
            [cell.praiseBtn setImage:[UIImage imageNamed:@"icon_dianzan"] forState:UIControlStateNormal];
            if (model.priseCount>0) {
                model.priseCount --;
            }
            
            [cell.praiseBtn setTitle:[NSString stringWithFormat:@" %ld",(long)model.priseCount] forState:UIControlStateNormal];
            if(model.priseLabel.length>name.length)
            {
                model.priseLabel = [model.priseLabel stringByReplacingOccurrencesOfString:STRING(@"%@，", name) withString:@""];
            }else{
                model.priseLabel = [model.priseLabel stringByReplacingOccurrencesOfString:name withString:@""];
            }
            //处理上一页数据
            NSInteger index = [_viewController.dataArray indexOfObject:_circleModel];
            _circleModel.flag = model.flag;
            _circleModel.priseCount = model.priseCount;
            [_viewController.dataArray replaceObjectAtIndex:index withObject:_circleModel];
            [_viewController.tableView reloadData];
        }
        
        //处理上一页数据
        
        cell.model = model;
        
        _listModel = model;
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
            
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self sendComment:nil];
    
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

@end
