//
//  SocketManager.h
//  MLogController
//
//  Created by ZZZZ on 2024/4/22.
//

#import <Foundation/Foundation.h>
#import "ClientSocketModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,KReadDataType){
    TAG_FIXED_LENGTH_HEADER = 10,//消息头部tag
    TAG_READ_NAME = 11,
    TAG_RESPONSE_BODY = 12,
    TAG_CLEAN_CACHE = 13
};


@protocol SocketManagerDelegate <NSObject>

-(void)socketAddConnection:(ClientSocketModel *)connectModel;

@end

@interface SocketManager : NSObject

@property (nonatomic,weak)id<SocketManagerDelegate> delegate;

+ (SocketManager *)sharedManager;

- (BOOL)startServers;

@end

NS_ASSUME_NONNULL_END
