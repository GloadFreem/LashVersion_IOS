//
//  ProjectSceneCommentVC.m
//  company
//
//  Created by Eugene on 16/6/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectSceneCommentVC.h"
#import "ProjectSceneCommentModel.h"
#import "ProjectDetailSceneMessageCell.h"
#import "ProjectSceneOtherCell.h"

#define REQUESTSCENECOMMENT @"requestProjectSceneCommentList"
@interface ProjectSceneCommentVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSTimer *_timer;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *footer;

@property (nonatomic, strong) UITextField *textField;
@end

@implementation ProjectSceneCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获得内容partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:REQUESTSCENECOMMENT];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _page = 0;
    
    [self startLoadData];
    [self setNav];
    [self createUI];
    
}

-(void)loadDataRegular
{
    _page = 0;
    [self startLoadData];
}

-(void)setNav
{
    self.navigationItem.title = @"交流详情";
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.sceneId],@"sceneId",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_SCENE_COMMENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestCommentList:)];
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
            for (NSInteger i = 0; i < modelArray.count; i ++) {
                ProjectSceneCommentModel *model = modelArray[i];
                ProjectDetailSceneCellModel *cellModel = [ProjectDetailSceneCellModel new];
                cellModel.flag = model.flag;
                cellModel.iconImage = model.users.headSculpture;
                cellModel.name = model.users.name;
                cellModel.content = model.content;
                cellModel.time = model.commentDate;
                [_dataArray insertObject:cellModel atIndex:0];
            }
            //刷新表
            [self.tableView reloadData];
            
            if (_dataArray.count > 1) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
            
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            //结束刷新
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }
}

-(void)createUI
{
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource =self;
    _tableView.delegate =self;
//    _tableView.bounces = NO;
//    _tableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_tableView];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREENHEIGHT -50);
    }];
    
    [self createFooterView];
    
}

-(void)createFooterView
{
    //加底部回复框
    _footer =[[UIView alloc]init];
    [_footer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_footer];
    [_footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    _textField = [[UITextField alloc]init];
    _textField.layer.cornerRadius = 2;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _textField.layer.borderWidth = 0.5;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.font = BGFont(15);
    
    [_footer addSubview:_textField];
    
    UIButton * btn =[[UIButton alloc]init];
    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:colorBlue];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_footer addSubview:btn];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.textField resignFirstResponder];
    
}

#pragma mark -发送信息
-(void)sendMessage:(UIButton*)btn
{
    [self.textField resignFirstResponder];
    if (self.sceneId) {
        if (self.textField.text && ![self.textField.text isEqualToString:@""]) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.scenePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.sceneId],@"sceneId",[NSString stringWithFormat:@"%@",self.textField.text],@"content", nil];
            //开始请求
            [self.httpUtil getDataFromAPIWithOps:REQUEST_SCENE_COMMENT postParam:dic type:0 delegate:self sel:@selector(requestSceneComment:)];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"评论内容不能内空"];
            return;
        }
    }else{
        self.textField.text = @"";
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"路演现场暂未开放评论"];
    }
    
}

-(void)requestSceneComment:(ASIHTTPRequest *)request
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
            [_dataArray removeAllObjects];
            [self startLoadData];
            
            [_scene.dataArray removeAllObjects];
            [_scene startLoadComment];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}


#pragma mark -刷新控件
-(void)nextPage
{
    _page ++;
    
    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page --;
    if (_page < 0) {
        _page = 0;
    }
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
    ProjectDetailSceneCellModel *model = self.dataArray[indexPath.row];
    if (model.flag) {
        return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ProjectDetailSceneMessageCell class] contentViewWidth:[self cellContentViewWith]];
    }
    
    return [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ProjectSceneOtherCell class] contentViewWidth:[self cellContentViewWith]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        ProjectDetailSceneCellModel *model = _dataArray[indexPath.row];
        
        if (model.flag) {
            static NSString *cellId = @"ProjectDetailSceneMessageCell";
            ProjectDetailSceneMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[ProjectDetailSceneMessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
            cell.model = model;
            return cell;
        }
        
        static NSString *cellId = @"ProjectSceneOtherCell";
        ProjectSceneOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ProjectSceneOtherCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.model = model;
        return cell;
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark -textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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


/*
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
        self.textField.text = textView.text;
    }
    NSLog(@"正在编辑");
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadDataRegular) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)dealloc{
    [_timer invalidate];
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
