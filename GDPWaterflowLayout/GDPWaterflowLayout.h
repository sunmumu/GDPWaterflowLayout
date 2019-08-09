//
//  GDPWaterflowLayout.h
//  HaiPai
//
//  Created by solin on 2019/8/9.
//  Copyright © 2019 solin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GDPWaterflowLayout;

@protocol GDPWaterflowLayoutDelegate  <NSObject>

@required

- (CGFloat)waterflowLayout:(GDPWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@optional

/**
 *  需要显示的列数, 默认2
 */
- (NSInteger)waterflowLayout:(GDPWaterflowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView;
/**
 *  列间距, 默认15
 */
- (CGFloat)waterflowLayout:(GDPWaterflowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView;
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(GDPWaterflowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  距离collectionView四周的间距, 默认{0, 10, 10, 10}
 */
- (UIEdgeInsets)waterflowLayout:(GDPWaterflowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView;


@end

@interface GDPWaterflowLayout : UICollectionViewLayout

/** 段头的size */
@property (nonatomic, assign) CGSize headerReferenceSize;

@property (nonatomic, weak) id<GDPWaterflowLayoutDelegate> delegate;

/** layout的代理 */
- (instancetype)initWithDelegate:(id<GDPWaterflowLayoutDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
