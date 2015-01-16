/*******************************************************************************
 * Copyright (c) 2014 IBM Corp.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 *
 * The Eclipse Public License is available at
 *   http://www.eclipse.org/legal/epl-v10.html
 * and the Eclipse Distribution License is available at
 *   http://www.eclipse.org/org/documents/edl-v10.php.
 *
 * Contributors:
 *    Mike Robertson - initial contribution
 *******************************************************************************/

//
//  RemoteViewController.m
//  IoTstarter
//

#import "RemoteViewController.h"
#import "AppDelegate.h"

@interface RemoteViewController ()

@property (strong, nonatomic) IBOutlet UIButton *aButton;
@property (strong, nonatomic) IBOutlet UIButton *bButton;
@property (strong, nonatomic) IBOutlet UIButton *xButton;
@property (strong, nonatomic) IBOutlet UIButton *yButton;

@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation RemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    int r = self.aButton.layer.frame.size.height;
    
    self.aButton.layer.cornerRadius = r/2;
    self.aButton.layer.borderWidth = 1;
    [self.aButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    self.bButton.layer.cornerRadius = r/2;
    self.bButton.layer.borderWidth = 1;
    [self.bButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    self.xButton.layer.cornerRadius = r/2;
    self.xButton.layer.borderWidth = 1;
    [self.xButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    self.yButton.layer.cornerRadius = r/2;
    self.yButton.layer.borderWidth = 1;
    [self.yButton setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
    r = self.dpad.layer.frame.size.height;
    self.dpad.layer.cornerRadius = r/2;
    self.dpad.layer.borderWidth = 1;
    self.dpad.layer.masksToBounds = YES;
    self.dpad.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)directionPressed:(id)sender
{
    NSString *pressedString;
    if (sender == self.upButton)
    {
        NSLog(@"up pressed");
        pressedString = @"UP";
    }
    else if (sender == self.downButton)
    {
        NSLog(@"down pressed");
        pressedString = @"DOWN";
    }
    else if (sender == self.leftButton)
    {
        NSLog(@"left pressed");
        pressedString = @"LEFT";
    }
    else if (sender == self.rightButton)
    {
        NSLog(@"right pressed");
        pressedString = @"RIGHT";
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *messageData = [MessageFactory createGamepadMessage:pressedString];

    [appDelegate publishData:messageData event:IOTGamepadEvent];
}

- (IBAction)letterPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *pressedString;
    if ([button.titleLabel.text isEqualToString:@"A"])
    {
        NSLog(@"A pressed");
        pressedString = @"A";
    }
    else if ([button.titleLabel.text isEqualToString:@"B"])
    {
        NSLog(@"B pressed");
        pressedString = @"B";
    }
    else if ([button.titleLabel.text isEqualToString:@"X"])
    {
        NSLog(@"X pressed");
        pressedString = @"X";
    }
    else if ([button.titleLabel.text isEqualToString:@"Y"])
    {
        NSLog(@"Y pressed");
        pressedString = @"Y";
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *messageData = [MessageFactory createGamepadMessage:pressedString];

    [appDelegate publishData:messageData event:IOTGamepadEvent];
}

- (IBAction)rightViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToLoginView];
}

- (IBAction)leftViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToLogView];
}

@end
