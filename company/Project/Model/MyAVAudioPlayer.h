//
//  MyAVAudioPlayer.h
//  company
//
//  Created by Eugene on 16/7/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface MyAVAudioPlayer : AVAudioPlayer

single_interface(MyAVAudioPlayer);
@property(nonatomic,strong) AVAudioPlayer *player;

-(instancetype)init;

+(instancetype)sharedAVAudioPlayer;

@property(assign,nonatomic)BOOL isPlayMusic;

@end
