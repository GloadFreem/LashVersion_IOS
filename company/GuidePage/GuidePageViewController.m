//
//  GuidePageViewController.m
//  company
//
//  Created by Eugene on 16/7/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "GuidePageViewController.h"

#import "LoginRegistViewController.h"

#define kImageCount 5
#define kRatioPage 0.95
#define kIntoButtonRatio 0.85
#define kImageRatio 0.6

@interface GuidePageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *page;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createScrollView];
    [self createPageController];
}

-(void)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.delegate =self;
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeMake(SCREENWIDTH*kImageCount, SCREENHEIGHT)];
    [_scrollView setPagingEnabled:YES];
    
    for (NSInteger i =0; i < kImageCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i *SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lead_guide_0%ld",(long)i+1]]];
        if (i == kImageCount - 1) {
            [self createIntoButton:imageView];
        }
        [_scrollView addSubview:imageView];
    }
    [self.view addSubview:_scrollView];
    
}
#pragma mark- 创建页面控制器
-(void)createPageController
{
    _page = [[UIPageControl alloc]init];
    [_page setBounds:CGRectMake(0, 0, 150, 55)];
    [_page setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT*kRatioPage)];
    
    [_page setNumberOfPages:kImageCount];
    [_page setCurrentPage:0];
    [_page setCurrentPageIndicatorTintColor:orangeColor];
//    [_page setPageIndicatorTintColor:orangeColor];
    [_page addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_page];
}

#pragma mark- page点击事件
-(void)pageClick:(UIPageControl*)page
{
    [_scrollView setContentOffset:CGPointMake(page.currentPage*SCREENWIDTH, 0) animated:YES];
}

#pragma mark- scrollView的代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.page setCurrentPage:scrollView.contentOffset.x/scrollView.bounds.size.width];
}

#pragma mark- 初始化最后一个界面控件
-(void)createIntoButton:(UIImageView*)imageView
{
    //打开用户交互
    [imageView setUserInteractionEnabled:YES];
    
    UIButton * intoButton =[[UIButton alloc]init];
//    UIImage * intoImage =[UIImage imageNamed:@"lead_guide_button_start"];
//    [intoButton setImage:intoImage forState:UIControlStateNormal];
    
//    CGRect intoBound ={CGPointZero,intoImage.size.width*kImageRatio,intoImage.size.height*kImageRatio};
//    [intoButton setBounds:intoBound];
    [intoButton setBackgroundColor:[UIColor clearColor]];
    [intoButton setFrame:CGRectMake(0, 0, SCREENWIDTH/2, SCREENWIDTH/5)];
    [intoButton setCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT*kIntoButtonRatio)];
    [intoButton addTarget:self action:@selector(intoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:intoButton];
}

#pragma mark- intoButton点击事件
-(void)intoButtonClick:(UIButton*)button
{
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    [data setValue:@"true" forKey:@"isStart"];
    LoginRegistViewController *login = [LoginRegistViewController new];
    
//    进入主界面
                AppDelegate * app =(AppDelegate* )[[UIApplication sharedApplication] delegate];
                app.window.rootViewController = login;
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
