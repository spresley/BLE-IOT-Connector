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
//  MessageFactory.h
//  IoTstarter
//

#import <Foundation/Foundation.h>

@interface MessageFactory : NSObject

+ (NSString *)createAccelMessage:(double)accel_x
                         accel_y:(double)accel_y
                         accel_z:(double)accel_z
                            roll:(double)roll
                           pitch:(double)pitch
                             yaw:(double)yaw
                             lat:(double)lat
                             lon:(double)lon;

+ (NSString *)createTouchmoveMessage:(double)screen_x
                            screen_y:(double)screen_y
                             delta_x:(double)delta_x
                             delta_y:(double)delta_y
                               ended:(int)ended;

+ (NSString *)createTextMessage:(NSString *)text;

+ (NSString *)createGamepadMessage:(NSString *)button;

+ (NSString *)createGamepadMessage:(NSString *)button
                            dpad_x:(double)dpad_x
                            dpad_y:(double)dpad_y;

@end
