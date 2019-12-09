//
//  SYCollectionView.m
//  gxsNewApp
//
//  Created by Apple on 2019/1/19.
//  Copyright © 2019年 liuyongqiang. All rights reserved.
//

#import "SYCollectionView.h"
#import "UIButton+SYCollectionView.h"

@interface SYCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *allkeys;
@end

@implementation SYCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.data isKindOfClass:[NSArray class]]) {
        return 1;
    } else {
        NSDictionary *dictionary = self.data;
        self.allkeys = dictionary.allKeys;
        self.allkeys = [self.allkeys sortedArrayUsingSelector:@selector(compare:)];
        return self.allkeys.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.data isKindOfClass:[NSArray class]]) {
        NSArray *array = self.data;
        return array.count;
    } else {
        NSDictionary *dictionary = self.data;
        NSString *key = [self.allkeys objectAtIndex:section];
        return [[dictionary objectForKey:key] count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.data isKindOfClass:[NSArray class]]) {
        NSArray *array = self.data;
        SYCollectionViewCellModel *cellModel = array[indexPath.row];
        return [self configCollectionViewWithCellModel:cellModel inCollectionView:collectionView atIndexPath:indexPath];
    } else {
        NSDictionary *dictionary = self.data;
        NSString *key = [self.allkeys objectAtIndex:indexPath.section];
        SYCollectionViewCellModel *cellModel = [dictionary objectForKey:key][indexPath.row];
        return [self configCollectionViewWithCellModel:cellModel inCollectionView:collectionView atIndexPath:indexPath];
    }
}

- (UICollectionViewCell *)configCollectionViewWithCellModel:(SYCollectionViewCellModel *)cellModel inCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    if ([cellModel respondsToSelector:@selector(cellIdentifier)]) {
        NSString *cellClassStr = [cellModel cellIdentifier];
        [self registerClass:[NSClassFromString(cellClassStr) class] forCellWithReuseIdentifier:cellClassStr];
        id<SYCollectionViewCellProtocol> cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassStr forIndexPath:indexPath];
        if ([cell respondsToSelector:@selector(bindCellModelCollectionView:cellModel:withIndexPath:)]) {
            [cell bindCellModelCollectionView:self cellModel:cellModel withIndexPath:indexPath];
        }
        if ([cell respondsToSelector:@selector(cellControls)]) {
            [cell.cellControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIButton class]]) {
                    if ([self.controlDelegate respondsToSelector:@selector(sy_inCollectionViewButtonEvent:model:indexPath:)]) {
                        UIButton *button = (UIButton *)obj;
                        [button clickButtonWithEvent:UIControlEventTouchUpInside action:^(UIButton * _Nonnull sender) {
                            [self.controlDelegate sy_inCollectionViewButtonEvent:(UIButton *)obj model:cellModel.enity indexPath:indexPath];
                        }];
                    }
                } else {
                    if ([self.controlDelegate respondsToSelector:@selector(sy_inCollectionView:hasKindOfControl:model:atIndexPath:)]) {
                        [self.controlDelegate sy_inCollectionView:collectionView hasKindOfControl:obj model:cellModel.enity atIndexPath:indexPath];
                    }
                }
            }];
        }
        
        return (UICollectionViewCell *)cell;
    }
    return [[UICollectionViewCell alloc] initWithFrame:CGRectZero];
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.data isKindOfClass:[NSArray class]]) {
        NSArray *array = self.data;
        id<SYCollectionViewCellRenderProtocol> cellModel = array[indexPath.row];
        Class<SYCollectionViewCellProtocol> cellClass = NSClassFromString([cellModel cellIdentifier]);
        if ([(NSObject *)cellClass respondsToSelector:@selector(sizeForCollectionView:cellModel:constrainedToSize:atIndexPath:)]) {
            return [cellClass sizeForCollectionView:collectionView
                                          cellModel:cellModel
                                  constrainedToSize:collectionView.frame.size atIndexPath:indexPath];
        }
        return CGSizeZero;
    } else {
        NSDictionary *dictionary = self.data;
        NSString *key = [self.allkeys objectAtIndex:indexPath.section];
        id<SYCollectionViewCellRenderProtocol> cellModel = [dictionary objectForKey:key][indexPath.row];
        Class<SYCollectionViewCellProtocol> cellClass = NSClassFromString([cellModel cellIdentifier]);
        if ([(NSObject *)cellClass respondsToSelector:@selector(sizeForCollectionView:cellModel:constrainedToSize:atIndexPath:)]) {
            return [cellClass sizeForCollectionView:collectionView
                                          cellModel:cellModel
                                  constrainedToSize:collectionView.frame.size atIndexPath:indexPath];
        }
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.syDelegate respondsToSelector:@selector(sy_collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.syDelegate sy_collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.syDelegate respondsToSelector:@selector(sy_collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.syDelegate sy_collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    return CGSizeZero;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.data isKindOfClass:[NSArray class]]) {
        NSArray *array = self.data;
        SYCollectionViewCellModel *cellModel = array[indexPath.item];
        if ([self.controlDelegate respondsToSelector:@selector(sy_collectionView:didSelectItemAtIndexPath:model:)]) {
            [self.controlDelegate sy_collectionView:collectionView didSelectItemAtIndexPath:indexPath model:cellModel.enity];
        }
        
    } else {
        NSDictionary *dictionary = self.data;
        NSString *key = [self.allkeys objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:key];
        SYCollectionViewCellModel *cellModel = array[indexPath.item];
        if ([self.controlDelegate respondsToSelector:@selector(sy_collectionView:didSelectItemAtIndexPath:model:)]) {
            [self.controlDelegate sy_collectionView:collectionView didSelectItemAtIndexPath:indexPath model:cellModel.enity];
        }
    }
}

