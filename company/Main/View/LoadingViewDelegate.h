//
//  LoadingViewDelegate.h
//  company
//
//  Created by Eugene on 16/8/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingViewDelegate : NSObject

@end

@protocol LoadingViewDelegate <NSObject>

-(void)refresh;

@end