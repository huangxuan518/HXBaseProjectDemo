//
//  BaseViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/9.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "RequestManager.h"
#import "UploadManager.h"
#import "DownloadImageManager.h"

@interface BaseViewController : UIViewController

@property (nonatomic,assign) BOOL isRequest;//是否正在请求 默认NO
@property (nonatomic, strong) RequestManager *requestManager;
@property (nonatomic,strong) UploadManager *uploadManager;//数据上传
@property (nonatomic,strong) DownloadImageManager *downloadImageManager;//图片下载
@property(nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) UIView *navigationBar;
  
//navigationBar高度
- (float)navigationBarHeight;

#pragma mark 公用方法
- (void)requestData;//网络请求
- (void)backAction:(UIButton *)sender;//返回
- (void)gotoLoginViewController;//去登陆界面

#pragma mark 界面切换

//不需要传参数的push 只需告诉类名字符串
- (void)pushViewControllerWithName:(id)classOrName;
//回到当前模块导航下的某一个页面
- (void)returnViewControllerWithName:(id)classOrName;
//切到指定模块下
- (void)popToHomePageWithTabIndex:(NSInteger)index completion:(void (^)(void))completion;

#pragma mark 左边按钮定制

/**
 *  显示默认返回按钮
 *
 *  @param title 需要传入上级界面标题
 */
- (void)showBackWithTitle:(NSString *)title;

/**
 *  自定义左边按钮
 *
 *  @param icon     图标 非必填
 *  @param title    标题 非必填
 *  @param selector 事件
 */
- (void)setLeftItemWithIcon:(UIImage *)icon title:(NSString *)title selector:(SEL)selector;
- (UIView *)ittemLeftItemWithIcon:(UIImage *)icon title:(NSString *)title selector:(SEL)selector;

#pragma mark 右边按钮定制

/**
 *  通过文字设置右侧导航按钮
 *
 *  @param title    文字
 *  @param selector 事件
 */
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector;
- (UIView *)ittemRightItemWithTitle:(NSString *)title selector:(SEL)selector;

/**
 *  通过ico定制右侧按钮
 *
 *  @param icon     图标
 *  @param selector 事件
 */
- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector;
- (UIView *)ittemRightItemWithIcon:(UIImage *)icon selector:(SEL)selector;

#pragma mark titleView定制

//设置纯文字titleVIew
- (void)setNavigationItemTitleViewWithTitle:(NSString *)title;

#pragma mark - 小红点

/**
 *  小红点View定制
 *
 *  @param redDotValue <#redDotValue description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)ittemRedViewWithRedDotValue:(NSString *)redDotValue;

#pragma mark - MJRefresh
- (MJRefreshNormalHeader *)setRefreshNormalHeaderParameter:(MJRefreshNormalHeader *)header;
- (MJRefreshBackNormalFooter *)setRefreshBackNormalFooterParameter:(MJRefreshBackNormalFooter *)footer;
- (MJRefreshAutoNormalFooter *)setRefreshAutoNormalFooterParameter:(MJRefreshAutoNormalFooter *)footer;

@end
