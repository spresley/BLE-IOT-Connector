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
//  MessageFactory.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "MessageFactory.h"
#import "Constants.h"

/**
 */

@implementation MessageFactory

/** 
 *  @param
 *  @return messageString
 */
+ (NSString *)createAccelMessage:(double)accel_x
                         accel_y:(double)accel_y
                         accel_z:(double)accel_z
                            roll:(double)roll
                           pitch:(double)pitch
                             yaw:(double)yaw
                             lat:(double)lat
                             lon:(double)lon
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_ACCEL_X: @(accel_x),
                                                JSON_ACCEL_Y: @(accel_y),
                                                JSON_ACCEL_Z: @(accel_z),
                                                JSON_ROLL: @(roll),
                                                JSON_PITCH: @(pitch),
                                                JSON_YAW: @(yaw),
                                                JSON_LAT: @(lat),
                                                JSON_LON: @(lon)
                                                }
    };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createTouchmoveMessage:(double)screen_x
                            screen_y:(double)screen_y
                             delta_x:(double)delta_x
                             delta_y:(double)delta_y
                               ended:(int)ended
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_SCREEN_X: @(screen_x),
                                                JSON_SCREEN_Y: @(screen_y),
                                                JSON_DELTA_X: @(delta_x),
                                                JSON_DELTA_Y: @(delta_y),
                                                JSON_ENDED: @(ended)
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createTextMessage:(NSString *)text
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_TEXT: text
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createGamepadMessage:(NSString *)button
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_BUTTON: button
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createGamepadMessage:(NSString *)button
                            dpad_x:(double)dpad_x
                            dpad_y:(double)dpad_y
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_BUTTON: button,
                                                JSON_DPAD_X: @(dpad_x),
                                                JSON_DPAD_Y: @(dpad_y)
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

@end