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
            _icoImageView.image = [UIImage imageNamed:model.icoName];
            _titleLabel.text = model.title;
            _littleRedDotLabel.hidden = !model.isLittleRedDot;
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
    }
    return 50;
}

@end


#pragma mark - Model

@implementation HXDemoCurrencyCellModel

+ (HXDemoCurrencyCellModel *)ittemModelWithIcoName:(NSString *)icoName title:(NSString *)title isLittleRedDot:(BOOL)isLittleRedDot {
    HXDemoCurrencyCellModel *model = [HXDemoCurrencyCellModel new];
    model.icoName = icoName.length > 0 ? icoName : @"";
    model.title = title.length > 0 ? title : @"";;
    model.isLittleRedDot = isLittleRedDot;
    return model;
}

@end
