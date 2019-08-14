//
//  SYCollectionView.h
//  gxsNewApp
//
//  Created by Apple on 2019/1/19.
//  Copyright © 2019年 liuyongqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCollectionViewCellProtocol.h"
#import "SYCollectionViewCellRenderProtocol.h"
#import "SYCollectionViewCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYCollectionViewScrollDelegate <NSObject>
@optional
- (void)sy_scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)sy_scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2);

- (void)sy_scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)sy_scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
- (void)sy_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)sy_scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)sy_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)sy_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (nullable UIView *)sy_viewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)sy_scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2);
- (void)sy_scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale;

- (BOOL)sy_scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)sy_scrollViewDidScrollToTop:(UIScrollView *)scrollView;

- (void)sy_scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0));
@end

@protocol SYCollectionViewControlDelegate <NSObject>
@optional
- (void)sy_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(id)model;

- (void)sy_inCollectionViewButtonEvent:(UIButton *)button model:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)sy_cellHasCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath didSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(id)model cellClass:(NSString *)cellClass;

- (void)sy_inCollectionView:(UICollectionView *)collectionView hasKindOfControl:(UIControl *)control model:(id)model atIndexPath:(NSIndexPath *)indexPath;
@end

@protocol SYCollectionViewDeletgate <NSObject>

- (void)sy_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

- (UICollectionReusableView *)sy_collectionView:(UICollectionView *)collectionView headerViewatIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)sy_collectionView:(UICollectionView *)collectionView footerViewatIndexPath:(NSIndexPath *)indexPath;
@end

@protocol SYCollectionViewEditDelegate <NSObject>
- (BOOL)sy_collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);

- (void)sy_collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0);

- (nullable NSArray<NSString *> *)sy_indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2));

- (NSIndexPath *)sy_collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2));
@end

@interface SYCollectionView : UICollectionView
@property (nonatomic, strong) id data;
@property (nonatomic, weak) id<SYCollectionViewControlDelegate> controlDelegate;
@property (nonatomic, weak) id<SYCollectionViewScrollDelegate> scrollDelegate;
@property (nonatomic, weak) id<SYCollectionViewDeletgate> syDelegate;
@property (nonatomic, weak) id<SYCollectionViewEditDelegate> editDelegate;
@end

NS_ASSUME_NONNULL_END

