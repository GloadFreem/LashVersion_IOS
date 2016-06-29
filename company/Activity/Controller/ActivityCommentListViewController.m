//
//  ActivityViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityCommentListViewController.h"
#import "ActionComment.h"
#import "ActionLikerModel.h"
#import "ActivityCommentCell.h"
#import "ActivityPriseViewCell.h"
#import "ActivityDetailCommentCellModel.h"
#import "ActivityCommentListFooterView.h"
#import "ActivityDetailCommentCellModel.h"
#define kActivityDetailHeaderCellId @"ActivityDetailHeaderCell"
@interface ActivityCommentListViewController ()<UITableViewDelegate,UITableViewDataSource,ActivityDetailFooterViewDelegate,UITextFieldDelegate>
{
    NSInteger page;
    ActivityCommentListFooterView * footerView;
}

@property (nonatomic, strong) ActionLikerModel * likersModel;
@property (nonatomic, strong) UIButton *shareBtn;           //分享按钮
@property (nonatomic, strong) UIButton *signUpBtn;          //报名按钮
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, copy) NSString * actionPrisePartner;
@property (nonatomic, copy) NSString * actionCommentPartner;
@property (nonatomic, copy) NSString * actionCommentListPartner;
@property (nonatomic, strong) ActivityDetailCommentCellModel *commentCellModel;
@end

@implementation ActivityCommentListViewController
{
    CGFloat _totalKeybordHeight;
    Boolean isRefresh;
    Boolean isNoMoreData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setUpNavBar];
    //初始化 控件
    [self createUI];
    
    //生成请求partner
    self.actionCommentListPartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_COMMENT_LIST];
    
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"活动评论"];
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(32, 20);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

#pragma mark -初始化控件
-(void)createUI
{
    self.view.backgroundColor = WriteColor;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = YES;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01f)];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
//    [self.tableView.mj_footer setHidden:YES];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    // 回复框
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(0, SCREENHEIGHT - 50*HEIGHTCONFIG - 64, SCREENWIDTH, 50 * HEIGHTCONFIG)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_tableView.mas_bottom);
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
    field.returnKeyType = UIReturnKeyDone;
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
    [answerBtn addTarget:self action:@selector(actionComment) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:answerBtn];
    [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(field.mas_right).offset(5);
        make.height.mas_equalTo(field.mas_height);
        make.centerY.mas_equalTo(field.mas_centerY);
        make.right.mas_equalTo(view.mas_right).offset(-12);
    }];
}

-(void)refreshData
{
    page = 0;
    isRefresh = true;
    isNoMoreData = false;
    
    [self loadActionCommentData];
}

-(void)loadMoreData
{
    isRefresh = false;
    if (!isNoMoreData) {
        page++;
    }
    
    [self loadActionCommentData];
}
/**
 *  评论列表
 */

-(void)loadActionCommentData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionCommentListPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",STRING(@"%ld", page),@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestActionCommentList:)];
}

