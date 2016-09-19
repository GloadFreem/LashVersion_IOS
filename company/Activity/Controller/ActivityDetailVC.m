//
//  ActivityDetailVC.m
//  JinZhiT
//
//  Created by Eugene on 16/5/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//


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

#import "RenzhengViewController.h"

#import "ActivityDetailHeaderCell.h"
#import "ShareToCircleView.h"
#import "CircleShareBottomView.h"
#import "ActivityInfoCell.h"
#import "ActivityBottomView.h"
#import "ActionIntroduceFrame.h"
#import "ActionIntroduce.h"

#import "LQQMonitorKeyboard.h"

#define kActivityDetailHeaderCellId @"ActivityDetailHeaderCell"
static CGFloat tableViewH = 0;
static int preFlag = 0;

#define SHARETOCIRCLE @"shareContentToFeeling"
#define COMMENTDELETE @"requestActionCommentDelete"
#define SHAREACTION @"requestShareAction"
#define COMMENTLIST @"requestPriseListAction"
#define ATTENDACTION @"requestAttendListAction"
#define ACTIONDETAIL @"requestDetailAction"
@interface ActivityDetailVC ()<UITableViewDelegate,UITableViewDataSource,ActivityDetailFooterViewDelegate,UITextFieldDelegate,ActivityBlackCoverViewDelegate,CircleShareBottomViewDelegate,ActivityBottomViewDelegate,ShareToCircleViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ActivityBottomView *bottomView;          //报名按钮
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
@property (nonatomic,strong) UIView * shareView;
@property (nonatomic, strong) ShareToCircleView *shareCircleView;
@property (nonatomic, copy) NSString *circlePartner;

@property (nonatomic, strong) NSMutableArray *dataArray;
/** 点赞按钮 */
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, copy) NSString *praiseFlag;
@property (nonatomic, copy) NSString *authenticName;  //认证信息
@property (nonatomic, copy) NSString *identiyTypeId;  //身份类型

@property (nonatomic, strong) ActivityBlackCoverView *blackCoverView;
/** 保存活动结束中的第一段文字 */
@property (nonatomic, copy) NSString *firstContext;
@property (nonatomic, strong) UIView *returnView;

@property (nonatomic, copy) NSString *selfId;

@property (nonatomic, copy) NSString *deletePartner;
@property (nonatomic, strong) ActivityDetailCellCommentItemModel * deleteModel;
@end

@implementation ActivityDetailVC
{
    CGFloat _totalKeybordHeight;
    //底部点赞评论
    ActivityDetailFooterView *footerView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    tableViewH = 0;
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    _authenticName = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_STATUS];
    _identiyTypeId = [defaults valueForKey:USER_STATIC_USER_AUTHENTIC_TYPE];
    _selfId =[defaults valueForKey:USER_STATIC_USER_ID];
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [self setUpNavBar];
    //    [self setupTextField];
    //生成请求partner
    self.actionDetailPartner = [TDUtil encryKeyWithMD5:KEY action:ACTIONDETAIL];
    self.actionAttendPartner = [TDUtil encryKeyWithMD5:KEY action:ATTENDACTION];
    self.actionCommentListPartner = [TDUtil encryKeyWithMD5:KEY action:COMMENTLIST];
    self.sharePartner = [TDUtil encryKeyWithMD5:KEY action:SHAREACTION];
    self.circlePartner = [TDUtil encryKeyWithMD5:KEY action:SHARETOCIRCLE];
    self.deletePartner = [TDUtil encryKeyWithMD5:KEY action:COMMENTDELETE];

    //初始化 控件
    [self createUI];
    //设置加载视图范围
    self.loadingViewFrame = self.view.frame;
    //请求数据
    [self loadActionDetailData];
    
    //获取分享数据
    [self loadShareData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadActionCommentData) name:@"refreshComment" object:nil];
}

-(void)setUpNavBar
{
    [self.navigationItem setTitle:@"活动详情"];
    
    [Encapsulation returnWithViewController:self img:@"leftBack"];
    
    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"write-share"] forState:UIControlStateNormal];
    shareBtn.size = shareBtn.currentImage.size;
    [shareBtn addTarget:self action:@selector(startShare) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
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
    _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-50-44);
        
    CGFloat bottomViewH = 50;
    CGFloat bottomViewY = SCREENHEIGHT - bottomViewH - 64;
    
    _bottomView = [[ActivityBottomView alloc] initWithFrame:CGRectMake(0, bottomViewY, SCREENWIDTH, bottomViewH)];
    [self.view addSubview:_bottomView];
    _bottomView.delegate = self;
    
    // 回复框
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(0, SCREENHEIGHT , SCREENWIDTH, 50)];
    [view setBackgroundColor:color(210, 213, 219, 1)];
    [self.view addSubview:view];
    _returnView = view;
    
    
    view.tag = 10001;
