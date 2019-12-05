//
//  RequestManager.m
//  HXBaseProjectDemo
//
//  Created by 黄轩 on 2017/1/16.
//  Copyright © 2017年 黄轩. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFNetworking.h>

#define kBaseUrl @"http://bankcardsilk.api.juhe.cn/"

@interface RequestManager ()

@property (nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation RequestManager

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

#pragma mark - 配置请求底层参数

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        //主Url 可以封装起来统一管理,也可以直接写在GET参数里单独管理
        NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
        //AFHTTPSessionManager 创建一个网络请求
        _sessionManager = [[AFHTTPSessionManager manager] initWithBaseURL:baseUrl];
        // Requests 请求Header参数
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        //自定义参数
//        [_sessionManager.requestSerializer setValue:@"fd0a97bd4bcb79b91c50b47c7fa8246d" forHTTPHeaderField:@"apikey"];
        //Responses 响应Header参数
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
}

#pragma mark - 接口请求

////银行卡类别查询
- (void)getBankcardsilkRequestWithNum:(NSString *)num success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorMsg))failure {

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];

    [params setValue:kJuHeAPPKEY forKey:@"key"];
    [params setValue:kSafeString(num) forKey:@"num"];

    [self getRequestWithUrl:@"bankcardsilk/query.php" params:params success:^(id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        if (failure) {
            failure(error.domain);
        }
    }];
}

#pragma mark - 各种请求

//GET
- (void)getRequestWithUrl:(NSString *)url params:(id)params success:(void (^)(id  _Nullable responseObject))success failure:(void (^)(NSError * _Nonnull error))failure {
    
    [self.sessionManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//POST
- (void)postRequestWithUrl:(NSString *)url params:(id)params success:(void (^)(id  _Nullable responseObject))success failure:(void (^)(NSError * _Nonnull error))failure {
    
    [self.sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//PUT
- (void)putRequestWithUrl:(NSString *)url params:(id)params success:(void (^)(id  _Nullable responseObject))success failure:(void (^)(NSError * _Nonnull error))failure {
    
    [self.sessionManager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//PATCH
- (void)patchRequestWithUrl:(NSString *)url params:(id)params success:(void (^)(id  _Nullable responseObject))success failure:(void (^)(NSError * _Nonnull error))failure {
    
    [self.sessionManager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//DELETE
- (void)deleteRequestWithUrl:(NSString *)url params:(id)params success:(void (^)(id  _Nullable responseObject))success failure:(void (^)(NSError * _Nonnull error))failure {
    
    [self.sessionManager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
