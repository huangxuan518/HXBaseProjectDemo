//
//  HXCardSwitchView.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/18.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "HXCardSwitchView.h"
#import "SXImageCell.h"
#import "AssetHelper.h"

@interface HXCardSwitchView () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 所有的图片名 */
@property (nonatomic, strong) NSMutableArray *assetImages;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation HXCardSwitchView

static NSString *const ID = @"image";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    // 创建布局
    _layout = [[SXLineLayout alloc] init];
    
    // 创建collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, self.frame.size.width, self.frame.size.height - 60) collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"SXImageCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self addSubview:_collectionView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 25, self.frame.size.width, 14)];
    _titleLabel.textColor = UIColorFromHex(0xffffff);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"";
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SXImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    id set = self.assetImages[indexPath.item];
    UIImage *image;
    if ([set isKindOfClass:[ALAsset class]]) {
        image = [ASSETHELPER getImageFromAsset:set type:ASSET_PHOTO_SCREEN_SIZE];
        cell.imageView.image = image;
    }
    
    if ([set isKindOfClass:[UIImage class]]) {
        cell.imageView.image = set;
    }
    return cell;
}

- (void)deleteWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.assetImages removeObjectAtIndex:indexPath.item];
    
    // 直接将cell删除
    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    if (self.assetImages.count > 0) {
        _titleLabel.hidden = NO;
        _titleLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.assetImages.count];
    } else {
        _titleLabel.hidden = YES;
    }
}

- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry {
    self.assetImages = [NSMutableArray arrayWithArray:cardSwitchViewAry];
  
    [_collectionView reloadData];
    
    if (self.assetImages.count > 0) {
        _titleLabel.hidden = NO;
        _titleLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.assetImages.count];
    } else {
        _titleLabel.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    
    _currentIndex = offset/243;
    
    if (_assetImages.count > 0) {
        _titleLabel.hidden = NO;
        _titleLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_currentIndex+1,(unsigned long)self.assetImages.count];
    } else {
        _titleLabel.hidden = YES;
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)assetImages
{
    if (!_assetImages) {
        _assetImages = [[NSMutableArray alloc] init];
    }
    return _assetImages;
}

@end
