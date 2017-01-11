//
//  QNStats.m
//  QiniuSDK
//
//  Created by ltz on 9/21/15.
//  Copyright (c) 2015 Qiniu. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
#endif

#include <stdlib.h>
#import "GZIP.h"
#import "QNStats.h"
#import "QNConfig.h"


@interface QNStats ()

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) &&__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || ( defined(MAC_OS_X_VERSION_MAX_ALLOWED) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_9)

@property (nonatomic) QNConfig *config;
@property (nonatomic) AFHTTPRequestOperationManager *httpManager;
@property (nonatomic) NSMutableArray *statsBuffer;
@property (nonatomic) NSLock *bufLock;

@property (nonatomic) NSTimer *pushTimer;
@property (nonatomic) NSTimer *getIPTimer;



// ...
@property (atomic) NSString *radioAccessTechnology;

@property (nonatomic) NSString *phoneModel; // dev
@property (nonatomic) NSString *systemName; // os
@property (nonatomic) NSString *systemVersion; // sysv
@property (nonatomic) NSString *appName;  // app
@property (nonatomic) NSString *appVersion; // appv

#endif

@end

@implementation QNStats

#if ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) &&__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || ( defined(MAC_OS_X_VERSION_MAX_ALLOWED) && MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_9)

- (instancetype) init {

	return [self initWithConfiguration:nil];
}

- (instancetype) initWithConfiguration: (QNConfig *) config {

	self = [super init];

	if (config == nil) {
		config = [[QNConfig alloc]init];
	}
	_config = config;

	_statsBuffer = [[NSMutableArray alloc] init];
	_bufLock = [[NSLock alloc] init];

	_httpManager = [[AFHTTPRequestOperationManager alloc] init];
	_httpManager.responseSerializer = [AFJSONResponseSerializer serializer];

	_count = 0;

	// get out ip first time
	[self getOutIp];

#if TARGET_OS_IPHONE

	// radio access technology
	_telephonyInfo = [CTTelephonyNetworkInfo new];
	_radioAccessTechnology = _telephonyInfo.currentRadioAccessTechnology;

	NSLog(@"Current Radio Access Technology: %@", _radioAccessTechnology);
	[NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
	 object:nil
	 queue:nil
	 usingBlock:^(NSNotification *note) {
	         _radioAccessTechnology = _telephonyInfo.currentRadioAccessTechnology;
	         NSLog(@"New Radio Access Technology: %@", _telephonyInfo.currentRadioAccessTechnology);
	         [self getOutIp];
	 }];

	// WiFi, WLAN, or nothing
	_wifiReach = [Reachability reachabilityForInternetConnection];
	_reachabilityStatus = _wifiReach.currentReachabilityStatus;

	[NSNotificationCenter.defaultCenter addObserverForName:kReachabilityChangedNotification
	 object:nil
	 queue:nil
	 usingBlock:^(NSNotification *note) {
	         _reachabilityStatus = _wifiReach.currentReachabilityStatus;

	         if (_reachabilityStatus != NotReachable) {
	                 [self getOutIp];
		 }
	 }];
	[_wifiReach startNotifier];

	// init device information
	_phoneModel = [[UIDevice currentDevice] model];
	_systemName = [[UIDevice currentDevice] systemName];
	_systemVersion = [[UIDevice currentDevice] systemVersion];
#elif TARGET_OS_OSX
	_phoneModel = @""
	              _systemName = @"osx"
	                            _systemVersion = @"";
#else
	_phoneModel = @"";
	_systemName = @"";
	_systemVersion = @"";
#endif

	// timer for push
	_pushTimer = [NSTimer scheduledTimerWithTimeInterval:_config.pushStatIntervalS target:self selector:@selector(pushStats) userInfo:nil repeats:YES];
	[_pushTimer fire];

	_getIPTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(getOutIp) userInfo:nil repeats:YES];
	[_getIPTimer fire];



	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	_appName = [info objectForKey:@"CFBundleDisplayName"];
	NSString *majorVersion = [info objectForKey:@"CFBundleShortVersionString"];
	NSString *minorVersion = [info objectForKey:@"CFBundleVersion"];
	_appVersion = [NSString stringWithFormat:@"%@(%@)", majorVersion, minorVersion];

	if (_appName == nil) {
		_appName = @"";
	}
	if (_appVersion == nil) {
		_appVersion = @"";
	}

	return self;
}

