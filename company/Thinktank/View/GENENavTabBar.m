//
//  GENENavTabBar.m
//  Company
//
//  Created by Eugene on 2016/10/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "GENENavTabBar.h"


#define TABBAR_TITLE_FONT [UIFont systemFontOfSize:17.f]
#define TABBAR_TITLE_SIZE_FONT [UIFont systemFontOfSize:14.f]

@interface GENENavTabBar (){
    UIButton        *_arrowButton;
    
    UIScrollView    *_navigationTabBar;      // all items on this scroll view
    
    UIView          *_line;                 // underscore show which item selected
//    ZLPopView       *_popView;              // when item menu, will show this view
    
    NSMutableArray  *_items;                // SCNavTabBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
    BOOL            _showArrowButton;       // is showed arrow button
    BOOL            _popItemMenu;           // is needed pop item menu
    NSMutableArray  *_itemsShowedTitle;
}
@end

@implementation GENENavTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [TDUtil colorWithHexString:@"3e3e3e"];
        [self viewConfig];
    }
    return self;
}

-(void)viewConfig
{
    _items = [@[] mutableCopy];
    _itemsShowedTitle = [@[] mutableCopy];
    
    CGFloat navWidth = SCREEN_WIDTH;
    _navigationTabBar = [[UIScrollView alloc]initWithFrame:CGRectMake(ZERO_COORDINATE, ZERO_COORDINATE, navWidth, NAVIGATION_BAR_HEIGHT)];
    _navigationTabBar.backgroundColor = [UIColor clearColor];
    _navigationTabBar.showsVerticalScrollIndicator = NO;
    _navigationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navigationTabBar];
    
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, NAVIGATION_BAR_HEIGHT - 0.0f, width - 4.0f, 0.0f)];
    _line.backgroundColor = [UIColor clearColor];
    [_navigationTabBar addSubview:_line];
}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    CGFloat width = (SCREEN_WIDTH - 16)/3;
    NSNumber *number = [NSNumber numberWithFloat:width];
//    for (NSString *title in titles)
//    {
//        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : TABBAR_TITLE_FONT} context:nil].size;
//        NSNumber *width = [NSNumber numberWithFloat:size.width + 20.f];
//        [widths addObject:width];
//    }
    for (NSInteger i = 0; i< 3; i++) {
        [widths addObject:number];
    }
    return widths;
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    [self cleanData];
    CGFloat buttonX = 8;
    for (NSInteger index = 0; index < _selectedItemTitles.count; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, ZERO_COORDINATE, [widths[index] floatValue], NAVIGATION_BAR_HEIGHT);
        button.titleLabel.font = TABBAR_TITLE_FONT;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:_selectedItemTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:[TDUtil colorWithHexString:@"c0d2eb"] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navigationTabBar addSubview:button];
        
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
        if (index == 0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:17];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }
    }
    if (widths.count) {
        [self showLineWithButtonWidth:[widths[0] floatValue]];
    }
    return buttonX;
}

- (void)cleanData
{
    [_items removeAllObjects];
    [_navigationTabBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    if ([self.delegate respondsToSelector:@selector(itemDidSelectedWithIndex:)]) {
        [self.delegate itemDidSelectedWithIndex:index];
    }
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex =currentIndex;
    UIButton *button = nil;
    //    if (_currentIndex < _items.count) {
    button = _items[currentIndex];
    for (UIButton *btn in _items) {
        if (btn == button) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:17];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }else{
            [btn setTitleColor:[TDUtil colorWithHexString:@"c0d2eb"] forState:UIControlStateNormal];
//            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
    }
    //    }else {
    //        button = [_items firstObject];
    //    }
    
    CGFloat flag = SCREEN_WIDTH;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (currentIndex < [_selectedItemTitles count] - 1)
        {
            offsetX = offsetX + 40.f;
        }
        
        [_navigationTabBar setContentOffset:CGPointMake(offsetX, ZERO_COORDINATE) animated:YES];
    }
    else
    {
        [_navigationTabBar setContentOffset:CGPointMake(ZERO_COORDINATE, ZERO_COORDINATE) animated:YES];
    }
    
    
    //    if (_currentIndex < _items.count) {
    [UIView animateWithDuration:.2f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentIndex] floatValue] - 4.0f, _line.frame.size.height);
    }];
    //    }

}


- (void)setSelectedItemTitles:(NSArray *)selectedItemTitles
{
    _selectedItemTitles = selectedItemTitles;
    _itemsWidth = [self getButtonsWidthWithTitles:_selectedItemTitles];
    CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
    _navigationTabBar.contentSize = CGSizeMake(contentWidth, ZERO_COORDINATE);
    CGFloat X = (SCREEN_WIDTH - contentWidth)/2;
    _navigationTabBar.frame = CGRectMake(X, ZERO_COORDINATE, contentWidth, NAVIGATION_BAR_HEIGHT);
}


@end
