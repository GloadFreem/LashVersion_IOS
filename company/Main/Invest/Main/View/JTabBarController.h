//
//  JTabBarController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTabBarControllerDelegate <NSObject>

@optional
-(void)selectedViewController:(UIViewController*)viewController;

@end



@interface JTabBarController : UITabBarController

@property (nonatomic, assign) NSInteger selectedItem;
/*  是否显示中间的按钮，默认为NO*/
@property (nonatomic, assign) BOOL showCenterItem;

/*  中间按钮的图片 */
@property (nonatomic, strong) UIImage * centerItemImage;

/* 中间按钮的试图控制器*/
@property (nonatomic, strong) UIViewController * centerViewController;

/* 文字颜色*/
@property (nonatomic, strong) UIColor * textColor;


/*   delegate*/
@property (nonatomic, weak) id<JTabBarControllerDelegate>JDelegate;


/* 隐藏或显示Tabbar */
-(void)tabBarHidden:(BOOL)hidden animated:(BOOL)animated;

/* 隐藏或显示中间试图控制器 */
-(void)showCenterViewController:(BOOL)show animated:(BOOL)animated;


-(id)initWithTabBarSelectedImages:(NSMutableArray*)selected normalImages:(NSMutableArray*)normal titles:(NSMutableArray*)titles;


@end


@interface Button : UIButton
@property (nonatomic, assign) NSUInteger badgeValue;
+ (instancetype)shareButton;


@end