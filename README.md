# HXBaseProjectDemo 如果对你有一点点帮助,请给一颗★,你的支持是对我的最大鼓励！
一个项目的基类工程

# 效果展示
![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/xiaoguo.png)

# 工程包含第三方
AFNetworking

MJRefresh

SDWebImage

SVProgressHUD

# 说明
基础类都在Base文件夹里面

常用的类和扩展都在Public文件夹里面

# Base

## 界面基类
BaseTabBarController

BaseNavigationController

BaseViewController

BaseTableViewController

BaseCollectionViewController

## Cell基类
BaseTableViewCell

BaseCollectionViewCell

## 模型基类

BaseModel

# Public

## Define
PublicDefine //宏

## Extension
UIView+Helpers //UIView扩展

UIImage+Extension //UIImage扩展

NSString+Extension //字符串扩展

UITabBar+Badge //TabBar小红点扩展

## Asset
AssetHelper //相册

## UploadImages
UploadImageManager //图片上传

## DownloadImages
DownloadImageManager //图片下载

# 示例
HXDemoViewController

# 使用说明
标签控制器对应的界面请在BaseTabBarController里面添加和更改
进入BaseTabBarController.m文件，找到如下方法

  - (void)setViewControllers {
      //UITabBarController 数据源
      NSArray *dataAry = @[@{@"class":HXDemoViewController.class,
                             @"title":@"首页",
                             @"image":@"home_fuexpress1",
                             @"selectedImage":@"home_fuexpress2",
                             @"badgeValue":@"0"},

                           @{@"class":BaseTableViewController.class,
                             @"title":@"理财",
                             @"image":@"home_list1",
                             @"selectedImage":@"home_list2",
                             @"badgeValue":@"0"},

                           @{@"class":BaseTableViewController.class,
                             @"title":@"我",
                             @"image":@"home_me1",
                             @"selectedImage":@"home_me2",
                             @"badgeValue":@"0"}];

      for (NSDictionary *dataDic in dataAry) {
          //每个tabar的数据
          Class classs = dataDic[@"class"];
          NSString *title = dataDic[@"title"];
          NSString *imageName = dataDic[@"image"];
          NSString *selectedImage = dataDic[@"selectedImage"];
          NSString *badgeValue = dataDic[@"badgeValue"];

          [self addChildViewController:[self ittemChildViewController:classs title:title imageName:imageName selectedImage:selectedImage badgeValue:badgeValue]];
      }
  }

按照给出的样式所示格式，添加标签，有几个就添加几个，标签控制器的高度可以修改代码

- (void)viewWillLayoutSubviews{
  float height = 50;
  CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
  tabFrame.size.height = height;
  tabFrame.origin.y = self.view.frame.size.height - height;
  self.tabBar.frame = tabFrame;
}

其中50就是默认高度，你需要多高就更改多大

标签里面的图标和文字的相关属性见代码

- (BaseNavigationController *)ittemChildViewController:(Class)classs title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage badgeValue:(NSString *)badgeValue {

    UIViewController *vc = [classs new];
    vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //起点-8图标才会到顶，然后加上计算出来的y坐标
    float origin = -9 + 6;
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(origin, 0, -origin,0);
    vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(-2 + 8, 2-8);
    //title设置
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromHex(0xe80010),NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    vc.tabBarItem.title = title;

    //小红点
    vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
    //导航
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.topItem.title = title;
    [nav.rootVcAry addObject:classs];
    return nav;
}

设置小红点数值

#pragma 设置小红点数值
//设置指定tabar 小红点的值

- (void)setBadgeValue:(NSString *)badgeValue index:(NSInteger)index {
  if (index + 1 > self.viewControllers.count || index < 0) {
  //越界或者数据异常直接返回
  return;
  }
  BaseNavigationController *base = self.viewControllers[index];
  if (base.viewControllers.count == 0) {
  return;
  }
  UIViewController *vc = base.viewControllers[0];
  vc.tabBarItem.badgeValue = badgeValue.intValue > 0 ? badgeValue : nil;
}

如果标签不需要显示数值，只需要显示一个小红点，可以通过下面2个方法控制

#pragma 设置小红点显示或者隐藏

//显示小红点 没有数值

