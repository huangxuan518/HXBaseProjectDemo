//
//  BaseCollectionViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseCollectionViewCell.h"

@interface BaseCollectionViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

//- (void)refresh;//下拉请求
//
//- (void)loadMore;//加载更多
//
//- (void)endRefreshing;//结束刷新
//
//- (void)removedRefreshing;//去掉上下拉刷新
//
//- (void)hideLoadMoreRefreshing;//隐藏加载更多
//
//- (void)showLoadMoreRefreshing;//显示加载更多

@end
