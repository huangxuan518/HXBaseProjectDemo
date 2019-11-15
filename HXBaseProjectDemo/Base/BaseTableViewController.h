//
//  BaseTableViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/10.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *dataSource;//cell相关data

- (NSArray *)cellDataSource;
    
//隐藏/显示navigationBar
- (void)hideNavigationBar:(BOOL)hide;
    
#pragma mark - 上下拉加载
- (void)removedRefreshing;//去掉上下拉刷新 列表默认添加 如不需要可调用该方法移除
- (void)refresh;//下拉请求
- (void)loadMore;//加载更多
- (void)endRefreshing;//结束刷新
- (void)hideLoadMoreRefreshing;//隐藏加载更多
- (void)showLoadMoreRefreshing;//显示加载更多

#pragma mark - 返回顶部
- (void)showBackToTopBtn;//显示返回顶部按钮
- (void)hideBackToTopBtn;//隐藏返回顶部按钮

//刷新数据
- (void)refreshData;

@end
