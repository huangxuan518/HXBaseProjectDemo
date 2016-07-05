//
//  BaseCollectionViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
//    // 下拉刷新
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    // 上拉刷新
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataAry.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"BaseCollectionViewCell";
    BaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //先实例化一个层
        UICollectionViewFlowLayout *layout= [UICollectionViewFlowLayout new];
        //创建一屏的视图大小
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

//#pragma mark - net
//
//- (void)refresh {
//    self.pageIndex = 1;
//    [self requestData];
//}
//
//- (void)loadMore {
//    self.pageIndex ++;
//    [self requestData];
//}
//
//- (void)endRefreshing {
//    [self.collectionView.mj_header endRefreshing];
//    [self.collectionView.mj_footer endRefreshing];
//}
//
//- (void)removedRefreshing {
//    [self endRefreshing];
//    self.collectionView.mj_header = nil;
//    self.collectionView.mj_footer = nil;
//}
//
//- (void)showLoadMoreRefreshing {
//    self.collectionView.mj_footer.hidden = NO;
//}
//
//- (void)hideLoadMoreRefreshing {
//    self.collectionView.mj_footer.hidden = YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
