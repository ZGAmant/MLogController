//
//  ClientSocketModel.m
//  MLogController
//
//  Created by ZZZZ on 2024/4/23.
//

#import "ClientSocketModel.h"

@implementation ClientSocketModel

-(instancetype)initWith:(GCDAsyncSocket *)socket name:(NSString *)deviceName ip:(NSString *)deviceIP{
    self = [super init];
    if (self) {
        self.socket = socket;
        self.deviceName = deviceName;
        self.deviceIP = deviceIP;
    }
    return self;
}

@end