//    [view setAlpha:0];
    
    UIView *line = [UIView new];
    line.backgroundColor = colorGray;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
    // 输入框
    _textField = [UITextField new];
    _textField.backgroundColor = RGBCOLOR(255, 255, 255);
    _textField.placeholder = @"请输入评论内容";
    _textField.layer.cornerRadius = 3;
    _textField.layer.borderColor = colorGray.CGColor;
    _textField.layer.borderWidth = .5f;
    _textField.delegate = self;
    [_textField setValue:color74 forKeyPath:@"_placeholderLabel.textColor"];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.textColor = [UIColor blackColor];
    _textField.font = BGFont(14);
    _textField.returnKeyType = UIReturnKeySend;
    _textField.keyboardType = UIKeyboardTypeDefault;
    CGRect frame = [_textField frame];
    frame.size.width = 15.0f;
    UIView *leftView = [[UIView alloc]initWithFrame:frame];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.mas_equalTo(_textField.mas_right).offset(5);
        make.height.mas_equalTo(_textField.mas_height);
        make.centerY.mas_equalTo(_textField.mas_centerY);
        make.right.mas_equalTo(view.mas_right).offset(-12);
    }];
}

#pragma mark--------loadShareData分享数据-------------
-(void)loadShareData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.sharePartner,@"partner",@"4",@"type",STRING(@"%ld", (long)self.actionId),@"contentId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_SHARE postParam:dic type:0 delegate:self sel:@selector(requestShareData:)];
}

-(void)requestShareData:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
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

    self.startLoading = YES;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.actionId),@"contentId", @"1", @"version", nil];
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
            
            self.activityModel = [ActivityViewModel new];
            self.activityModel.attended = baseModel.attended;
            _bottomView.attend = baseModel.attended;
            self.activityModel.flag = baseModel.flag;
            self.activityModel.imgUrl = baseModel.startPageImage;
            self.activityModel.startTime = baseModel.startTime;
            self.activityModel.endTime = baseModel.endTime;
            self.activityModel.type = baseModel.type;
//            NSLog(@"打印结束时间---%@",baseModel.endTime);
            if(![TDUtil isArrivedTime:baseModel.endTime])
            {
                _bottomView.isExpired = YES;
            }
            self.activityModel.memberLimit = baseModel.memberLimit;
            self.activityModel.address = baseModel.address;
            self.activityModel.name = baseModel.name;
            self.activityModel.actionId = baseModel.actionId;
             _bottomView.flag = baseModel.flag;
            preFlag = baseModel.flag;
            
            
            ActivityDetailHeaderModel *model =[ActivityDetailHeaderModel new];
            model.flag = baseModel.flag;
            model.title = baseModel.name;
            model.content = baseModel.desc;
            model.actionId = baseModel.actionId;

            ActionIntroduceFrame *actionIntroF = [[ActionIntroduceFrame alloc] init];
            actionIntroF.tableViewH = 0;
            
            NSMutableArray *tempArr = [NSMutableArray array];
            for (NSDictionary *dic in baseModel.actionintroduces) {
                ActionIntroduce *actionIntro = [ActionIntroduce ActionIntroducesWithDic:dic];
                ActionIntroduceFrame *actionIntroF = [[ActionIntroduceFrame alloc] init];
                actionIntroF.actionIntro = actionIntro;
                
                if (actionIntro.type == 0) {
                    if (_firstContext.length == 0) {
                        _firstContext = actionIntro.content;
                    }
                    tableViewH += actionIntroF.cellHeight;
                } else {
//                    tableViewH += 180;
                    tableViewH += actionIntroF.cellHeight;
                }
                [tempArr addObject:actionIntroF];
            }
            tableViewH+=40;
            model.actionIntroduceFrames = tempArr;
            
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
            
            [_dataArray addObject:self.activityModel];
            //获取项目参加人数
            [self loadActionAttendData];
            
//            NSLog(@"打印header模型---%@",self.headerModel);
        }
    }else{
        self.isNetRequestError = YES;
    }
}

/**
 *  获取报名人数
 */

