//
//  Encapsulation.h
//  WatchMagazine
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 lile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encapsulation : NSObject
/**
 *  添加头部标题图片
 *
 *  @param mySelf 当前控制器
 *  @param img    要添加的标题图片
 */
+ (void)viewController:(UIViewController * )mySelf img:(NSString *)img;

+ (void)returnWithViewController:(UIViewController * )mySelf img:(NSString *)img;

+ (void)rightBarButtonWithViewController:(UIViewController * )vc imgName:(NSString *)imgName;
/**
 *  给cell添加动画
 *
 *  @param cell 当前UITableViewCell
 */
+ (void)tableViewCellAnimation:(UITableViewCell *)cell;

/**
 *  给cell添加动画
 *
 *  @param cell 当前UICollectionViewCell
 */
+ (void)collectionViewCellAnimation:(UICollectionViewCell *)cell;

- (void)addHeader:(UIViewController *)vc tableView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, assign) BOOL isUpLoading;

@end
