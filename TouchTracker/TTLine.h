//
// Created by 吕晴阳 on 2018/9/9.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface TTLine : NSObject
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;
-(double) angleRadio;
-(BOOL) nearPoint:(CGPoint) point distance:(double)distance;
-(void) translate:(CGPoint)translation;
@end