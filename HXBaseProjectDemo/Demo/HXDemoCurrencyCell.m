//
//  HXDemoCurrencyCell.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/10/27.
//  Copyright © 2016年 Yiss Inc. All rights reserved.
//

#import "HXDemoCurrencyCell.h"

@implementation HXDemoCurrencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(id)data delegate:(id)delegate {
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data[@"data"] isKindOfClass:[HXDemoCurrencyCellModel class]]) {
            HXDemoCurrencyCellModel *model = data[@"data"];
            _titleLabel.text = model.title;
        }
    }
}

+ (float)getCellFrame:(id)msg {
    if ([msg isKindOfClass:[NSNumber class]]) {
        NSNumber *number = msg;
        float height = number.floatValue;
        if (height > 0) {
            return height;
        }
    } else if ([msg isKindOfClass:[HXDemoCurrencyCellModel class]]) {
        //如果高度需要根据特定字段计算，可以在这里计算 至于根据哪个字段计算，这个看实际情况
        HXDemoCurrencyCellModel *model = (HXDemoCurrencyCellModel *)msg;
        float titleFont = 12;
        CGSize titleSize = [model.title ex_sizeWithFont:[UIFont systemFontOfSize:titleFont] constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
        return 50 + titleSize.height - titleFont;
    }
    return 50;
}

@end


#pragma mark - Model

@implementation HXDemoCurrencyCellModel

+ (HXDemoCurrencyCellModel *)ittemModelWithTitle:(NSString *)title {
    HXDemoCurrencyCellModel *model = [HXDemoCurrencyCellModel new];
    model.title = kSafeString(title);
    return model;
}

@end
