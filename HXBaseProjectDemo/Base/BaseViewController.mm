//
//  BaseViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseViewController.h"
//#import "UIViewController+KeyboardCorver.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self addNotification];
    _pageIndex = 1;
    [self showBack];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
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

- (void)returnViewControllerWithName:(id)classOrName {
    Class classs;
    if ([classOrName isKindOfClass:[NSString class]]) {
        NSString *name = classOrName;
        if (name.length == 0) {
            return;
        }
        classs = NSClassFromString(name);
    } else if ([classOrName isSubclassOfClass:[BaseViewController class]]) {
        classs = classOrName;
    }
    
    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:classs]) {
             [self.navigationController popToViewController:obj animated:YES];
            return;
        }
    }];
}

#pragma mark 导航定制

- (void)showBack {
    if (self.navigationController.viewControllers.count > 1) {
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        if ([vc.title isEqualToString:@"云档口"]) {
            [self showBackWithTitle:@"首页"];
        } else {
            if (vc.title.length > 0) {
                [self showBackWithTitle:vc.title];
            } else {
                [self showBackWithTitle:vc.navigationItem.title];
            }
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

- (void)sellTitleViewForTitle:(NSString *)title {
    self.navigationItem.titleView = nil;
    if (title.length == 0) {
        return;
    }
    
    UIImage *icon = [UIImage imageNamed:@"arrow_down_down"];
    
    if (_isUp) {
        icon = [UIImage imageNamed:@"arrow_up_up"];
    }
    
    float width = 13;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -width, 0, width);
    //title与ico的间隔5
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
    float leight = titleSize.width + 5;
    if (icon) {
        leight += width;
        [btn setImage:icon forState:UIControlStateNormal];
        [btn setImage:icon forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, leight -width, 0, -leight + width);
    }
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    
    self.navigationItem.titleView = btn;
}

- (void)showBackWithTitle:(NSString *)title {
    [self setLeftItemWithIcon:[UIImage imageNamed:@"back_more"] title:title selector:@selector(backAction:)];
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
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
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
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
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
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT)];
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

- (void)click:(UIButton *)sender {
    _isUp = !_isUp;
    [self titleViewButtonAction:_isUp];
    [self sellTitleViewForTitle:sender.titleLabel.text];
}

- (void)titleViewButtonAction:(BOOL)isUp {
    
}

#pragma mark - 懒加载

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

//- (void)dealloc {
//    [self clearNotificationAndGesture];
//}

@end



@implementation NSString (Extention)

- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    
    return resultSize;
}
@end
