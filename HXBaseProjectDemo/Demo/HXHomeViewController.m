//
//  HXHomeViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXHomeViewController.h"
#import "HXBluetoothEquipmentNearbyListViewController.h"

#import "HXDemoCurrencyCell.h"

#import "RequestManager.h"

@interface HXHomeViewController ()

@end

@implementation HXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitleViewWithTitle:@"首页"];
    [self.tableview registerNib:[UINib nibWithNibName:@"HXDemoCurrencyCell" bundle:nil] forCellReuseIdentifier:@"HXDemoCurrencyCell"];
}

- (void)showBackWithTitle:(NSString *)title {
    
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
                  @"data":[HXDemoCurrencyCellModel ittemModelWithTitle:@"单张图片上传示例"],
                  @"action":@"uploadData",
                  @"delegate":@YES};
        [subarr addObject:dict];
        [arr addObject:subarr];
        
        //section 1
        subarr = [NSMutableArray arrayWithCapacity:1];
        
        //row 1
        dict =  @{@"class":HXDemoCurrencyCell.class,
                  @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
                  @"data":[HXDemoCurrencyCellModel ittemModelWithTitle:@"网络请求示例"],
                  @"action":@"request",
                  @"delegate":@YES};
        [subarr addObject:dict];
        
        dict =  @{@"class":HXDemoCurrencyCell.class,
                  @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
                  @"data":[HXDemoCurrencyCellModel ittemModelWithTitle:@"周边蓝牙扫描"],
                  @"action":@"gotoCoreBluetoothViewController"};
        [subarr addObject:dict];

        [arr addObject:subarr];
        
        self.dataSource = arr;
    }
    return self.dataSource;
}

#pragma mark - goto

//网络请求
- (void)request {
    [self.requestManager getBankcardsilkRequestWithNum:@"6228480402564890018" success:^(id responseObject) {
        NSDictionary *dataDic = (NSDictionary *)responseObject[@"result"];
        NSLog(@"%@",dataDic);
    } failure:^(NSString *errorMsg) {
        
    }];
}

//去蓝牙列表界面
- (void)gotoCoreBluetoothViewController {
    HXBluetoothEquipmentNearbyListViewController *vc = [HXBluetoothEquipmentNearbyListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadData {
    UIImage *image = [UIImage imageNamed:@"ceshi.jpg"];
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    
    [self.uploadManager uploadData:imgData progress:^(float percent) {
        
    } completion:^(NSError *error, NSString *link,NSData *data,NSInteger index) {
        NSLog(@"上传成功 图片地址:%@",link);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
