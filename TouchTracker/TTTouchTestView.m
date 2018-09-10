//
// Created by 吕晴阳 on 2018/9/10.
// Copyright (c) 2018 Lv Qingyang. All rights reserved.
//

#import "TTTouchTestView.h"


@implementation TTTouchTestView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self=[super initWithFrame:frame]){
        self.backgroundColor= [UIColor grayColor];
    }

    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for(UITouch *touch in touches){
        NSLog(@"%s\n%@\n%@", sel_getName(_cmd), touch, [touch locationInView:self]);
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for(UITouch *touch in touches){
        NSLog(@"%s\n%@\n%@", sel_getName(_cmd), touch, [touch locationInView:self]);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for(UITouch *touch in touches){
        NSLog(@"%s\n%@\n%@", sel_getName(_cmd), touch, [touch locationInView:self]);
    }
}
@end