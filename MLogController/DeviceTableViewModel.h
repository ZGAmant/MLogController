//
//  DeviceTableViewModel.h
//  MLogController
//
//  Created by ZG on 2024/4/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceTableViewModel : NSObject

@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *deviceIP;
@property (nonatomic,assign) BOOL isConnect;

+(instancetype)modelWith:(NSString *)deviceName deviceIP:(NSString *)deviceIP isConnect:(BOOL)isConnect;

@end

NS_ASSUME_NONNULL_END
