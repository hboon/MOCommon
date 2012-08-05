//
//  MOLocator.h
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Jun/20/2009.
//
/*
 Copyright 2009 Yar Hwee Boon. All rights reserved.
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of MotionObj nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#define MOLOCATOR_DID_GET_LOCATION_SUCCESSFULLY @"MOLOCATOR_DID_GET_LOCATION_SUCCESSFULLY"
#define MOLOCATOR_DID_GET_LOCATION_FAILED @"MOLOCATOR_DID_GET_LOCATION_FAILED"

#define MOLOCATOR_FAIL_REASON @"MOLOCATOR_FAIL_REASON"
#define MOLOCATOR_FAIL_REASON_LOCATION_SERVICES_DISABLED @"MOLOCATOR_FAIL_REASON_LOCATION_SERVICES_DISABLED"
#define MOLOCATOR_FAIL_REASON_LOCATION_SERVICES_DISABLED_FOR_APP @"MOLOCATOR_FAIL_REASON_LOCATION_SERVICES_DISABLED_FOR_APP"
#define MOLOCATOR_FAIL_REASON_CANNOT_DETERMINE_LOCATION @"MOLOCATOR_FAIL_REASON_CANNOT_DETERMINE_LOCATION"

@interface MOLocator : NSObject<CLLocationManagerDelegate>

@property (nonatomic) BOOL locating;
@property (nonatomic,retain) NSString* latitude;
@property (nonatomic,retain) NSString* longitude;
@property (nonatomic,retain) NSString* purpose;

+ (MOLocator*)sharedLocator;

- (void)startLocating;
- (BOOL)wasUpdatedWithinLastTenMinute;

@end
