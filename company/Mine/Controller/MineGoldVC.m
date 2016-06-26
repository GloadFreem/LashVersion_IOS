//
//  MineGoldVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MineGoldVC.h"
#import "MineGoldMingxiVC.h"

#define GOLDACCOUNT @"requestGoldAccount"
@interface MineGoldVC ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, copy) NSString *count;
@property (nonatomic, assign) NSInteger rewardId;

@end

@implementation MineGoldVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.partner = [TDUtil encryKeyWithMD5:KEY action:GOLDACCOUNT];
    [self startLoadData];
}

-(void)startLoadData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:LOGO_GOLD_ACCOUNT postParam:dic type:0 delegate:self sel:@selector(requestGoldInfo:)];
    
}

-(void)requestGoldInfo:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:dataArray[0]];
            
            _count = [dataDic valueForKey:@"count"];
            _countLabel.text = [NSString stringWithFormat:@"%@",_count];
            
        }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

- (IBAction)leftBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            MineGoldMingxiVC *vc = [MineGoldMingxiVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self.navigationController.navigationBar setHidden:NO];
}

@end
