//
//  DealBillVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "DealBillVC.h"
#import "BillDetailCell.h"
#import "BillEndCell.h"

#define TRADELIST @"requestTradeList"
#import "BillDetailCellModel.h"

@interface DealBillVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSMutableArray *tempArray;
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
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    [self setupNav];
    [self createTableView];
    _isFirst = YES;
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64);
    _page = 0;
    [self loadData];
    
}

#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
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
    NSDictionary *dic =[NSDictionary  dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    if (_isFirst) {
        
        self.startLoading = YES;
    }
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_TRADE_LIST postParam:dic type:0 delegate:self sel:@selector(requestTradeList:)];
}
-(void)requestTradeList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            self.startLoading = NO;
            _isFirst = NO;
            if (_page == 0) {
                [_tempArray removeAllObjects];
            }
//            NSMutableArray *tempArray = [NSMutableArray new];
            if ( jsonDic[@"data"] && [jsonDic[@"data"] count]) {
                NSArray *modelArray =[BillDetailCellModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i =0; i < modelArray.count; i ++) {
                    
                    [_tempArray addObject:modelArray[i]];
                }
            }
            
            if (_tempArray.count > 1) {
                for (NSInteger i =0; i < _tempArray.count - 1; i ++) {
                    if (i == 0) {
                        BillDetailCellModel *model = _tempArray[0];
                        model.isShow = YES;
                    }
                    BillDetailCellModel *modelI = _tempArray[i];
                    NSArray *arr1 = [modelI.record.tradeDate componentsSeparatedByString:@" "];
                    NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"-"];
                    NSString *year1 = arr2[0];
                    for (NSInteger j =i +1; j < _tempArray.count; j ++) {
                        BillDetailCellModel *modelJ = _tempArray[j];
                        arr1 = [modelJ.record.tradeDate componentsSeparatedByString:@" "];
                        arr2 = [arr1[0] componentsSeparatedByString:@"-"];
                        NSString *year2 = arr2[0];
                        if ([year1 isEqualToString:year2]) {
                            modelJ.isShow = NO;
                        }else{
                            modelJ.isShow = YES;
                        }
                   }
               }
            }else{
                if (_tempArray.count) {
                    BillDetailCellModel *model = _tempArray[0];
                    model.isShow = YES;
                }
            }
            self.dataArray = _tempArray;
        }
    }else{
        self.isNetRequestError = YES;
    }
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (_dataArray.count <= 0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
    }
    [self.tableView reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [self loadData];
}

-(void)createTableView
{
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
//    [_tableView.mj_header beginRefreshing];
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
    if (_dataArray.count) {
        return _dataArray.count + 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        if (indexPath.row == _dataArray.count) {
            return 20;
        }else{
            id  model = _dataArray[indexPath.row];
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[BillDetailCell class] contentViewWidth:[self cellContentViewWith]];
        }
    }
    return 0.000000001f;
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
    if (_dataArray.count) {
        if (indexPath.row == _dataArray.count) {
            static NSString *cellId = @"BillEndCell";
            BillEndCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[BillEndCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            return cell;
        }else{
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
    }
    return nil;
}
#pragma mark -cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
