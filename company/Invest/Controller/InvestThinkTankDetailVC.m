//
//  InvestThinkTankDetailVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "InvestThinkTankDetailVC.h"
#import "InvestDetailModel.h"
#import "CircleShareBottomView.h"

#define INVESTDETAIL  @"requestInvestorDetail"

#define SHAREINVESTOR @"requestShareInvestor"

@interface InvestThinkTankDetailVC ()<UIScrollViewDelegate,CircleShareBottomViewDelegate>

@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic, strong) UIImageView *backgroundImage;  //背景图片
@property (nonatomic, strong) UIScrollView *scrollView;     // 滚动视图

@property (nonatomic, strong) UIButton *leftBack;      //返回按钮
@property (nonatomic, strong) UIButton *shareBtn;      //分享按钮
@property (nonatomic, strong) UILabel *titleLabel;       //标题

@property (nonatomic, strong) UIImageView *whiteImage;  //白色底板
@property (nonatomic, strong) UIImageView *iconImage;    //头像
@property (nonatomic, strong) UILabel *name;       //名字
@property (nonatomic, strong) UILabel *posiotion;  //职位
@property (nonatomic, strong) UILabel *company;    //公司
@property (nonatomic, strong) UIView *bottonLine;  //下划线
@property (nonatomic, strong) UILabel *address;    //地址

@property (nonatomic, strong) UIView *firstView;   //第一个透明的View
@property (nonatomic, strong) UIView *secondView;  //第二个透明的View

@property (nonatomic, strong) UIView *firstLeftView; //左边分隔
@property (nonatomic, strong) UIView *firstRightView; //右边分隔
@property (nonatomic, strong) UILabel *fieldLabel;  //领域label
@property (nonatomic, strong) UILabel *fieldContent; //领域内容

@property (nonatomic, strong) UIView *secondLeftView ; //左边分隔
@property (nonatomic, strong) UIView *secondRightView; //右边分隔
@property (nonatomic, strong) UILabel *personLabel;    //个人简介
@property (nonatomic, strong) UILabel *personContent;  //个人内容

@property (nonatomic, strong) UIButton *attationBtn;

@property (nonatomic, strong) InvestDetailModel *model;

@end

@implementation InvestThinkTankDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //1、设置当有导航栏自动添加64高度的属性为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获得partner
    self.partner = [TDUtil encryKeyWithMD5:KEY action:INVESTDETAIL];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:SHAREINVESTOR];
    
    
    [self startLoadData];
//    [self startLoadShare];
    
//    [self setKeyScrollView:_scrollView scrolOffsetY:300 options:nil];
    [self createUI];
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
            _shareContent = data[@"content"];
            
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
    [self.httpUtil getDataFromAPIWithOps:INVEST_LIST_DETAIL postParam:dic type:1 delegate:self sel:@selector(requestInvestDetail:)];
}

-(void)requestInvestDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            InvestDetailModel *detailModel =[InvestDetailModel mj_objectWithKeyValues:jsonDic[@"data"]];
            _model = detailModel;
            
//            NSLog(@"dayin模型----%@",_model);
            //2.设置导航栏内容
