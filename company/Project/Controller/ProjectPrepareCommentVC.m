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

#define REQUESTCOMMENTLIST @"requestProjectCommentList"
#define REQUESTCOMMENT @"requestProjectComment"
@interface ProjectPrepareCommentVC ()<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>
@property (nonatomic, copy) NSString *commentpartner;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation ProjectPrepareCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:REQUESTCOMMENTLIST];
    self.commentpartner = [TDUtil encryKeyWithMD5:KEY action:REQUESTCOMMENT];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    _page = 0;
    [self createUI];
    [self startLoadData];
    [self setNav];
    
}

-(void)setNav
{
    self.navigationItem.title = @"评论详情";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    [leftback addTarget:self action:@selector(leftback) forControlEvents:UIControlEventTouchUpInside];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

-(void)leftback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
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
            
            NSArray *modelArray = [ProjectSceneCommentModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            for (NSInteger i  = 0 ; i < modelArray.count ; i ++) {
                ProjectSceneCommentModel *model = modelArray[i];
                [_dataArray insertObject:model atIndex:0];
            }
            
            //刷新表
            [_tableView reloadData];
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

-(void)createUI
{
    _tableView = [[UITableView alloc]init];
//    _tableView.bounces = NO;
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    if (!_dataArray.count) {
        [_tableView.mj_header beginRefreshing];
    }
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREENHEIGHT -50-64);
    }];
    
    [self createFooterView];
}

-(void)createFooterView
{
    //加底部回复框
    _footer =[[UIView alloc]init];
    
    [self.view addSubview:_footer];
    [_footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    _textView = [[UITextView alloc]init];
    _textView.layer.cornerRadius = 2;
    _textView.layer.masksToBounds = YES;
    _textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.delegate = self;
    _textView.font = BGFont(15);
    _textView.returnKeyType = UIReturnKeyDone;
    [_footer addSubview:_textView];
    
    UIButton * btn =[[UIButton alloc]init];
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:colorBlue];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_footer addSubview:btn];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(btn.mas_left).offset(-5);
    }];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_footer.mas_top);
        make.right.mas_equalTo(_footer.mas_right);
        make.bottom.mas_equalTo(_footer.mas_bottom);
        make.width.mas_equalTo(75);
    }];
}

#pragma mark -发送信息
-(void)sendMessage:(UIButton*)btn
{
    if (self.textView.text && ![self.textView.text isEqualToString:@""]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.commentpartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",[NSString stringWithFormat:@"%@",self.textView.text],@"content", nil];
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
            
            self.textView.text = @"";
            [self.textView resignFirstResponder];
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

#pragma mark- textView  delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"开始编辑");
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        self.textView.text = textView.text;
    }
    NSLog(@"正在编辑");
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
