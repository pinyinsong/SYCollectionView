//
//  SYCollectionViewCellModel.h
//  gxsNewApp
//
//  Created by Apple on 2019/1/19.
//  Copyright © 2019年 liuyongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYCollectionViewCellRenderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYCollectionViewCellModel<__covariant Object> : NSObject <SYCollectionViewCellRenderProtocol>

- (instancetype)initWithEnity:(Object)enity;

@property (nonatomic, readonly) Object enity;
@end

NS_ASSUME_NONNULL_END
