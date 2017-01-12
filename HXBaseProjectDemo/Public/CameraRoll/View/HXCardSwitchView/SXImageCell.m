//
//  SXImageCell.m
//  108 - 特殊布局
//
//  Created by 董 尚先 on 15/3/20.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXImageCell.h"

@interface SXImageCell()

@end

@implementation SXImageCell

- (void)awakeFromNib {
    self.imageView.layer.cornerRadius = 2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

@end
