//
//  QNConfig.m
//  QiniuDownloadSDK
//
//  Created by ltz on 10/19/15.
//  Copyright © 2015 Qiniu. All rights reserved.
//

#import "QNConfig.h"

@implementation QNConfig


- (id) init {

	self = [super init];

	// init dns
	id<QNResolverDelegate> r1 = [QNResolver systemResolver];
	id<QNResolverDelegate> r2 = [[QNResolver alloc] initWithAddres:@"223.6.6.6"];
	id<QNResolverDelegate> r3 = [[QNResolver alloc] initWithAddres:@"114.114.115.115"];
	_dns = [[QNDnsManager alloc] init:[NSArray arrayWithObjects:r1,r2, r3, nil] networkInfo:[QNNetworkInfo normal ]];

	_statsHost = @"http://reportqos.qiniuapi.com";

	_pushDropRate = 30;
	_pushStatIntervalS = 300;

	return self;
}

- (void) setDropRate:(float)rate {

	_pushDropRate = (int)(rate*100);

}
- (void) setPushIntervalS:(uint) interval {

	_pushStatIntervalS = interval;
}


@end
