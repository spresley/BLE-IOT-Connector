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
//  LogTableViewController.m
//  IoTstarter
//

#import "LogTableViewController.h"
#import "AppDelegate.h"

@interface LogTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation LogTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.logTableViewController = self;
    }
    return self;
}

/*************************************************************************
 * View related methods
 *************************************************************************/

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[appDelegate.tabController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
    appDelegate.currentView = LOG;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

/*************************************************************************
 * IBAction methods
 *************************************************************************/
- (IBAction)clearPressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.messageLog removeAllObjects];
    [self.tableView reloadData];
}

- (IBAction)rightViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[appDelegate switchToRemoteView];
    [appDelegate switchToLoginView];
}

- (IBAction)leftViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToIoTView];
}

/*************************************************************************
 * UITableView delegate methods
 *************************************************************************/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // The table will always have only 1 section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.messageLog.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logMessageCell" forIndexPath:indexPath];
    
    // Configure the cell...
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [appDelegate.messageLog objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [[UIColor alloc] initWithRed:78/255.0 green:79/255.0 blue:80/255.0 alpha:1.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *message = cell.textLabel.text;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:OK_STRING, nil];
    [alert show];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.messageLog removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
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
