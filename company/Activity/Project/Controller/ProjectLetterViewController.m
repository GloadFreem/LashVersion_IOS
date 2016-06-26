//
//  ProjectLetterViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectLetterViewController.h"
#import "ProjectLetterCell.h"
#import "ProjectLetterModel.h"

@interface ProjectLetterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; //列表
@property (nonatomic, strong) NSMutableArray *dataArray;    //数据

@property (nonatomic, strong) NSMutableArray *deleteArray;

@property (nonatomic, strong) UIView *bottomView;   //底部视图
@property (nonatomic, strong) UIButton *allSelectedBtn;    //全选按钮
@property (nonatomic, strong) UIButton *deleteBtn;      //删除按钮
@property (nonatomic, strong) UIButton *operateBtn;    // 编辑按钮

@end

@implementation ProjectLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    _deleteArray = [NSMutableArray array];
    
    [self loadData];
    
    [self createTableView];
    
    [self setupNav];
    
    [self setupBottomView];
}

#pragma mark -loadData 
-(void)loadData
{
    NSArray *array = @[@"金指投",@"银指投",@"铁指投",@"铜指头",@"大拇指",@"金指投",@"银指投",@"铁指投",@"铜指头",@"大拇指",@"金指投",@"银指投",@"铁指投",@"铜指头",@"大拇指",@"金指投",@"银指投",@"铁指投",@"铜指头",@"大拇指",@"金指投",@"银指投",@"铁指投",@"铜指头",@"大拇指"];
    for (int i =0; i<20; i++) {
        ProjectLetterModel *model= [ProjectLetterModel new];
        model.titleLabel = array[i];
        [_dataArray addObject:model];
    }
}
#pragma mark -创建tableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.bottom);
    }];
    
}
#pragma mark -导航栏设置
-(void)setupNav
{
    //返回按钮
    UIButton * leftback = [UIButton buttonWithType:UIButtonTypeCustom];
    leftback.tag = 0;
    [leftback setBackgroundImage:[UIImage imageNamed:@"leftBack"] forState:UIControlStateNormal];
    leftback.size = leftback.currentBackgroundImage.size;
    [leftback addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftback] ;
    //编辑按钮
    UIButton * operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    operateBtn.tag = 1;
    [operateBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [operateBtn.titleLabel setFont:BGFont(17)];
    [operateBtn setTitle:@"完成" forState:UIControlStateSelected];
    [operateBtn setBackgroundColor:[UIColor clearColor]];
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [operateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    operateBtn.size = CGSizeMake(36, 18);
    [operateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:operateBtn];
    _operateBtn = operateBtn;
//    标题视图
    UIView *titleView = [UIView new];
//    [titleView setBackgroundColor:[UIColor greenColor]];
    titleView.frame = CGRectMake(0, 0, 80, 25);
    
    UILabel *label = [UILabel new];
    label.text = @"站内信";
    label.font = BGFont(20);
    
//    label.backgroundColor = [UIColor orangeColor];
    label.textColor  = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleView);
        make.centerY.mas_equalTo(titleView);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 2;
    [btn setBackgroundImage:[UIImage imageNamed:@"letterArrow"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView);
        make.left.mas_equalTo(label.mas_right).offset(5);
        
    }];
    
    
    self.navigationItem.titleView = titleView;
}
#pragma mark -底部视图设置
-(void)setupBottomView
{
    //初始化底部视图
    _bottomView = [UIView new];
    _bottomView.hidden = YES;
    [_bottomView setBackgroundColor:color(61, 69, 78, 1)];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(48*HEIGHTCONFIG);
    }];
    //初始化全选按钮
    _allSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"letterUnselected"] forState:UIControlStateNormal];
    [_allSelectedBtn setTag:5];
    [_allSelectedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_allSelectedBtn setBackgroundImage:[UIImage imageNamed:@"letterSelected"] forState:UIControlStateSelected];
    [_bottomView addSubview:_allSelectedBtn];
    [_allSelectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView);
        make.left.mas_equalTo(_bottomView.mas_left).offset(18*WIDTHCONFIG);
    }];
    //全选label
    UILabel * label = [UILabel new];
    label.text = @"全选";
    label.font = BGFont(17);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView);
        make.left.mas_equalTo(_allSelectedBtn.mas_right).offset(9*WIDTHCONFIG);
        make.height.mas_equalTo(17);
    }];
    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTag:6];
    [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_deleteBtn.titleLabel setFont:BGFont(17)];
    [_bottomView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomView.mas_right).offset(-(23*WIDTHCONFIG));
        make.centerY.mas_equalTo(_bottomView);
        make.height.mas_equalTo(17*HEIGHTCONFIG);
    }];
    
    
}

#pragma mark -tableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ProjectLetterCell";
    ProjectLetterCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:nil options:nil] lastObject];
        }
    //如果编辑按钮未点击
    if (!_operateBtn.selected) {
        cell.selectImage.hidden = YES;
        [cell relayoutCellWithModel:_dataArray[indexPath.row]];
        return cell;
    }else{   // 出于编辑状态下
        cell.selectImage.hidden = NO;
        cell.iconLeftSpace.constant =41;
    }
    
    [cell relayoutCellWithModel:_dataArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_operateBtn.selected) {
        NSLog(@"进入详情页面");
    }else{   //在编辑状态下
        ProjectLetterModel *model = _dataArray[indexPath.row];
        model.selectedStatus = !model.selectedStatus;  //改变model的选中状态
        [_deleteArray addObject:model];          //将选中的model加入删除数组
        //刷新表格
        [_tableView reloadData];
        //刷新当前行
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

}
-(void)btnClick:(UIButton*)btn
{
    if (btn.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (btn.tag == 1) {
        btn.selected = !btn.selected;
        _bottomView.hidden = !_bottomView.hidden;
        
        //判断tableView的长度
        if (!_bottomView.hidden) {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SCREENHEIGHT-48*SCREENHEIGHT);
            }];
        }else{
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(SCREENHEIGHT);
            }];
            
        }
        
        //刷新tableView
        [_tableView reloadData];
        
        NSLog(@"点击编辑");
    }
    if (btn.tag == 5) {
        _allSelectedBtn.selected = !_allSelectedBtn.selected;
        //清空删除数组内容
        [_deleteArray removeAllObjects];
        //改变model的选中状态
        for (NSInteger i=0; i<_dataArray.count; i++) {
            ProjectLetterModel *model =_dataArray[i];
            model.selectedStatus = btn.selected;
            //将model加入删除数组
            if (model.selectedStatus) {
                [_deleteArray addObject:model];
            }
            //刷新表格
            [_tableView reloadData];
        }
    }
    //删除按钮 点击事件
    if (btn.tag == 6) {
        //将删除数组从原数组移除
        for (NSInteger i=0; i < _deleteArray.count; i++) {
            [_dataArray removeObject:_deleteArray[i]];
        }
        //将全选按钮职位常态
        if (_allSelectedBtn.selected) {
            _allSelectedBtn.selected = NO;
        }
        //刷新表格
        [_tableView reloadData];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    //显示tabbar
    AppDelegate *delegate = [UIApplication sharedApplication].delegate ;
    [delegate.tabBar tabBarHidden:NO animated:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _dataArray = nil;
    _deleteArray = nil;
    
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
