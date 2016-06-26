//
//  InvestPersonDetailViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestPersonDetailViewController.h"
#import "InvestPersonWhiteImageView.h"
#import "InvestDetailModel.h"

#import "CircleShareBottomView.h"

#import "InvestCommitProjectVC.h"

#define SHAREINVESTOR @"requestShareInvestor"
#define INVESTDETAIL  @"requestInvestorDetail"

@interface InvestPersonDetailViewController ()<UIScrollViewDelegate,CircleShareBottomViewDelegate>


@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic, strong) UIImageView *background;//背景
@property (nonatomic, strong) UIScrollView *scrollView;  //滑动视图
@property (nonatomic, strong) InvestPersonWhiteImageView *whiteView;    //白色地板视图

@property (nonatomic, strong) UIButton *leftBackBtn; //左返回按钮
@property (nonatomic, strong) UILabel *titleLabel;   //标题
@property (nonatomic, strong) UIButton *shareBtn;    //分享按钮

@property (nonatomic, strong) UIView  *mengBanView;    //蒙版
@property (nonatomic, strong) UIView *leftLine;    //  左边线
@property (nonatomic, strong) UIView *rightLine;    //右边线
@property (nonatomic, strong) UILabel *personLabel;    //个人简介
@property (nonatomic, strong) UILabel *personContent;    //简介内容

@property (nonatomic, strong) UIButton *commitBtn;    //提交按钮
@property (nonatomic, strong) UIButton *attentionBtn;  //关注按钮

@property (nonatomic, strong) InvestDetailModel *model;

@end

@implementation InvestPersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:INVESTDETAIL];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:SHAREINVESTOR];
    
    [self startLoadData];
    [self startLoadShare];
    
}
-(void)startLoadShare
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",self.investorId,@"investorId",self.type,@"type", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_SHARE_INVESTOR postParam:dic type:0 delegate:self sel:@selector(requestShareContent:)];
}
-(void)requestShareContent:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *data = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            _shareUrl = data[@"url"];
            _shareImage = data[@"image"];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}


-(void)startLoadData
{
//    NSLog(@"----%@",self.investorId);
//    NSLog(@"----- 数量%@",self.attentionCount);
    [SVProgressHUD show];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.investorId,@"investorId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:INVEST_LIST_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestInvestDetail:)];
}

-(void)requestInvestDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            InvestDetailModel *detailModel =[InvestDetailModel mj_objectWithKeyValues:jsonDic[@"data"]];
            _model = detailModel;
//            NSLog(@"dayin模型----%@",_model);
            [self createUI];
            
        }else{
          [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
    
    [SVProgressHUD dismiss];
}
#pragma mark -搭建UI
-(void)createUI
{
    //背景
    _background = [[UIImageView alloc]init];
    _background.image = [UIImage imageNamed:@"touziren-bg"];
    [self.view addSubview:_background];
    [_background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    //滚动视图
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate =self;
//    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"个人资料";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_top).offset(25);
        make.centerX.equalTo(_scrollView);
        make.height.mas_equalTo(18);
    }];
    //左返回箭头
    _leftBackBtn = [[UIButton alloc]init];
    [_leftBackBtn setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    _leftBackBtn.tag = 60;
    _leftBackBtn.size = CGSizeMake(32, 20);
    [_leftBackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_leftBackBtn];
    [_leftBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.mas_equalTo(_scrollView.mas_left).offset(12);
    }];
    //分享按钮
    _shareBtn = [[UIButton alloc]init];
    _shareBtn.tag = 61;
    [_shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"write-拷贝-2"] forState:UIControlStateNormal];
    [_scrollView addSubview:_shareBtn];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-22);
    }];
    
    //白色地板
    _whiteView = [InvestPersonWhiteImageView instancetationInvestPersonWhiteImageView];
    [_whiteView.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.user.headSculpture]] placeholderImage:[UIImage new]];
    _whiteView.nameLabel.text = _model.user.name;
    
    DetailAuthentics *authentics = _model.user.authentics[0];
    _whiteView.positionLabel.text = authentics.position;
    _whiteView.companyLabel.text = authentics.companyName;
    _whiteView.addressLabel.text = authentics.companyAddress;
    //拿到投资领域
    NSArray *fieldArray = _model.areas;
    
    [_scrollView addSubview:_whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(_scrollView);
        make.left.mas_equalTo(_scrollView.mas_left).offset(30);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-30);
        make.height.mas_equalTo(300);
    }];
    //蒙版
    _mengBanView = [[UIView alloc]init];
    _mengBanView.backgroundColor = [UIColor whiteColor];
    _mengBanView.alpha = 0.3;
    _mengBanView.layer.cornerRadius = 3;
    _mengBanView.layer.masksToBounds = YES;
    [_scrollView addSubview:_mengBanView];
    
    //个人简介
    _personLabel = [[UILabel alloc]init];
