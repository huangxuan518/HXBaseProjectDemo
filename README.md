# HXBaseProjectDemo 如果对你有一点点帮助,请给一颗★,你的支持是对我的最大鼓励！
一个项目的基类工程

# 效果展示
![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/xiaoguo.png)

# 示例
HXDemoViewController

# 工程包含第三方
AFNetworking

MJRefresh

SDWebImage

SVProgressHUD

# 说明

配置都在Config文件夹里面

基础类都在Base文件夹里面

常用的类和扩展都在Public文件夹里面

# Config

AppConfig //App的一些常用参数配置

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

# 使用说明
标签控制器对应的界面请在BaseTabBarController里面添加和更改
进入BaseTabBarController.m文件，找到如下方法

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/2.png)


按照给出的样式所示格式，添加标签，有几个就添加几个，标签控制器的高度可以修改代码

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/1.png)

其中50就是默认高度，你需要多高就更改多大

标签里面的图标和文字的相关属性见代码

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/3.png)

//设置指定tabar 小红点的值

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/4.png)

如果标签不需要显示数值，只需要显示一个小红点，可以通过下面2个方法控制

//显示小红点 没有数值

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/6.png)

//隐藏小红点 没有数值

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/7.png)

如何在其他界面获取BaseTabBarController，可以通过

BaseTabBarController *baseTabBar = ((AppDelegate *)[UIApplication sharedApplication].delegate).baseTabBar获取，然后调用设置小红点的方法

导航样式请在BaseNavigationController里面修改

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/8.png)

push是否隐藏标签在方法

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/9.png)
里做了处理，所以不需要push的时候再加显示或隐藏的处理了，如果需要自己单独处理可以屏蔽此代码

BaseTableViewController使用,记得添加头文件

![image](https://github.com/huangxuan518/HXBaseProjectDemo/blob/master/HXBaseProjectDemo/ShiLiImage/10.png)


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
