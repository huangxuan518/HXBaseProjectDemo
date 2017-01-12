//
//  HXPhotoCell.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/18.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "HXPhotoCell.h"

@implementation HXPhotoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setData:(id)data delegate:(id)delegate {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = data;
        NSString *groupName = dic[@"name"];
        NSInteger groupPhotoCount = [dic[@"count"] intValue];
        UIImage *image = dic[@"thumbnail"];
        _icoImageView.image = image;
        _titleLabel.text = [NSString stringWithFormat:@"%@ %ld",groupName,(long)groupPhotoCount];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
