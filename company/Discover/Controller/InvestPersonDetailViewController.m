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
#import "RenzhengViewController.h"
#import "CircleShareBottomView.h"
#import "CirclePersonVC.h"
#import "InvestCommitProjectVC.h"

#define SHAREINVESTOR @"requestShareInvestor"
#define INVESTDETAIL  @"requestInvestorDetail"
#define INVESTORCOLLECT @"requestInvestorCollect"

@interface InvestPersonDetailViewController ()<UIScrollViewDelegate>


@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareContent;
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

@property (nonatomic, strong) UIButton *circleBtn;
@property (nonatomic, strong) UIButton *commitBtn;    //提交按钮
@property (nonatomic, strong) UIButton *attentionBtn;  //关注按钮

@property (nonatomic, strong) InvestDetailModel *model;

@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@end

@implementation InvestPersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSLog(@"zhuangtai--%@----zhi---%@",_authenticName,_identiyTypeId);
    // Do any additional setup after loading the view from its nib.
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:INVESTDETAIL];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:SHAREINVESTOR];
    self.investorCollectPartner = [TDUtil encryKeyWithMD5:KEY action:INVESTORCOLLECT];
    
    [self startLoadData];
    [self createUI];
    
//    [self startLoadShare];
    
}

//-(void)startLoadShare
//{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",self.investorId,@"investorId",self.type,@"type", nil];
//    //开始请求
//    [self.httpUtil getDataFromAPIWithOps:REQUEST_SHARE_INVESTOR postParam:dic type:0 delegate:self sel:@selector(requestShareContent:)];
//}
//-(void)requestShareContent:(ASIHTTPRequest *)request
//{
//    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
////        NSLog(@"返回:%@",jsonString);
//    NSMutableDictionary* jsonDic = [jsonString JSONValue];
//    if (jsonDic !=nil) {
//        NSString *status = [jsonDic valueForKey:@"status"];
//        if ([status integerValue] == 200) {
//            NSDictionary *data = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
//            _shareUrl = data[@"url"];
//            _shareImage = data[@"image"];
//            _shareContent = data[@"content"];
//            
//        }else{
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
//        }
//    }
//}

-(void)startLoadData
{
//    NSLog(@"----%@",self.investorId);
//    NSLog(@"----- 数量%@",self.attentionCount);
//    self.loadingViewFrame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64);
//    self.startLoading = YES;
//    self.isTransparent = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.partner,@"partner",self.investorId,@"investorId", VERSION,@"version",nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:INVEST_LIST_DETAIL postParam:dic type:1 delegate:self sel:@selector(requestInvestDetail:)];
}

