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
//  IoTProfile.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "Constants.h"
#import "IoTProfile.h"

/**
 */

@implementation IoTProfile

- (id)initWithName:(NSString *)name dictionary:(NSMutableDictionary *)dictionary
{
    if (self = [super init])
    {
        self.profileName = name;
        self.organization = [dictionary objectForKey:IOTOrganization];
        self.deviceID = [dictionary objectForKey:IOTDeviceID];
        self.authorizationToken = [dictionary objectForKey:IOTAuthToken];
    }
    return self;
}

- (id)initWithName:(NSString *)name
      organization:(NSString *)organization
          deviceID:(NSString *)deviceID
authorizationToken:(NSString *)authorizationToken
{
    if (self = [super init])
    {
        self.profileName = name;
        self.organization = organization;
        self.deviceID = deviceID;
        self.authorizationToken = authorizationToken;
    }
    return self;
}

- (NSMutableDictionary *)createDictionaryFromProfile
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:self.organization forKey:IOTOrganization];
    [dictionary setObject:self.deviceID forKey:IOTDeviceID];
    [dictionary setObject:self.authorizationToken forKey:IOTAuthToken];
    
    return dictionary;
}

@end