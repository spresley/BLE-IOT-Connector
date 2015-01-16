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
//  Callbacks.h
//  IoTstarter
//

#import <Foundation/Foundation.h>
#import "Messenger.h"

@interface InvocationCallbacks : NSObject <InvocationComplete>

- (void)onSuccess:(NSObject *)invocationContext;
- (void)onFailure:(NSObject *)invocationContext
        errorCode:(int)errorCode
     errorMessage:(NSString *)errorMessage;

@end

@interface GeneralCallbacks : NSObject <MqttCallbacks>

- (void)onConnectionLost:(NSObject *)invocationContext
            errorMessage:(NSString *)errorMessage;
- (void)onMessageArrived:(NSObject *)invocationContext
                 message:(MqttMessage *)message;
- (void)onMessageDelivered:(NSObject *)invocationContext
                 messageId:(int)msgId;

@end