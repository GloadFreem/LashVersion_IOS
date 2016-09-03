//
//  ActivityInfoCell.m
//  company
//
//  Created by LiLe on 16/8/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ActivityInfoCell.h"
#import "ActionIntroduce.h"
#import "ActivityIntroduceCell.h"
#import "ActionIntroduceFrame.h"

@interface  ActivityInfoCell()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ActivityInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"activityInfo";
    ActivityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ActivityInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
        topView.backgroundColor = RGBCOLOR(224, 224, 224);
        [self.contentView addSubview:topView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 100) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_tableView];
        _tableView.userInteractionEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.userInteractionEnabled = NO;
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
//        headerView.backgroundColor = [UIColor redColor];
        _tableView.tableHeaderView = headerView;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 10, 4, 20)];
        lineView.backgroundColor = RGBCOLOR(113, 149, 227);
        lineView.layer.cornerRadius = 2;
        lineView.layer.masksToBounds = YES;
        [headerView addSubview:lineView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, 5, 100, 30)];
        titleL.text = @"活动介绍";
        [headerView addSubview:titleL];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 1)];
        lineView2.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineView2];
        
    }
    return self;
}

- (void)setActionIntroFs:(NSArray<ActionIntroduceFrame *> *)actionIntroFs
{
    _actionIntroFs = actionIntroFs;
}

- (void)setTableViewH:(CGFloat)tableViewH
{
    _tableViewH = tableViewH;
    _tableView.frame = CGRectMake(0, 10, SCREENWIDTH, _tableViewH);
    [_tableView reloadData];

}

#pragma mark - 数据源方法和代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionIntroduceFrame *actionInF = self.actionIntroFs[indexPath.row];
    ActionIntroduce *actionIntro = actionInF.actionIntro;
    if (0 == actionIntro.type) {
         return actionInF.cellHeight;
    } else {
        return 180;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _actionIntroFs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionIntroduceFrame *actionIntroF = _actionIntroFs[indexPath.row];
    if (0 == actionIntroF.actionIntro.type) {
        ActivityIntroduceCell *cell = [ActivityIntroduceCell cellWithTableView:tableView];
        cell.actionIntroF = _actionIntroFs[indexPath.row];
        return cell;
    } else {
        ActivityIntroduceImgCell *cell = [ActivityIntroduceImgCell cellWithTableView:tableView];
        cell.actionIntro = actionIntroF.actionIntro;
        return cell;
    }
}


@end