-(void)requestActionCommentList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            if (isRefresh) {
                NSArray *dataPriseArray = [NSArray arrayWithArray:[jsonDic[@"data"] valueForKey:@"prises"]];
                
                NSMutableArray *tempLikes = [NSMutableArray new];
                for (int i = 0; i < dataPriseArray.count; i++) {
                    ActivityDetailCellLikeItemModel *model = [ActivityDetailCellLikeItemModel new];
                    model.userName = dataPriseArray[i];
                    model.userId = @"1";
                    [tempLikes addObject:model];
                }
                self.commentCellModel.likeItemsArray = [tempLikes copy];
                if(!self.likersModel)
                {
                    self.likersModel = [[ActionLikerModel alloc]init];
                }
                self.likersModel.likers = [NSMutableArray arrayWithArray:tempLikes];
                
                
                NSArray *dataCommentArray = [NSArray arrayWithArray:[jsonDic[@"data"] valueForKey:@"comments"]];
                
                if(!self.commentCellModel)
                {
                    self.commentCellModel = [ActivityDetailCommentCellModel new];
                }
                
                ActionComment * baseModel;
                
                NSMutableArray * tempArray = [NSMutableArray new];
                for(NSDictionary * dic in dataCommentArray)
                {
                    //解析
                    baseModel =[ActionComment mj_objectWithKeyValues:dic];
                    
                    ActivityDetailCellCommentItemModel *commentItemModel = [ActivityDetailCellCommentItemModel new];
                    commentItemModel.firstUserName = baseModel.userName;
                    commentItemModel.firstUserId = STRING(@"%ld", (long)baseModel.usersByUserId.userId);
                    if([dic valueForKey:@"atUserName"])
                    {
                        commentItemModel.secondUserName = [dic valueForKey:@"atUserName"];
                        commentItemModel.secondUserId = @"";
                        
                    }
                    commentItemModel.commentString = baseModel.content;
                    
                    [tempArray addObject:commentItemModel];
                }
                
                if(self.commentCellModel.commentItemsArray && page!=0)
                {
                    NSMutableArray * array = [NSMutableArray arrayWithArray:self.commentCellModel.commentItemsArray];
                    [array addObjectsFromArray:tempArray];
                    self.commentCellModel.commentItemsArray  = array;
                }else{
                    self.commentCellModel.commentItemsArray  = [tempArray copy];
                }
                
            }else{
                NSArray *dataCommentArray = [NSArray arrayWithArray:[jsonDic[@"data"] valueForKey:@"comments"]];
                
                if(!self.commentCellModel)
                {
                    self.commentCellModel = [ActivityDetailCommentCellModel new];
                }
                
                ActionComment * baseModel;
                
                NSMutableArray * tempArray = [NSMutableArray new];
                for(NSDictionary * dic in dataCommentArray)
                {
                    //解析
                    baseModel =[ActionComment mj_objectWithKeyValues:dic];
                    
                    ActivityDetailCellCommentItemModel *commentItemModel = [ActivityDetailCellCommentItemModel new];
                    commentItemModel.firstUserName = baseModel.userName;
                    commentItemModel.firstUserId = STRING(@"%ld", (long)baseModel.usersByUserId.userId);
                    if([dic valueForKey:@"atUserName"])
                    {
                        commentItemModel.secondUserName = [dic valueForKey:@"atUserName"];
                        commentItemModel.secondUserId = @"";
                        
                    }
                    commentItemModel.commentString = baseModel.content;
                    
                    [tempArray addObject:commentItemModel];
                }
                
                NSMutableArray * array = [NSMutableArray arrayWithArray:self.commentCellModel.commentItemsArray];
                [array addObjectsFromArray:tempArray];
                self.commentCellModel.commentItemsArray  = array;
            }
            
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
        }else if ([status integerValue]==201)
        {
            isNoMoreData = YES;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}


#pragma mark -tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if(self.likersModel)
    {
        count = 1;
    }
    
    return self.commentCellModel.commentItemsArray.count+count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(self.likersModel)
    {
        if(row==0)
        {
            CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.likersModel keyPath:@"model" cellClass:[ActivityPriseViewCell class] contentViewWidth:[self cellContentViewWith]];
            return h;
        }
    }
    
    NSInteger index = row;
    if(row!=0)
    {
        index --;
    }
    
    CGFloat h = 0;
    if (row-1<self.commentCellModel.commentItemsArray.count) {
        h = [self.tableView cellHeightForIndexPath:indexPath model:[self.commentCellModel.commentItemsArray objectAtIndex:index] keyPath:@"model" cellClass:[ActivityCommentCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    return h;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(self.likersModel)
    {
        if(row==0)
        {
            static NSString *cellId = @"ActivityPriseViewCell";
            ActivityPriseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[ActivityPriseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            if(self.likersModel)
            {
                [cell setModel:self.likersModel];
            }
            return cell;
        }
    }
    
    static NSString *cellId = @"ActivityCommentViewCell";
    ActivityCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ActivityCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (row-1<self.commentCellModel.commentItemsArray.count) {
        [cell setModel:[self.commentCellModel.commentItemsArray objectAtIndex:row-1]];
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [cell setDidClickCommentLabelBlock:^(NSString* userId,NSString * name, CGRect rectInWindow) {
        weakSelf.textField.placeholder =[NSString stringWithFormat:@"  回复：%@",name];
        [weakSelf.textField becomeFirstResponder];
        weakSelf.isReplayingComment = YES;
        weakSelf.commentToUser = userId;
    }];
    return cell;
    
}



-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(!footerView)
    {
        footerView  = [[ActivityCommentListFooterView alloc]init];
        footerView.delegate = self;
    }
    
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{   
    return footerView.height;
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


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -btnAction
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO]
    ;
    
    //设置导航样式
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES]
    ;
//    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
//    [delegate.tabBar tabBarHidden:NO animated:NO];
//    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark -textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
    }
    [self actionComment];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"开始编辑");
    _textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
    }
    NSLog(@"结束编辑");
}