- (void) addStatics:(NSMutableDictionary *)stat {

	[_bufLock lock];
	[_statsBuffer addObject:stat];
	[_bufLock unlock];
}

- (BOOL) shouldDrop {
	int r = arc4random_uniform(100);
	return r < _config.pushDropRate;
}

- (void) pushStats {

	@synchronized(self) {

#if TARGET_OS_IPHONE
		if (_reachabilityStatus == NotReachable) {
			return;
		}
#endif

		[_bufLock lock];
		if ([_statsBuffer count] == 0) {
			[_bufLock unlock];
			return;
		}
		NSMutableArray *reqs = [[NSMutableArray alloc] init];
		for (int i=0; i<[_statsBuffer count]; i++) {
			if ([self shouldDrop]) {
				continue;
			}
			[reqs addObject:[_statsBuffer objectAtIndex:i]];
		}
		//NSMutableArray *reqs = [[NSMutableArray alloc] initWithArray:_statsBuffer copyItems:YES];
		[_statsBuffer removeAllObjects];
		[_bufLock unlock];

		if ([reqs count] != 0) {
			long long now = (long long)([[NSDate date] timeIntervalSince1970]* 1000000000);
			for (int i=0; i<[reqs count]; i++) {
				NSMutableDictionary *stat = [[reqs objectAtIndex:i] mutableCopy];
				long long st = [[stat valueForKey:@"st"] longLongValue];
				NSNumber *pi = [NSNumber numberWithLongLong:(now - st)];
				[stat setObject:pi forKey:@"pi"];
				[reqs setObject:stat atIndexedSubscript:i];
			}
			NSDictionary *parameters = @{@"dev": _phoneModel, @"os": _systemName, @"sysv": _systemVersion,
				                     @"app": _appName, @"appv": _appVersion,
				                     @"stats": reqs, @"v": @"0.1"};
			//NSLog(@"stats: %@", reqs);
			NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
			data = [data gzippedDataWithCompressionLevel:0.7];
//			NSURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[_config.statsHost stringByAppendingString:@"/v1/stats"] parameters:parameters error:nil];
			NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];

			[req setHTTPMethod:@"POST"];
			[req setURL:[NSURL URLWithString:[_config.statsHost stringByAppendingString:@"/v1/stats"]]];
			[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
			[req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
			[req setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
			[req setHTTPBody:data];

			AFHTTPRequestOperation *operation = [_httpManager HTTPRequestOperationWithRequest:req success:^(AFHTTPRequestOperation *operation, id responseObject) {
			                                             _count += [reqs count];

							     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			                                             NSLog(@"post stats failed, %@", error);
							     }];
			[_httpManager.operationQueue addOperation:operation];
		}
	}
}

- (void) getOutIp {

	[_httpManager GET:[_config.statsHost stringByAppendingString:@"/v1/ip"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
	         NSDictionary *rst = (NSDictionary *)responseObject;
	         _sip = [rst valueForKey:@"ip"];
	 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	         NSLog(@"get ip failed: %@", error);
	 }];
}


- (NSString *) getSIP {

	return _sip;
}

- (NSString *) getNetType {
#if TARGET_OS_IPHONE
	if (_reachabilityStatus == ReachableViaWiFi) {
		return @"wifi";
	} else if (_reachabilityStatus == ReachableViaWWAN) {
		return @"wan";
	}
#elif TARGET_OS_MAC
	return @"wifi";
#endif

	return @"";
}


#endif

@end

