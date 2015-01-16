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
//  TopicFactory.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "TopicFactory.h"
#import "Constants.h"

/** Use this if it turns out I have a decent number of topics to publish to
 * or subscribe from
 */

@implementation TopicFactory

/** Retrieve the event topic string for a specific event type.
 *  @param event The event type to get the topic string for
 *  @return topicString The event topic string for event
 */
+ (NSString *)getEventTopic:(NSString *)event
{
    NSString *topicString = [NSString stringWithFormat:IOTEventTopic, event, @"json"];
    return topicString;
}

/** Retrieve the command topic string for a specific command type.
 *  @param command The command type to get the topic string for
 *  @return topicString The command topic string for command
 */
+ (NSString *)getCommandTopic:(NSString *)command
{
    NSString *topicString = [NSString stringWithFormat:IOTCommandTopic, command, @"json"];
    return topicString;
}

/** Retrieve the event topic string for a specific event type. Use m2m demo format instead
 *  of IoT format.
 *  @param event The event type to get the topic string for
 *  @return topicString The event topic string for event
 */
+ (NSString *)getM2MEventTopic:(NSString *)event
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *topicString = [NSString stringWithFormat:IOTM2MEventTopic, appDelegate.deviceID, event];
    return topicString;
}

@end
