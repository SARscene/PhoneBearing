//
//  InterfaceController.m
//  WatchBearing Extension
//
//  Created by bob on 2015-10-23.
//  Copyright © 2015 Cryptonym Ltd. All rights reserved.
//

#import "InterfaceController.h"
@import WatchConnectivity;

@interface InterfaceController()
@property NSTimer*      timer;
@property WCSession*    session;
@property NSNumber*     bearingValue;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *bearing;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    self.bearingValue = [NSNumber numberWithDouble:0.];
    [self updateBearingText:self.bearingValue];
    
    if ([WCSession isSupported]) {
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)tap {
    WKHapticType tapType;
    double doubleBearing = [self.bearingValue doubleValue];
    if (doubleBearing > 7.5 && doubleBearing < 180.0f) {
        tapType = WKHapticTypeStop;
    } else if ( doubleBearing > 180 && doubleBearing < (360 - 7.5)) {
        tapType = WKHapticTypeStart;
    } else {
        tapType = WKHapticTypeClick;
    }
    
    [[WKInterfaceDevice currentDevice] playHaptic:tapType];
}

- (void)tick:(NSTimer*)timer
{
    [self tap];
}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message
{
    self.bearingValue = message[@"bearing"];
    [self updateBearingText:self.bearingValue];
}

-(void)updateBearingText:(NSNumber*)bearing
{
    NSString* bearingText = [NSString stringWithFormat:@"%@", bearing];
    [self.bearing setText:bearingText];
}



@end
