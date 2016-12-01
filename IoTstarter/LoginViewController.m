/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  LoginViewController.m
//  IoTstarter
//

#import "LoginViewController.h"
#import "AppDelegate.h"

/*
 * BLE Defines
 */

#define TIMER_PAUSE_INTERVAL 10.0
#define TIMER_SCAN_INTERVAL  2.0

#define SENSOR_TAG_NAME @"CC2650 SensorTag"
#define ROOM_MONITOR_TAG_NAME @"ELEC6245 RoomMonitor"
#define GDP_NODE_NAME @"GH-SensorNode"

@interface LoginViewController () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) IBOutlet UIButton *activateButton;

@property (strong, nonatomic) IBOutlet UILabel *connected;

@property (strong, nonatomic) IBOutlet UITextField *organizationField;
@property (strong, nonatomic) IBOutlet UITextField *authTokenField;
@property (strong, nonatomic) IBOutlet UITextField *deviceIDField;

@property (strong, nonatomic) IBOutlet UIButton *showAuthToken;

@property (strong, nonatomic) IBOutlet UISwitch *accelSwitch;

// BLE properties
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *sensorTag;
@property (nonatomic, strong) CBPeripheral *roomSensorTag;
@property (nonatomic, assign) BOOL keepScanning;
// End BLE Properties

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.loginViewController = self;
    }
    return self;
}

/*************************************************************************
 * View related methods
 *************************************************************************/

- (void)viewWillAppear:(BOOL)animated
{
    [self updateViewLabels];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentView = LOGIN;
    
    self.authTokenField.secureTextEntry = YES;
    self.authTokenField.delegate = self;
    self.deviceIDField.delegate = self;
    self.organizationField.delegate = self;
    
    self.organizationField.placeholder = IOTOrgPlaceholder;
    self.deviceIDField.placeholder = IOTDevicePlaceholder;
    self.authTokenField.placeholder = IOTAuthPlaceholder;
    
    /*
     * Pre-fill connection info
     */
    
    self.organizationField.text = @"f6z0bl";
    self.deviceIDField.text = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]; //use advertising identifier as device ID
    self.authTokenField.text = @"test1234";
    
    if (![appDelegate.organization isEqualToString:@""])
    {
        self.organizationField.text = appDelegate.organization;
    }
    if (![appDelegate.deviceID isEqualToString:@""])
    {
        self.deviceIDField.text = appDelegate.deviceID;
    }
    if (![appDelegate.authToken isEqualToString:@""])
    {
        self.authTokenField.text = appDelegate.authToken;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.authTokenField.secureTextEntry = YES;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    self.organizationField.text = appDelegate.organization;
    self.deviceIDField.text = appDelegate.deviceID;
    self.authTokenField.text = appDelegate.authToken;
    
    /*
     *  Todo BLE stuff here
     */
    
    // Create the CBCentralManager.
    // NOTE: Creating the CBCentralManager with initWithDelegate will immediately call centralManagerDidUpdateState.
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}

/*************************************************************************
 * BLE Methods
 *************************************************************************/

- (void)pauseScan {
    // Scanning uses up battery on phone, so pause the scan process for the designated interval.
    NSLog(@"*** PAUSING SCAN...");
    [NSTimer scheduledTimerWithTimeInterval:TIMER_PAUSE_INTERVAL target:self selector:@selector(resumeScan) userInfo:nil repeats:NO];
    [self.centralManager stopScan];
}

- (void)resumeScan {
    if (self.keepScanning) {
        // Start scanning again...
        NSLog(@"*** RESUMING SCAN!");
        [NSTimer scheduledTimerWithTimeInterval:TIMER_SCAN_INTERVAL target:self selector:@selector(pauseScan) userInfo:nil repeats:NO];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)cleanup {
    [_centralManager cancelPeripheralConnection:self.sensorTag];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    BOOL showAlert = YES;
    NSString *state = @"";
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"This device does not support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"This app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth on this device is currently powered off.";
            break;
        case CBCentralManagerStateResetting:
            state = @"The BLE Manager is resetting; a state update is pending.";
            break;
        case CBCentralManagerStatePoweredOn:
            showAlert = NO;
            state = @"Bluetooth LE is turned on and ready for communication.";
            NSLog(@"%@", state);
            self.keepScanning = YES;
            [NSTimer scheduledTimerWithTimeInterval:TIMER_SCAN_INTERVAL target:self selector:@selector(pauseScan) userInfo:nil repeats:NO];
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStateUnknown:
            state = @"The state of the BLE Manager is unknown.";
            break;
        default:
            state = @"The state of the BLE Manager is unknown.";
    }
    
    if (showAlert) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Central Manager State" message:state preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    // Retrieve the peripheral name from the advertisement data using the "kCBAdvDataLocalName" key
    NSString *peripheralName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    NSLog(@"NEXT PERIPHERAL: %@ (%@)", peripheralName, peripheral.identifier.UUIDString);
    if (peripheralName) {
        if ([peripheralName isEqualToString:GDP_NODE_NAME]) { //ROOM_MONITOR_TAG_NAME
            // we found a tag so stop scanning
            self.keepScanning = NO;
            
            // save a reference to the sensor tag
            self.sensorTag = peripheral;
            self.sensorTag.delegate = self;
            
            // Request a connection to the peripheral
            [self.centralManager connectPeripheral:self.sensorTag options:nil];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"**** SUCCESSFULLY CONNECTED TO SENSOR TAG!!!");
    //self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:56];
    //self.temperatureLabel.text = @"Connected";
    
    // Now that we've successfully connected to the SensorTag, let's discover the services.
    // - NOTE:  we pass nil here to request ALL services be discovered.
    //          If there was a subset of services we were interested in, we could pass the UUIDs here.
    //          Doing so saves batter life and saves time.
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"**** CONNECTION FAILED!!!");
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"**** DISCONNECTED FROM SENSOR TAG!!!");
}