-(void)loadActionAttendData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.actionId),@"contentId",@"0",@"page", nil];
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
                   
                    [_dataArray addObject:[NSString stringWithFormat:@"%ld",(unsigned long)dataArray.count]];
                    
                    for(NSDictionary * dic in dataArray)
                    {
                        
                        //解析
                        baseModel =[ActivityAttendModel mj_objectWithKeyValues:dic];
                        
                        [self.dataArray addObject:baseModel];
                        
                    }
                    
                }else{
                [_dataArray addObject:[NSString stringWithFormat:@"0"]];
                }
                
            }
            //点赞评论
            [self loadActionCommentData];
        }
    }else{
        self.isNetRequestError = YES;
    }
}

/**
 *  评论列表
 */
-(void)loadActionCommentData
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionCommentListPartner,@"partner",STRING(@"%ld", (long)self.actionId),@"contentId",@"0",@"page",PLATFORM,@"platform", nil];
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
                if (tempArray.count > 4) break;
                    
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
                commentItemModel.commentId = baseModel.commentId;
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
    }else{
        self.isNetRequestError = YES;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [self loadActionDetailData];
}

-(void)setHeaderModel:(ActivityDetailHeaderModel *)headerModel
{
    _headerModel = headerModel;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --------------tableViewDataSource---------------------

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!footerView) {
        __weak typeof(self) weakSelf = self;
        
        footerView = [ActivityDetailFooterView new];
        [footerView setDidClickCommentLabelBlock:^(NSString * commentId,NSString * repleyName, CGRect rectInWindow, ActivityDetailCellCommentItemModel *model) {
            NSInteger num1 = [weakSelf.selfId integerValue];
            NSInteger num2 = [commentId integerValue];
            if (num1 != num2) {
                weakSelf.textField.placeholder =[NSString stringWithFormat:@" 回复：%@",repleyName];
                [weakSelf.textField becomeFirstResponder];
                [weakSelf.bottomView setHidden:NO];
                weakSelf.isReplayingComment = YES;
                weakSelf.commentToUser = commentId;
                [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
            }else{//点击自己  可以删除
                weakSelf.deleteModel = model;
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
                __block ActivityDetailVC* blockSelf = weakSelf;
                
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [blockSelf btnCertain:nil];
                }];
                
                [alertController addAction:cancleAction];
                [alertController addAction:okAction];
                
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                
                return;

            }
        }];
        footerView.delegate = self;
    }
    return footerView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
    _textField.placeholder = nil;
}

- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [footerView.superview convertRect:footerView.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

-(void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark---删除评论---
-(void)btnCertain:(id)sender
{
    //删除 评论哈
    if (_deleteModel) {
        NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.commentCellModel.commentItemsArray];
        [tempArray removeObject:_deleteModel];
        self.commentCellModel.commentItemsArray  = [tempArray copy];
    }
    //刷新视图
    [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
    
    
    if (_deleteModel.commentId) {
        //更新数据
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.deletePartner,@"partner",[NSString stringWithFormat:@"%ld",(long)_deleteModel.commentId],@"commentId", nil];
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT_DELETE postParam:dic type:0 delegate:self sel:@selector(requestDeleteComment:)];
    }
}

-(void)requestDeleteComment:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    //        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic !=nil) {
        NSString *status =[jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"删除成功");
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count) {
        if (self.dataArray.count > 8) {
            return 8;
        }else{
            return self.dataArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        if (indexPath.row == 0) {
            return 318.5;
        }
        if (indexPath.row == 1) {
//            return 1500;
            return tableViewH+10+30;
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
    self.startLoading = NO;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count) {
        
        if (indexPath.row == 0) {
            static NSString *cellId = @"ActivityDetailExiciseContentCell";
            ActivityDetailExiciseContentCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:cellId owner:nil options:nil] lastObject];
            }
            if (_dataArray[indexPath.row+1]) {
                cell.model = _dataArray[indexPath.row+1];
                [cell.dinstanceLabel setHidden:YES];
                return cell;
            }
        }
        
        if (indexPath.row == 1) {
            ActivityInfoCell *cell = [ActivityInfoCell cellWithTableView:tableView];
            ActivityDetailHeaderModel *headerModel = _dataArray[0];
            cell.actionIntroFs = headerModel.actionIntroduceFrames;
            cell.tableViewH = tableViewH;
            return cell;
        }
        
        if (indexPath.row == 2) {
            static NSString *cellId = @"ActivityDetailExerciseCell";
            ActivityDetailExerciseCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
                
            }

            if (_dataArray[indexPath.row]) {
                cell.countLabel.text =  [NSString stringWithFormat:@"(%@)",_dataArray[2]];
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
    if(2 == indexPath.row)
    {
        ActivityAttendListViewController * attendListViewController = [[ActivityAttendListViewController alloc]init];
        attendListViewController.actionId = self.actionId;
        [self.navigationController pushViewController:attendListViewController animated:YES];
    }
}

