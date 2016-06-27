//
//  DealBillVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "DealBillVC.h"
#import "BillDetailCell.h"

#define TRADELIST @"requestTradeList"
#import "BillDetailCellModel.h"

@interface DealBillVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation DealBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:TRADELIST];
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [self setupNav];
    _page = 0;
    [self loadData];
    [self createTableView];
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(leftBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    self.navigationItem.title = @"交易账单";
}

-(void)leftBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    NSDictionary *dic =[NSDictionary  dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",_page],@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_TRADE_LIST postParam:dic type:0 delegate:self sel:@selector(requestTradeList:)];
}
-(void)requestTradeList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            if (_page == 0) {
                [_dataArray removeAllObjects];
            }
            if ([jsonDic[@"data"] count]) {
                NSArray *modelArray =[BillDetailCellModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i =0; i < modelArray.count; i ++) {
                    
                    [_dataArray addObject:modelArray[i]];
                }
            }
            for (NSInteger i =0; i < _dataArray.count - 1; i ++) {
                if (i == 0) {
                    BillDetailCellModel *model = _dataArray[0];
                    model.isShow = YES;
                }
                BillDetailCellModel *modelI = _dataArray[i];
                NSArray *arr1 = [modelI.record.tradeDate componentsSeparatedByString:@" "];
                NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"-"];
                NSString *year1 = arr2[0];
                for (NSInteger j =i +1; j < _dataArray.count; j ++) {
                    BillDetailCellModel *modelJ = _dataArray[j];
                    arr1 = [modelJ.record.tradeDate componentsSeparatedByString:@" "];
                    arr2 = [arr1[0] componentsSeparatedByString:@"-"];
                    NSString *year2 = arr2[0];
                    if ([year1 isEqualToString:year2]) {
                        modelJ.isShow = NO;
                    }else{
                        modelJ.isShow = YES;
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
-(void)createTableView
{
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    //    tableView.mj_footer.hidden = YES;
    _tableView.mj_footer.automaticallyHidden = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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

#pragma mark -tableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id  model = _dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BillDetailCell class] contentViewWidth:[self cellContentViewWith]];
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
    static NSString *cellId = @"BillDetailCell";
    BillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BillDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    if (indexPath.row == 0) {
        [cell.topLine setHidden:YES];
    }
    return cell;
}
#pragma mark -cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
