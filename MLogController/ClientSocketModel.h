//
//  ClientSocketModel.h
//  MLogController
//
//  Created by ZZZZ on 2024/4/23.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

NS_ASSUME_NONNULL_BEGIN

struct SocketManagerHeader {
    uint32 dataLength;
    uint8 dataType;
    uint8 retain;
};

@interface ClientSocketModel : NSObject

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *deviceIP;
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic) struct SocketManagerHeader currentManagerHeader;

-(instancetype)initWith:(GCDAsyncSocket *)socket name:(NSString *)deviceName ip:(NSString *)deviceIP;

@end

NS_ASSUME_NONNULL_END
