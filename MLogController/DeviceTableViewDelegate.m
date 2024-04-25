//
//  DeviceTableViewDelegate.m
//  MLogController
//
//  Created by ZZZZ on 2024/4/19.
//

#import "DeviceTableViewDelegate.h"
#import "Nibs/DeviceCell.h"

@interface DeviceTableViewDelegate ()


@end

@implementation DeviceTableViewDelegate
#pragma mark - NSTableViewDataSource

/// 列表数量
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.deviceArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 52;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    DeviceCell *cellView = [tableView makeViewWithIdentifier:@"ViewControllerDeviceCell" owner:self];
    if (!cellView) {
        // 创建新的单元格视图
        cellView = [[DeviceCell alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        cellView.identifier = @"ViewControllerDeviceCell";
    }
    DeviceTableViewModel *model = [self.deviceArray objectAtIndex:row];
    // 配置单元格内容
    cellView.deviceName.stringValue = model.deviceName;
    cellView.deviceIP.stringValue = model.deviceIP;
    cellView.isConnect = model.isConnect;

    return cellView;
}


#pragma mark - 懒加载
-(NSMutableArray<DeviceTableViewModel *> *)deviceArray{
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}

@end