//            [self setUpNavBar];
            
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
    
    [SVProgressHUD dismiss];
}
#pragma mark- 设置导航栏
-(void)setUpNavBar
{
    self.navigationItem.title = @"个人资料";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(45, 30);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
//    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.tag = 1;
//    [shareBtn setBackgroundImage:[UIImage imageNamed:@"write-拷贝-2"] forState:UIControlStateNormal];
//    shareBtn.size = shareBtn.currentBackgroundImage.size;
//    [shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
}
-(void)createUI
{   //背景图片
    _backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _backgroundImage.image = [UIImage imageNamed:@"touziren-bg"];
    [self.view addSubview:_backgroundImage];
    //滚动视图
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    
    //标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"个人资料";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [_scrollView addSubview:_titleLabel];
    
    //返回按钮
    _leftBack = [[UIButton alloc]init];
    [_leftBack setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    _leftBack.tag = 0;
//    _leftBack.size = CGSizeMake(45, 30);
//    _leftBack.size = CGSizeMake(80, 30);
    _leftBack.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [_leftBack addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_leftBack];
    
//    //分享
//    _shareBtn = [[UIButton alloc]init];
//    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"write-拷贝-2"] forState:UIControlStateNormal];
//    _shareBtn.tag = 1;
//    [_shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:_shareBtn];
    
    //白色底板
    _whiteImage = [[UIImageView alloc]init];
    _whiteImage.image = [UIImage imageNamed:@"圆角矩形-4-拷贝-2"];
    [_scrollView addSubview:_whiteImage];
    //头像
    _iconImage = [[UIImageView alloc]init];
    _iconImage.layer.cornerRadius = 47;
    _iconImage.layer.masksToBounds = YES;
    [_whiteImage addSubview:_iconImage];
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
//    [_iconImage setBackgroundColor:[UIColor redColor]];
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.user.headSculpture]] placeholderImage:[UIImage new]];
    //名字
    _name = [[UILabel alloc]init];
    _name.textColor = [UIColor blackColor];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.font = [UIFont systemFontOfSize:15];
    [_whiteImage addSubview:_name];
    _name.text = _model.user.name;
    //职位
    _posiotion = [[UILabel alloc]init];
    _posiotion.textAlignment = NSTextAlignmentLeft;
    _posiotion.textColor = [UIColor darkTextColor];
    _posiotion.font = [UIFont systemFontOfSize:10];
    [_whiteImage addSubview:_posiotion];
    DetailAuthentics *authentics = _model.user.authentics[0];
    
    _posiotion.text = authentics.position;
    //公司
    _company = [[UILabel alloc]init];
    _company.textColor = [UIColor darkTextColor];
    _company.textAlignment = NSTextAlignmentCenter;
    _company.font = [UIFont systemFontOfSize:13];
    [_whiteImage addSubview:_company];
    _company.text = authentics.companyName;
    //下划线
    _bottonLine = [[UIView alloc]init];
    _bottonLine.backgroundColor = [UIColor darkGrayColor];
    [_whiteImage addSubview:_bottonLine];
    //地址
    _address  = [[UILabel alloc]init];
    _address.textColor = [UIColor darkTextColor];
    _address.font = [UIFont systemFontOfSize:10];
    _address.textAlignment = NSTextAlignmentCenter;
    [_whiteImage addSubview:_address];
    DetailCity *city = authentics.city;
    DetailProvince *province = city.province;
    _address.text = [NSString stringWithFormat:@"%@ | %@",province.name,city.name];
    
    //透明的View
    _firstView = [[UIView alloc]init];
    _firstView.backgroundColor = [UIColor whiteColor];
    _firstView.alpha = 0.3;
    _firstView.layer.cornerRadius = 3;
    _firstView.layer.masksToBounds = YES;
    [_scrollView addSubview:_firstView];
    //左分隔线
    _firstLeftView = [[UIView alloc]init];
    _firstLeftView.backgroundColor = orangeColor;
    [_scrollView addSubview:_firstLeftView];
    //服务领域
    _fieldLabel = [[UILabel alloc]init];
    _fieldLabel.textAlignment = NSTextAlignmentCenter;
    _fieldLabel.textColor = [UIColor whiteColor];
    _fieldLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_fieldLabel];
    _fieldLabel.text = @"服务·领域";
    //又分隔线
    _firstRightView = [[UIView alloc]init];
    _firstRightView.backgroundColor = orangeColor;
    [_scrollView addSubview:_firstRightView];
    //领域内容
//    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 35 * 2;
    _fieldContent = [[UILabel alloc]init];
    _fieldContent.textColor = [UIColor whiteColor];
    _fieldContent.textAlignment = NSTextAlignmentLeft;
    _fieldContent.font = [UIFont systemFontOfSize:12];
//    _fieldContent.preferredMaxLayoutWidth = maxWidth;
    _fieldContent.numberOfLines =0;
    
    
    [_scrollView addSubview:_fieldContent];
    //第二个透明的View
    _secondView = [[UIView alloc]init];
    _secondView.backgroundColor = [UIColor whiteColor];
    _secondView.alpha = 0.3;
    _secondView.layer.cornerRadius = 3;
    _secondView.layer.masksToBounds = YES;
    [_scrollView addSubview:_secondView];
    //分隔线
    _secondLeftView = [[UIView alloc]init];
    _secondLeftView.backgroundColor = orangeColor;
    [_scrollView  addSubview:_secondLeftView];
    //个人简介
    _personLabel = [[UILabel alloc]init];
    _personLabel.textColor = [UIColor whiteColor];
    _personLabel.textAlignment = NSTextAlignmentCenter;
    _personLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_personLabel];
    _personLabel.text = @"个人·简介";
    //右分隔线
    _secondRightView = [[UIView alloc]init];
    _secondRightView.backgroundColor = orangeColor;
    [_scrollView addSubview:_secondRightView];
    //个人内容
    _personContent = [[UILabel alloc]init];
    _personContent.textAlignment = NSTextAlignmentLeft;
    _personContent.textColor = [UIColor whiteColor];
    _personContent.font = [UIFont systemFontOfSize:12];
