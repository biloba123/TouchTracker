//
// Created by 吕晴阳 on 2018/9/9.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "TTLine.h"


@implementation TTLine {

}
- (double)angleRadio {
    double x = abs(self.start.x - self.end.x);
    double y = abs(self.start.y - self.end.y);
    return x / hypot(x, y);
}

- (bool)nearPoint:(CGPoint)point distance:(double)distance {
    double a = hypot(abs(self.start.x - self.end.x), abs(self.start.y - self.end.y)),
            b = hypot(abs(point.x - self.end.x), abs(point.y - self.end.y)),
            c = hypot(abs(self.start.x - point.x), abs(self.start.y - point.y));
    double s=(a+b+c)/2;
    double A= sqrt(s*(s-a)*(s-b)*(s-c));
    double d=(2*A)/a;
    return d<=distance;
}

- (void)translate:(CGPoint)translation {
    _start.x+=translation.x;
    _end.x+=translation.x;
    _start.y+=translation.y;
    _end.y+=translation.y;
}


@end