/*************************************************************************
 * END BLE METHODS
 *************************************************************************/

- (void)updateViewLabels
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.activateButton setEnabled:YES];
    
    if (appDelegate.isConnected)
    {
        // If device is connected, then it is already registered and all values were
        // already set.
        [self.activateButton setTitle:IOTDeactivateLabel forState:UIControlStateNormal];
        self.connected.text = YES_STRING;
    }
    else
    {
        // If device is not connected, it may or may not be registered.
        [self.activateButton setTitle:IOTActivateLabel forState:UIControlStateNormal];
        self.connected.text = NO_STRING;
    }
    [self.showAuthToken setTitle:IOTShowTokenLabel forState:UIControlStateNormal];
}

/*************************************************************************
 * IBAction methods
 *************************************************************************/

- (IBAction)showAuthToken:(id)sender
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if ([self.showAuthToken.currentTitle isEqualToString:IOTShowTokenLabel])
    {
        self.authTokenField.secureTextEntry = NO;
        [self.showAuthToken setTitle:IOTHideTokenLabel forState:UIControlStateNormal];
    }
    else
    {
        self.authTokenField.secureTextEntry = YES;
        [self.showAuthToken setTitle:IOTShowTokenLabel forState:UIControlStateNormal];
    }
}

- (IBAction)activateSensor:(id)sender
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.activateButton setEnabled:NO];
    [appDelegate storePropertiesToArchive];
    
    if ([self.activateButton.titleLabel.text isEqualToString:IOTActivateLabel])
    {
        // Start MQTT logic
        Messenger *messenger = [Messenger sharedMessenger];
        NSString *serverAddress;
        NSString *clientID;
        
        appDelegate.organization = [NSString stringWithFormat:@"%@", self.organizationField.text];
        appDelegate.deviceID = [NSString stringWithFormat:@"%@", self.deviceIDField.text];
        appDelegate.authToken = [NSString stringWithFormat:@"%@", self.authTokenField.text];
        
        if ([appDelegate.organization isEqualToString:IOTQuickStartOrgID])
        {
            appDelegate.connectionType = QUICKSTART;
            appDelegate.sensorFrequency = IOTSensorFreqDefault;
            serverAddress = IOTQuickStartServer;
            clientID = [NSString stringWithFormat:IOTClientID, appDelegate.organization, IOTDeviceType, appDelegate.deviceID];
        }
        else if ([appDelegate.organization isEqualToString:IOTM2MOrgID])
        {
            appDelegate.connectionType = M2M;
            appDelegate.sensorFrequency = IOTSensorFreqFast;
            serverAddress = IOTM2MDemosServer;
            clientID = [NSString stringWithFormat:IOTM2MClientID, appDelegate.deviceID];
        }
        else {
            appDelegate.connectionType = IOTF;
            appDelegate.sensorFrequency = IOTSensorFreqDefault;
            serverAddress = [NSString stringWithFormat:IOTServerAddress, appDelegate.organization];
            clientID = [NSString stringWithFormat:IOTClientID, appDelegate.organization, IOTDeviceType, appDelegate.deviceID];
        }
        
#ifdef USE_LOCAL_NOTIFICATIONS
        // Run the MQTT Connection in a background task so that it continues processing messages
        // while the application is running in the background.
        appDelegate.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"iotbgtask" expirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:appDelegate.bgTask];
            appDelegate.bgTask = UIBackgroundTaskInvalid;
        }];
#endif
        [messenger connectWithHost:serverAddress port:IOTServerPort clientId:clientID];
    }
    else if ([self.activateButton.titleLabel.text isEqualToString:IOTDeactivateLabel])
    {
        // Stop MQTT logic
        Messenger *messenger = [Messenger sharedMessenger];
        
        [messenger disconnect];
    }
}

- (IBAction)rightViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToIoTView];
}

- (IBAction)leftViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[appDelegate switchToRemoteView];
    [appDelegate switchToLogView];
}

- (IBAction)toggleAccel:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isAccelEnabled = [self.accelSwitch isOn];
    if (appDelegate.isConnected && appDelegate.isAccelEnabled)
    {
        [appDelegate startMotionManager];
    }
    else if (appDelegate.isConnected && !appDelegate.isAccelEnabled)
    {
        [appDelegate stopMotionManager];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)text
{
    [text resignFirstResponder];
    return YES;
}

/*************************************************************************
 * Other standard iOS methods
 *************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfilesTableViewController *tableView = [segue destinationViewController];
    tableView.currentOrganization = [NSString stringWithString:self.organizationField.text];
    tableView.currentDeviceID = [NSString stringWithString:self.deviceIDField.text];
    tableView.currentAuthToken = [NSString stringWithString:self.authTokenField.text];
}

@end
