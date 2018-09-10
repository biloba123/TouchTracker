//
// Created by 吕晴阳 on 2018/9/9.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "TTDrawView.h"
#import "TTLine.h"

@interface TTDrawView ()
@property(nonatomic) NSMutableArray *finishLines;
@property(nonatomic) TTLine *curLine;
@end

@implementation TTDrawView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _finishLines = [NSMutableArray new];
        self.backgroundColor= [UIColor whiteColor];
        self.multipleTouchEnabled=YES;
    }
    return self;
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] set];
    for (TTLine *line in self.finishLines) {
        [self drawLine:line];
    }

    if (self.curLine) {
        [[UIColor redColor] set];
        [self drawLine:self.curLine];
    }

}

- (void)drawLine:(nonnull TTLine *)line {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 10;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:line.start];
    [path addLineToPoint:line.end];
    [path stroke];
}

#pragma mark Touch events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    TTLine *line = [TTLine new];
    line.start = line.end = [[touches anyObject] locationInView:self];
    self.curLine = line;
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    self.curLine.end = [[touches anyObject] locationInView:self];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.finishLines addObject:self.curLine];
    self.curLine=nil;
    [self setNeedsDisplay];
}

@end