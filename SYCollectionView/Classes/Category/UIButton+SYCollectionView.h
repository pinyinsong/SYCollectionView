//
//  UIButton+SYCollectionView.h
//  Pods-SYCollectionView_Example
//
//  Created by 宋玉 on 2019/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SYCollectionView)
- (void)clickButtonWithEvent:(UIControlEvents)event action:(void(^)(UIButton *sender))action;
@end

NS_ASSUME_NONNULL_END
