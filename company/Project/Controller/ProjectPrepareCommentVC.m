//
//  ProjectPrepareCommentVC.m
//  company
//
//  Created by Eugene on 16/6/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPrepareCommentVC.h"
#import "ProjectPrepareCommentCell.h"
#import "ProjectSceneCommentModel.h"
#import "LQQMonitorKeyboard.h"

#define REQUESTCOMMENTDELETE @"requestProjectCommentDelete"
#define REQUESTCOMMENTLIST @"requestProjectCommentList"
#define REQUESTCOMMENT @"requestProjectComment"
@interface ProjectPrepareCommentVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, copy) NSString *commentpartner;

@property (nonatomic, strong) UITableViewCustomView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIView *footer;


@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, copy) NSString *deletePartner;
@property (nonatomic, strong) ProjectSceneCommentModel *deleteModel;
@property (nonatomic, copy) NSString *selfId; //自己id

@end

@implementation ProjectPrepareCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:REQUESTCOMMENTLIST];
    self.commentpartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTCOMMENT];
    
    self.deletePartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTCOMMENTDELETE];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    _selfId = [data objectForKey:USER_STATIC_USER_ID];
    
    _isFirst = YES;
    
    _page = 0;
    [self setNav];
    [self createUI];
    
    self.loadingViewFrame = self.view.frame;
    
    [self startLoadData];
    
}

-(void)setNav
{
    self.navigationItem.title = @"评论详情";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [leftback addTarget:self action:@selector(leftback) forControlEvents:UIControlEventTouchUpInside];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

-(void)leftback
{
    [self.httpUtil requestDealloc];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",[NSString stringWithFormat:@"%ld",(long)_page],@"page", @"1",@"platform",nil];
    
    if (_isFirst) {
        self.startLoading = YES;
    }
    
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_COMMENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestCommentList:)];
}

-(void)requestCommentList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (_page == 0) {
        [_dataArray removeAllObjects];
    }
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            self.startLoading = NO;
            
            if (_isFirst) {
                _isFirst= NO;
            }
            
            NSArray *modelArray = [ProjectSceneCommentModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            for (NSInteger i  = 0 ; i < modelArray.count ; i ++) {
                ProjectSceneCommentModel *model = modelArray[i];
                [_dataArray insertObject:model atIndex:0];
            }
            
            }
            if (_dataArray.count <= 0) {
                self.tableView.isNone = YES;
            }else{
                self.tableView.isNone = NO;
            }
        
        //刷新表
        [_tableView reloadData];
        
        if (_dataArray.count > 1) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            
            
        }else{
            self.startLoading = NO;
            
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        //结束刷新
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        self.isNetRequestError = YES;
    }
    //结束刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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

-(void)createUI
{
    _tableView = [[UITableViewCustomView alloc]init];
//    _tableView.bounces = NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = color(237, 238, 239, 1);
    [self.view addSubview:_tableView];
    
    //长安手势
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    longPressGr.minimumPressDuration = 1;
    
    longPressGr.numberOfTouchesRequired = 1;
    
    [_tableView addGestureRecognizer:longPressGr];
    
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    
    [self createFooterView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        //        make.height.mas_equalTo(SCREENHEIGHT -50-64);
        make.bottom.mas_equalTo(_footer).offset(0);
    }];
}

-(void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        
        //add your code here
        if (_dataArray[indexPath.row]) {
            ProjectSceneCommentModel *model = _dataArray[indexPath.row];
            NSInteger num1= [_selfId integerValue];
            NSInteger num2 = model.users.userId;
            if (num2 == num1) {//是自己的
                _deleteModel = (ProjectSceneCommentModel*)model;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
                __block ProjectPrepareCommentVC* blockSelf = self;
                
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
        }
        
        
    }
}

#pragma mark---删除评论---
-(void)btnCertain:(id)sender
{
    [_dataArray removeObject:_deleteModel];
    [self.tableView reloadData];
    
    if (_deleteModel.commentId) {
        //更新数据
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.deletePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_deleteModel.commentId],@"commentId", nil];
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:REQUEST_COMMENT_DELETE postParam:dic type:0 delegate:self sel:@selector(requestDeleteComment:)];
    }
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

-(void)createFooterView
{
    //加底部回复框
    _footer =[[UIView alloc]init];
    _footer.backgroundColor =[UIColor whiteColor];
//    _footer.frame = CGRectMake(0, self.view.frame.size.height - 64-50, SCREENWIDTH, 50);
    [self.view addSubview:_footer];
    
    [_footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [LQQMonitorKeyboard LQQAddMonitorWithShowBack:^(NSInteger height) {
        
//        _footer.frame = CGRectMake(0, self.view.frame.size.height - 50 - height, SCREENWIDTH, 50);
        //        NSLog(@"键盘出现了 == %ld",(long)height);
        [_footer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(SCREENHEIGHT-height - 114);
        }];
    } andDismissBlock:^(NSInteger height) {
        
//        _footer.frame = CGRectMake(0, self.view.frame.size.height - 50, SCREENWIDTH, 50);
        //        NSLog(@"键盘消失了 == %ld",(long)height);
        [_footer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
    }];
    

    _textField = [[UITextField alloc]init];
    _textField.layer.cornerRadius = 2;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.delegate = self;
    _textField.font = BGFont(15);
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeySend;
    [_footer addSubview:_textField];
    
    UIButton * btn =[[UIButton alloc]init];
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:colorBlue];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    _sendBtn = btn;
    [_footer addSubview:btn];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(btn.mas_left).offset(-5);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_top);
        make.right.mas_equalTo(_footer.mas_right).offset(-5);
        make.bottom.mas_equalTo(_textField.mas_bottom);
        make.width.mas_equalTo(70);
    }];
}

#pragma mark -发送信息
-(void)sendMessage:(UIButton*)btn
{
    [self.textField resignFirstResponder];
    if (self.textField.text && ![self.textField.text isEqualToString:@""]) {
        _sendBtn.enabled = NO;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.commentpartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",[NSString stringWithFormat:@"%@",self.textField.text],@"content", nil];
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_COMMENT postParam:dic type:0 delegate:self sel:@selector(requestComment:)];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"评论内容不能内空"];
        return;
    }
}
-(void)requestComment:(ASIHTTPRequest *)request
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
            _page = 0;
            [self startLoadData];
            //刷新前一页评论数据
            [_footerCommentView setProjectId:self.projectId];
//            [_scene.dataArray removeAllObjects];
//            [_scene startLoadComment];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
    _sendBtn.enabled = YES;
}

#pragma mark -刷新控件
-(void)nextPage
{
    _page = 0;
    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page ++;
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}


#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataArray[indexPath.row];
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ProjectPrepareCommentCell class] contentViewWidth:[self cellContentViewWith]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ProjectPrepareCommentCell";
    ProjectPrepareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ProjectPrepareCommentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage:nil];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
    }
//    NSLog(@"结束编辑");
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self cancleRequest];
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
