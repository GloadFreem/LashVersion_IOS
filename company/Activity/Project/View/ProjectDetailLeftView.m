//
//  ProjectDetailLeftView.m
//  JinZhiT
//
//  Created by Eugene on 16/5/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectDetailLeftView.h"
#import "ProjectDetailLeftHeaderCell.h"
#import "ProjectDetailLeftTeamCell.h"
#import "ProjectDetailLeftFooterCell.h"
#import "ProjectDetailLeftHeaderModel.h"
#import "ProjectDetailLeftTeamModel.h"
#import "ProjectDetailLeftFooterModel.h"

@implementation ProjectDetailLeftView
{
    UITableView *_tableView;
    UIView *_bottomView;  //最底层色块
    UIButton *_serviceBtn; //客服
    UIButton *_investBtn;   //跟投按钮
    NSMutableArray *_dataArray;
    CGFloat _cellHeight;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = colorGray;
        _height = 0;
        _dataArray = [NSMutableArray array];
        _cellHeight = 0;
        [self createUI];
    }
    return self;
}


#pragma mark -创建内部视图
-(void)createUI
{
    ProjectDetailLeftHeaderModel *model = [ProjectDetailLeftHeaderModel new];
    model.projectStr = @"逸景营地";
    model.goalStr = @"1000万";
    model.achieveStr = @"800万";
    model.timeStr = @"2016.6.1";
    model.addressStr = @"陕西 | 西安";
    model.statusStr = @"路演中";
    model.contentStr = @"迪士尼代表动画角色，米老鼠的最初原型是他的设计伙伴伍培·艾沃克斯（iwerke)执笔设计的。维·史密斯和费洛伊德·戈特佛森创作的米老鼠的故事。米老鼠的形象设计出来以后，迪士尼开始用它来制作动画片。";
    model.pictureArray = @[@"2010年11月25日-Blue-Footed-Booby,-Galápagos-Islands.png",@"2010年11月25日-Blue-Footed-Booby,-Galápagos-Islands.png",@"2010年11月25日-Blue-Footed-Booby,-Galápagos-Islands.png"];
    
    [_dataArray addObject:model];
    
    _tableView = [[UITableView alloc]init];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    _serviceBtn = [UIButton new];
    [_serviceBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kefu"] forState:UIControlStateNormal];
    [_serviceBtn setTag:300];
    [_serviceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _serviceBtn.layer.cornerRadius = 20;
    _serviceBtn.layer.masksToBounds = YES;
    [_bottomView addSubview:_serviceBtn];
    [_serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomView.mas_left).offset(8*WIDTHCONFIG);
        make.centerY.mas_equalTo(_bottomView.mas_centerY);
        make.width.mas_equalTo(97*WIDTHCONFIG);
        make.height.mas_equalTo(40);
    }];
    
    _investBtn = [UIButton new];
    [_investBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-rocket"] forState:UIControlStateNormal];
    [_investBtn setTag:301];
    [_investBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _investBtn.layer.cornerRadius = 20;
    _investBtn.layer.masksToBounds = YES;
    [_bottomView addSubview:_investBtn];
    [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.mas_centerY);
        make.right.mas_equalTo(_bottomView.mas_right).offset(-8*WIDTHCONFIG);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(_serviceBtn.mas_right).offset(24*WIDTHCONFIG);
    }];
    
}

#pragma mark -tableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        id model = _dataArray[indexPath.row];
        
        _cellHeight = [_tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ProjectDetailLeftHeaderCell class] contentViewWidth:[self cellContentViewWith]];
        // 刷新frame
        [self refreshFrame];
        
        return _cellHeight;
    }
    if (indexPath.row == 1) {
        return 187;
    }
    return 118;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellId = @"ProjectDetailLeftHeaderCell";
        ProjectDetailLeftHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ProjectDetailLeftHeaderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.indexPath = indexPath;
//        __weak typeof (self) weakSelf = self;
        if (!cell.moreButtonClickedBlock) {
            [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
                ProjectDetailLeftHeaderModel *model =_dataArray[0];
                model.isOpen = !model.isOpen;
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
        cell.model = _dataArray[0];
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *cellId = @"ProjectDetailLeftTeamCell";
        ProjectDetailLeftTeamCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ProjectDetailLeftTeamCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }
    static NSString *cellId = @"ProjectDetailLeftFooterCell";
    ProjectDetailLeftFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ProjectDetailLeftFooterCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)refreshFrame
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_cellHeight + 118 + 187);
    }];
    _height = 118 + 187 + 60 + _cellHeight;
    
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
#pragma mark -  底部按钮点击事件
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 300) {
        
    }
    if (btn.tag == 301) {
        
    }
}
#pragma mark - 计算高度
-(CGFloat)calculateHeight
{
    return 0;
}

@end
