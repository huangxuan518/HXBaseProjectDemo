//
//  RequestManager.h
//  HXBaseProjectDemo
//
//  Created by 黄轩 on 2017/1/16.
//  Copyright © 2017年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

//银行卡类别查询
- (void)getBankcardsilkRequestWithNum:(NSString *)num success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure;

+ (instancetype)sharedInstance;

@end
