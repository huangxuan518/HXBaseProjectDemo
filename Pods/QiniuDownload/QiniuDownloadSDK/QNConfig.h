//
//  QNConfig.h
//  QiniuDownloadSDK
//
//  Created by ltz on 10/19/15.
//  Copyright © 2015 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HappyDNS.h"


@interface QNConfig : NSObject

- (id) init;
- (void) setDropRate:(float)rate;
- (void) setPushIntervalS:(uint) interval;

@property int pushDropRate;
@property uint pushStatIntervalS;
@property (nonatomic) NSString *statsHost;
@property (nonatomic) QNDnsManager *dns;

@end
