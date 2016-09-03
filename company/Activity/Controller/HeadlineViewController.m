//
//  HeadlineViewController.m
//  company
//
//  Created by LiLe on 16/8/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "HeadlineViewController.h"
#import "HeadlineBottomImgCell.h"
#import "HeadlineRightImgCell.h"
#import "HeadlineDetailViewController.h"
#import "Headline.h"

@interface HeadlineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger nextPage;
/** 判断是否是第一次成功加载数据 */
@property (nonatomic, assign) BOOL isFirst;
@end

@implementation HeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"金日投条";
    
    [Encapsulation returnWithViewController:self img:@"leftBack"];
    
    _tableView = [[UITableViewCustomView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-15) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置刷新控件
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHttp)];
    //自动改变透明度
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [self.tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPageA)];
    [self.view addSubview:_tableView];
    //    _tableView.separatorInset = UIEdgeInsetsMake(0,0, 0, 0); // 设置端距，这里表示separator离左边和右边均0像素
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //设置加载视图范围
    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
    
    _dataArr = [NSMutableArray array];
    self.nextPage = 0;
    self.isUpLoading = NO;
    _isFirst = YES;
    [self loadHeadlineData];

    
}

- (void)refreshHttp
{
//    __block HeadlineViewController *vc = self;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        vc.nextPage = 0;
//        vc.isUpLoading = NO;
//        [vc loadHeadlineData];
//    }];
//    [_tableView.mj_header beginRefreshing];
    self.nextPage = 0;
    [self loadHeadlineData];
}

- (void)nextPageA
{
//    __block HeadlineViewController *vc = self;
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        vc.nextPage++;
//        vc.isUpLoading = YES;
//        [vc loadHeadlineData];
//    }];
    self.nextPage ++;
    [self loadHeadlineData];
}

#pragma mark - table view delegate method and datasource method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Headline *headLine = _dataArr[indexPath.row];
    if (1 == headLine.flag) {
        return 250;
    }
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Headline *headLine = _dataArr[indexPath.row];
    if (1 == headLine.flag) {
        HeadlineBottomImgCell *cell = [HeadlineBottomImgCell cellWithTableView:tableView];
        cell.headline = _dataArr[indexPath.row];
        return cell;
    }
    HeadlineRightImgCell *cell = [HeadlineRightImgCell cellWithTableView:tableView];
    cell.headline = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Headline *headline = _dataArr[indexPath.row];
    HeadlineDetailViewController *headlineDetailVc = [[HeadlineDetailViewController alloc] init];
    headlineDetailVc.url = headline.url;
    headlineDetailVc.image = headline.imgName;
    headlineDetailVc.titleText = headline.title;
    headlineDetailVc.contentText = headline.name;
    [self.navigationController pushViewController:headlineDetailVc animated:YES];
}

#pragma mark - barButton method
// 返回上一vc
- (void)backHome:(UIViewController *)mySelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)loadHeadlineData
{
    if (_isFirst) {
        self.startLoading = YES;
    }
    NSString *partner = [TDUtil encryKeyWithMD5:KEY action:@"requestConsultList"];
    NSDictionary *paramsDic = @{@"key":KEY,
                                @"partner": partner,
                                @"page":[NSString stringWithFormat:@"%ld", (long)_nextPage],
                                @"version":@"1"};
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [manager POST:JZT_URL(@"requestConsultList.action") parameters:paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"] intValue]== 200) {
            if (self.nextPage == 0) {
                [_dataArr removeAllObjects];
            }
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            for (NSDictionary *dic in dataArray) {
                Headline *headline = [Headline headlineWithDict:dic];
                [_dataArr addObject:headline];
            }
            if (_isFirst) {
                _isFirst = NO;
            }
            [_tableView reloadData];
        } else {
            
        }
        weakSelf.startLoading = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakSelf.isNetRequestError  =YES;
    }];
    
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

#pragma mark - lazy load
- (NSArray *)dataArr
{
    if (!_dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    return _dataArr;
}



@end
