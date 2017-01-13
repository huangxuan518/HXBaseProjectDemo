
//
//  BaseViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/9.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageIndex = 1;
    [self showBack];
    [self requestData];
    self.view.backgroundColor = kViewBackgroundColor;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
}

#pragma mark - 网络请求

- (void)requestData {

}

- (void)gotoLoginViewController {

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

#pragma mark - 回到导航Index

- (void)popToHomePageWithTabIndex:(NSInteger)index
                       completion:(void (^)(void))completion
{
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    NSInteger viewIndex = 0;
    for (UIView *view in keyWindow.subviews)
    {
        if (viewIndex > 0)
        {
            [view removeFromSuperview];
        }
        viewIndex++;
    }
    
    self.tabBarController.selectedIndex = index;
    if ([self.tabBarController presentedViewController]) {
        [self.tabBarController dismissViewControllerAnimated:NO completion:^{
            for (UINavigationController *nav in self
                 .tabBarController.viewControllers) {
                [nav popToRootViewControllerAnimated:NO];
            }
            if (completion)
                completion();
        }];
    } else {
        for (UINavigationController *nav in self
             .tabBarController.viewControllers) {
            [nav popToRootViewControllerAnimated:NO];
        }
        if (completion)
            completion();
    }
}

- (void)pushViewControllerWithName:(id)classOrName {
    if (classOrName) {
        Class classs;
        if ([classOrName isKindOfClass:[NSString class]]) {
            NSString *name = classOrName;
            classs = NSClassFromString(name);
        } else if ([classOrName isSubclassOfClass:[BaseViewController class]]) {
            classs = classOrName;
        }
        
        UIViewController *vc = [classs new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)returnViewControllerWithName:(id)classOrName {
    if (classOrName) {
        Class classs;
        if ([classOrName isKindOfClass:[NSString class]]) {
            NSString *name = classOrName;
            classs = NSClassFromString(name);
        } else if ([classOrName isSubclassOfClass:[BaseViewController class]]) {
            classs = classOrName;
        }
        
        [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:classs]) {
                [self.navigationController popToViewController:obj animated:YES];
                *stop = YES;
                return;
            }
        }];
    }
}

#pragma mark 导航定制

- (void)showBack {
    if (self.navigationController.viewControllers.count > 1) {
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if (vc.title.length > 0) {
            [self showBackWithTitle:vc.title];
        } else {
            [self showBackWithTitle:vc.navigationItem.title];
        }
    }
}

- (UIView *)ittemRedViewWithRedDotValue:(NSString *)redDotValue {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor redColor];
    label.text = redDotValue;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    float leight = 20;
    float height = 20;
    if (redDotValue.intValue > 9) {
        leight = 30;
        height = 20;
    }
    label.layer.cornerRadius = height/2;
    label.layer.masksToBounds = YES;
    label.frame = CGRectMake(0, 0, leight, height);
    
    view.frame = CGRectMake(0, 0, leight, height);
    [view addSubview:label];
    return view;
}

- (void)setNavigationItemTitleViewWithTitle:(NSString *)title {
    self.navigationItem.titleView = nil;
    if (title.length == 0) {
        return;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateNormal];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateHighlighted];
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    float leight = titleSize.width;
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    self.navigationItem.titleView = btn;
}

- (void)showBackWithTitle:(NSString *)title {
    NSString *imageName = @"back_more1";
    if (kStatusBarStyle == UIStatusBarStyleLightContent) {
        imageName = @"back_more";
    }
    [self setLeftItemWithIcon:[UIImage imageNamed:imageName] title:title selector:@selector(backAction:)];
}

- (void)setLeftItemWithIcon:(UIImage *)icon title:(NSString *)title selector:(SEL)selector {
    self.navigationItem.leftBarButtonItem = [self ittemLeftItemWithIcon:icon title:title selector:selector];
}

