//
//  NSString+Extension.m
//  HXCamouflageCalculator
//
//  Created by 黄轩 on 16/10/11.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)stringDisposeWithFloatStringValue:(NSString *)floatStringValue {
    NSString *str = floatStringValue;
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else {
            if ([str rangeOfString:@"."].location != NSNotFound) {
                str = [str substringToIndex:[str length]-1];
            } else {
                break;
            }
        }
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}

//此方法去掉2.0000这样的浮点后面多余的0
//传人一个浮点字符串,需要保留几位小数则保留好后再传
+ (NSString *)stringDisposeWithFloatValue:(float)floatNum {
    
    NSString *str = [NSString stringWithFormat:@"%.2f",floatNum];
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}

+ (NSString *)ittemThousandPointsFromNumString:(NSString *)numString {
    NSString *str = numString;
    
    NSString *preStr = @"";
    if ([str rangeOfString:@"-"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        preStr = @"-";
    }
    
    NSString *lastStr = @"";
    if ([str rangeOfString:@"."].location != NSNotFound) {
        NSArray *array = [str componentsSeparatedByString:@"."];
        if (array.count > 1) {
            str = array[0];
            lastStr = [NSString stringWithFormat:@".%@",array[1]];
        }
    }

    NSUInteger len = [str length];
    NSUInteger x = len % 3;
    NSUInteger y = len / 3;
    NSUInteger dotNumber = y;
    
    if (x == 0) {
        dotNumber -= 1;
        x = 3;
    }
    NSMutableString *rs = [@"" mutableCopy];
    
    [rs appendString:[str substringWithRange:NSMakeRange(0, x)]];
    
    for (int i = 0; i < dotNumber; i++) {
        [rs appendString:@","];
        [rs appendString:[str substringWithRange:NSMakeRange(x + i * 3, 3)]];
    }
    rs = [NSMutableString stringWithFormat:@"%@%@",preStr,rs];
   [rs appendString:lastStr];
   return rs;
}

- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize resultSize;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
        NSDictionary *attributes = @{ NSFontAttributeName:font };
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        NSStringDrawingContext *context;
        [invocation setArgument:&size atIndex:2];
        [invocation setArgument:&options atIndex:3];
        [invocation setArgument:&attributes atIndex:4];
        [invocation setArgument:&context atIndex:5];
        [invocation invoke];
        CGRect rect;
        [invocation getReturnValue:&rect];
        resultSize = rect.size;
    } else {
        NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
        [invocation setArgument:&font atIndex:2];
        [invocation setArgument:&size atIndex:3];
        [invocation invoke];
        [invocation getReturnValue:&resultSize];
    }
    
    return resultSize;
}

@end