//    _personLabel.text =@"个人 · 简介";
    _personLabel.text = self.titleText;
    _personLabel.textColor = [UIColor whiteColor];
    _personLabel.textAlignment = NSTextAlignmentCenter;
    _personLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_personLabel];
    [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mengBanView.mas_top).offset(15);
        make.centerX.equalTo(_mengBanView);
        make.height.mas_equalTo(15);
    }];
    _leftLine = [[UIView alloc]init];
    _leftLine.backgroundColor = orangeColor;
    [_scrollView addSubview:_leftLine];
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_personLabel);
        make.right.mas_equalTo(_personLabel.mas_left).offset(-1);
        make.height.mas_equalTo(_personLabel);
        make.width.mas_equalTo(2);
    }];
    _rightLine = [[UIView alloc]init];
    _rightLine.backgroundColor = orangeColor;
    [_scrollView addSubview:_rightLine];
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_personLabel);
        make.left.mas_equalTo(_personLabel.mas_right).offset(1);
        make.height.mas_equalTo(_personLabel);
        make.width.mas_equalTo(2);
    }];
    //简介内容
    _personContent = [[UILabel alloc]init];
    _personContent.textColor = [UIColor whiteColor];
    _personContent.textAlignment = NSTextAlignmentLeft;
    _personContent.font = [UIFont systemFontOfSize:14];
    _personContent.numberOfLines = 0;
    _personContent.text = authentics.introduce;
    CGFloat height = [_personContent.text commonStringHeighforLabelWidth:SCREENWIDTH-72 withFontSize:14] + 20;
    [_scrollView addSubview:_personContent];
    [_personContent  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_personLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_mengBanView.mas_left).offset(18);
        make.right.mas_equalTo(_mengBanView.mas_right).offset(-18);
        make.height.mas_equalTo(height);
    }];
    //蒙版约束
    [_mengBanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).offset(18);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-18);
        make.top.mas_equalTo(_whiteView.mas_bottom).offset(20);
        make.bottom.mas_equalTo(_personContent.mas_bottom).offset(10);
    }];
    
    //提交按钮
    _commitBtn = [[UIButton alloc]init];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"icon-commit"] forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitBtn];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mengBanView.mas_bottom).offset(27);
        make.right.mas_equalTo(_scrollView.mas_centerX).offset(-23);
//        make.width.mas_equalTo(90);
//        make.height.mas_equalTo(30);
    }];
    //关注按钮
    _attentionBtn = [[UIButton alloc]init];
    _attentionBtn.layer.cornerRadius =3;
    _attentionBtn.layer.masksToBounds = YES;
    
    [_attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_attentionBtn setImage:[UIImage imageNamed:@"icon-guanzhu"] forState:UIControlStateNormal];
    [_attentionBtn.titleLabel setFont:BGFont(14)];
    
    if (_collected) {
        [_attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnCray];
    }else{
    [_attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%@)",self.attentionCount] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnGreen];
    }
    [_scrollView addSubview:_attentionBtn];
    [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_centerX).offset(23);
        make.width.height.mas_equalTo(_commitBtn);
        make.top.mas_equalTo(_commitBtn.mas_top);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_attentionBtn.mas_bottom).offset(69);
    }];
    
}

