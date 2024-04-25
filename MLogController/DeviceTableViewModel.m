//
//  DeviceTableViewModel.m
//  MLogController
//
//  Created by ZG on 2024/4/25.
//

#import "DeviceTableViewModel.h"

@implementation DeviceTableViewModel

+(instancetype)modelWith:(NSString *)deviceName deviceIP:(NSString *)deviceIP isConnect:(BOOL)isConnect{
    DeviceTableViewModel *model = [[DeviceTableViewModel alloc]init];
    model.deviceName = deviceName;
    model.deviceIP = deviceIP;
    model.isConnect = isConnect;
    return model;
}

@end