#pragma footerDelegate
-(void)didClickLikeButton
{
    
    if(!self.actionPrisePartner)
    {
        self.actionPrisePartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_PRISE];
    }
    
    //开始请求
    [self actionPrise];
}

-(void)didClickCommentButton
{
    [self.textField becomeFirstResponder];
    //设置初始化状态
    _textField.placeholder = @"";
    //恢复为评论状态
    self.commentToUser = @"0";
}

-(void)didClickShowAllButton
{
    ActivityCommentListViewController * controller  = [[ActivityCommentListViewController alloc]init];
    controller.activityModel = self.activityModel;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  活动点赞
 */
-(void)actionPrise
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionPrisePartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",STRING(@"%ld", self.headerModel.flag),@"flag", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_PRISE postParam:dic type:0 delegate:self sel:@selector(requestPriseAction:)];
}

-(void)requestPriseAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * dic = [jsonDic valueForKey:@"data"];
            self.headerModel.flag = [[dic valueForKey:@"flag"] integerValue];
            
            ActivityDetailCellLikeItemModel * model = [[ActivityDetailCellLikeItemModel alloc]init];
            
            //获取自身userId
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString * userId = [[data valueForKey:USER_STATIC_USER_ID] stringValue];
            
            //设置属性
            model.userId = userId;
            model.userName = [dic valueForKey:@"name"];
            
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.commentCellModel.likeItemsArray];
            if(self.headerModel.flag!=1)
            {
                if(array && array.count>0)
                {
                    for (int i =0 ;i< self.likersModel.likers.count;i++) {
                        ActivityDetailCellLikeItemModel * m = [self.likersModel.likers objectAtIndex:i];
                        if ([m.userName isEqualToString:model.userName]) {
                            [self.likersModel.likers removeObject:m];
                        }
                    }
                }
                
            }else{
                [self.likersModel.likers insertObject:model atIndex:0];
            }
            
            
            [self.tableView reloadData];
        }
    }
}

/**
 *  活动评论
 */
-(void)actionComment
{
    NSString * content = self.textField.text;
    if([content isEqualToString:@""] ||[content isEqualToString:@"请输入评论内容"])
    {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入评论内容"];
        return;
    }
    
    if(!self.actionCommentPartner)
    {
        self.actionCommentPartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_COMMENT];
    }
    
    int flag = 1;
    if(self.commentToUser && ![self.commentToUser isEqualToString:@""])
    {
        flag = 2;
    }
    
    if(!_commentToUser)
    {
        _commentToUser = @"0";
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionCommentPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",STRING(@"%d", flag),@"flag",content,@"content",self.commentToUser,@"atUserId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT postParam:dic type:0 delegate:self sel:@selector(requestCommentAction:)];
}

-(void)requestCommentAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * dic = [jsonDic valueForKey:@"data"];
            
            ActionComment * baseModel;
            
            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.commentCellModel.commentItemsArray];
            //解析
            baseModel =[ActionComment mj_objectWithKeyValues:dic];
            
            ActivityDetailCellCommentItemModel *commentItemModel = [ActivityDetailCellCommentItemModel new];
            commentItemModel.firstUserName = [[dic valueForKey:@"usersByUserId"] valueForKey:@"name"];
            commentItemModel.firstUserId = [[dic valueForKey:@"usersByUserId"] valueForKey:@"userId"];
            
            
            if([dic valueForKey:@"usersByAtUserId"])
            {
                commentItemModel.secondUserName = [[dic valueForKey:@"usersByAtUserId"] valueForKey:@"name"];
                commentItemModel.secondUserId = [[dic valueForKey:@"usersByAtUserId"] valueForKey:@"userId"];
                
            }
            commentItemModel.commentString = baseModel.content;
            
            [tempArray insertObject:commentItemModel atIndex:0];
            
            self.commentCellModel.commentItemsArray  = [tempArray copy];
            
            //刷新视图
            [self.tableView reloadData];
            
            //注销键盘
            [self.textField resignFirstResponder];
            [self.textField setText:@""];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

@end