- (void)showBadgeWithIndex:(int)index {
 [self.tabBar showBadgeOnItemIndex:2];
}

//隐藏小红点 没有数值
- (void)hideBadgeWithIndex:(int)index {
[self.tabBar hideBadgeOnItemIndex:2];
}

如何在其他界面获取BaseTabBarController，可以通过
BaseTabBarController *baseTabBar = ((AppDelegate *)[UIApplication sharedApplication].delegate).baseTabBar获取，然后调用设置小红点的方法

导航样式请在BaseNavigationController里面修改

- (void)loadView {
  [super loadView];
  // bg.png为自己ps出来的想要的背景颜色。
  [self.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromHex(0xffc947) size:CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + 20)]
  forBarPosition:UIBarPositionAny
  barMetrics:UIBarMetricsDefault];
  [self.navigationBar setShadowImage:[UIImage new]];

  //状态栏颜色
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
  //title颜色和字体
  self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromHex(0x333333),
  NSFontAttributeName:[UIFont systemFontOfSize:18]};

  if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
  //导航背景颜色
  self.navigationBar.barTintColor = UIColorFromHex(0xffc947);
  }

  //系统返回按钮图片设置
  UIImage *image = [UIImage imageNamed:@"back_more"];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width-1, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  [[UINavigationBar appearance] setTintColor:UIColorFromHex(0x333333)];
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
  forBarMetrics:UIBarMetricsDefault];
}

push是否隐藏标签在方法

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  for (Class classes in self.rootVcAry) {
  if ([viewController isKindOfClass:classes]) {
  if (self.navigationController.viewControllers.count > 0) {
  viewController.hidesBottomBarWhenPushed = YES;
  } else {
  viewController.hidesBottomBarWhenPushed = NO;
  }
  } else {
  viewController.hidesBottomBarWhenPushed = YES;
  }
  }
  [super pushViewController:viewController animated:animated];
}
里做了处理，所以不需要push的时候再加显示或隐藏的处理了，如果需要自己单独处理可以屏蔽此代码

BaseTableViewController使用,记得添加头文件

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = @"首页";
  [self.tableview registerNib:[UINib nibWithNibName:@"HXDemoCurrencyCell" bundle:nil] forCellReuseIdentifier:@"HXDemoCurrencyCell"];
}

#pragma mark - cellDataSource

- (NSArray *)cellDataSource {

  if (!self.dataSource) {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];

    NSMutableArray *subarr = nil;
    NSDictionary *dict = nil;

    //section 0
    subarr = [NSMutableArray arrayWithCapacity:1];
    dict =  @{@"class":HXDemoCurrencyCell.class,
    @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
    @"data":[HXDemoCurrencyCellModel ittemModelWithIcoName:@"" title:@"测试1" isLittleRedDot:YES],
    @"action":@"gotoDemoViewController",
    @"delegate":@YES};
    [subarr addObject:dict];
    [arr addObject:subarr];

    //section 1
    subarr = [NSMutableArray arrayWithCapacity:1];

    //row 0
    dict =  @{@"class":HXDemoCurrencyCell.class,
    @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
    @"data":[HXDemoCurrencyCellModel ittemModelWithIcoName:@"" title:@"测试2" isLittleRedDot:NO],
    @"action":@"gotoDemoViewController",
    @"delegate":@YES};
    [subarr addObject:dict];

    //row 1
    dict =  @{@"class":HXDemoCurrencyCell.class,
    @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
    @"data":[HXDemoCurrencyCellModel ittemModelWithIcoName:@"" title:@"测试3" isLittleRedDot:YES],
    @"action":@"gotoDemoViewController",
    @"delegate":@YES};
    [subarr addObject:dict];

    [arr addObject:subarr];

    self.dataSource = arr;
  }
  return self.dataSource;
}

#pragma mark - goto

- (void)gotoDemoViewController {
  HXDemoViewController *vc = [HXDemoViewController new];
  [self.navigationController pushViewController:vc animated:YES];
}


数据模型继承自BaseModel就可以直接保存

//保存

- (void)saveData:(id)obj {
  NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:obj];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:archiveCarPriceData forKey:@"someKey"];
  [userDefaults synchronize];
}

//获取
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
id obj = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"someKey"]] ;
