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
#import "ActivityDetailHeaderCell.h"
#import "ActivityDetailHeaderModel.h"
#import "ActivityDetailExerciseCell.h"
#import "ActivityDetailListCell.h"
#import "ActivityDetailFooterView.h"
#import "ActivityDetailCommentCellModel.h"
#import "ActivityDetailExiciseContentCell.h"
#import "ActivityAttendListViewController.h"
#import "ActivityCommentListViewController.h"


#define kActivityDetailHeaderCellId @"ActivityDetailHeaderCell"
static CGFloat textFieldH = 40;

@interface ActivityDetailVC ()<UITableViewDelegate,UITableViewDataSource,ActivityDetailFooterViewDelegate,UITextFieldDelegate,ActivityViewDelegate,ActivityBlackCoverViewDelegate>

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

@end

@implementation ActivityDetailVC
{
    CGFloat _totalKeybordHeight;
    //底部点赞评论
    ActivityDetailFooterView *footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setUpNavBar];
    //初始化 控件
    [self createUI];
    
    //    [self setupTextField];
    
    //生成请求partner
    self.actionDetailPartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_DETAIL];
    self.actionAttendPartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_ATTEND];
    self.actionCommentListPartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_COMMENT_LIST];
    
    //点赞评论
    [self loadActionCommentData];
    
    //请求数据
    [self loadActionDetailData];
    //获取项目参加人数
    [self loadActionAttendData];
    
}
-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"活动详情"];
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(32, 20);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback];
}

#pragma mark -初始化控件
-(void)createUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.01f)];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
    //    ActivityDetailFooterView *footerView = [ActivityDetailFooterView new];
    //    footerView.frame = CGRectMake(0, 0, SCREENWIDTH, 180);
    //    footerView.model = _dataSource[1];
    //    footerView.backgroundColor = [UIColor redColor];
    
    //    _tableView.tableFooterView = footerView;
    //报名按钮
    _signUpBtn = [[UIButton alloc]init];
    _signUpBtn.backgroundColor = orangeColor;
    [_signUpBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    [_signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signUpBtn.titleLabel setFont:BGFont(19)];
    [_signUpBtn addTarget:self action:@selector(attendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpBtn];
    //分享按钮
    _shareBtn = [[UIButton alloc]init];
    _shareBtn.backgroundColor = color(67, 179, 204, 1);
    [_shareBtn setTitle:@"我要分享" forState:UIControlStateNormal];
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

/**
 *  获取活动列表
 */

-(void)loadActionDetailData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", self.activityModel.actionId),@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_DETAIL postParam:dic type:0 delegate:self sel:@selector(requestActionDetailList:)];
}

-(void)requestActionDetailList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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
            
            //            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            //            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }
    }
}

/**
 *  获取报名人数
 */

-(void)loadActionAttendData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", self.activityModel.actionId),@"contentId",@"0",@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_ATTEND postParam:dic type:0 delegate:self sel:@selector(requestActionAttendList:)];
}

-(void)requestActionAttendList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            if([jsonDic[@"data"] isKindOfClass:NSArray.class])
            {
                NSArray *dataArray = [NSArray arrayWithArray:jsonDic[@"data"]];
                
                ActivityAttendModel * baseModel;
                if(!self.dataAttendSource)
                {
                    self.dataAttendSource = [NSMutableArray new];
                }
                
                for(NSDictionary * dic in dataArray)
                {
                    //解析
                    baseModel =[ActivityAttendModel mj_objectWithKeyValues:dic];
                    //替换模型
                    [self.dataAttendSource addObject:baseModel];
                }
                
                [self.tableView reloadData];
            }
            
        }
    }
}

/**
 *  评论列表
 */

-(void)loadActionCommentData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionCommentListPartner,@"partner",STRING(@"%ld", self.activityModel.actionId),@"contentId",@"0",@"page", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT_LIST postParam:dic type:0 delegate:self sel:@selector(requestActionCommentList:)];
}

