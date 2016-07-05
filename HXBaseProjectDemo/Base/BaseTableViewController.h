//
//  BaseTableViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"

@interface BaseTableViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableview;

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
