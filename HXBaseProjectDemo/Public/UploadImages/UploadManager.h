//
//  UploadManager.h
//  HXBaseProjectDemo
//
//  Created by 黄轩 on 2017/1/12.
//  Copyright © 2017年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kScope @"huangxuan518"
#define kAccessKey @"qsR-Kbno05P7UKiw76WbgIuMUT1XBJS3uOaWbbkr"
#define kSecretKey @"hh_PlPwxtK08DvK88iIJwc9y0sQJQgPPNPzIxmIj"

@interface UploadManager : NSObject

/**
 *  上传单个数据
 *
 *  @param data       上传的数据
 *  @param progress   进度
 *  @param completion 完成回调
 */
- (void)uploadData:(NSData *)data
          progress:(void (^)(float percent))progress
        completion:(void (^)(NSError *error, NSString *link, NSInteger index))completion;

/**
 *  上传多个数据
 *
 *  @param datas              上传的数据组
 *  @param progress           进度
 *  @param oneTaskCompletion  单个完成回调
 *  @param allTasksCompletion 全部完成回调
 */
- (void)uploadDatas:(NSArray<NSData *> *)datas
           progress:(void(^)(float percent))progress
  oneTaskCompletion:(void (^)(NSError *error, NSString *link, NSInteger index))oneTaskCompletion
 allTasksCompletion:(void (^)())allTasksCompletion;

@end