-(void)requestActionCommentList:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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
                commentItemModel.firstUserId = STRING(@"%ld", baseModel.usersByUserId.userId);
                if([dic valueForKey:@"atUserName"])
                {
                    commentItemModel.secondUserName = [dic valueForKey:@"atUserName"];
                    commentItemModel.secondUserId = @"";
                    
                }
                commentItemModel.commentString = baseModel.content;
                
                [tempArray addObject:commentItemModel];
            }
            
            self.commentCellModel.commentItemsArray  = [tempArray copy];
            
            //模拟随机点赞数据
            int likeRandom = arc4random_uniform(3);
            
            //测试
            likeRandom = 30;
            
            NSMutableArray *tempLikes = [NSMutableArray new];
            for (int i = 0; i < dataPriseArray.count; i++) {
                ActivityDetailCellLikeItemModel *model = [ActivityDetailCellLikeItemModel new];
                model.userName = dataPriseArray[i];
                model.userId = @"1";
                [tempLikes addObject:model];
            }
            self.commentCellModel.likeItemsArray = [tempLikes copy];
            
            //            footerView.model = self.commentCellModel;
            
            //            [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(layout:) userInfo:nil repeats:NO];
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

#pragma mark -tableViewDataSource
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
    NSInteger count = 0;
    if (self.headerModel) {
        count=3;
    }
    return self.dataAttendSource.count+count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.headerModel)
    {
        if (indexPath.row == 0) {
            return [self.tableView cellHeightForIndexPath:indexPath model:self.headerModel keyPath:@"model" cellClass:[ActivityDetailHeaderCell class] contentViewWidth:[self cellContentViewWith]];
        }else if(indexPath.row == 1)
        {
            return 140;
        }else if(indexPath.row == 2)
        {
            return 48;
        }
    }else{
        if (indexPath.row == 0) {
            return 140;;
        }else if(indexPath.row == 1)
        {
            return 48;
        }
    }
    
    return 67;
    
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
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.headerModel)
    {
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
            cell.model = self.headerModel;
            return cell;
        }else if (indexPath.row == 1){
            static NSString *cellId = @"ActivityDetailExiciseContentCell";
            ActivityDetailExiciseContentCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            cell.model = self.activityModel;
            return cell;
        }else if (indexPath.row == 2){
            static NSString *cellId = @"ActivityDetailExerciseCell";
            ActivityDetailExerciseCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                cell.countLabel.text = STRING(@"(%ld)", self.dataAttendSource.count);
            }
            
            return cell;
        }else if(indexPath.row < 8)
        {
            static NSString *cellId = @"ActivityDetailListCell";
            ActivityDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            
            //设置模型
            cell.model = [self.dataAttendSource objectAtIndex:indexPath.row-3];
            return cell;
        }
    }else{
        if (indexPath.row == 0){
            static NSString *cellId = @"ActivityDetailExiciseContentCell";
            ActivityDetailExiciseContentCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            cell.model = self.activityModel;
            return cell;
        }else if (indexPath.row == 1){
            static NSString *cellId = @"ActivityDetailExerciseCell";
            ActivityDetailExerciseCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            
            return cell;
        }else
        {
            static NSString *cellId = @"ActivityDetailListCell";
            ActivityDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            cell.model = [self.dataAttendSource objectAtIndex:indexPath.row-2];
            //设置模型
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
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES]
    ;
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:NO animated:NO];
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", self.activityModel.actionId),@"contentId",STRING(@"%ld", self.headerModel.flag),@"flag", nil];
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", self.activityModel.actionId),@"contentId",STRING(@"%d", 2),@"flag",content,@"content",STRING(@"%@", _commentToUser),@"atUserId", nil];
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",parthner,@"partner",content,@"content",STRING(@"%ld", self.activityModel.actionId),@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ATTEND_ACTION postParam:dic type:0 delegate:self sel:@selector(requestAttendAction:)];
}

-(void)requestAttendAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![textField.text isEqualToString:@""]) {
        
        self.textField.text = textField.text;
        
        
    }
    NSLog(@"结束编辑");
}
@end
