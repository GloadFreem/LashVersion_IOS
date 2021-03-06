//
//  MIneAreaVC.m
//  company
//
//  Created by Eugene on 16/6/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MIneAreaVC.h"
#import "MineDeatilAreaVC.h"
#define PROVINCE @"getProvinceListAuthentic"

@interface MIneAreaVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * idArray;

@end

@implementation MIneAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    
    [self setupNav];
    NSString * string = [AES encrypt:PROVINCE password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    
    self.loadingViewFrame = self.view.frame;
    
    [self createTableView];
    [self createData];
    
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
    self.navigationItem.title = @"所在地";
}

-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    _tableView = [[UITableViewCustomView alloc]init];
//    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

#pragma mark- 创建数据
-(void)createData{
    
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner", nil];
    
    self.startLoading = YES;
    [[EUNetWorkTool shareTool] POST:JZT_URL(PROVINCE_LIST) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            self.startLoading = NO;
            
            NSArray *dataArray = [[NSArray alloc]initWithArray:dic[@"data"]];
            for (NSDictionary *dic in dataArray) {
                [_dataArray addObject:dic[@"name"]];
                [_idArray addObject:dic[@"provinceId"]];
            }
            
            if (_dataArray.count <= 0 || _idArray.count <= 0) {
                self.tableView.isNone = YES;
            }else{
                self.tableView.isNone = NO;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            //            NSLog(@"数据下载成功");
            [_tableView reloadData];
        }else{
            self.startLoading = NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.startLoading = YES;
        self.isNetRequestError = YES;
    }];
}


-(void)refresh
{
    [self createData];
}

#pragma mark- tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark- tableViewDelagate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //通过一个标识从缓存池寻找可循环利用的cell
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    //如果没有就创建一个
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count) {
       cell.textLabel.text = _dataArray[indexPath.row];
    }
//    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark- tableViewCell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MineDeatilAreaVC *detail = [MineDeatilAreaVC new];
    
    detail.provinceId = _idArray[indexPath.row];
    detail.province = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)dealloc
{
    [self cancleRequest];
}

@end
