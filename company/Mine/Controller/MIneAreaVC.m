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
@property (nonatomic, strong) UITableView *tableView;
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
    self.navigationItem.title = @"";
}

-(void)leftBack:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView
{
    _tableView = [UITableView new];
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
    [self.httpUtil getDataFromAPIWithOps:PROVINCE_LIST postParam:dic type:0 delegate:self sel:@selector(requestProvice:)];
}

-(void)requestProvice:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!=nil) {
        NSString *status = [dic objectForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *dataArray = [[NSArray alloc]initWithArray:dic[@"data"]];
            for (NSDictionary *dic in dataArray) {
                [_dataArray addObject:dic[@"name"]];
                [_idArray addObject:dic[@"provinceId"]];
            }
            
//            NSLog(@"数据下载成功");
            [_tableView reloadData];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
    }
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
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray.count) {
       cell.textLabel.text = _dataArray[indexPath.row];
    }
    
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


@end