-(void)requestInvestDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
//            self.startLoading = NO;
            InvestDetailModel *detailModel =[InvestDetailModel mj_objectWithKeyValues:jsonDic[@"data"]];
            self.collected = detailModel.collected;
            self.attentionCount = [NSString stringWithFormat:@"%ld",(long)detailModel.collectCount];
            
            _model = detailModel;

    
        }else{
//            self.startLoading = NO;
          [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}
#pragma mark -搭建UI
-(void)createUI
{
    //认证信息
    DetailAuthentics *authentics = _model.user.authentics[0];
    if (authentics.identiytype.identiyTypeId == 1) {//项目方
        self.titleText = @"个人 · 简介";
        self.titleStr = @"项目方详情";
    }
    if (authentics.identiytype.identiyTypeId == 2) {//投资人
        self.titleText = @"个人 · 简介";
        self.titleStr = @"投资人详情";
    }
    if (authentics.identiytype.identiyTypeId == 3) {//投资机构
        self.titleText = @"机构 · 简介";
        self.titleStr = @"投资机构详情";
    }
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
    _titleLabel.text = self.titleStr;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_top).offset(30);
        make.centerX.equalTo(_scrollView);
        make.height.mas_equalTo(18);
    }];
    //左返回箭头
    _leftBackBtn = [[UIButton alloc]init];
    [_leftBackBtn setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    _leftBackBtn.tag = 60;
    
//    _leftBackBtn.size = CGSizeMake(80, 30);
    _leftBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [_leftBackBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_leftBackBtn];
    [_leftBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.mas_equalTo(_scrollView.mas_left).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
//    //分享按钮
//    _shareBtn = [[UIButton alloc]init];
//    _shareBtn.tag = 61;
//    [_shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"write-拷贝-2"] forState:UIControlStateNormal];
//    [_scrollView addSubview:_shareBtn];
//    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_titleLabel);
//        make.right.mas_equalTo(_scrollView.mas_right).offset(-22);
//    }];
    
    //白色地板
    _whiteView = [InvestPersonWhiteImageView instancetationInvestPersonWhiteImageView];
    [_whiteView.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.user.headSculpture]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    _whiteView.nameLabel.text = _model.user.name;
    
    
    _whiteView.positionLabel.text = authentics.position;
//    _whiteView.companyLabel.text = authentics.companyName;
    DetailCity *city = authentics.city;
    DetailProvince *province = city.province;
    _whiteView.companyLabel.text = authentics.companyName;
    if ([city.name isEqualToString:@"北京市"] || [city.name isEqualToString:@"上海市"] || [city.name isEqualToString:@"天津市"] || [city.name isEqualToString:@"重庆市"] || [city.name isEqualToString:@"香港"] || [city.name isEqualToString:@"澳门"] || [city.name isEqualToString:@"钓鱼岛"]) {
        _whiteView.addressLabel.text = [NSString stringWithFormat:@"%@",province.name];
    }else{
        _whiteView.addressLabel.text = [NSString stringWithFormat:@"%@ | %@",province.name,city.name];
    }
    //拿到投资领域
    _whiteView.areas = _model.areas;
    //领域赋值
    
    [_scrollView addSubview:_whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(_scrollView);
        make.left.mas_equalTo(_scrollView.mas_left).offset(30);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-30);
        make.height.mas_equalTo(300*HEIGHTCONFIG);
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

    NSString *string =  authentics.introduce;
//    _personContent.text = authentics.introduce;
    if (authentics.identiytype.identiyTypeId == 3) {//投资机构
        string = authentics.companyIntroduce;
    }
//    UIColor *color = [UIColor whiteColor];
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    NSAttributedString *atrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle}];
    
//    _personContent.attributedText = string;
    _personContent.text = string;
    CGFloat height = [string commonStringHeighforLabelWidth:SCREENWIDTH-72 withFontSize:14] + 20;
    [_scrollView addSubview:_personContent];
    [_personContent  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_personLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_mengBanView.mas_left).offset(18);
        make.right.mas_equalTo(_mengBanView.mas_right).offset(-18);
        make.height.mas_equalTo(height);
    }];
//    _personContent.isAttributedContent = YES;
    //蒙版约束
    [_mengBanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_scrollView.mas_left).offset(18);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-18);
        make.top.mas_equalTo(_whiteView.mas_bottom).offset(20);
        make.bottom.mas_equalTo(_personContent.mas_bottom).offset(10);
    }];
    
    //圈子按钮
    _circleBtn = [UIButton new];
    [_circleBtn addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_circleBtn setImage:[UIImage imageNamed:@"icon_circleBtn"] forState:UIControlStateNormal];
    [_circleBtn setTitle:@" 圈子话题" forState:UIControlStateNormal];
    [_circleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_circleBtn setBackgroundColor:orangeColor];
    _circleBtn.layer.cornerRadius = 3;
    _circleBtn.layer.masksToBounds = YES;
    _circleBtn.titleLabel.font = BGFont(16);
    
    [_scrollView addSubview:_circleBtn];
    //提交按钮
    _commitBtn = [[UIButton alloc]init];
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"icon_commit_pro"] forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitBtn];
    
    //关注按钮
    _attentionBtn = [[UIButton alloc]init];
    _attentionBtn.layer.cornerRadius =3;
    _attentionBtn.layer.masksToBounds = YES;
    [_attentionBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    [_attentionBtn setImage:[UIImage imageNamed:@"icon-guanzhu"] forState:UIControlStateNormal];
    [_attentionBtn.titleLabel setFont:BGFont(16)];
    
    if (_collected) {
        [_attentionBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnCray];
    }else{
    [_attentionBtn setTitle:[NSString stringWithFormat:@" 关注(%@)",self.attentionCount] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundColor:btnGreen];
    }
    [_scrollView addSubview:_attentionBtn];
    
    if (_isCircle) {
        
        [_circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mengBanView.mas_bottom).offset(27);
            make.right.mas_equalTo(_scrollView.mas_centerX).offset(-20);
                    make.width.mas_equalTo(125*WIDTHCONFIG);
                    make.height.mas_equalTo(30*WIDTHCONFIG);
        }];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_scrollView.mas_centerX).offset(20);
            make.width.height.mas_equalTo(_circleBtn);
            make.top.mas_equalTo(_circleBtn.mas_top);
        }];
        
    }else{
    if ([self.identiyTypeId isEqualToString:@"1"]) {
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mengBanView.mas_bottom).offset(27);
            make.right.mas_equalTo(_scrollView.mas_centerX).offset(-20);
            //        make.width.mas_equalTo(90);
            //        make.height.mas_equalTo(30);
        }];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_scrollView.mas_centerX).offset(20);
            make.width.height.mas_equalTo(_commitBtn);
            make.top.mas_equalTo(_commitBtn.mas_top);
        }];
    }else{
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_mengBanView.mas_bottom).offset(27);
            make.centerX.mas_equalTo(_scrollView.mas_centerX);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(40);
        }];
    }
    }
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_attentionBtn.mas_bottom).offset(69);
    }];
    
}

