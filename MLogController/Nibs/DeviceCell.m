//
//  DeviceTableViewCell.m
//  MLogController
//
//  Created by ZZZZ on 2024/4/19.
//

#import "DeviceCell.h"

@interface DeviceCell ()

@property (weak) IBOutlet NSView *stateView;

@end

@implementation DeviceCell

- (void)awakeFromNib{
    [super awakeFromNib];
    // 设置圆形
    self.stateView.wantsLayer = YES;
    self.stateView.layer.cornerRadius = 10;
    self.stateView.layer.masksToBounds = YES;
    self.stateView.layer.backgroundColor = [NSColor redColor].CGColor;

    // 设置边框
    self.stateView.layer.borderWidth = 2.0;
    self.stateView.layer.borderColor = [NSColor whiteColor].CGColor;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)setIsConnect:(BOOL)isConnect{
    _isConnect = isConnect;
    if (isConnect) {
        self.stateView.layer.backgroundColor = [NSColor greenColor].CGColor;
    }else{
        self.stateView.layer.backgroundColor = [NSColor redColor].CGColor;
    }
}

@end
