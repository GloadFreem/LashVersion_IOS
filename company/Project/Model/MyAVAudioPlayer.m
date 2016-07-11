//
//  MyAVAudioPlayer.m
//  company
//
//  Created by Eugene on 16/7/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "MyAVAudioPlayer.h"

@implementation MyAVAudioPlayer

single_implementation(MyAVAudioPlayer)


-(instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}

#pragma mark 单例模式(避免同时播放多首歌)
+(instancetype)sharedAVAudioPlayer{
    static MyAVAudioPlayer *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


@end
