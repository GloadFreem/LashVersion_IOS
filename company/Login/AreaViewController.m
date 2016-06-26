//
//  AreaViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "AreaViewController.h"
#import "RenzhengViewController.h"
#import "DetailAreaViewController.h"
#define PROVINCE @"getProvinceListAuthentic"
@interface AreaViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * idArray;

@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_dataArray) {
        _dataArray =[NSMutableArray array];
    }
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    
    NSString * string = [AES encrypt:PROVINCE password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    
    [self createData];
    
}

#pragma mark- 创建数据
-(void)createData{
    
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner", nil];
    [self.httpUtil getDataFromAPIWithOps:PROVINCE_LIST postParam:dic type:0 delegate:self sel:@selector(requestProvice:)];
}

-(void)requestProvice:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!=nil) {
        NSString *status = [dic objectForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *dataArray = [[NSArray alloc]initWithArray:dic[@"data"]];
            for (NSDictionary *dic in dataArray) {
                [_dataArray addObject:dic[@"name"]];
                [_idArray addObject:dic[@"provinceId"]];
            }
            
            NSLog(@"数据下载成功");
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
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark- tableViewCell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailAreaViewController *detail = [DetailAreaViewController new];
    detail.type = self.type;
    detail.provinceId = _idArray[indexPath.row];
    detail.province = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
   
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