//    _personContent.preferredMaxLayoutWidth = maxWidth;
    _personContent.numberOfLines = 0;
    
    
    
    [_scrollView addSubview:_personContent];
    //关注按钮
    _attationBtn = [[UIButton alloc]init];
    [_attationBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_attationBtn setImage:[UIImage imageNamed:@"icon-guanzhu"] forState:UIControlStateNormal];
    _attationBtn.layer.cornerRadius = 5;
    _attationBtn.layer.masksToBounds = YES;
    _attationBtn.titleLabel.textColor = [UIColor whiteColor];
    _attationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:_attationBtn];
    
    if (_collected) {
        [_attationBtn setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
        [_attationBtn setBackgroundColor:btnCray];
    }else{
        [_attationBtn setTitle:[NSString stringWithFormat:@" 关注(%@)",self.attentionCount] forState:UIControlStateNormal];
        [_attationBtn setBackgroundColor:btnGreen];
    }
    //添加约束
    //背景图片
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    //滚定视图
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    //标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_top).offset(25);
        make.centerX.equalTo(_scrollView);
        make.height.mas_equalTo(18);
    }];
    //返回按钮
    [_leftBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.mas_equalTo(_scrollView.mas_left).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    //分享按钮
//    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_titleLabel);
//        make.right.mas_equalTo(_scrollView.mas_right).offset(-22);
//    }];

    //白色底板
    [_whiteImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollView);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(_scrollView.mas_left).offset(50);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-50);
        make.height.mas_equalTo(250);
    }];
    //头像
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_whiteImage);
        make.width.height.mas_equalTo(94);
        make.top.mas_equalTo(_whiteImage.mas_top).offset(35);
    }];
    //名字
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_whiteImage);
        make.top.mas_equalTo(_iconImage.mas_bottom).offset(17);
        make.height.mas_equalTo(15);
    }];
    //职位
    [_posiotion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_name.mas_right).offset(8);
        make.bottom.mas_equalTo(_name.mas_bottom);
        make.height.mas_equalTo(11);
    }];
    //公司
    [_company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_whiteImage);
        make.top.mas_equalTo(_name.mas_bottom).offset(17);
        make.height.mas_equalTo(13);
    }];
    //下划线
    [_bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_company.mas_bottom);
        make.centerX.mas_equalTo(_whiteImage);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(_company);
    }];
    //地址
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_whiteImage);
        make.top.mas_equalTo(_bottonLine.mas_bottom).offset(10);
        make.height.mas_equalTo(11);
    }];
   
    //服务领域
    [_fieldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_firstView.mas_top).offset(15);
        make.centerX.mas_equalTo(_firstView);
        make.height.mas_equalTo(13);
    }];
    //分隔线
    [_firstLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_fieldLabel);
        make.height.mas_equalTo(13);
        make.right.mas_equalTo(_fieldLabel.mas_left).offset(-1);
        make.width.mas_equalTo(2);
    }];
    [_firstRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_fieldLabel);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(2);
        make.left.mas_equalTo(_fieldLabel.mas_right).offset(1);
    }];
    //领域内容
    _fieldContent.text = authentics.companyIntroduce;
    
    CGFloat height1 = [_fieldContent.text commonStringHeighforLabelWidth:SCREENWIDTH-72 withFontSize:12];
    [_fieldContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_fieldLabel.mas_bottom).offset(19);
        make.left.mas_equalTo(_firstView.mas_left).offset(18);
        make.right.mas_equalTo(_firstView.mas_right).offset(-18);
        make.height.mas_equalTo(height1);
    }];
    //第一个透明的View
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollView);
        make.top.mas_equalTo(_whiteImage.mas_bottom).offset(20);
        make.left.mas_equalTo(_scrollView.mas_left).offset(18);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-18);
        make.bottom.mas_equalTo(_fieldContent.mas_bottom).offset(17);
    }];
    //个人简介
    [_personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_secondView);
        make.top.mas_equalTo(_secondView.mas_top).offset(15);
        make.height.mas_equalTo(13);
    }];
    //左分隔线
    [_secondLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_personLabel);
        make.right.mas_equalTo(_personLabel.mas_left).offset(-1);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(2);
    }];
    [_secondRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_personLabel);
        make.left.mas_equalTo(_personLabel.mas_right).offset(1);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(2);
    }];
    //个人内容
    _personContent.text = authentics.introduce;
    
    CGFloat height2 = [_personContent.text commonStringHeighforLabelWidth:SCREENWIDTH-72 withFontSize:12] ;
    [_personContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_personLabel.mas_bottom).offset(19);
        make.left.mas_equalTo(_secondView.mas_left).offset(18);
        make.right.mas_equalTo(_secondView.mas_right).offset(-18);
        make.height.mas_equalTo(height2);
    }];
    //第二个透明的View
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollView);
        make.top.mas_equalTo(_firstView.mas_bottom).offset(20);
        make.left.mas_equalTo(_scrollView.mas_left).offset(18);
        make.right.mas_equalTo(_scrollView.mas_right).offset(-18);
        make.bottom.mas_equalTo(_personContent.mas_bottom).offset(17);
    }];
    //关注按钮
    [_attationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_secondView.mas_bottom).offset(20);
        make.left.mas_equalTo(_secondView.mas_left).offset(20);
        make.right.mas_equalTo(_secondView.mas_right).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_attationBtn.mas_bottom).offset(20);
    }];
}

