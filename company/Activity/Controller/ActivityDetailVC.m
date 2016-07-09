//
//  ActivityDetailVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityCell.h"
#import "ActionComment.h"
#import "ActivityDetailVC.h"
#import "ActionDetailModel.h"
#import "ActivityAttendModel.h"
#import "ActivityBlackCoverView.h"
#import "ActivityDetailHeaderModel.h"
#import "ActivityDetailExerciseCell.h"
#import "ActivityDetailListCell.h"
#import "ActivityDetailFooterView.h"
#import "ActivityDetailCommentCellModel.h"
#import "ActivityDetailExiciseContentCell.h"
#import "ActivityAttendListViewController.h"
#import "ActivityCommentListViewController.h"

#import "ActivityDetailHeaderCell.h"

#import "CircleShareBottomView.h"

#define kActivityDetailHeaderCellId @"ActivityDetailHeaderCell"
static CGFloat textFieldH = 40;

#define SHAREACTION @"requestShareAction"
#define COMMENTLIST @"requestPriseListAction"
#define ATTENDACTION @"requestAttendListAction"
#define ACTIONDETAIL @"requestDetailAction"
@interface ActivityDetailVC ()<UITableViewDelegate,UITableViewDataSource,ActivityDetailFooterViewDelegate,UITextFieldDelegate,ActivityViewDelegate,ActivityBlackCoverViewDelegate,CircleShareBottomViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *signUpBtn;          //报名按钮
@property (nonatomic, strong) UIButton *shareBtn;           //分享按钮
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, copy) NSString * actionPrisePartner;
@property (nonatomic, copy) NSString * actionDetailPartner;
@property (nonatomic, copy) NSString * actionCommentPartner;
@property (nonatomic, copy) NSString * actionCommentListPartner;
@property (nonatomic, copy) NSString * actionAttendPartner;
@property (nonatomic, copy) NSString *commentToUser;
@property (nonatomic, strong) NSMutableArray *dataAttendSource;
@property (nonatomic, strong) ActivityDetailHeaderModel * headerModel;
@property (nonatomic, strong) ActivityDetailCommentCellModel *commentCellModel;

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *sharePartner;
@property (nonatomic, copy) NSString *shareImage;
@property (nonatomic, copy) NSString *shareUrl; //分享地址
@property (nonatomic, copy) NSString *contentText;
@property (nonatomic,strong)UIView * bottomView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ActivityDetailVC
{
    CGFloat _totalKeybordHeight;
    //底部点赞评论
    ActivityDetailFooterView *footerView;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setUpNavBar];
    
    
    //    [self setupTextField];
    
    //生成请求partner
    self.actionDetailPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONDETAIL];
    self.actionAttendPartner = [TDUtil encryKeyWithMD5:KEY action:ATTENDACTION];
    self.actionCommentListPartner = [TDUtil encryKeyWithMD5:KEY action:COMMENTLIST];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:SHAREACTION];
    //初始化 控件
    [self createUI];
    
    //请求数据
    [self loadActionDetailData];
    
    //获取分享数据
    [self loadShareData];
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"活动详情"];
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

