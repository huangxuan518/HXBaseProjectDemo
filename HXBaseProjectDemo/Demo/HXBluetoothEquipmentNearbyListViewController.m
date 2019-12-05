//
//  HXBluetoothEquipmentNearbyListViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXBluetoothEquipmentNearbyListViewController.h"

#import "HXDemoCurrencyCell.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface HXBluetoothEquipmentNearbyListViewController () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,strong) CBCentralManager *manager;
/*...用于存储周边的设备列表...*/
@property (nonatomic, strong) NSMutableArray *devicesListArray;

@property (nonatomic,strong) CBCharacteristic *characteristic;

@end

@implementation HXBluetoothEquipmentNearbyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitleViewWithTitle:@"周边蓝牙扫描"];
    [self.tableview registerNib:[UINib nibWithNibName:@"HXDemoCurrencyCell" bundle:nil] forCellReuseIdentifier:@"HXDemoCurrencyCell"];
    
    //初始化
    [self manager];
}

#pragma mark - cellDataSource

- (NSArray *)cellDataSource {
    
    if (!self.dataSource) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];
        
        NSMutableArray *subarr = nil;
        __block NSDictionary *dict = nil;
        
        //section 0
        subarr = [NSMutableArray arrayWithCapacity:1];
        [self.devicesListArray enumerateObjectsUsingBlock:^(CBPeripheral *peripheral, NSUInteger idx, BOOL * _Nonnull stop) {
            dict =  @{@"class":HXDemoCurrencyCell.class,
                      @"height":@([HXDemoCurrencyCell getCellFrame:nil]),
                      @"data":[HXDemoCurrencyCellModel ittemModelWithTitle:[NSString stringWithFormat:@"%@ | %@",kSafeString(peripheral.name),peripheral.identifier]],
                      @"action":@"uploadData",
                      @"delegate":@YES};
            [subarr addObject:dict];
        }];
        [arr addObject:subarr];
        
        self.dataSource = arr;
    }
    return self.dataSource;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *peripheral = self.devicesListArray[indexPath.row];
    [self connect:peripheral];

}

#pragma mark - 蓝牙相关

/**
 *  停止扫描
 */
- (void)stopScan {
    [self.manager stopScan];
    NSLog(@"stopScan....");
    [self refreshData];
}

#pragma mark CBCentralManagerDelegate
//当蓝牙状态改变的时候就会调用这个方法 仅仅在CBCentralManagerStatePoweredOn的时候可用当central的状态是OFF的时候所有与中心连接的peripheral都将无效并且都要重新连接，central的初始状态时是Unknown
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            NSLog(@"蓝牙不可用");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"未授权");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"蓝牙未打开");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开");
            //扫描周边的所有蓝牙4.0外设
            [self.manager scanForPeripheralsWithServices:nil options:nil];
            //3秒后停止。(开启扫描后会不停的扫描)
            [self performSelector:@selector(stopScan) withObject:nil afterDelay:3];
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"状态未知");
        default:
            NSLog(@"不明情况了");
            ;
    }
}

//扫描到外设的时候会调该方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if(![self.devicesListArray containsObject:peripheral])
        [self.devicesListArray addObject:peripheral];
    [self refreshData];
    NSLog(@"%@", peripheral.identifier);
    NSLog(@"%@", peripheral);
}

#pragma mark - 连接设备

//连接指定的设备
- (BOOL)connect:(CBPeripheral *)peripheral {
    [self.manager connectPeripheral:peripheral
                                     options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    return YES;
}

//连接到Peripherals-成功 //扫描外设中的服务和特征  连接上外围设备的时候会调用该方法
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    //设置的peripheral委托CBPeripheralDelegate
    //@interface ViewController : UIViewController
    [peripheral setDelegate:self];
    //扫描外设Services，成功后会进入方法：-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [peripheral discoverServices:nil];
    
}
//连接到Peripherals-失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

/**
 *  发现外围设备的服务会来到该方法(扫描到服务之后直接添加peripheral的services)
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"发现外围设备的服务");
    for (CBService *serivce in peripheral.services) {
        NSLog(@"====%@------%@+++++++",serivce.UUID.UUIDString,peripheral.identifier);
//        if ([serivce.UUID.UUIDString isEqualToString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]) {
//            // characteristicUUIDs : 可以指定想要扫描的特征(传nil,扫描所有的特征)
            [peripheral discoverCharacteristics:nil forService:serivce];
//        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"发现外围设备的特征");
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"====%@------+",characteristic.UUID.UUIDString);
            // 拿到特征,和外围设备进行交互
            [self notifyCharacteristic:peripheral characteristic:characteristic];
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"====%@------+",characteristic.UUID.UUIDString);
            // 拿到特征,和外围设备进行交互   保存写的特征
            self.characteristic = characteristic;
    }
}

//设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}

//写数据
-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value
{
    //只有 characteristic.properties 有write的权限才可以写
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        /*
         最好一个type参数可以为CBCharacteristicWriteWithResponse或type:CBCharacteristicWriteWithResponse,区别是是否会有反馈
         */
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"该字段不可写！");
    }
}

#pragma mark - 懒加载

//初始化CBCentralManager
- (CBCentralManager *)manager {
    if (!_manager) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _manager;
}

//周围设备列表
- (NSMutableArray *)devicesListArray {
    if (!_devicesListArray) {
        _devicesListArray  = [NSMutableArray arrayWithCapacity:1];
    }
    return _devicesListArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
