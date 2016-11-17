//
//  InvistViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvistViewController.h"
#import "InvistTableViewCell.h"
#import "NSString+Addition.h"
#import "RenzhengViewController.h"
#import "MineDataVC.h"
#define UPDATEUSERINFO @"requestUpdateUserInfoAction"
#define INVESTFIELD @"getIndustoryAreaListAuthentic"
@interface InvistViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSMutableArray *statusArray; //状态数组
@property (nonatomic, strong) NSMutableArray *dataSelected; //选中字段数组
@property (nonatomic, strong) NSMutableArray *idSelected; //选中id数组

@property (nonatomic, copy) NSString *updatePartner;

@property (nonatomic, copy) NSString *investField;
@end

@implementation InvistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    if (!_dataSelected) {
        _dataSelected = [NSMutableArray array];
    }
    if (!_idArray) {
        _idArray = [NSMutableArray array];
    }
    if (!_idSelected) {
        _idSelected = [NSMutableArray array];
    }
    NSString * string = [AES encrypt:INVESTFIELD password:KEY];
    self.partner = [TDUtil encryptMD5String:string];
    self.updatePartner = [TDUtil encryKeyWithMD5:KEY action:UPDATEUSERINFO];
    
    [self createData];
}
#pragma mark- 拿数据
-(void)createData{
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner", nil];
    [self.httpUtil getDataFromAPIWithOps:INVEST_FIELD_LIST postParam:dic type:0 delegate:self sel:@selector(requestInvestField:)];
}

-(void)requestInvestField:(ASIHTTPRequest *)request
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
                [_idArray addObject:dic[@"areaId"]];
                [_statusArray addObject:@"0"];//未选中状态为0
            }
            
            [_tableView reloadData];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"message"]];
    }
}
#pragma mark - tableView DataSource 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark- tableView delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    InvistTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InvistTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.leftLabel.text = _dataArray[indexPath.row];
//    CGFloat width = [cell.leftLabel.text commonStringWidthForFont:17];
//    cell.leftLabelWidth.constant = width;
    [cell.leftLabel sizeToFit];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSLog(@"id数组：%@",_idSelected);
    if (_statusArray != nil && _statusArray.count != indexPath.row) {
        NSString *status = [_statusArray objectAtIndex:indexPath.row];
        InvistTableViewCell *cell = (InvistTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        if ([status isEqualToString:@"0"]) {
            if (_dataSelected.count >= 3) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"最多选择三个"];
                return;
            }else{
                //选中
                [cell.selectImage setImage:[UIImage imageNamed:@"icon_name_select"]];
                //将选中的cell数据加到选中数组
                [_dataSelected addObject:_dataArray[indexPath.row]];
                [_idSelected addObject:_idArray[indexPath.row]];
                status =@"1";
            }
            
        }else{
            status = @"0";
            [cell.selectImage setImage:[UIImage imageNamed:@"icon_name_unselect"]];
             //将选中的cell数据加到选中数组

            [_dataSelected  removeObject:_dataArray[indexPath.row]];
            [_idSelected removeObject:_idArray[indexPath.row]];
        }
        //点击cell将对应的cell数组的状态改变
        [_statusArray replaceObjectAtIndex:indexPath.row withObject:status];
    }
    
    
    
    
    
//    for (NSInteger i= 0; i < _statusArray.count; i++) {
//        //拿到cell
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
//        InvistTableViewCell *cell = (InvistTableViewCell*)[_tableView cellForRowAtIndexPath:indexpath];
//        if ([_statusArray[i] isEqualToString:@"0"]) {
//            //未选中
//            
//            [cell.selectImage setImage:[UIImage imageNamed:@"icon_name_unselect"]];
//            //将选中的cell数据加到选中数组
//            
//            [_dataSelected  removeObject:_dataArray[indexPath.row]];
//        }else{
//            
//            if (_dataSelected.count > 3) {
//                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"最多选择三个"];
//                return;
//            }else{
//                //选中
//                [cell.selectImage setImage:[UIImage imageNamed:@"icon_name_select"]];
//                //将选中的cell数据加到选中数组
//                [_dataSelected addObject:_dataArray[indexPath.row]];
//            }
//            
//        }
//    }
    
    
    
    //刷新tableView
   // [_tableView reloadData];
}
- (IBAction)leftBack:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)certifyBtn:(UIButton *)sender {
    
    NSMutableString *investField = [[NSMutableString alloc]init];
    NSMutableString *idString = [[NSMutableString alloc]init];
    
    //投资领域
    for (NSInteger i= 0; i < _dataSelected.count; i ++) {
        if (i!=_dataSelected.count-1) {
            [investField appendFormat:@"%@ | ",_dataSelected[i]];
            [idString appendFormat:@"%@,",_idSelected[i]];
        }else{
            [investField appendFormat:@"%@",_dataSelected[i]];
            [idString appendFormat:@"%@,",_idSelected[i]];
        }
    }
    
    if (_isMine) {
        _investField = [NSString stringWithFormat:@"%@",investField];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.updatePartner,@"partner",@"",@"userIntroduce",@"",@"companyIntroduce",idString,@"areas",nil];
        [self.httpUtil getDataFromAPIWithOps:REQUEST_UPDATE_USERINFO postParam:dic type:1 delegate:self sel:@selector(requestInfo:)];
        
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MineDataVC class]]) {
                MineDataVC *vc = (MineDataVC*)VC;
                vc.areas = self.investField;
                [vc.tableView reloadData];
            }
        }
    }else{
    for (UIViewController *VC in self.navigationController.viewControllers) {
        
        if ([VC isKindOfClass:[RenzhengViewController class]]) {
            RenzhengViewController *vc = (RenzhengViewController*)VC;
            vc.investField = investField;
//            NSLog(@"投资领域%@",investField);
            vc.areaId = idString;
//            NSLog(@"ID%@",idString);
            [vc refreshData];
        }
    }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestInfo:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!= nil) {
        NSString *status = [dic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"城市修改成功");
            NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
            [data setObject:self.investField forKey:USER_STATIC_INVEST_AREAS];
            [data synchronize];
        }else{
            //            NSLog(@"城市修改失败");
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isMine) {
        self.navigationController.navigationBar.hidden = YES;
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIImageView new]];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancleRequest];
    
    if (_isMine) {
        self.navigationController.navigationBar.hidden = YES;
    }
}
@end
