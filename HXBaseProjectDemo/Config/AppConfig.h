//
//  AppConfig.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

typedef enum ServerType {
    ProductionMode = 0, //生产环境
    StagingMode = 1,    //预发布环境
    TestMode = 2,       //测试环境
} ServerType;

#define RELEASE_MODE 0 //appstore 改为0

//测试环境
#define kDebugSvrAddr @""
#define kDebugSvrPort 9000

//预发布环境
#define kPreReleaseSvrAddr @""
#define kPreReleaseSvrPort 8080

//正式环境
#define kReleaseSvrAddr @""
#define kReleaseSvrPort 80

//七牛云存储 以下为本人的空间参数，仅供测试，不得用于非法用途
#define kScope @"huangxuan518" //存储空间空间名 建议创建华东空间 默认就是华东空间的配置，其他空间需要自己设置
#define kAccessKey @"qsR-Kbno05P7UKiw76WbgIuMUT1XBJS3uOaWbbkr" //AccessKey 见密钥管理
#define kSecretKey @"hh_PlPwxtK08DvK88iIJwc9y0sQJQgPPNPzIxmIj" //SecretKey 见密钥管理
#define kQiNiuHost @"http://ojnjkctvf.bkt.clouddn.com"; //见存储空间内容管理 外链默认域名

#define knavigationBarBackgroundColor UIColorFromHex(0xffc947) //导航背景颜色

#endif
