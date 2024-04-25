//
//  DeviceTableViewCell.h
//  MLogController
//
//  Created by ZZZZ on 2024/4/19.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCell : NSTableCellView
@property (weak) IBOutlet NSTextField *deviceName;
@property (weak) IBOutlet NSTextField *deviceIP;
@property (nonatomic,assign) BOOL isConnect;

@end

NS_ASSUME_NONNULL_END
