//
//  DetailAreaViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "DetailAreaViewController.h"
#import "RenzhengViewController.h"
#import "AreaViewController.h"



#define CITY @"getCityListByProvinceIdAuthentic"

@interface DetailAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, copy) NSString *city;


@end

@implementation DetailAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_dataArray) {
        _dataArray =  [NSMutableArray array];
    }
    if (!_idArray) {
        _idArray  = [NSMutableArray array];
    }
    
    NSString * string = [AES encrypt:CITY password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    
    
    
    [self loadData];
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
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
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
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.city = _dataArray[indexPath.row];
    NSString *address;
    if ([self.city isEqualToString:@"北京市"] || [self.city isEqualToString:@"上海市"] || [self.city isEqualToString:@"天津市"] || [self.city isEqualToString:@"重庆市"] || [self.city isEqualToString:@"香港"] || [self.city isEqualToString:@"澳门"] || [self.city isEqualToString:@"钓鱼岛"]) {
        address = [NSString stringWithFormat:@"%@",self.province];
        
    }else{
        address = [NSString stringWithFormat:@"%@ | %@",self.province,self.city];
    }
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[AreaViewController class]]) {
//            AreaViewController *vc = (AreaViewController*)VC;
            [VC removeFromParentViewController];
//            self.navigationController.viewControllers.
            
        }
        
            if ([VC isKindOfClass:[RenzhengViewController class]]) {
                RenzhengViewController *vc = (RenzhengViewController*)VC;
                vc.companyAddress = address;
                vc.cityId = _idArray[indexPath.row];
                
                [vc refreshData];
           
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}




//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (IBAction)leftBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
