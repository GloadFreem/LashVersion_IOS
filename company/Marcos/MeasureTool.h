
//
//  MeasureTool.h
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#ifndef MeasureTool_h
#define MeasureTool_h

#define SCREENWIDTH [UIScreen mainScreen] .bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen] .bounds.size.height
#define WIDTHCONFIG ([[UIScreen mainScreen] bounds].size.width/375.0)
#define HEIGHTCONFIG ([[UIScreen mainScreen] bounds].size.height/667.0)
#define color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define color47  color(47,47,47,1)
#define color74  color(74,74,74,1)
#define orangeColor  color(255,103,0,1)
#define colorBlue    color(0,160,233,1)
#define colorGray   color(230,230,230,1)
#define btnGreen    color(84,175,135,1)
#define btnCray     color(204,204,204,1)

#define BGFont(size) [UIFont systemFontOfSize:size]

#define NUMBERFORTY 40
#define NUMBERTHIRTY 30

#endif /* MeasureTool_h */
