//
//  SYCollectionViewCellRenderProtocol.h
//  gxsNewApp
//
//  Created by Apple on 2019/1/19.
//  Copyright © 2019年 liuyongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYCollectionViewCellRenderProtocol <NSObject>
@required
/**
 Cell对应的重用标识

 @return cell重用字符串
 */
- (NSString *)cellIdentifier;
@end

NS_ASSUME_NONNULL_END
