//
//  ViewController.m
//  MLogController
//
//  Created by ZZZZ on 2024/4/19.
//

#import "ViewController.h"
#import "DeviceTableViewDelegate.h"
#import "SocketManager.h"


@interface ViewController ()<SocketManagerDelegate,NSNetServiceDelegate>
@property (weak) IBOutlet NSTableView *devicesTableView;
@property (weak) IBOutlet NSTableView *logsTableView;
@property (nonatomic,strong)DeviceTableViewDelegate *deviceTableDelegate;
@property (nonatomic,strong)SocketManager *socketManager;
@property (nonatomic,strong)NSNetService *netService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.socketManager startServers];
    [self.netService publish];
    self.view.frame = NSMakeRect(0, 0, 1200, 800);
    [self.devicesTableView registerNib:[[NSNib alloc] initWithNibNamed:@"DeviceCell" bundle:nil] forIdentifier:@"ViewControllerDeviceCell"];
//    [self.logsTableView registerNib:[[NSNib alloc] initWithNibNamed:@"MyCustomCell" bundle:nil] forIdentifier:@"ViewControllerLogCell"];
    self.devicesTableView.delegate = self.deviceTableDelegate;
    self.devicesTableView.dataSource = self.deviceTableDelegate;
    
    
    
}

- (NSMutableData *)byteOrderWithProtobuf:(NSData *)data{
    NSUInteger length = [data length];
    NSLog(@"%ld",length);
    Byte result[4];
    result[0] = (Byte) ((length >> 24)&0xff);
    result[1] = (Byte) ((length >> 16)&0xff);
    result[2] = (Byte) ((length >> 8)&0xff);
    result[3] = (Byte) (length&0xff);
    NSLog(@"%2s", result);
    NSMutableData * orderData = [NSMutableData dataWithBytes:result length:4];
    [orderData appendData:data];
    return orderData;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
#pragma mark - SocketManagerDelegate
-(void)socketAddConnection:(ClientSocketModel *)connectModel{
    DeviceTableViewModel *model = [DeviceTableViewModel modelWith:connectModel.deviceName deviceIP:connectModel.deviceIP isConnect:connectModel.isConnect];
    [self.deviceTableDelegate.deviceArray addObject:model];
//    [self.devicesTableView reloadDataForRowIndexes:[[NSIndexSet alloc]initWithIndex:self.deviceTableDelegate.deviceArray.count] columnIndexes:[[NSIndexSet alloc]initWithIndex:0]];
    [self.devicesTableView reloadData];
}

#pragma mark - NSNetServiceDelegate
-(void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"发布了监听");
}
-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict{
    NSLog(@"没有发布:%@",errorDict);
}

#pragma mark - 懒加载
-(DeviceTableViewDelegate *)deviceTableDelegate{
    if(!_deviceTableDelegate){
        _deviceTableDelegate = [[DeviceTableViewDelegate alloc]init];
    }
    return _deviceTableDelegate;
}
-(SocketManager *)socketManager{
    if(!_socketManager){
        _socketManager = [SocketManager sharedManager];
        _socketManager.delegate = self;
    }
    return _socketManager;
}
-(NSNetService *)netService{
    if (!_netService) {
        _netService = [[NSNetService alloc] initWithDomain:@"local." type:@"_companion-link._tcp." name:@"LOGControllerServices" port:12346];
        _netService.delegate = self;
    }
    return _netService;
}

@end
