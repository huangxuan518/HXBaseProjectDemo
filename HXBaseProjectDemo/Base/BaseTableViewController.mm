//
//  BaseTableViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITextField *currentTextfield;//当前的文本筐
@property (nonatomic,strong) UITextView *currentTextView;//当前的TextView
@property (nonatomic,assign) BOOL keyboardIsShown;
@property (nonatomic,assign) CGPoint contentoffset;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [self.view addSubview:self.tableview];
}

- (void)requestData {
    
}

#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
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
//    [self.tableview.mj_header endRefreshing];
//    [self.tableview.mj_footer endRefreshing];
//}
//
//- (void)removedRefreshing {
//    self.tableview.mj_header = nil;
//    self.tableview.mj_footer = nil;
//}
//
//- (void)showLoadMoreRefreshing {
//    self.tableview.mj_footer.hidden = NO;
//}
//
//- (void)hideLoadMoreRefreshing {
//    self.tableview.mj_footer.hidden = YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
