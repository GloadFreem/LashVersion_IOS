//
//  MIneProjectCommitRecordVC.m
//  company
//
//  Created by Eugene on 16/6/30.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MIneProjectCommitRecordVC.h"

#import "MineProjectCommitRecordCell.h"

#import "MineProjectCommitRecordBaseModel.h"
#define COMMITRECORD @"requestProjectCommitRecords"
@interface MIneProjectCommitRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;


@end

@implementation MIneProjectCommitRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.partner = [TDUtil encryKeyWithMD5:KEY action:COMMITRECORD];
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    _page = 0;
    [self startLoadData];
    [self setupNav];
    
    [self createTableView];
}
-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)self.projectId],@"projectId",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    //    开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_PROJECT_COMMIT_RECORD postParam:dic type:0 delegate:self sel:@selector(requestList:)];
}
-(void)requestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            if (_page == 0) {
                [_dataArray removeAllObjects];
            }
            NSArray *modelArray =[MineProjectCommitRecordBaseModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
            for (NSInteger i =0; i < modelArray.count; i ++) {
                MineProjectCommitRecordBaseModel *model = modelArray[i];
                [_dataArray addObject:model];
            }
            
            
            [self.tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    }
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(35, 30);
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"提交记录";
}

-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    _tableView  = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    //    _tableView.backgroundColor = [UIColor redColor];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    //    tableView.mj_footer.hidden = YES;
    _tableView.mj_footer.automaticallyHidden = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
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
    _page = 0;
    
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
    return 67;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MineProjectCommitRecordCell";
    MineProjectCommitRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
