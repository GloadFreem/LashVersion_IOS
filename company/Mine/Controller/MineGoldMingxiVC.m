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

#import "MineGoldMingXiEndCell.h"

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
    self.partner = [TDUtil encryKeyWithMD5:KEY action:GOLDDETAIL];
    _page = 0;
    [self startLoadData];
    
    [self createTableView];

}
-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
    
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
            
            if (jsonDic[@"data"] && [jsonDic[@"data"] count]) {
                NSArray *modelArray = [MineGoldMingxiModel mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
                for (NSInteger i =0; i < modelArray.count; i ++) {
                    
                    [_dataArray addObject:modelArray[i]];
                }
                
                if (_dataArray.count > 1) {
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
                }else{
                    MineGoldMingxiModel *model = _dataArray[0];
                    model.isShow = YES;
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
    [_tableView.mj_footer endRefreshing];
}
#pragma mark -设置导航栏
-(void)setupNav
{
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
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
//    [_tableView.mj_header beginRefreshing];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPage)];
    //    tableView.mj_footer.hidden = YES;
    _tableView.mj_footer.automaticallyHidden = YES;
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
    [self startLoadData];
    //    NSLog(@"回到顶部");
}

-(void)refreshHttp
{
    _page = 0;
    
    [self startLoadData];
    //    NSLog(@"下拉刷新");
}


-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count) {
        return _dataArray.count + 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      //   ---------------------cell自适应-------------
    if (_dataArray.count) {
        if (indexPath.row == _dataArray.count) {
            return 20;
        }else{
            id  model = _dataArray[indexPath.row];
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MineGoldMingxiCell class] contentViewWidth:[self cellContentViewWith]];
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
            static NSString *cellId = @"MineGoldMingXiEndCell";
            MineGoldMingXiEndCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[MineGoldMingXiEndCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
            cell.backgroundColor = [UIColor redColor];
            return cell;
            
        }else{
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
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
