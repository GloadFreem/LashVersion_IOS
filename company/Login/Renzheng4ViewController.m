//
//  Renzheng4ViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "Renzheng4ViewController.h"
#import "RegistNameTableViewCell.h"
#import "JTabBarController.h"
#import "AppDelegate.h"
#define PROTOCOL @"getProtocolAuthentic"
@interface Renzheng4ViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UIActivityIndicatorView *activity;
}

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat tableViewH;

@property (nonatomic, strong) NSMutableArray *dataSelected;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation Renzheng4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.partner = [TDUtil encryKeyWithMD5:KEY action:PROTOCOL];
    //请求数据
    [self initData];
    
    //设置导航栏标题
    if ([self.identifyType integerValue] == 2) {
        self.titleLabel.text = @"(3/3)";
    }
    if ([self.identifyType integerValue] == 3) {
        self.titleLabel.text = @"(4/4)";
    }
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_dataSelected) {
        _dataSelected = [NSMutableArray array];
    }
    if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    
    self.doneBtn.layer.cornerRadius = 20;
    self.doneBtn.layer.masksToBounds = YES;
}
#pragma mark -- 初始化数据
-(void)initData{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:KEY,@"key",self.partner,@"partner", nil];
    [self.httpUtil getDataFromAPIWithOps:AUTHENTICATE_PROTOCOL postParam:dic type:0 delegate:self sel:@selector(requestGetProtocol:)];
}

-(void)requestGetProtocol:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        
        if ([status integerValue] == 200) {
            _dataArray = [jsonDic objectForKey:@"data"];
            for (NSInteger i = 0; i < _dataArray.count; i ++) {
                [_statusArray addObject:@"0"];
            }
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            
        }
    }
    [_tableView reloadData];
}
#pragma mark- tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_height > 35) {
        
        return _height + 16 + 10;
    }
    
    return 44 + 10;
    
}

#pragma mark- tableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    RegistNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RegistNameTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    cell.leftButton.tag = indexPath.row;
    cell.rightLabel.numberOfLines = 0;
//    cell.rightLabel.text = _dataArray[indexPath.row];
    [TDUtil setLabelMutableText:cell.rightLabel content:_dataArray[indexPath.row] lineSpacing:3 headIndent:0];
    
    CGFloat height = [cell.rightLabel.text commonStringHeighforLabelWidth:SCREENWIDTH - 70 withFontSize:14];
//    NSLog(@"高度是%f",height);
    cell.rightLabelHeight.constant = height;
    _height = height;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_statusArray != nil && _statusArray.count != indexPath.row){
        NSString *status = _statusArray[indexPath.row];
        RegistNameTableViewCell *cell = (RegistNameTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        if ([status isEqualToString:@"0"]) {
            
            status = @"1";
            [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"icon_name_select"] forState:UIControlStateNormal];
            [_dataSelected addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
        }else{
            status = @"0";
            [cell.leftButton setBackgroundImage:[UIImage imageNamed:@"icon_name_unselect"] forState:UIControlStateNormal];
            [_dataSelected removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        [_statusArray replaceObjectAtIndex:indexPath.row withObject:status];
    }
}
#pragma mark -返回上一页
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -认证信息成功
- (IBAction)doneBtnClick:(UIButton *)sender {
    if (_dataSelected.count == 0) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择认证协议"];
        return;
    }
    
    NSMutableString *optional = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < _dataSelected.count; i ++) {
        if (i!=_dataSelected.count-1){
        [optional appendFormat:@"%@,",_dataSelected[i]];
        }else{
        [optional appendFormat:@"%@",_dataSelected[i]];
        }
    }
    //设置身份类型
    [_dicData setObject:self.identifyType forKey:@"identiyTypeId"];
    //设置认证协议
    [_dicData setObject:optional forKey:@"optional"];
    
    //读取图片加到图片字典 并请求数据
    //检验照片是否存在
    BOOL retA =[TDUtil checkImageExists:@"identiyCarA"];
    
    BOOL retB =[TDUtil checkImageExists:@"identiyCarB"];
    
    BOOL retC =[TDUtil checkImageExists:@"buinessLicence"];
    
    
    //开始加载动画
    //上传文件
    self.loadingViewFrame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    self.startLoading = YES;
    self.isTransparent  = YES;
    
    if ([self.identifyType integerValue] == 2) {//投资人
        //加到上传文件字典
        if (retA && retB) {
            NSDictionary *fileDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"identiyCarA",@"identiyCarA",@"identiyCarB",@"identiyCarB", nil];
            
            [self.httpUtil getDataFromAPIWithOps:AUTHENTICATE postParam:_dicData files:fileDic type:0 delegate:self sel:@selector(requestSetIdentifyType:)];
            
        }
    }else{
        //加到上传文件字典
        if (retA && retB && retC) {
            NSDictionary *fileDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"identiyCarA",@"identiyCarA",@"identiyCarB",@"identiyCarB",@"buinessLicence",@"buinessLicence", nil];
            
            [self.httpUtil getDataFromAPIWithOps:AUTHENTICATE postParam:_dicData files:fileDic type:0 delegate:self sel:@selector(requestSetIdentifyType:)];
            
        }
    }
}

-(void)requestSetIdentifyType:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        
        if ([status integerValue] == 200) {

            self.startLoading = NO;

            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            UINavigationController *nav = (UINavigationController*)window.rootViewController;
            JTabBarController * tabBarController;
            for (UIViewController *vc in nav.childViewControllers) {
                if ([vc isKindOfClass:JTabBarController.class]) {
                    tabBarController = (JTabBarController*)vc;
                }
            }
            if (!tabBarController) {
                tabBarController = [CommentTD createViewControllers];
            }
            [self.navigationController pushViewController:tabBarController animated:NO];
        }else{
            self.startLoading = NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
            }
    }

}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = NO;
}

//让当前控制器对应的状态栏是白色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

@end
