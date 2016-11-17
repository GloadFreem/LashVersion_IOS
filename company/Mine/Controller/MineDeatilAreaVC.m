//
//  MineDeatilAreaVC.m
//  company
//
//  Created by Eugene on 16/6/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineDeatilAreaVC.h"
#define CITY @"getCityListByProvinceIdAuthentic"
#import "MIneAreaVC.h"
#import "MineDataVC.h"
#import "MineViewController.h"
#define MODIFYADDRESS @"requestModifyCity"
@interface MineDeatilAreaVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableViewCustomView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *addressPartner;

@property (nonatomic, copy) NSString *address;
@end

@implementation MineDeatilAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_dataArray) {
        _dataArray =  [NSMutableArray array];
    }
    if (!_idArray) {
        _idArray  = [NSMutableArray array];
    }
    
    self.loadingViewFrame = self.view.frame;
    
    [self setupNav];
    
    NSString * string = [AES encrypt:CITY password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    self.addressPartner = [TDUtil encryKeyWithMD5:KEY action:MODIFYADDRESS];
    [self createTableView];
    [self loadData];
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

-(void)loadData
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.provinceId,@"provinceId", nil];
    
    self.startLoading = YES;
    
    [[EUNetWorkTool shareTool] POST:JZT_URL(CITY_LIST) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            self.startLoading = NO;
            
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            for (NSDictionary *dic in dataArray) {
                [_dataArray addObject:dic[@"name"]];
                [_idArray addObject:dic[@"cityId"]];
            }
            if (_dataArray.count <= 0 || _idArray.count <= 0) {
                self.tableView.isNone = YES;
            }else{
                self.tableView.isNone = NO;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
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
    [self loadData];
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

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
//    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.city = _dataArray[indexPath.row];
    NSString *address;
    if ([self.city isEqualToString:@"北京市"] || [self.city isEqualToString:@"上海市"] || [self.city isEqualToString:@"天津市"] || [self.city isEqualToString:@"重庆市"] || [self.city isEqualToString:@"香港"] || [self.city isEqualToString:@"澳门"] || [self.city isEqualToString:@"钓鱼岛"]) {
        address = [NSString stringWithFormat:@"%@",self.city];
    
    }else{
        address = [NSString stringWithFormat:@"%@ | %@",self.province,self.city];
        
    }
    _address = address;
    _cityId = [NSString stringWithFormat:@"%@",_idArray[indexPath.row]];
    
    
    [self modifyAddress];
    
}
-(void)modifyAddress
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.addressPartner,@"partner",_cityId,@"cityId", nil];
//    [self.httpUtil getDataFromAPIWithOps:REQUEST_MODIFY_CITY postParam:dic type:1 delegate:self sel:@selector(requestAddress:)];
    [[EUNetWorkTool shareTool] POST:JZT_URL(REQUEST_MODIFY_CITY) parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        if ([dic[@"status"] integerValue] == 200) {
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:self.city forKey:USER_STATIC_CITY];
            [data setObject:self.province forKey:USER_STATIC_PROVINCE];
            [data synchronize];
//            NSLog(@"修改成功");
            for (UIViewController *VC in self.navigationController.viewControllers) {
                if ([VC isKindOfClass:[MIneAreaVC class]]) {
                    [VC removeFromParentViewController];
                    
                }
                
                if ([VC isKindOfClass:[MineDataVC class]]) {
                    MineDataVC *vc = (MineDataVC*)VC;
                    vc.address = _address;
                    [vc.tableView reloadData];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self cancleRequest];
}
@end
