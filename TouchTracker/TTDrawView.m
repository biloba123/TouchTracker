//
// Created by 吕晴阳 on 2018/9/9.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDrawView.h"
#import "TTLine.h"

@interface TTDrawView () <UIGestureRecognizerDelegate>
@property(nonatomic) NSMutableArray *finishLines;
@property(nonatomic) NSMutableDictionary *curLines;
@property(nonatomic, weak) TTLine *selectLine;
@property(nonatomic) UIPanGestureRecognizer *panRecognizer;
@end

@implementation TTDrawView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.finishLines = [NSMutableArray new];
        self.curLines = [NSMutableDictionary new];
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;

        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]
                initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTap];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self action:@selector(tap:)];
        tap.delaysTouchesBegan = YES;
        [tap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:tap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];

        self.panRecognizer = [[UIPanGestureRecognizer alloc]
                initWithTarget:self action:@selector(pan:)];
        self.panRecognizer.cancelsTouchesInView = NO;
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.panRecognizer];
    }
    return self;
}

#pragma mark - Gesture
- (void)pan:(UIPanGestureRecognizer *)recognizer {
    if(self.selectLine && recognizer.state==UIGestureRecognizerStateChanged){
        [self.selectLine translate:[recognizer translationInView:self]];
        [recognizer setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];
    }
}

- (void)longPress:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s %ld", sel_getName(_cmd), recognizer.state);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.selectLine = [self lineAtPoint:[recognizer locationInView:self]];
            break;
        case UIGestureRecognizerStateEnded:
            self.selectLine = nil;
            break;
    }
    [self setNeedsDisplay];
}


- (void)doubleTap:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s %ld", sel_getName(_cmd), recognizer.state);
    [self.finishLines removeAllObjects];
    [self.curLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s %ld", sel_getName(_cmd), recognizer.state);
    CGPoint point = [recognizer locationInView:self];
    self.selectLine = [self lineAtPoint:point];
    if (self.selectLine) {
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menuController.menuItems = @[deleteItem];
        [menuController setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menuController setMenuVisible:YES animated:YES];
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    for (TTLine *line in self.finishLines) {
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:[line angleRadio]] set];
        [self drawLine:line];
    }

    for (TTLine *line in self.curLines.allValues) {
        [[UIColor colorWithRed:0 green:0 blue:0 alpha:[line angleRadio]] set];
        [self drawLine:line];
    }

    if (self.selectLine) {
        [[UIColor greenColor] set];
        [self drawLine:self.selectLine];
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

#pragma mark - Line operation
- (void)deleteLine:(id)sender {
    [self.finishLines removeObject:self.selectLine];
    [self setNeedsDisplay];
}

#pragma mark - Others
- (TTLine *)lineAtPoint:(CGPoint)point {
    TTLine *line = nil;
    for (TTLine *l in self.finishLines) {
        if ([l nearPoint:point distance:10.0]) {
            line = l;
            break;
        }
    }

    return line;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panRecognizer) {
        return YES;
    }
    return NO;
}

@end