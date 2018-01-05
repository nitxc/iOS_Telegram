/*
 * This is the source code of BTCchat for iOS v. 1.1
 * It is licensed under GNU GPL v. 2 or later.
 * You should have received a copy of the license in this archive (see LICENSE).
 *
 * Copyright Peter Iakovlev, 2013.
 */

#import <Foundation/Foundation.h>

@class UICollectionView;

@interface TGCollectionViewUpdateContext : NSObject

- (void)insertSectionAtIndex:(NSUInteger)index;
- (void)deleteSectionAtIndex:(NSUInteger)index;
- (void)insertItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void)deleteItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void)replaceItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;

- (void)commit:(UICollectionView *)collectionView;

@end