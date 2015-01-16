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
//  Messenger.h
//  IoTstarter
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "MqttOCClient.h"
#import "TopicFactory.h"
#import "MessageFactory.h"
#import "Callbacks.h"
#import "Trace.h"

#define PAHO_TRACE 0

@interface Messenger : NSObject

@property (strong, nonatomic) MqttClient *client;
@property (strong, nonatomic) id<MqttTraceHandler> tracer;

+ (id)sharedMessenger;

- (void)connectWithHost:(NSString *)host
                   port:(int)port
               clientId:(NSString *)clientId;

- (void)publish:(NSString *)topic
        payload:(NSString *)payload
            qos:(int)qos
       retained:(BOOL)retained;

- (void)subscribe:(NSString *)topicFilter
              qos:(int)qos;

- (void)unsubscribe:(NSString *)topicFilter;

- (void)disconnect;

@end
