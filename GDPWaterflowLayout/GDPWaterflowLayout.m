//
//  GDPWaterflowLayout.m
//  HaiPai
//
//  Created by solin on 2019/8/9.
//  Copyright © 2019 solin. All rights reserved.
//

#import "GDPWaterflowLayout.h"

static const NSInteger GDP_Columns_ = 2;
static const CGFloat GDP_XMargin_ = 15;
static const CGFloat GDP_YMargin_ = 10;
static const UIEdgeInsets GDP_EdgeInsets_ = {0, 10, 10, 10};

@interface GDPWaterflowLayout ()

/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableDictionary       *maxYDict;
/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray            *attrsArray;

- (NSInteger)columns;

- (CGFloat)xMargin;

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsets;

@end

@implementation GDPWaterflowLayout

// MARK: - init
- (id<GDPWaterflowLayoutDelegate>)delegate {
    return (id<GDPWaterflowLayoutDelegate>)self.collectionView.dataSource;
}

- (instancetype)initWithDelegate:(id<GDPWaterflowLayoutDelegate>)delegate {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)flowLayoutWithDelegate:(id<GDPWaterflowLayoutDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/**
 *  每次布局之前的准备
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    // 1.清空最大的Y值
    [self.maxYDict removeAllObjects];
    
    for (int i = 0; i <self.columns; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.edgeInsets.top);
    }
    
    // 2.计算所有cell的属性
    [self.attrsArray removeAllObjects];
    
    //头部视图
    UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
    layoutHeader.frame =CGRectMake(0,0, self.headerReferenceSize.width, self.headerReferenceSize.height);
    [self.attrsArray addObject:layoutHeader];
    
    //item内容视图
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  返回所有的尺寸
 */
- (CGSize)collectionViewContentSize {
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    
    //包括段头headerView的高度
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.edgeInsets.bottom + self.headerReferenceSize.height );
}

/**
 *  返回indexPath这个位置Item的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    // 计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - (self.columns - 1) * self.xMargin)/self.columns;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 计算位置
    CGFloat x = self.edgeInsets.left + (width + self.xMargin) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + [self yMarginAtIndexPath:indexPath];
    
    // 更新这一列的最大Y值
    self.maxYDict[minColumn] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //把瀑布流的Cell的起始位置从headerView的最大Y开始布局
    attrs.frame = CGRectMake(x, self.headerReferenceSize.height + y, width, height );
    return attrs;
}

/**
 *  返回rect范围内的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

// MARK: - Setter -
- (NSInteger)columns {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:columnsInCollectionView:)]) {
        return [self.delegate waterflowLayout:self columnsInCollectionView:self.collectionView];
    } else {
        return GDP_Columns_;
    }
}

- (CGFloat)xMargin {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:columnsMarginInCollectionView:)]) {
        return [self.delegate waterflowLayout:self columnsMarginInCollectionView:self.collectionView];
    } else {
        return GDP_XMargin_;
    }
}

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:collectionView:linesMarginForItemAtIndexPath:)]) {
        return [self.delegate waterflowLayout:self collectionView:self.collectionView linesMarginForItemAtIndexPath:indexPath];
    } else {
        return GDP_YMargin_;
    }
}

- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:edgeInsetsInCollectionView:)]) {
        return [self.delegate waterflowLayout:self edgeInsetsInCollectionView:self.collectionView];
    } else {
        return GDP_EdgeInsets_;
    }
}

// MARK: - Getter -
- (NSMutableDictionary *)maxYDict {
    if (!_maxYDict) {
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}


@end