#pragma mark -初始化控件
-(void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.0001f)];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    
//    if (!headerView) {
//        headerView = [ActivityDetailHeaderView new];
//        [headerView setMoreButtonClickedBlock:^(BOOL isOpen) {
//            _headerModel.isOpen = !_headerModel.isOpen;
//        }];
//    }
//    headerView.height = 360;
//    headerView.model = _headerModel;
//    _tableView.tableHeaderView = headerView;
    
    //报名按钮
    _signUpBtn = [[UIButton alloc]init];
    _signUpBtn.backgroundColor = orangeColor;
    [_signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signUpBtn.titleLabel setFont:BGFont(19)];
    [_signUpBtn addTarget:self action:@selector(attendAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_activityModel.attended)
    {
        [_signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [_signUpBtn setBackgroundColor:GrayColor];
        [_signUpBtn setEnabled:NO];
    }
    
    [self.view addSubview:_signUpBtn];
    //分享按钮
    _shareBtn = [[UIButton alloc]init];
    _shareBtn.backgroundColor = color(67, 179, 204, 1);
    [_shareBtn setTitle:@"我要分享" forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(startShare) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareBtn.titleLabel setFont:BGFont(19)];
    [self.view addSubview:_shareBtn];
    CGFloat width = SCREENWIDTH/2;
    CGFloat height = 50;
    [_signUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(width);
    }];
    
    // 回复框
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(0, SCREENHEIGHT - 50*HEIGHTCONFIG - 64, SCREENWIDTH, 50 * HEIGHTCONFIG)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_tableView.mas_bottom);
    }];
    
    view.tag = 10001;
    [view setAlpha:0];
    
    UIView *line = [UIView new];
    line.backgroundColor = colorGray;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
    //输入框
    UITextField *field = [UITextField new];
    field.placeholder = @"请输入评论内容";
    field.layer.cornerRadius = 3;
    field.layer.borderColor = colorGray.CGColor;
    field.layer.borderWidth = .5f;
    field.delegate = self;
    [field setValue:color74 forKeyPath:@"_placeholderLabel.textColor"];
    field.textAlignment = NSTextAlignmentLeft;
    field.textColor = [UIColor blackColor];
    field.font = BGFont(14);
    field.returnKeyType = UIReturnKeyDone;
    _textField = field;
    CGRect frame = [field frame];
    frame.size.width = 15.0f;
    UIView *leftView = [[UIView alloc]initWithFrame:frame];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(12);
        make.right.mas_equalTo(view.mas_right).offset(-76);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.height.mas_equalTo(36);
    }];
    
    UIButton *answerBtn = [UIButton new];
    [answerBtn setTitle:@"发表" forState:UIControlStateNormal];
    [answerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [answerBtn setBackgroundColor:colorBlue];
    answerBtn.layer.cornerRadius = 3;
    answerBtn.layer.masksToBounds = YES;
    answerBtn.titleLabel.font = BGFont(16);
    [answerBtn addTarget:self action:@selector(actionComment) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:answerBtn];
    [answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(field.mas_right).offset(5);
        make.height.mas_equalTo(field.mas_height);
        make.centerY.mas_equalTo(field.mas_centerY);
        make.right.mas_equalTo(view.mas_right).offset(-12);
    }];
}

#pragma mark--------loadShareData分享数据-------------
-(void)loadShareData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",@"4",@"type",@"1",@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_SHARE postParam:dic type:0 delegate:self sel:@selector(requestShareData:)];
}
-(void)requestShareData:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:jsonDic[@"data"]];
            
            _shareTitle = dataDic[@"title"];
            _shareUrl = dataDic[@"url"];
            _shareImage = dataDic[@"image"];
            _contentText = dataDic[@"content"];
        }
    }
}

/**
 *  获取活动列表
 */

-(void)loadActionDetailData
{
    [SVProgressHUD show];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestActionDetailList:)];
}

-(void)requestActionDetailList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //解析
            ActionDetailModel * baseModel =[ActionDetailModel mj_objectWithKeyValues:jsonDic[@"data"]];
            
            
            ActivityDetailHeaderModel *model =[ActivityDetailHeaderModel new];
            model.flag = baseModel.flag;
            model.title = baseModel.name;
            model.content = baseModel.desc;
            model.actionId = baseModel.actionId;
            
            NSArray * array = baseModel.actionimages;
            NSMutableArray* imageArray = [NSMutableArray new];
            for (Actionimages * image in array) {
                [imageArray addObject:image.url];
            }
            
            model.pictureArray = imageArray;
            
            //设置数据模型
            self.headerModel = model;
            
            //如果该数据不为空
            if (_dataArray.count) {
                [_dataArray insertObject:model atIndex:0];
            }else{
                [_dataArray addObject:model];
            }
            
            //获取项目参加人数
            [self loadActionAttendData];
            
//            NSLog(@"打印header模型---%@",self.headerModel);

//
        }
    }
}

/**
 *  获取报名人数
 */

-(void)loadActionAttendData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",@"0",@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_ATTEND postParam:dic type:0 delegate:self sel:@selector(requestActionAttendList:)];
}

-(void)requestActionAttendList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            if([jsonDic[@"data"] isKindOfClass:NSArray.class])
            {
                NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
                if (dataArray.count) {
                    ActivityAttendModel * baseModel;
                   
                    [_dataArray addObject:self.activityModel];
                    
                    [_dataArray addObject:[NSString stringWithFormat:@"%ld",(unsigned long)dataArray.count]];
                    
                    for(NSDictionary * dic in dataArray)
                    {
                        //解析
                        baseModel =[ActivityAttendModel mj_objectWithKeyValues:dic];
                        
                        [self.dataArray addObject:baseModel];
                    }

                    //点赞评论
                    [self loadActionCommentData];
                    
                }
                
            }
            
        }
    }
}