-(void)btnClick:(UIButton*)btn
{
    //返回按钮点击处理
    if (btn.tag == 60) {
        
        if (_selectedNum == 1) {
            NSInteger index =  [_viewController.investPersonArray indexOfObject:_viewController.investModel];
            
                _viewController.investModel.collected  = _collected;
                if (_collected) {
                    _viewController.investModel.collectCount++;
                }else{
                    _viewController.investModel.collectCount--;
                }
                [_viewController.investPersonArray replaceObjectAtIndex:index withObject:_viewController.investModel];
                [_viewController.tableView reloadData];
            
        }
        if (_selectedNum == 2) {
            NSInteger index = [_viewController.investOrganizationSecondArray indexOfObject:_viewController.investModel];
            
                _viewController.investModel.collected = _collected;
                if (_collected) {
                    _viewController.investModel.collectCount ++;
                }else{
                    _viewController.investModel.collectCount --;
                }
                [_viewController.investOrganizationSecondArray replaceObjectAtIndex:index withObject:_viewController.investModel];
                [_viewController.tableView reloadData];
            
        }
        if (_isMine) {
            if (!_collected) {
                
                NSInteger index = [_attentionVC.investArray indexOfObject:_attentionVC.selectedListModel];
                [_attentionVC.investArray removeObject:_attentionVC.selectedListModel];
                [_attentionVC.identifyArray removeObjectAtIndex:index];
                [_attentionVC.investTableView reloadData];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark ----------------------  圈子按钮  -----------------------
-(void)circleBtnClick:(UIButton*)btn
{
//    NSLog(@"投资人圈子入口");
    CirclePersonVC *vc = [CirclePersonVC new];
    vc.titleStr = [NSString stringWithFormat:@"%@的话题",_model.user.name];
    vc.userId = self.investorId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----------------------  提交按钮  -----------------------
-(void)commitClick:(UIButton*)btn
{

        InvestCommitProjectVC *vc = [InvestCommitProjectVC new];
        vc.model = _listModel;
        
        [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark ---------------------- 关注按钮  -------------------------
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
//        NSLog(@"dayin模型----%@",_model.user);
//        NSLog(@"打印flag---%@",flag);
//        NSLog(@"打印partner---%@",self.investorCollectPartner);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.investorCollectPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_model.user.userId],@"userId",flag,@"flag", nil];
//        NSLog(@"数据字典---%@",dic);
    _attentionBtn.enabled = NO;
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:REQUEST_INVESTOR_COLLECT postParam:dic type:0 delegate:self sel:@selector(requestInvestorCollect:)];
   
}
-(void)requestInvestorCollect:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
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
                
                [_attentionBtn  setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)--count] forState:UIControlStateNormal];
                [_attentionBtn setBackgroundColor:btnGreen];
            }
            _attentionCount = [NSString stringWithFormat:@"%ld",(long)count];
            
//            NSLog(@"关注成功");
        }else{
//            NSLog(@"关注失败");
        }
    }
    _attentionBtn.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSLog(@"zhuangtai--%@----zhi---%@",_authenticName,_identiyTypeId);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[UIButton new]];
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self cancleRequest];
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
