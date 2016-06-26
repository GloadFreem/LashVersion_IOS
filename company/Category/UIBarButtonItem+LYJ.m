//
//  UIBarButtonItem+LYJ.m
//  ChemistsStore
//

//  Copyright (c) 2015年 Gene. All rights reserved.
//

#import "UIBarButtonItem+LYJ.h"

@implementation UIBarButtonItem (LYJ)


+ (id)barButtonItemWithIcon:(NSString *)icon andHeightIcon:(NSString *)heightIcon Target:(id)target action:(SEL)action andTag:(NSInteger)tag{
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setBounds:CGRectMake(0, 0, 15, 15)];
    UIImage * imageNormal =[UIImage imageNamed:icon];
    imageNormal = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:imageNormal forState:UIControlStateNormal];
    UIImage * heightImage =[UIImage imageNamed:heightIcon];
    heightImage = [heightImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:heightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}


@end
