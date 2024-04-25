//
//  DeviceTableViewDelegate.h
//  MLogController
//
//  Created by ZZZZ on 2024/4/19.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "DeviceTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceTableViewDelegate : NSObject <NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic,strong) NSMutableArray<DeviceTableViewModel *> *deviceArray;

@end

NS_ASSUME_NONNULL_END
