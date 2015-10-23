#import "ViewController.h"
@import CoreLocation;

@interface ViewController ()
@property CLLocationManager* locManager;
@property (weak, nonatomic) IBOutlet UILabel *compassDirection;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    [self.locManager startUpdatingHeading];

}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    self.compassDirection.text = [NSString stringWithFormat:@"%f", newHeading.magneticHeading];
}

@end
