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
//  IoTProfile.h
//  IoTstarter
//

#import <Foundation/Foundation.h>

@interface IoTProfile : NSObject

@property (nonatomic, strong) NSString *profileName;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *authorizationToken;

- (id)initWithName:(NSString *)name dictionary:(NSMutableDictionary *)dictionary;

- (id)initWithName:(NSString *)name
      organization:(NSString *)organization
          deviceID:(NSString *)deviceID
authorizationToken:(NSString *)authorizationToken;

- (NSMutableDictionary *)createDictionaryFromProfile;

@end