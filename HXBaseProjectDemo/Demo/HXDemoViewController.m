//
//  HXDemoViewController.m
//  HXBaseProjectDemo
//
//  Created by 黄轩 on 2017/1/11.
//  Copyright © 2017年 黄轩. All rights reserved.
//

#import "HXDemoViewController.h"

#import "HXDemoCurrencyCell.h"

@interface HXDemoViewController ()

@end

@implementation HXDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    [self.tableview registerNib:[UINib nibWithNibName:@"HXDemoCurrencyCell" bundle:nil] forCellReuseIdentifier:@"HXDemoCurrencyCell"];
}

#pragma mark - cellDataSource

- (NSArray *)cellDataSource {
    
    if (!self.dataSource) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];
        
        NSMutableArray *subarr = nil;
        NSDictionary *dict = nil;
        
        //section 0
        subarr = [NSMutableArray arrayWithCapacity:1];
        dict =  @{@"class":HXDemoCurrencyCell.class,
                  @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
                  @"data":[HXDemoCurrencyCellModel ittemModelWithIcoName:@"" title:@"上传" isLittleRedDot:YES],
                  @"action":@"uploadData",
                  @"delegate":@YES};
        [subarr addObject:dict];
        [arr addObject:subarr];
        
        //section 1
        subarr = [NSMutableArray arrayWithCapacity:1];
        
        //row 0
        dict =  @{@"class":HXDemoCurrencyCell.class,
                  @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
                  @"data":[HXDemoCurrencyCellModel ittemModelWithIcoName:@"" title:@"测试2" isLittleRedDot:NO],
                  @"action":@"gotoDemoViewController",
                  @"delegate":@YES};
        [subarr addObject:dict];
        
        //row 1
        dict =  @{@"class":HXDemoCurrencyCell.class,
                  @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
                  @"data":[HXDemoCurrencyCellModel ittemModelWithIcoName:@"" title:@"测试3" isLittleRedDot:YES],
                  @"action":@"gotoDemoViewController",
                  @"delegate":@YES};
        [subarr addObject:dict];
        
        [arr addObject:subarr];
        
        self.dataSource = arr;
    }
    return self.dataSource;
}

#pragma mark - goto

- (void)gotoDemoViewController {
    HXDemoViewController *vc = [HXDemoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadData {
    UIImage *image = [UIImage imageNamed:@"xiaoguo"];
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    
    [self.uploadManager uploadData:imgData progress:^(float percent) {
        
    } completion:^(NSError *error, NSString *link, NSInteger index) {
        NSLog(@"上传成功 图片地址:%@",link);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
