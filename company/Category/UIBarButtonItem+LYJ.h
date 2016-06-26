//
//  UIBarButtonItem+LYJ.h
//  ChemistsStore
//

//  Copyright (c) 2015年 Gene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LYJ)

+ (id)barButtonItemWithIcon:(NSString *)icon andHeightIcon:(NSString *)heightIcon Target:(id)target action:(SEL)action andTag:(NSInteger)tag;

@end