#pragma mark -btnAction
- (void)backHome:(UIViewController *)mySelf
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if(self.shareView != nil)
    {
        [self.shareView removeFromSuperview];
    }
}

-(void)startShare
{
    NSArray *titleList = @[@"圈子",@"QQ",@"微信",@"朋友圈",@"短信"];
    NSArray *imageList = @[@"icon_share_circle@2x",@"icon_share_qq",@"icon_share_wx",@"icon_share_friend",@"icon_share_msg"];
    CircleShareBottomView *share = [CircleShareBottomView new];
    share.tag = 1;
    [share createShareCircleViewWithTitleArray:titleList imageArray:imageList];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBG)];
    [share addGestureRecognizer:tap];
    [[self topView] addSubview:share];
    self.shareView = share;
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
                [self dismissBG];
                [self createShareCircleView];
            }
                break;
            case 1:{
                if ([QQApiInterface isQQInstalled])
                {
                    // QQ好友
                    arr = @[UMShareToQQ];
                    [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
                    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
                break;
            case 2:{
                // 微信好友
                arr = @[UMShareToWechatSession];
                [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
                
                //                NSLog(@"分享到微信");
            }
                break;
            case 3:{
                // 微信朋友圈
                arr = @[UMShareToWechatTimeline];
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
                
                //                NSLog(@"分享到朋友圈");
            }
                break;
            case 4:{
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
            shareContentString = [NSString stringWithFormat:@"%@:%@\n%@",_shareTitle,_contentText,_shareUrl];
        }
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            shareImage];
        
        __weak typeof (self) weakSelf = self;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:arr content:shareContentString image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf performSelector:@selector(dismissBG) withObject:nil afterDelay:1.0];
                    
                    
                });
            }
        }];
    }
}

-(void)createShareCircleView
{
    ShareToCircleView *shareView =[[[NSBundle mainBundle] loadNibNamed:@"ShareToCircleView" owner:nil options:nil] lastObject];
    shareView.backgroundColor = [UIColor clearColor];
    [shareView instancetationShareToCircleViewWithimage:self.activityModel.imgUrl title:self.activityModel.name content:_firstContext];
    shareView.tag = 1000;
    [[UIApplication sharedApplication].windows[0] addSubview:shareView];
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    shareView.textView.delegate = self;
//    [shareView.textView becomeFirstResponder];
    shareView.delegate = self;
    _shareCircleView = shareView;
}

#pragma mark-------ShareToCircleViewDelegate--------
-(void)clickBtnInView:(ShareToCircleView *)view andIndex:(NSInteger)index content:(NSString *)content
{
    if (index == 0) {
        [view removeFromSuperview];
    }else{
        //        NSLog(@"调接口");
        [_shareCircleView removeFromSuperview];
        if ([content isEqualToString:@"说点什么吧..."]) {
            content = @"";
        }
        if (_firstContext.length>200) {
            _firstContext = [_firstContext substringToIndex:200];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.circlePartner,@"partner",STRING(@"%ld", (long)self.actionId),@"contentId",@"6",@"type",content,@"comment",STRING(@"%ld", (long)self.actionId),@"content",_firstContext,@"description",self.activityModel.imgUrl,@"image",@"金指投活动",@"tag",nil];
        NSLog(@"%@",dic);
        //开始请求
        [self.httpUtil getDataFromAPIWithOps:SHARE_TO_CIRCLE postParam:dic type:0 delegate:self sel:@selector(requestShareToCircle:)];
    }
}

