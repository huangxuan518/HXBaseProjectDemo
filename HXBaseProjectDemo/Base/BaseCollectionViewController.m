//
//  BaseCollectionViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/26.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()

@property (nonatomic,strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) UIButton *backToTopBtn;//返回顶部按钮

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self header];
    [self footer];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 网络请求

- (void)requestData {
    [self endRefreshing];
}

#pragma mark - 代理
#pragma mark UICollectionViewDataSource/UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataAry.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"BaseCollectionViewCell";
    BaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 返回顶部

//显示返回顶部按钮
- (void)showBackToTopBtn {
    if (nil == _backToTopBtn) {
        _backToTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 36 - 20, self.view.frame.size.height - 20 - 36, 36, 36)];
        [_backToTopBtn setBackgroundImage:[UIImage imageNamed:@"back_to_top"] forState:UIControlStateNormal];
        [_backToTopBtn addTarget:self action:@selector(onBackToTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToTopBtn];
        
    }
    else{
        [self.view bringSubviewToFront:_backToTopBtn];
    }
    
    _backToTopBtn.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        _backToTopBtn.alpha = 1.0;
    }];
}

//隐藏返回顶部按钮
- (void)hideBackToTopBtn {
    [UIView animateWithDuration:0.3 animations:^{
        _backToTopBtn.alpha = 0.0;
    }];
}

//返回顶部事件
- (void)onBackToTopBtnClick {
    [self.collectionView setContentOffset:CGPointMake(0, -self.collectionView.contentInset.top) animated:YES];
}

#pragma mark - MJRefresh上下拉加载

- (void)refresh {
    self.pageIndex = 1;
    [self requestData];
}

- (void)loadMore {
    self.pageIndex ++;
    [self requestData];
}

- (void)endRefreshing {
    if (_header) {
        [self.header endRefreshing];
    }
    if (_footer) {
        [self.footer endRefreshing];
    }
}

- (void)removedRefreshing {
    _header = nil;
    _footer = nil;
    self.collectionView.mj_header = nil;
    self.collectionView.mj_footer = nil;
}

- (void)showLoadMoreRefreshing {
    self.footer.hidden = NO;
}

- (void)hideLoadMoreRefreshing {
    self.footer.hidden = YES;
}

- (MJRefreshNormalHeader *)header {
    if (!_header) {
        __weak __typeof(self)weakSelf = self;
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong __typeof(self)self = weakSelf;
            [self refresh];
        }];
        self.collectionView.mj_header = _header;
    }
    return [self setRefreshNormalHeaderParameter:_header];
}

- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        __weak __typeof(self)weakSelf = self;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            __strong __typeof(self)self = weakSelf;
            [self loadMore];
        }];
        self.collectionView.mj_footer = _footer;
    }
    return [self setRefreshAutoNormalFooterParameter:_footer];
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //先实例化一个层
        UICollectionViewFlowLayout *layout= [UICollectionViewFlowLayout new];
        //创建一屏的视图大小
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray new];
    }
    return _dataAry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
