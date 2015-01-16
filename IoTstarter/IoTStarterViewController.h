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
//  ViewController.h
//  IoTstarter
//

#ifndef IoTStarterViewController_h
#define IoTStarterViewController_h

@interface IoTStarterViewController : UIViewController <NSURLConnectionDelegate, UIGestureRecognizerDelegate>

- (void)updateViewLabels;
- (void)updateMessageCounts;
- (void)updateAccelLabels;
- (void)updateBackgroundColor:(UIColor *)color;

@end

#endif