- (UIBarButtonItem *)ittemLeftItemWithIcon:(UIImage *)icon title:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item;
    if (!icon && title.length == 0) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateNormal];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateHighlighted];
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    float leight = titleSize.width;
    if (icon) {
        leight += icon.size.width;
        [btn setImage:icon forState:UIControlStateNormal];
        [btn setImage:icon forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
    }
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item = [self ittemRightItemWithTitle:title selector:selector];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector color:(UIColor *)color{
    UIBarButtonItem *item = [self ittemRightItemWithTitle:title selector:selector color:color];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector {
    UIBarButtonItem *item = [self ittemRightItemWithIcon:icon selector:selector];
    self.navigationItem.rightBarButtonItem = item;
}

- (UIBarButtonItem *)ittemRightItemWithIcon:(UIImage *)icon selector:(SEL)selector {
    UIBarButtonItem *item;
    if (!icon) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    float leight = icon.size.width;
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setImage:icon forState:UIControlStateHighlighted];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [btn setFrame:CGRectMake(0, 0, leight, 30)];

    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (UIBarButtonItem *)ittemRightItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item;
    if (title.length == 0) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateNormal];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateHighlighted];
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    float leight = titleSize.width;
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
- (UIBarButtonItem *)ittemRightItemWithTitle:(NSString *)title selector:(SEL)selector color:(UIColor *)color{
    UIBarButtonItem *item;
    if (title.length == 0) {
        item = [[UIBarButtonItem new] initWithCustomView:[UIView new]];
        return item;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    if (selector) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:color forState:UIControlStateNormal];
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    float leight = titleSize.width;
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
#pragma mark - Action

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载

- (UploadManager *)uploadManager {
    if (!_uploadManager) {
        _uploadManager = [UploadManager new];
    }
    return _uploadManager;
}

- (DownloadImageManager *)downloadImageManager {
    if (!_downloadImageManager) {
        _downloadImageManager = [DownloadImageManager new];
    }
    return _downloadImageManager;
}

- (MJRefreshNormalHeader *)setRefreshNormalHeaderParameter:(MJRefreshNormalHeader *)header {
    //header.lastUpdatedTimeLabel.hidden = YES;
    
    //[header setTitle:NSLocalizedStringFromTable(@"MJRefreshHeaderIdleText", @"MJRefresh", @"下拉可以刷新") forState:MJRefreshStateIdle];
    //[header setTitle:NSLocalizedStringFromTable(@"MJRefreshHeaderPullingText", @"MJRefresh", @"松开立即刷新") forState:MJRefreshStatePulling];
    //[header setTitle:NSLocalizedStringFromTable(@"MJRefreshHeaderRefreshingText", @"MJRefresh",@"正在刷新数据中...") forState:MJRefreshStateRefreshing];
    return header;
}

- (MJRefreshBackNormalFooter *)setRefreshBackNormalFooterParameter:(MJRefreshBackNormalFooter *)footer {
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshBackFooterIdleText", @"MJRefresh",@"上拉可以加载更多") forState:MJRefreshStateIdle];
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshBackFooterPullingText", @"MJRefresh",@"松开立即加载更多") forState:MJRefreshStatePulling];
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshBackFooterRefreshingText", @"MJRefresh",@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshBackFooterNoMoreDataText", @"MJRefresh",@"已经全部加载完毕") forState:MJRefreshStateNoMoreData];
    return footer;
}

- (MJRefreshAutoNormalFooter *)setRefreshAutoNormalFooterParameter:(MJRefreshAutoNormalFooter *)footer {
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshAutoFooterIdleText", @"MJRefresh",@"点击或上拉加载更多") forState:MJRefreshStateIdle];
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshAutoFooterRefreshingText", @"MJRefresh",@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
    //[footer setTitle:NSLocalizedStringFromTable(@"MJRefreshAutoFooterNoMoreDataText", @"MJRefresh",@"已经全部加载完毕") forState:MJRefreshStateNoMoreData];
    return footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