- (void)sy_collectionView:(UICollectionView *)collectionView atIndexPath:(nonnull NSIndexPath *)atIndexPath didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath model:(nonnull id)model cellClass:(nonnull NSString *)cellClass {
    if ([self.controlDelegate respondsToSelector:@selector(sy_cellHasCollectionView:atIndexPath:didSelectItemAtIndexPath:model:cellClass:)]) {
        [self.controlDelegate sy_cellHasCollectionView:collectionView atIndexPath:atIndexPath didSelectItemAtIndexPath:indexPath model:model cellClass:cellClass];
    }
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidScroll:)]) {
        [self.scrollDelegate sy_scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewWillBeginDragging:)]) {
        [self.scrollDelegate sy_scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2) {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidZoom:)]) {
        [self.scrollDelegate sy_scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.scrollDelegate sy_scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidEndDragging:willDecelerate:)]) {
        [self.scrollDelegate sy_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewWillBeginDecelerating:)]) {
        [self.scrollDelegate sy_scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate sy_scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidEndScrollingAnimation:)]) {
        [self.scrollDelegate sy_scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_viewForZoomingInScrollView:)]) {
        return [self.scrollDelegate sy_viewForZoomingInScrollView:scrollView];
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2) {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewWillBeginZooming:withView:)]) {
        [self.scrollDelegate sy_scrollViewWillBeginZooming:scrollView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidEndZooming:withView:atScale:)]) {
        [self.scrollDelegate sy_scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewShouldScrollToTop:)]) {
        return [self.scrollDelegate sy_scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidScrollToTop:)]) {
        [self.scrollDelegate sy_scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) {
    if ([self.scrollDelegate respondsToSelector:@selector(sy_scrollViewDidChangeAdjustedContentInset:)]) {
        [self.scrollDelegate sy_scrollViewDidChangeAdjustedContentInset:scrollView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.syDelegate respondsToSelector:@selector(sy_collectionView:willDisplayCell:forItemAtIndexPath:)]) {
        [self.syDelegate sy_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if ([self.syDelegate respondsToSelector:@selector(sy_collectionView:headerViewatIndexPath:)]) {
            return [self.syDelegate sy_collectionView:collectionView headerViewatIndexPath:indexPath];
        }
    } else {
        if ([self.syDelegate respondsToSelector:@selector(sy_collectionView:footerViewatIndexPath:)]) {
            return [self.syDelegate sy_collectionView:collectionView footerViewatIndexPath:indexPath];
        }
    }
    return nil;
}

#pragma mark - EditDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.editDelegate respondsToSelector:@selector(sy_collectionView:canMoveItemAtIndexPath:)]) {
        return [self.editDelegate sy_collectionView:collectionView canMoveItemAtIndexPath:indexPath];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.editDelegate respondsToSelector:@selector(sy_collectionView:moveItemAtIndexPath:toIndexPath:)]) {
        [self.editDelegate sy_collectionView:collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView API_AVAILABLE(tvos(10.2)) {
    if ([self.editDelegate respondsToSelector:@selector(sy_indexTitlesForCollectionView:)]) {
        return [self.editDelegate sy_indexTitlesForCollectionView:collectionView];
    }
    return @[];
}

/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
/// Return an index path with a single index to indicate an entire section, instead of a specific item.
- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index API_AVAILABLE(tvos(10.2)) {
    if ([self.editDelegate respondsToSelector:@selector(sy_collectionView:indexPathForIndexTitle:atIndex:)]) {
        return [self.editDelegate sy_collectionView:collectionView indexPathForIndexTitle:title atIndex:index];
    }
    return nil;
}
@end

