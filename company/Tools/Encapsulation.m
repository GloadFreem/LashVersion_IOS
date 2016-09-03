//
//  Encapsulation.m
//  WatchMagazine
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 lile. All rights reserved.
//

#import "Encapsulation.h"


@implementation Encapsulation

+ (void)viewController:(UIViewController * )mySelf img:(NSString *)img
{
    mySelf.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 150, 30)];
    UIImageView *titleLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLogoImgView.image = [UIImage imageNamed:img];
    [mySelf.navigationItem.titleView addSubview:titleLogoImgView];
}


+ (void)returnWithViewController:(UIViewController * )mySelf img:(NSString *)img
{
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.size = CGSizeMake(80, 30);
    [returnBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    [returnBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    mySelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:returnBtn];
    [returnBtn addTarget:mySelf action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
}

+ (void)rightBarButtonWithViewController:(UIViewController * )vc imgName:(NSString *)imgName
{
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.size = CGSizeMake(80, 30);
    [rightBarButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60)];
    [rightBarButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    [rightBarButton addTarget:vc action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backHome:(UIViewController *)mySelf
{
    [mySelf.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonAction:(UIViewController *)mySelf
{
    
}

+ (void)tableViewCellAnimation:(UITableViewCell *)cell
{
    //动画
    cell.layer.transform=CATransform3DMakeScale(0.3, 0.3, 0.1);
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 0.1);
    }];
}

+ (void)collectionViewCellAnimation:(UICollectionViewCell *)cell
{
    //动画
    cell.layer.transform=CATransform3DMakeScale(0.3, 0.3, 0.1);
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 0.1);
    }];
}
#pragma mark - 刷新


//// 下拉刷新
//- (void)addHeader:(UIViewController *)vc tableView:(UITableView *)tableView
//{
//    //__block myViewController *vc = self;
//    [tableView addHeaderWithCallback:^{
//        
//        _nextPage = 1;
//        _isUpLoading = NO;
//        [vc getAFN:_nextPage];
//        
//    }];
//    [tableView headerBeginRefreshing];
//}

//// 上拉刷新
//- (void)addFooter
//{
//    
//    __block ForumListViewController *vc = self;
//    [self.tableView addFooterWithCallback:^{
//        vc.nextPage++;
//        vc.isUpLoading = YES;
//        [vc getAFN:vc.nextPage];
//    }];
//    [self.tableView headerBeginRefreshing];
//}


@end
