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

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *addressPartner;

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
    
    NSString * string = [AES encrypt:CITY password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    self.addressPartner = [TDUtil encryKeyWithMD5:KEY action:MODIFYADDRESS];
    [self createTableView];
    [self loadData];
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

-(void)loadData
{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.provinceId,@"provinceId", nil];
    [self.httpUtil getDataFromAPIWithOps:CITY_LIST postParam:dic type:0 delegate:self sel:@selector(requestCity:)];
}

-(void)requestCity:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic != nil) {
        NSString *status = [dic objectForKey:@"status"];
        if ([status integerValue] == 200)  {
            NSArray *dataArray = [NSArray arrayWithArray:dic[@"data"]];
            for (NSDictionary *dic in dataArray) {
                [_dataArray addObject:dic[@"name"]];
                [_idArray addObject:dic[@"cityId"]];
            }
            
            [_tableView reloadData];
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
        }
    }
    
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.city = _dataArray[indexPath.row];
    NSString *address = [NSString stringWithFormat:@"%@ | %@",self.province,self.city];
    _cityId = [NSString stringWithFormat:@"%@",_idArray[indexPath.row]];
    
    [self modifyAddress];
    
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[MIneAreaVC class]]) {
            //            AreaViewController *vc = (AreaViewController*)VC;
            [VC removeFromParentViewController];
            //            self.navigationController.viewControllers.
            
        }
        
        if ([VC isKindOfClass:[MineViewController class]]) {
            MineViewController *vc = (MineViewController*)VC;
            
            [vc loadAuthenData];
        }
        
        
        if ([VC isKindOfClass:[MineDataVC class]]) {
            MineDataVC *vc = (MineDataVC*)VC;
            vc.address = address;
//            vc.cityId = _idArray[indexPath.row];
            
            [vc.tableView reloadData];
            
            [self.navigationController popToViewController:vc animated:YES];
        }
        
        
        
    }
    
    
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)modifyAddress
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.addressPartner,@"partner",_cityId,@"cityId", nil];
    [self.httpUtil getDataFromAPIWithOps:REQUEST_MODIFY_CITY postParam:dic type:0 delegate:self sel:@selector(requestAddress:)];
}
-(void)requestAddress:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!= nil) {
        NSString *status = [dic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSLog(@"城市修改成功");
            
            [self changeModel];
        }else{
            NSLog(@"城市修改失败");
        }
    }
}

-(void)changeModel
{
    
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
