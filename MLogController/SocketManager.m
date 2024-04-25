//
//  SocketManager.m
//  MLogController
//
//  Created by ZZZZ on 2024/4/22.
//

#import "SocketManager.h"
#import "GCDAsyncSocket.h"

#define ZPacketHeaderLength 9

@interface SocketManager() <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) NSMutableDictionary *clientSockets;

@end

static SocketManager *socketManager = nil;

@implementation SocketManager

+ (SocketManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketManager = [[super allocWithZone:NULL] init];
    });
    
    return socketManager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

-(id)copy{
    return self;
}

- (BOOL)startServers{
    // 启动服务端
    NSError *error = nil;
    if (![self.serverSocket acceptOnPort:12345 error:&error]) {
        NSLog(@"Error starting server: %@", error);
        return NO;
    } else {
        NSLog(@"Server started on port 12345");
        return YES;
    }
}

#pragma mark - GCDAsyncSocketDelegate

/// 有新的连接
/// - Parameters:
///   - sock: 服务端
///   - newSocket: 客户端连接
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"新连接:%@--%p",newSocket.connectedHost,newSocket);
    
    ClientSocketModel *socketModel = [[ClientSocketModel alloc]initWith:newSocket name:@"" ip:newSocket.localHost];
    
    // 生成一个唯一的标识符
    NSString *clientIdentifier = [NSString stringWithFormat:@"%p", newSocket];

    // 存储客户端连接信息
    [self.clientSockets setObject:socketModel forKey:clientIdentifier];
    
    // 读取客户端发送的数据
//    [newSocket readDataWithTimeout:-1 tag:0];
    [newSocket readDataToLength:ZPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
    
}


/// 接收客户端的数据
/// - Parameters:
///   - sock: 客户端的连接
///   - data: 读取到的数据
///   - tag: 消息标志
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // 生成一个唯一的标识符
    NSString *clientIdentifier = [NSString stringWithFormat:@"%p", sock];
    // 删除客户端连接信息
    ClientSocketModel *model = [self.clientSockets objectForKey:clientIdentifier];
    NSData *messageTag;
    NSString *name;
    switch (tag) {
        case TAG_FIXED_LENGTH_HEADER:
            messageTag = [data subdataWithRange:NSMakeRange(0,3)];
            if (![[[NSString alloc]initWithData:messageTag encoding:NSUTF8StringEncoding] isEqual:@"LOG"]) {
                [sock readDataWithTimeout:-1 tag:TAG_CLEAN_CACHE];
                NSLog(@"消息头不一致:%@",[[NSString alloc]initWithData:messageTag encoding:NSUTF8StringEncoding]);
                return;
            }
            model.currentManagerHeader = [self decryptionDataHeader:data];
//            NSLog(@"%u--%u",model.currentManagerHeader.dataLength,model.currentManagerHeader.dataType);
            
            if (model.currentManagerHeader.dataType == 0) {
                [sock readDataToLength:model.currentManagerHeader.dataLength withTimeout:-1 tag:TAG_READ_NAME];
            }else if (model.currentManagerHeader.dataType == 1) {
                [sock readDataToLength:model.currentManagerHeader.dataLength withTimeout:-1 tag:TAG_RESPONSE_BODY];
            }else{
                [sock readDataWithTimeout:-1 tag:TAG_CLEAN_CACHE];
            }
            break;
        case TAG_READ_NAME:
            name = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if (data.length == model.currentManagerHeader.dataLength) {
                model.deviceName = name;
                [self.delegate socketAddConnection:model];
            }else{
                NSLog(@"名字读取失败");
            }
            [sock readDataToLength:ZPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
            break;
        case TAG_RESPONSE_BODY:
            NSLog(@"获取数据:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            if (data.length == model.currentManagerHeader.dataLength) {
                [sock readDataToLength:ZPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
            }else{
                NSLog(@"数据未完全读取");
            }
            break;
        case TAG_CLEAN_CACHE:
            NSLog(@"清理缓存:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            [sock readDataToLength:ZPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
            break;
        default:
//            [sock readDataWithTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
            [sock readDataToLength:ZPacketHeaderLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
            break;
    }
    
//    NSLog(@"Received data from client: %@--%ld", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    // 继续读取数据
//    [sock readDataWithTimeout:-1 tag:0];
}


/// 客户端断开连接
/// - Parameters:
///   - sock: 客户端套接字
///   - err: 断开错误信息
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    // 生成一个唯一的标识符
    NSString *clientIdentifier = [NSString stringWithFormat:@"%p", sock];
    // 删除客户端连接信息
    [self.clientSockets removeObjectForKey:clientIdentifier];
}

/// 解析数据
/// 信息
/// - Parameter data: 长度为ZPacketHeaderLength的头部数据
- (struct SocketManagerHeader)decryptionDataHeader:(NSData *)data{
    NSData *lengthData = [data subdataWithRange:NSMakeRange(3,4)];
    Byte *bytes = (Byte *)[lengthData bytes];
    struct SocketManagerHeader dataHeader;
    dataHeader.dataLength = (bytes[0]<<24) + (bytes[1]<<16) + (bytes[2]<<8) + bytes[3];
    uint8 dataType;
    [[data subdataWithRange:NSMakeRange(7,1)] getBytes:&dataType length:1];
    dataHeader.dataType = dataType;
//    dataHeader.dataType = *(uint8 *)([[data subdataWithRange:NSMakeRange(7,1)] bytes]);
    return dataHeader;
}

#pragma makr - 懒加载
-(GCDAsyncSocket *)serverSocket{
    if(!_serverSocket){
        _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _serverSocket;
}
-(NSMutableDictionary *)clientSockets{
    if(!_clientSockets){
        _clientSockets = [NSMutableDictionary dictionary];
    }
    return _clientSockets;
}

@end