/**
 *  评论列表
 */

-(void)loadActionCommentData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionCommentListPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",@"0",@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestActionCommentList:)];
}

-(void)requestActionCommentList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSArray *dataPriseArray = [NSArray arrayWithArray:[jsonDic[@"data"] valueForKey:@"prises"]];
            NSArray *dataCommentArray = [NSArray arrayWithArray:[jsonDic[@"data"] valueForKey:@"comments"]];
            
            self.commentCellModel = [ActivityDetailCommentCellModel new];
            
            ActionComment * baseModel;
            
            NSMutableArray * tempArray = [NSMutableArray new];
            for(NSDictionary * dic in dataCommentArray)
            {
                //解析
                baseModel =[ActionComment mj_objectWithKeyValues:dic];
                
                ActivityDetailCellCommentItemModel *commentItemModel = [ActivityDetailCellCommentItemModel new];
                commentItemModel.firstUserName = baseModel.userName;
                commentItemModel.firstUserId = STRING(@"%ld", (long)baseModel.usersByUserId.userId);
                if([dic valueForKey:@"atUserName"])
                {
                    commentItemModel.secondUserName = [dic valueForKey:@"atUserName"];
                    commentItemModel.secondUserId = @"";
                    
                }
                commentItemModel.commentString = baseModel.content;
                
                [tempArray addObject:commentItemModel];
            }
            
            self.commentCellModel.commentItemsArray  = [tempArray copy];
            
            NSMutableArray *tempLikes = [NSMutableArray new];
            for (int i = 0; i < dataPriseArray.count; i++) {
                ActivityDetailCellLikeItemModel *model = [ActivityDetailCellLikeItemModel new];
                model.userName = dataPriseArray[i];
                model.userId = @"1";
                [tempLikes addObject:model];
            }
            self.commentCellModel.likeItemsArray = [tempLikes copy];
            
            
            [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
            
        }
    }
}


-(void)setHeaderModel:(ActivityDetailHeaderModel *)headerModel
{
    _headerModel = headerModel;
}

-(void)dealloc
{
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

#pragma mark --------------tableViewDataSource---------------------

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!footerView) {
        __weak typeof(self) weakSelf = self;
        
        footerView = [ActivityDetailFooterView new];
        [footerView setDidClickCommentLabelBlock:^(NSString * commentId,NSString * repleyName, CGRect rectInWindow) {
            weakSelf.textField.placeholder =[NSString stringWithFormat:@"  回复：%@",repleyName];
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            [weakSelf adjustTableViewToFitKeyboardWithRect];
        }];
        footerView.delegate = self;
    }
    
    NSLog(@"高度:%f",footerView.height);
    return footerView;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count) {
        if (self.dataArray.count >=5) {
            return 8;
        }else{
            return 3 + self.dataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        if (indexPath.row == 0) {
            return [self.tableView cellHeightForIndexPath:indexPath model:self.headerModel keyPath:@"model" cellClass:[ActivityDetailHeaderCell class] contentViewWidth:[self cellContentViewWith]];
        }
        if (indexPath.row == 1) {
            return 140;
        }
        if (indexPath.row == 2) {
            return 48;
        }
        return 67;
    }
    
    return 0.00000000001f;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    if (!footerView) {
        footerView = (ActivityDetailFooterView *)[self tableView:tableView viewForFooterInSection:section];
    }
    
    
    return footerView.height;
    
}

