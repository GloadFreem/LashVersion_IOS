//
//  MP3Player.h
//  company
//
//  Created by Eugene on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MP3Player : NSObject

single_interface(MP3Player);
@property(strong,nonatomic)AVPlayer*player;
@property(assign,nonatomic)BOOL isPlayMusic;

-(instancetype)init;

@end