-(void)requestShareToCircle:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//        NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            //            NSLog(@"分享成功");
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络好像出了点问题，检查一下"];
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
    [self.navigationController.navigationBar setHidden:NO];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UINavigationController *nav = (UINavigationController*)window.rootViewController;
    JTabBarController * tabBarController;
    for (UIViewController *vc in nav.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:JTabBarController.class]) {
            tabBarController = (JTabBarController*)vc;
            [tabBarController tabBarHidden:YES animated:NO];
        }
    }
    
    AppDelegate * delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate.tabBar tabBarHidden:YES animated:NO];
    [IQKeyboardManager sharedManager].enable = NO;
    
    [LQQMonitorKeyboard LQQAddMonitorWithShowBack:^(NSInteger height) {
        
        _returnView.frame = CGRectMake(0, self.view.frame.size.height - height - 50, SCREENWIDTH, 50);
        //        NSLog(@"键盘出现了 == %ld",(long)height);
        CGFloat h = height + 50;
        if (_totalKeybordHeight != h) {
            _totalKeybordHeight = h;
//            [self adjustTableViewToFitKeyboard];
        }
        
    } andDismissBlock:^(NSInteger height) {
        
        _returnView.frame = CGRectMake(0, self.view.frame.size.height , SCREENWIDTH, 50);
        //        NSLog(@"键盘消失了 == %ld",(long)height);
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationController.navigationBar.hidden = NO;
}

#pragma footerDelegate
-(void)didClickLikeButton:(UIButton*)btn
{

    if(!self.actionPrisePartner)
    {
        self.actionPrisePartner = [TDUtil encryKeyWithMD5:KEY action:ACTION_PRISE];
    }
    
    _agreeBtn = btn;
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
        //调整键盘位置
        [self adjustTableViewToFitKeyboard];
    
        [self.textField becomeFirstResponder];

}

#pragma mark - 代理方法
// 查看全部活动评论的代理
-(void)didClickShowAllButton
{
    ActivityCommentListViewController * controller  = [[ActivityCommentListViewController alloc]init];
    controller.headerModel = self.headerModel;
    controller.actionId =self.actionId;
    [self.navigationController pushViewController:controller animated:YES];
}

/** 活动点赞 */
-(void)actionPrise
{
    int isPrise = preFlag == 1 ? 2 : 1;
    preFlag = isPrise;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.actionId),@"contentId",STRING(@"%d", isPrise),@"flag", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_PRISE postParam:dic type:0 delegate:self sel:@selector(requestPriseAction:)];
}

-(void)requestPriseAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic != nil) {
        NSString *status = [jsonDic valueForKey:@"status"];
        if ([status integerValue] == 200) {
            NSDictionary * dic = [jsonDic valueForKey:@"data"];
//            self.praiseFlag = [dic valueForKey:@"flag"];
            ActivityDetailCellLikeItemModel * model = [[ActivityDetailCellLikeItemModel alloc]init];
            //获取自身userId
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString * userId = [data valueForKey:USER_STATIC_USER_ID];
            
            //设置属性
            model.userId = userId;
            model.userName = [dic valueForKey:@"name"];
            
            
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.commentCellModel.likeItemsArray];
            if(preFlag==2)
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
            // 当点赞或取消点赞时改变该按钮的选中状态，即改变图片颜色
            _agreeBtn.selected = !_agreeBtn.selected;
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
        [_textField resignFirstResponder];
        //刷新视图
        [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
         [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入评论内容"];
        return;
    }
    
    if(!_commentToUser)
    {
        _commentToUser = @"0";
        
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",self.actionDetailPartner,@"partner",STRING(@"%ld", (long)self.actionId),@"contentId",STRING(@"%d", 2),@"flag",content,@"content",STRING(@"%@", _commentToUser),@"atUserId", nil];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:ACTION_COMMENT postParam:dic type:0 delegate:self sel:@selector(requestCommentAction:)];
}

-(void)requestCommentAction:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
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
            if (tempArray.count < 5) {
                [tempArray insertObject:commentItemModel atIndex:0];
            }
            
            self.commentCellModel.commentItemsArray  = [tempArray copy];
            
            //刷新视图
            [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
            
            //注销键盘
            [self.textField resignFirstResponder];
            [self.textField setText:@""];
            self.commentToUser = @"";
            
            [self loadActionCommentData];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
        }
    }
}

#pragma ActivityDelegate
-(void)attendAction
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
-(void)clickBtnInBlackView:(ActivityBlackCoverView *)view andIndex:(NSInteger)index content:(NSString *)content
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KEY,@"key",parthner,@"partner",content,@"content",STRING(@"%ld", (long)self.actionId),@"contentId", nil];
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
        [_bottomView.signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
        [_bottomView.signUpBtn setBackgroundColor:btnCray];
        [_bottomView.signUpBtn setEnabled:NO];
        
        // 报名完成之后重新请求数据更新UI
        NSMutableArray *tempDataArr = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            [tempDataArr addObject:self.dataArray[i]];
        }
        self.dataArray = tempDataArr;
        
        [self loadActionAttendData];

        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"message"]];
    }
}

#pragma mark -textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.font= BGFont(18);
    textView.textColor = color47;
    if ([textView.text isEqualToString:@"说点什么吧..."]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.font = BGFont(15);
        textView.text = @"说点什么吧...";
    }
}

#pragma mark -textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _textField.placeholder = @"";
    [self actionComment];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        self.textField.text = textField.text;
    }
}



@end