#pragma mark -btnAction
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        //获得当前点击的模型在数组的位置
        NSInteger index = [_viewController.thinkTankArray indexOfObject:_viewController.investModel];
        //改变当前模型的状态属性
        _viewController.investModel.collected  = _collected;
        if (_collected) {
            _viewController.investModel.collectCount ++;
        }else{
            _viewController.investModel.collectCount --;
        }
        
        //替换模型  刷新表格
        [_viewController.thinkTankArray replaceObjectAtIndex:index withObject:_viewController.investModel];
        [_viewController.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
#pragma mark -分享按钮处理
    if (btn.tag == 1) {
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
        NSString * shareImage = _shareImage;
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_shareContent];
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
                    [UMSocialData defaultData].extConfig.qqData.title = @"金指投投融资";
                    [UMSocialData defaultData].extConfig.qzoneData.title = @"金指投投融资";
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
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"金指投投融资";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"金指投投融资";
                
//                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = @"金指投投融资";
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"金指投投融资";
                
//                NSLog(@"分享到朋友圈");
            }
                break;
            case 3:{
                // 短信
                arr = @[UMShareToSms];
                shareContent = shareContentString;
                
//                NSLog(@"分享短信");
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
                if ([[arr objectAtIndex:0] isEqualToString:UMShareToSms]) {
                    shareImage = nil;
                }
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            shareImage];
        
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self performSelector:@selector(dismissBG) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
                    
                });
            }
        }];
    }
}
#pragma mark -------关注事件处理
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.investorCollectPartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_model.user.userId],@"userId",flag,@"flag", nil];
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
                [_attationBtn  setTitle:[NSString stringWithFormat:@" 已关注"] forState:UIControlStateNormal];
                [_attationBtn setBackgroundColor:btnCray];
                
            }else{
                count --;
                
                [_attationBtn  setTitle:[NSString stringWithFormat:@" 关注(%ld)",(long)count] forState:UIControlStateNormal];
                [_attationBtn setBackgroundColor:btnGreen];
                
            }
            _attentionCount = [NSString stringWithFormat:@"%ld",(long)count];
            
            
            //                    InvestListModel * model = (InvestListModel*)klistModel;
            //                    InvestPersonCell * cell = (InvestPersonCell*)klistCell;
            //                    if (model.collected) {
            //                        model.collectCount ++;
            //                        //刷新cell
            //                        [cell.collectBtn setTitle:[NSString stringWithFormat:@" 已关注(%ld)",model.collectCount] forState:UIControlStateNormal];
            //                    }else{
            //                        //关注数量减1
            //                        model.collectCount --;
            //                        //刷新cell
            //                        [cell.collectBtn setTitle:[NSString stringWithFormat:@" 关注(%ld)",model.collectCount] forState:UIControlStateNormal];
            //                    }
            
            
            
            NSLog(@"关注成功");
        }else{
            NSLog(@"关注失败");
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationController.navigationBar setHidden:NO];
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
}
//-(void)dealloc
//{
//    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
//    [_scrollView removeFromSuperview];
//    _scrollView = nil;
//}
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
