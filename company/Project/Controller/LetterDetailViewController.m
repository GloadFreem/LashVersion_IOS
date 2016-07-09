//
//  LetterDetailViewController.m
//  company
//
//  Created by Eugene on 16/7/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "LetterDetailViewController.h"
#import "TDUtil.h"
@interface LetterDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation LetterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self createUI];
}

#pragma mark -导航栏设置
-(void)setupNav
{
    //返回按钮
    self.navigationItem.title = @"详情";
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = CGSizeMake(80, 30);
    leftback.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
}

-(void)btnClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI
{
    _scrollView = [UIScrollView new];
    _scrollView.delegate =self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = _model.title;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [TDUtil colorWithHexString:@"1B1B1B"];
    [_scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(_titleLabel.mas_left).offset(10);
    }];
    
    _timeLabel = [UILabel new];
    _titleLabel.text = _model.messageDate;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = BGFont(14);
    _timeLabel.textColor = color74;
    [_scrollView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(14);
    }];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.textColor = color47;
    _subTitleLabel.font = BGFont(14);
    _subTitleLabel.text = _model.messagetype.name;
    _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    _subTitleLabel.numberOfLines = 0;
    [_scrollView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-15);
    }];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = colorGray;
    [_scrollView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(15);
    }];
    
    _contentLabel = [UILabel new];
    _contentLabel.text = _model.content;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = BGFont(13);
    _contentLabel.textColor = color74;
    _contentLabel.numberOfLines = 0;
    [_scrollView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_lineView.mas_bottom).offset(20);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_contentLabel.mas_bottom).offset(30);
    }];
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
