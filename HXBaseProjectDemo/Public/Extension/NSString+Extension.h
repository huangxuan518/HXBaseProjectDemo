//
//  NSString+Extension.h
//  HXCamouflageCalculator
//
//  Created by 黄轩 on 16/10/11.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//去掉无意义的0
+ (NSString *)stringDisposeWithFloatStringValue:(NSString *)floatStringValue;

+ (NSString *)stringDisposeWithFloatValue:(float)floatNum;

//千分位格式化数据
+ (NSString *)ittemThousandPointsFromNumString:(NSString *)numString;

//计算字符串的CGSize
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
