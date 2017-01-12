//
//  UploadManager.h
//  HXBaseProjectDemo
//
//  Created by 黄轩 on 2017/1/12.
//  Copyright © 2017年 黄轩. All rights reserved.
//

#import "UploadManager.h"
#import "QiniuSDK.h"
#import "QNUrlSafeBase64.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "QN_GTM_Base64.h"

static NSInteger defaultLiveTime = 5;
static NSString *QiNiuHost = kQiNiuHost; //外链默认域名

@interface UploadManager ()

@property (nonatomic, assign) NSInteger index;

/**
 *  上传所需的token
 */
@property (nonatomic, strong) NSString *uploadToken;

@end

@implementation UploadManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createToken];
    }
    return self;
}

- (void)uploadData:(NSData *)data
          progress:(void (^)(float percent))progress
        completion:(void (^)(NSError *error, NSString *link,NSData *data,NSInteger index))completion {
    QNUploadManager *manager = [[QNUploadManager alloc] init];
    
    [manager putData:data
                 key:[self ittemKey]
               token:self.uploadToken
            complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (completion) {
                    if (info.error) {
                        completion(info.error,nil,data,self.index);
                    } else {
                        NSString *link =
                        [NSString stringWithFormat:@"%@/%@", QiNiuHost, resp[@"key"]];
                        completion(nil, link,data, self.index);
                    }
                }
            }
              option:[[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
                  if (progress) {
                      progress(percent);
                  }
              }]];
}

- (void)uploadDatas:(NSArray<NSData *> *)datas
           progress:(void(^)(float percent))progress
  oneTaskCompletion:(void (^)(NSError *error, NSString *link,NSData *data,NSInteger index))oneTaskCompletion
 allTasksCompletion:(void (^)())allTasksCompletion {
    if (self.index < datas.count) {
        [self uploadData:datas[self.index]
        progress:^(float percent) {
            if (progress) {
                progress(percent);
            }
        }
        completion:^(NSError *error, NSString *link,NSData *data,NSInteger index) {
            NSLog(@"oneTaskCompletion");
            if (oneTaskCompletion) {
                oneTaskCompletion(error, link,data,index);
            }
            self.index++;
            [self uploadDatas:datas
                      progress:progress
             oneTaskCompletion:oneTaskCompletion
            allTasksCompletion:allTasksCompletion];
        }];
    } else {
        if (allTasksCompletion) {
            allTasksCompletion();
        }
        self.index = 0;
    }
}

//上传到云存储的key 可以随便设置格式 类似 http://ojnjkctvf.bkt.clouddn.com/2017/01/12/134334.png
- (NSString *)ittemKey {
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd/HHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *key = [NSString stringWithFormat:@"%@.png",dateString];
    return key;
}

- (void)createToken {
    
    NSInteger liveTime = defaultLiveTime;
    
    if (!kScope.length || !kAccessKey.length || !kSecretKey.length) {
        return;
    }
    
    //将上传策略中的scrop和deadline序列化成json格式
    NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
    [authInfo setObject:kScope forKey:@"scope"];
    [authInfo setObject:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] + liveTime * 24 * 3600] forKey:@"deadline"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    // 对json序列化后的上传策略进行URL安全的base64编码
    NSString *encodedString = [self urlSafeBase64Encode:jsonData];
    
    // 用secretKey对编码后的上传策略进行HMAC-SHA1加密，并且做安全的base64编码，得到encoded_signed
    NSString *encodedSignedString = [self HMACSHA1:kSecretKey text:encodedString];
    
    // 将accessKey、encodedSignedString和encodedString拼接，中间用：分开，就是上传的token
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",kAccessKey, encodedSignedString, encodedString];
    
    self.uploadToken = token;
}

- (NSString *)HMACSHA1:(NSString *)key text:(NSString *)text {
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString *hash = [self urlSafeBase64Encode:HMAC];
    return hash;
}

- (NSString *)urlSafeBase64Encode:(NSData *)text {
    NSString *base64 =
    [[NSString alloc] initWithData:[QN_GTM_Base64 encodeData:text] encoding:NSUTF8StringEncoding];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64 = [base64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return base64;
}

@end
