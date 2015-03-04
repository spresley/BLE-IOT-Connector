/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  ViewController.m
//  IoTstarter
//

#import "IoTStarterViewController.h"
#import "AppDelegate.h"
#import "DrawingView.h"

@interface IoTStarterViewController ()

@property (strong, nonatomic) IBOutlet UILabel *deviceId;

@property (strong, nonatomic) IBOutlet UILabel *accelX;
@property (strong, nonatomic) IBOutlet UILabel *accelY;
@property (strong, nonatomic) IBOutlet UILabel *accelZ;

@property (strong, nonatomic) IBOutlet UILabel *messagesPublished;
@property (strong, nonatomic) IBOutlet UILabel *messagesReceived;

@property (strong, nonatomic) IBOutlet UIButton *textButton;
@property (strong, nonatomic) IBOutlet DrawingView *colorView;

@property (strong, nonatomic) IBOutlet UIImageView *borderImage;

@end

@implementation IoTStarterViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.iotViewController = self;
    }
    return self;
}

/*************************************************************************
 * View related methods
 *************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateViewLabels];
    [self updateMessageCounts];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentView = IOT;
    
    int r = self.borderImage.layer.frame.size.height;
    self.borderImage.layer.cornerRadius = r/2;
    self.borderImage.layer.masksToBounds = YES;
    self.borderImage.layer.borderWidth = 2;
    self.borderImage.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)updateViewLabels
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.deviceId.text = appDelegate.deviceID;
}

- (void)updateMessageCounts
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.messagesPublished.text = [NSString stringWithFormat:@"%zd", appDelegate.publishCount];
    self.messagesReceived.text = [NSString stringWithFormat:@"%zd", appDelegate.receiveCount];
}

- (void)updateAccelLabels
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CMAcceleration accel = appDelegate.latestAcceleration;
    self.accelX.text = [NSString stringWithFormat:@"x: %f", accel.x];
    self.accelY.text = [NSString stringWithFormat:@"y: %f", accel.y];
    self.accelZ.text = [NSString stringWithFormat:@"z: %f", accel.z];
}

- (void)updateBackgroundColor:(UIColor *)color
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    [self.colorView setBackgroundColor:color];
    //NSLog(@"Background color updated");
}

/*************************************************************************
 * IBAction methods
 *************************************************************************/

- (IBAction)sendTextPressed:(id)sender
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Text" message:@"Enter text to send" delegate:self cancelButtonTitle:CANCEL_STRING otherButtonTitles:SUBMIT_STRING, nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (IBAction)rightViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToLogView];
}

- (IBAction)leftViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToLoginView];
}

/*************************************************************************
 * Alert View Handler
 *************************************************************************/

- (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if ([[alertView textFieldAtIndex:0].text isEqualToString:@""] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:CANCEL_STRING])
    {
        // skip empty input or when cancel pressed
        return;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *messageData = [MessageFactory createTextMessage:[alertView textFieldAtIndex:0].text];

    [appDelegate publishData:messageData event:IOTTextEvent];
}

/*************************************************************************
 * Other standard iOS methods
 *************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
