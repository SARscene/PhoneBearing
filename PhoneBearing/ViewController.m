#import "ViewController.h"
@import CoreLocation;
@import WatchConnectivity;

@interface ViewController ()
@property CLLocationManager* locManager;
@property WCSession* session;
@property (weak, nonatomic) IBOutlet UILabel *compassDirection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    [self.locManager startUpdatingHeading];
    
    if ([WCSession isSupported]) {
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }

}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.compassDirection.text = [NSString stringWithFormat:@"%f", newHeading.magneticHeading];
    NSDictionary* message = @{@"bearing":[NSNumber numberWithDouble:newHeading.magneticHeading]};
    [self.session sendMessage:message replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        // Nop
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"Send error");
    }];
}

@end
