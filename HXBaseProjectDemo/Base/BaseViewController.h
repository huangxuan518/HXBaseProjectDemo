//
//  BaseViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHRequestManager;

@interface BaseViewController : UIViewController

@property (nonatomic,assign) BOOL isRequest;//是否正在请求 默认NO
@property(nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,strong) SHRequestManager *requestManager;
@property(nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isUp; //titleView 箭头是否朝上 初始化为NO

#pragma mark 界面切换
//回到当前模块导航下的某一个页面
- (void)returnViewControllerWithName:(id)classOrName;
//切到指定模块下
- (void)popToHomePageWithTabIndex:(NSInteger)index completion:(void (^)(void))completion;

#pragma mark 公用方法
- (void)backAction:(UIButton *)sender;//返回

#pragma mark titleView定制

/**
 *  设置titleView的标题
 *
 *  @param title <#title description#>
 *
 *  @return <#return value description#>
 */
- (void)sellTitleViewForTitle:(NSString *)title;

/**
 *  标题点击事件
 *
 *  @param isUp 是否朝上 YES.朝上  NO.朝下
 */
- (void)titleViewButtonAction:(BOOL)isUp;

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
- (UIBarButtonItem *)ittemLeftItemWithIcon:(UIImage *)icon title:(NSString *)title selector:(SEL)selector;

#pragma mark 右边按钮定制

/**
 *  小红点View定制
 *
 *  @param redDotValue <#redDotValue description#>
 *
 *  @return <#return value description#>
 */
- (UIView *)ittemRedViewWithRedDotValue:(NSString *)redDotValue;

/**
 *  通过文字设置右侧导航按钮
 *
 *  @param title    文字
 *  @param selector 事件
 */
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector;
- (UIBarButtonItem *)ittemRightItemWithTitle:(NSString *)title selector:(SEL)selector;
- (void)setRightItemWithTitle:(NSString *)title selector:(SEL)selector color:(UIColor *)color;
/**
 *  通过ico定制右侧按钮
 *
 *  @param icon     图标
 *  @param selector 事件
 */
- (void)setRightItemWithIcon:(UIImage *)icon selector:(SEL)selector;
- (UIBarButtonItem *)ittemRightItemWithIcon:(UIImage *)icon selector:(SEL)selector;

@end


@interface NSString (Extention)
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
@end
