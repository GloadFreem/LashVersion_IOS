//
//  MineGoldMingxiVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineGoldMingxiVC.h"
#import "MineGoldMingxiCell.h"
#import "MineGoldMingxiModel.h"



#define GOLDDETAIL @"requestUserGoldTradeList"
@interface MineGoldMingxiVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation MineGoldMingxiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    [self setupNav];
    [self createTableView];
    self.partner = [TDUtil encryKeyWithMD5:KEY action:GOLDDETAIL];
    _page = 0;
    [self loadData];
//    [self.dataArray addObjectsFromArray:[self createModelsWithCount:10]];
}
-(void)loadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",_page],@"page", nil];
    
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_GOLD_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestGoldDetail:)];
}
-(void)requestGoldDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            if (_page == 0) {
                [_dataArray removeAllObjects];
            }
            if ([jsonDic[@"data"] count]) {
                NSArray *modelArray = [MineGoldMingxiModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i =0; i < modelArray.count; i ++) {
                    
                    [_dataArray addObject:modelArray[i]];
                }
                
                for (NSInteger i =0; i < _dataArray.count - 1; i++) {
                    if (i == 0) {
                        MineGoldMingxiModel *model = _dataArray[0];
                        model.isShow = YES;
                    }
                    MineGoldMingxiModel *modelI = _dataArray[i];
                    NSArray *arr1 = [modelI.tradeDate componentsSeparatedByString:@" "];
                    NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"-"];
                    NSString *month1 = arr2[1];
                    for (NSInteger j = i + 1; j < _dataArray.count; j ++) {
                        MineGoldMingxiModel *modelJ = _dataArray[j];
                        arr1 = [modelJ.tradeDate componentsSeparatedByString:@" "];
                        arr2 = [arr1[0] componentsSeparatedByString:@"-"];
                        NSString *month2 = arr2[1];
                        if ([month1 isEqualToString:month2]) {
                            modelJ.isShow = NO;
                        }else{
                            modelJ.isShow = YES;
                        }
                    }
                }
                
                [self.tableView reloadData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];

            }
        }else{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    }
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"收支明细";
}

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
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    //    tableView.mj_footer.hidden = YES;
    _tableView.mj_footer.automaticallyHidden = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
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
    [self loadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page = 0;
    
    [self loadData];
    //    NSLog(@"下拉刷新");
}


-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(NSArray*)createModelsWithCount:(NSInteger)count
//{
//    NSMutableArray *mArr = [NSMutableArray new];
//    for (int i=0; i<count; i++) {
//        MineGoldMingxiModel *model =[MineGoldMingxiModel new];
//        
//        model.dayStr = @"15日";
//        model.titleStr = @"金指投投资平台";
//        model.numberStr = @"+ 15";
//        model.contentStr = @"潜力无限";
//        if (i == 0) {
//            model.yearStr = @"2016年5月";
//        }else{
//            model.yearStr = @"";
//        }
//        [mArr addObject:model];
//    }
//    return [mArr copy];
//}
#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      //   ---------------------cell自适应-------------
    id  model = _dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MineGoldMingxiCell class] contentViewWidth:[self cellContentViewWith]];
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MineGoldMingxiCell";
    MineGoldMingxiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MineGoldMingxiCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    if (indexPath.row == 0) {
        [cell.topLine setHidden:YES];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