-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 60) {
        
        if (_selectedNum == 1) {
            NSInteger index =  [_viewController.investPersonArray indexOfObject:_viewController.investModel];
            if (index) {
                _viewController.investModel.collected  = _collected;
                if (_collected) {
                    _viewController.investModel.collectCount++;
                }else{
                    _viewController.investModel.collectCount--;
                }
                [_viewController.investPersonArray replaceObjectAtIndex:index withObject:_viewController.investModel];
                [_viewController.tableView reloadData];
            }
            
        }
        if (_selectedNum == 2) {
            NSInteger index = [_viewController.investOrganizationSecondArray indexOfObject:_viewController.investModel];
            if (index) {
                _viewController.investModel.collected = _collected;
                if (_collected) {
                    _viewController.investModel.collectCount ++;
                }else{
                    _viewController.investModel.collectCount --;
                }
                [_viewController.investOrganizationSecondArray replaceObjectAtIndex:index withObject:_viewController.investModel];
                [_viewController.tableView reloadData];
            }
            
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
#pragma mark -----分享
    if (btn.tag == 61) {
        [self startShare];
    }
}

#pragma mark -开始分享

- (UIView*)topView {
    UIViewController *recentView = self;
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

/**
 *  点击空白区域shareView消失
 */

- (void)dismissBG
{
    if(self.bottomView != nil)
    {
        [self.bottomView removeFromSuperview];
    }
}

-(void)startShare
{
    NSArray *titleList = @[@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareViewWithTitleArray:titleList imageArray:imageList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBG)];
    [share addGestureRecognizer:tap];
    [[self topView] addSubview:share];
    self.bottomView = share;
    share.delegate = self;
}
-(void)sendShareBtnWithView:(CircleShareBottomView *)view index:(int)index
{
    //分享
    if (view.tag == 1) {
        //得到用户SID
        //        UIImage * shareImage = [UIImage imageNamed:@"share_jixiangwu"];
        NSString *shareContentString = [NSString stringWithFormat:@"快来一起玩\n%@",_shareUrl];
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
                    [UMSocialData defaultData].extConfig.qqData.title = @"金指投";
                    [UMSocialData defaultData].extConfig.qzoneData.title = @"金指投";
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
                break;
            case 1:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"金指投";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"金指投";
                
                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"金指投";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"金指投";
                
                NSLog(@"分享到朋友圈");
            }
                break;
            case 3:{
                // 短信
                arr = @[UMShareToSms];
                shareContent = shareContentString;
                
                NSLog(@"分享短信");
            }
                break;
            case 100:{
                [self dismissBG];
            }
                break;
            default:
                break;
        }
        if(arr == nil)
        {
            return;
        }
        //        if ([[arr objectAtIndex:0] isEqualToString:UMShareToSms]) {
        //            shareImage = nil;
        //        }
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self performSelector:@selector(dismissBG) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
                    
                    
                });
            }
        }];
    }
}


#pragma mark -----  提交按钮
-(void)commitClick:(UIButton*)btn
{
    InvestCommitProjectVC *vc = [InvestCommitProjectVC new];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.tabBar tabBarHidden:YES animated:NO];
    vc.model = _listModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ----- 关注按钮
-(void)attentionClick:(UIButton*)btn
{
    _collected = !_collected;
    NSString *flag;
    if (_collected) {
        //关注
        flag = @"1";
        
    }else{
        //quxiao关注
        flag = @"2";
        
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.investorCollectPartner,@"partner",[NSString stringWithFormat:@"%ld",_model.user.userId],@"userId",flag,@"flag", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:REQUEST_INVESTOR_COLLECT postParam:dic type:0 delegate:self sel:@selector(requestInvestorCollect:)];
}
-(void)requestInvestorCollect:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
           NSInteger  count=  [_attentionCount integerValue];
            
            if (_collected) {
                count ++;
                
                [_attentionBtn  setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                [_attentionBtn setBackgroundColor:btnCray];
                
                
            }else{
                
                [_attentionBtn  setTitle:[NSString stringWithFormat:@" 关注(%ld)",--count] forState:UIControlStateNormal];
                [_attentionBtn setBackgroundColor:btnGreen];
            }
            _attentionCount = [NSString stringWithFormat:@"%ld",count];
            

            NSLog(@"关注成功");
        }else{
            NSLog(@"关注失败");
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
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
