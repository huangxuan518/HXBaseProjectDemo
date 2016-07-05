//
//  BaseTabBarController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewControllers];
}

- (void)setViewControllers {
    //UITabBarController 数据源
    NSArray *dataAry = @[@{@"class":UIViewController.class,
                           @"title":@"首页",
                           @"image":@"button_home",
                           @"selectedImage":@"button_home1",
                           @"badgeValue":@"0"},
                         
                         @{@"class":UIViewController.class,
                           @"title":@"我",
                           @"image":@"button_home",
                           @"selectedImage":@"button_home1",
                           @"badgeValue":@"0"}];
    
    for (NSDictionary *dataDic in dataAry) {
        NSInteger index = [dataAry indexOfObject:dataDic];
        
        //每个tabar的数据
        Class classs = dataDic[@"class"];
        NSString *title = dataDic[@"title"];
        NSString *imageName = dataDic[@"image"];
        NSString *selectedImage = dataDic[@"selectedImage"];
        NSString *badgeValue = dataDic[@"badgeValue"];

        UIViewController *vc = [classs new];
        vc.tabBarItem.tag = index;
        vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //起点-8图标才会到顶，然后加上计算出来的y坐标
//        float origin = -8 + (self.tabBar.frame.size.height - vc.tabBarItem.image.size.height)/2 ;
//        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(origin, 0, -origin,0);
        //title设置
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
        vc.tabBarItem.title = title;
        
        //小红点
        vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
        //导航
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.topItem.title = title;
        [nav.rootVcAry addObject:classs];
        [self addChildViewController:nav];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
