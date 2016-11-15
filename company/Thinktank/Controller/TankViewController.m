//
//  TankViewController.m
//  company
//
//  Created by Eugene on 2016/10/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "TankViewController.h"
#import "GENENavTabBar.h"
#import <objc/message.h>
#import "HeadlineViewController.h"
#import "TankFastNewsController.h"
#import "TankPointController.h"
@interface TankViewController ()<UIScrollViewDelegate,GENENavTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *selectedVCArray;
@property (nonatomic, strong) UIScrollView *mainView;
@property (nonatomic, strong) GENENavTabBar *navTabBar;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *totalTitles;
@property (nonatomic, assign) NSString *recordLastClickTitle;

@end

static void *RecordLastClickKey = @"RecordLastClickKey";

@implementation TankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self viewConfig];
    [self initConfig];
    
}

- (void)viewConfig
{
//    _navTabBarColor = _navTabBarColor ? _navTabBarColor : NavTabbarColor;
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(ZERO_COORDINATE, ZERO_COORDINATE, SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
    statusView.backgroundColor = [TDUtil colorWithHexString:@"3e454f"];
    [self.view addSubview:statusView];
    
    _navTabBar = [[GENENavTabBar alloc] initWithFrame:CGRectMake(ZERO_COORDINATE, STATUS_BAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    
    _navTabBar.delegate = self;
    _navTabBar.backgroundColor = [TDUtil colorWithHexString:@"3e454f"];
    _navTabBar.lineColor = orangeColor;
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(ZERO_COORDINATE, _navTabBar.frame.origin.y + _navTabBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _navTabBar.frame.origin.y - _navTabBar.frame.size.height)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
//    _mainView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_mainView];
    [self.view addSubview:_navTabBar];
    
}

-(void)initConfig
{
    [self setupTotalTitles];
    [self setupViewControllerDict];
    if ([NSUD objectForKey:SELECTED_CHANNEL_NAMES] == nil) {
        for (int index = 0; index < 3; index++) {
            UIViewController *viewController = (UIViewController *)self.subViewControllers[index];
            viewController.view.frame = CGRectMake(index * SCREEN_WIDTH, ZERO_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
            [_mainView addSubview:viewController.view];
            [self addChildViewController:viewController];
            [self.titles addObject:[self.subViewControllers[index] title]];
        }
        _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, ZERO_COORDINATE);
    } else {
        self.titles = [NSUD objectForKey:SELECTED_CHANNEL_NAMES];
        [self addChildViewControllerWithTitlesArray:self.titles];
    }
    _navTabBar.totalItemTitles = self.totalTitles;
    _navTabBar.selectedItemTitles = self.totalTitles;
}

-(NSArray*)subViewControllers
{
    if (!_subViewControllers.count) {
        TankFastNewsController *sevenViewController = [[TankFastNewsController alloc] init];
        sevenViewController.title = @"7x24快讯";
//        sevenViewController.view.backgroundColor = [UIColor blueColor];
        
        HeadlineViewController *eightViewController = [[HeadlineViewController alloc] init];
        eightViewController.title = @"金日投条";
//        eightViewController.view.backgroundColor = [UIColor greenColor];
        
        TankPointController *ninghtViewController = [[TankPointController alloc] init];
        ninghtViewController.title = @"原创内容";
//        ninghtViewController.view.backgroundColor = [UIColor redColor];
        _subViewControllers = @[sevenViewController, eightViewController, ninghtViewController];
    }
    return _subViewControllers;
    
}

- (void)addChildViewControllerWithTitlesArray:(NSArray *)titles
{
    for (int index = 0; index < titles.count; index++) {
        NSDictionary *viewControllerDict = [NSUD objectForKey:VIEWCONTROLLER_INDEX_DICT];
        int viewControllerIndex = [viewControllerDict[titles[index]] intValue];
        UIViewController *viewController = (UIViewController *)_subViewControllers[viewControllerIndex];
        viewController.view.frame = CGRectMake(index * SCREEN_WIDTH, ZERO_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
        [_mainView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * titles.count, ZERO_COORDINATE);
}

- (void)cleanData
{
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
}

- (void)setupTotalTitles
{
    _totalTitles = [NSMutableArray arrayWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in self.subViewControllers)
    {
        [_totalTitles addObject:viewController.title];
    }
}
- (void)setupViewControllerDict
{
    NSMutableDictionary *viewControllerDict = [@{} mutableCopy];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:VIEWCONTROLLER_INDEX_DICT]) {
        [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
            [viewControllerDict setObject:[NSNumber numberWithInteger:idx] forKey:viewController.title];
        }];
        [NSUD setObject:viewControllerDict forKey:VIEWCONTROLLER_INDEX_DICT];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = round(scrollView.contentOffset.x / SCREEN_WIDTH);
    _navTabBar.currentIndex = _currentIndex;
    [self closeKeyboard];
}
-(void)closeKeyboard
{
    TankFastNewsController *fast = (TankFastNewsController *)_subViewControllers[0];
    [fast.searchBar resignFirstResponder];
    [fast.view endEditing:YES];
    HeadlineViewController *header = (HeadlineViewController *)_subViewControllers[1];
    [header.searchBar resignFirstResponder];
    [header.view endEditing:YES];
    TankPointController *point = (TankPointController *)_subViewControllers[2];
    [point resignFirstResponder];
    [point.view endEditing:YES];
}
-(void)closeKeyboard:(NSInteger)index
{
    if (index == 0) {
        HeadlineViewController *header = (HeadlineViewController *)_subViewControllers[1];
        [header.searchBar resignFirstResponder];
        TankPointController *point = (TankPointController *)_subViewControllers[2];
        [point resignFirstResponder];
    }
    if (index == 1) {
        TankFastNewsController *fast = (TankFastNewsController *)_subViewControllers[0];
        [fast.searchBar resignFirstResponder];
        TankPointController *point = (TankPointController *)_subViewControllers[2];
        [point resignFirstResponder];
    }
    if (index == 2) {
        TankFastNewsController *fast = (TankFastNewsController *)_subViewControllers[0];
        [fast.searchBar resignFirstResponder];
        HeadlineViewController *header = (HeadlineViewController *)_subViewControllers[1];
        [header.searchBar resignFirstResponder];
    }
}

#pragma mark - GENENavTabBarDelegate Methods
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    [self closeKeyboard];
    
    [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, ZERO_COORDINATE) animated:_scrollAnimation];
    NSString *selectedChannel = [NSUD objectForKey:SELECTED_CHANNEL_NAMES][index];
    objc_setAssociatedObject(self.recordLastClickTitle, RecordLastClickKey, selectedChannel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
