//
//  UIButton+SYCollectionView.m
//  Pods-SYCollectionView_Example
//
//  Created by 宋玉 on 2019/8/14.
//

#import "UIButton+SYCollectionView.h"
#import <objc/message.h>

@implementation UIButton (SYCollectionView)
- (void)clickButtonWithEvent:(UIControlEvents)event action:(void (^)(UIButton * _Nonnull))action {
    if (action) {
        objc_setAssociatedObject(self, _cmd, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self addTarget:self action:@selector(buttonClick) forControlEvents:event];
}

- (void)buttonClick {
    void (^block)(UIButton *button);
    block = objc_getAssociatedObject(self, @selector(clickButtonWithEvent:action:));
    block(self);
}
@end
