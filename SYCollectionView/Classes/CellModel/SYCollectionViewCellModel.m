//
//  SYCollectionViewCellModel.m
//  gxsNewApp
//
//  Created by Apple on 2019/1/19.
//  Copyright © 2019年 liuyongqiang. All rights reserved.
//

#import "SYCollectionViewCellModel.h"

@implementation SYCollectionViewCellModel
- (instancetype)initWithEnity:(id)enity {
    self = [super init];
    if (self) {
        _enity = enity;
    }
    return self;
}

- (NSString *)cellIdentifier {
    return @"";
}
@end
