//
//  MOLocator.m
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

#import "MOLocator.h"

#import "MOUtility.h"

#define MOLOCATOR_TIMER_DURATION 15.0f

@interface MOLocator()

@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) NSDate* lastUpdated;

- (void)didGetLocation:(CLLocationCoordinate2D)aCoordinate;
- (void)locatingFailedBecauseUserDisabledForApp:(BOOL)yesOrNo;

@end


@implementation MOLocator

@synthesize locating;
@synthesize latitude;
@synthesize longitude;
@synthesize purpose;

@synthesize timer;
@synthesize locationManager;
@synthesize lastUpdated;


+ (MOLocator*)sharedLocator {
	MO_DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] init];
	});
}


- (void)startLocating {
	if (self.locating) return;
	if ([self.timer isValid]) return;

	if (!self.locationManager) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		self.locationManager.delegate = self;
	}

	self.locating = YES;
	[self.locationManager startUpdatingLocation];

	self.timer = [NSTimer scheduledTimerWithTimeInterval:MOLOCATOR_TIMER_DURATION target:self selector:@selector(locatingTimeoutTimerFired:) userInfo:nil repeats:NO];
	MO_LogDebug(@" start locating with timer set to %fsec", MOLOCATOR_TIMER_DURATION);
}


- (void)didGetLocation:(CLLocationCoordinate2D)aCoordinate {
	self.lastUpdated = [NSDate date];
	self.latitude = [NSString stringWithFormat:@"%f", aCoordinate.latitude];
	self.longitude = [NSString stringWithFormat:@"%f", aCoordinate.longitude];

	[self.locationManager stopUpdatingLocation];
	self.locating = NO;

	[[NSNotificationCenter defaultCenter] postNotificationName:MOLOCATOR_DID_GET_LOCATION_SUCCESSFULLY object:self];
}

#pragma mark Accessor

- (void)setPurpose:(NSString*)aString {
	self.locationManager.purpose = aString;
}


- (NSString*)purpose {
	return self.locationManager.purpose;
}


- (BOOL)wasUpdatedWithinInterval:(NSTimeInterval)aNumber {
	return [[self.lastUpdated dateByAddingTimeInterval:aNumber] compare:[NSDate date]] == NSOrderedDescending;
}


- (BOOL)wasUpdatedWithinLastTenMinute {
	return [self wasUpdatedWithinInterval:36000];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
	// According to docs should just ignore and keep waiting
	if ([error code] == kCLErrorLocationUnknown) return;

	[self.timer invalidate];
	[self.locationManager stopUpdatingLocation];
	self.locating = NO;
	MO_LogDebug(@" didFailWithError: %@", error);
	
	MO_LogDebug(@" kCLErrorDenied: %d code: %d", kCLErrorDenied, [error code]);
	if ([error code] == kCLErrorDenied) {
		[self locatingFailedBecauseUserDisabledForApp:YES];
		return;
	}

	if ([error code] == kCLErrorNetwork) {
		[self locatingFailedBecauseUserDisabledForApp:NO];
		return;
	}	
	
	if ([error code] == kCLErrorHeadingFailure) {
		[self locatingFailedBecauseUserDisabledForApp:NO];
		return;
	}
	
	[self locatingFailedBecauseUserDisabledForApp:NO];
}


- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
	MO_LogDebug(@"Loc rx. Age: %fs h: %f v: %f l/l: %f %f time left: %f\n", [self.locationManager.location.timestamp timeIntervalSinceNow], self.locationManager.location.horizontalAccuracy, self.locationManager.location.verticalAccuracy, newLocation.coordinate.latitude, newLocation.coordinate.longitude, [[self.timer fireDate] timeIntervalSinceDate:[NSDate date]]);
	NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
	
	if (fabs(howRecent) > 5.0f) {
		MO_LogDebug(@"Old location. Age: %fs", [self.locationManager.location.timestamp timeIntervalSinceNow]);
		[self.locationManager stopUpdatingLocation];
		[self.locationManager startUpdatingLocation];
		return;
	}

	if (newLocation.horizontalAccuracy > 0 && newLocation.horizontalAccuracy <= 20) {
		[timer invalidate];
		[self didGetLocation:newLocation.coordinate];
	} else {
		MO_LogDebug(@"not accurate enough, continue waiting");
	}
}

#pragma mark Location services

- (void)locatingFailedBecauseUserDisabledForApp:(BOOL)yesOrNo {
	if (![CLLocationManager locationServicesEnabled]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MOLOCATOR_DID_GET_LOCATION_FAILED object:self userInfo:@{MOLOCATOR_FAIL_REASON: MOLOCATOR_FAIL_REASON_LOCATION_SERVICES_DISABLED}];
		return;
	}

	if (yesOrNo) {
		[[NSNotificationCenter defaultCenter] postNotificationName:MOLOCATOR_DID_GET_LOCATION_FAILED object:self userInfo:@{MOLOCATOR_FAIL_REASON: MOLOCATOR_FAIL_REASON_LOCATION_SERVICES_DISABLED_FOR_APP}];
		return;
	}

	self.latitude = nil;
	self.longitude = nil;

	[[NSNotificationCenter defaultCenter] postNotificationName:MOLOCATOR_DID_GET_LOCATION_FAILED object:self userInfo:@{MOLOCATOR_FAIL_REASON: MOLOCATOR_FAIL_REASON_CANNOT_DETERMINE_LOCATION}];
}


- (void)locatingTimeoutTimerFired:(NSTimer*)theTimer {
	MO_LogDebug(@"Locator timeout timer fired. Age: %fs h: %f v: %f l/l: %f %f\n", [self.locationManager.location.timestamp timeIntervalSinceNow], self.locationManager.location.horizontalAccuracy, self.locationManager.location.verticalAccuracy, self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
	[self.timer invalidate];
	[self.locationManager stopUpdatingLocation];
	self.locating = NO;
	
	if (self.locationManager.location.horizontalAccuracy > 0) {
		NSTimeInterval howRecent = [self.locationManager.location.timestamp timeIntervalSinceNow];
		
		if (fabs(howRecent) < MOLOCATOR_TIMER_DURATION) {
			[self didGetLocation:self.locationManager.location.coordinate];
			return;
		}
	}
	
	[self locatingFailedBecauseUserDisabledForApp:NO];
}

@end
