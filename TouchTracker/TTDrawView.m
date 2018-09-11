//
// Created by 吕晴阳 on 2018/9/9.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "TTDrawView.h"
#import "TTLine.h"

@interface TTDrawView ()
@property(nonatomic) NSMutableArray *finishLines;
@property(nonatomic) NSMutableDictionary *curLines;
@end

@implementation TTDrawView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _finishLines = [NSMutableArray new];
        _curLines = [NSMutableDictionary new];
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] set];
    for (TTLine *line in self.finishLines) {
        [self drawLine:line];
    }

    [[UIColor redColor] set];
    for (TTLine *line in self.curLines.allValues) {
        [self drawLine:line];
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
    for (UITouch *touch in touches) {
        TTLine *line = [TTLine new];
        line.start = line.end = [touch locationInView:self];
        self.curLines[[NSValue valueWithNonretainedObject:touch]] = line;
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch *touch in touches) {
        TTLine *line = self.curLines[[NSValue valueWithNonretainedObject:touch]];
        line.end = [touch locationInView:self];
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        [self.finishLines addObject:self.curLines[key]];
        [self.curLines removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch *touch in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:touch];
        [self.curLines removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

@end