-(void)layout:(id)sender
{
    if(self.commentCellModel)
    {
        footerView.model = self.commentCellModel;
        
        //容器
        UIView *view = [UIView new];
        [view addSubview:footerView];
        
        view.sd_layout.widthIs(self.view.frame.size.width).autoHeightRatio(0);
        
        footerView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        //主动刷新UI
        [footerView updateLayout];
    }
    
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataArray.count) {
        
        
            if (indexPath.row  == 0) {
                static NSString *cellId =@"ActivityDetailHeaderCell";
                ActivityDetailHeaderCell *cell =[tableView dequeueReusableCellWithIdentifier:kActivityDetailHeaderCellId];
                if (!cell) {
                    cell = [[ActivityDetailHeaderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
                }
                cell.indexPath = indexPath;
                __weak typeof (self) weakSelf = self;
                if (!cell.moreButtonClickedBlock) {
                    [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                        ActivityDetailHeaderModel *model =weakSelf.headerModel;
                        model.isOpen = !model.isOpen;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }
                if (_dataArray[indexPath.row]) {
                    cell.model = _dataArray[indexPath.row];
                }
                return cell;
            }
        
       
        
            if (indexPath.row == 1) {
                static NSString *cellId = @"ActivityDetailExiciseContentCell";
                ActivityDetailExiciseContentCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:nil options:nil] lastObject];
                }
                if (_dataArray[indexPath.row]) {
                    cell.model = _dataArray[indexPath.row];
                    //               cell.model = self.activityModel;
                    return cell;
                }
            }
        
        
        
            if (indexPath.row == 2) {
                static NSString *cellId = @"ActivityDetailExerciseCell";
                ActivityDetailExerciseCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                    
                }
                if (_dataArray[indexPath.row]) {
                    cell.countLabel.text =  [NSString stringWithFormat:@"(%@)",_dataArray[indexPath.row]];
                    //                cell.countLabel.text = STRING(@"(%ld)", (unsigned long)self.dataAttendSource.count);
                    return cell;
                }
                
            }
        
            static NSString *cellId = @"ActivityDetailListCell";
            ActivityDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            //设置模型
            if (_dataArray[indexPath.row]) {
                cell.model = [self.dataArray objectAtIndex:indexPath.row];
                return cell;
            }
       
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if(row==2)
    {
        ActivityAttendListViewController * attendListViewController = [[ActivityAttendListViewController alloc]init];
        attendListViewController.activityModel = self.activityModel;
        [self.navigationController pushViewController:attendListViewController animated:YES];
    }
}

#pragma mark -btnAction
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-------startShare分享-----------
#pragma mark -开始分享

#pragma mark  转发

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
        NSString *shareContentString = [NSString stringWithFormat:@"%@",_contentText];
        NSArray *arr = nil;
        NSString *shareContent;
        
        switch (index) {
            case 0:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
                    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
                    [UMSocialData defaultData].extConfig.qzoneData.title = _shareTitle;
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
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 2:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到朋友圈");
            }
                break;
            case 3:{
                // 短信
                arr = @[UMShareToSms];
                
                shareContent = [NSString stringWithFormat:@"%@\n%@",shareContentString,_shareUrl];;
                
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
                    
                    [self performSelector:@selector(dismissBG) withObject:nil afterDelay:1.0];
                    
                    
                });
            }
        }];
    }
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES]
    ;
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)adjustTableViewToFitKeyboardWithRect
{
    
}
#pragma footerDelegate
-(void)didClickLikeButton
{
    
    if(!self.actionPrisePartner)
    {
        self.actionPrisePartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_PRISE];
    }
    
    //开始请求
    [self actionPrise];
}


-(void)didClickCommentButton
{
    if(!self.actionCommentPartner)
    {
        self.actionCommentPartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_COMMENT];
    }
    
    _commentToUser = @"0";
    [self.textField setText:@""];
    [self.textField setPlaceholder:@""];
    [self.textField becomeFirstResponder];
}

-(void)didClickShowAllButton
{
    ActivityCommentListViewController * controller  = [[ActivityCommentListViewController alloc]init];
    controller.activityModel = self.activityModel;
    controller.headerModel = self.headerModel;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  活动点赞
 */
-(void)actionPrise
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",STRING(@"%ld", (long)self.headerModel.flag),@"flag", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_PRISE postParam:dic type:0 delegate:self sel:@selector(requestPriseAction:)];
}

