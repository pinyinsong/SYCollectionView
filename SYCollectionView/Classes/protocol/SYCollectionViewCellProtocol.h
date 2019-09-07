//
//  SYCollectionViewCellProtocol.h
//  gxsNewApp
//
//  Created by Apple on 2019/1/19.
//  Copyright © 2019年 liuyongqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYCollectionViewCellRenderProtocol;

@protocol CellHasCollectionViewDelegate <NSObject>
@optional
- (void)sy_collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath didSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(id)model cellClass:(NSString *)cellClass;
@end

@protocol SYCollectionViewCellProtocol <NSObject>
@required
/** 绑定数据 */
- (void)bindCellModelCollectionView:(UICollectionView *)collectionView cellModel:(id<SYCollectionViewCellRenderProtocol>)cellModel withIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 item尺寸
 */
+ (CGSize)sizeForCollectionView:(UICollectionView *)collectionView cellModel:(id<SYCollectionViewCellRenderProtocol>)cellModel constrainedToSize:(CGSize)size atIndexPath:(NSIndexPath *)indexPath;

/**
 所有继承UICcontrol的子类的集合
 */
- (NSArray<UIControl *> *)cellControls;

@end

NS_ASSUME_NONNULL_END