-(void)requestPriseAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * dic = [jsonDic valueForKey:@"data"];
            self.headerModel.flag = [[dic valueForKey:@"flag"] integerValue];
            ActivityDetailCellLikeItemModel * model = [[ActivityDetailCellLikeItemModel alloc]init];
            
            //获取自身userId
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString * userId = [data valueForKey:USER_STATIC_USER_ID];
            
            //设置属性
            model.userId = userId;
            model.userName = [dic valueForKey:@"name"];
            
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.commentCellModel.likeItemsArray];
            if(self.headerModel.flag==1)
            {
                
                if(array && array.count>0)
                {
                    for (int i =0 ;i< array.count;i++) {
                        ActivityDetailCellLikeItemModel * m = [array objectAtIndex:i];
                        if ([m.userName isEqualToString:model.userName]) {
                            [array removeObject:m];
                        }
                    }
                }
                
            }else{
                [array insertObject:model atIndex:0];
            }
            
            self.commentCellModel.likeItemsArray = array;
            
            [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
            
        }
    }
}

/**
 *  活动评论
 */
-(void)actionComment
{
    NSString * content = self.textField.text;
    if([content isEqualToString:@""] ||[content isEqualToString:@"请输入评论内容"])
    {
         [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入评论内容"];
        return;
    }
    
    if(!_commentToUser)
    {
        _commentToUser = @"0";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId",STRING(@"%d", 2),@"flag",content,@"content",STRING(@"%@", _commentToUser),@"atUserId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT postParam:dic type:0 delegate:self sel:@selector(requestCommentAction:)];
}

-(void)requestCommentAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * dic = [jsonDic valueForKey:@"data"];
            
            ActionComment * baseModel;
            
            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.commentCellModel.commentItemsArray];
            //解析
            baseModel =[ActionComment mj_objectWithKeyValues:dic];
            
            ActivityDetailCellCommentItemModel *commentItemModel = [ActivityDetailCellCommentItemModel new];
            commentItemModel.firstUserName = [[dic valueForKey:@"usersByUserId"] valueForKey:@"name"];
            commentItemModel.firstUserId = [[dic valueForKey:@"usersByUserId"] valueForKey:@"userId"];
            
            
            if([dic valueForKey:@"usersByAtUserId"])
            {
                commentItemModel.secondUserName = [[dic valueForKey:@"usersByAtUserId"] valueForKey:@"name"];
                commentItemModel.secondUserId = [[dic valueForKey:@"usersByAtUserId"] valueForKey:@"userId"];
                
            }
            commentItemModel.commentString = baseModel.content;
            
            [tempArray insertObject:commentItemModel atIndex:0];
            
            self.commentCellModel.commentItemsArray  = [tempArray copy];
            
            //刷新视图
            [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
            
            //注销键盘
            [self.textField resignFirstResponder];
            [self.textField setText:@""];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}


#pragma ActivityDelegate
-(void)attendAction:(id)model
{
    ActivityBlackCoverView * attendView = [ActivityBlackCoverView instancetationActivityBlackCoverView];
    attendView.delegate = self;
    attendView.tag = 1000;
    [self.view addSubview:attendView];
    [attendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma ActivityBlackCoverViewDelegate
-(void)clickBtnInView:(ActivityBlackCoverView *)view andIndex:(NSInteger)index content:(NSString *)content
{
    if (index==0) {
        [view removeFromSuperview];
    }else{
        //确定
        [self attendActionWithContent:content];
    }
}


/**
 *  报名
 */

-(void)attendActionWithContent:(NSString*)content
{
    NSString * parthner = [TDUtil encryKeyWithMD5:KEY action:ATTEND_ACTION];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",parthner,@"partner",content,@"content",STRING(@"%ld", (long)self.activityModel.actionId),@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ATTEND_ACTION postParam:dic type:0 delegate:self sel:@selector(requestAttendAction:)];
}

-(void)requestAttendAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        UIView * view  = [self.view viewWithTag:1000];
        if(view)
        {
            [view removeFromSuperview];
        }
        
        //更改本页报名按钮状态
        [_signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [_signUpBtn setBackgroundColor:GrayColor];
        [_signUpBtn setEnabled:NO];
        //更改上一页cell报名按钮状态
        _activityModel.attended = YES;
        NSInteger index = [_viewController.dataSourceArray indexOfObject:_activityModel];
        [_viewController.dataSourceArray replaceObjectAtIndex:index withObject:_activityModel];
        [_viewController.tableView reloadData];
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }
}


#pragma mark -textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        [self actionComment];
        
    }
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"开始编辑");
    
    UIView * view  = [self.view viewWithTag:10001];
    view.alpha = 1;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
        
        
    }
    NSLog(@"结束编辑");
    UIView * view  = [self.view viewWithTag:10001];
    view.alpha = 0;
}
@end
