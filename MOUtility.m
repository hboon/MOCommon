//
//  MOUtility.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Mar/08/2009.
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

#import "MOUtility.h"

CGFloat moDegreeToRadian(CGFloat aFloat) {
	return aFloat * M_PI / 180;
}


CGFloat moRadianToDegree(CGFloat aFloat) {
	return aFloat * 180 / M_PI;
}


int moRoundUp(double f) {
	return round(f+0.49999);
}

NSString* moEmptyStringIfNull(NSString* str) {
	if ((NSNull*)str == [NSNull null]) return @"";

	return str;
}

#pragma mark Localization

// Useful for figuring out canonical language identifiers when doing localizations
void moLogLanguagesAndIdentifiers(void) {
	for (NSString* each in [NSLocale preferredLanguages]) {
		NSLog(@"%@ = %@", [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:each], each);
	}
}

#pragma mark -

id<UIApplicationDelegate> moApplicationDelegate(void) {
	return [UIApplication sharedApplication].delegate;
}


void moAlertWithDelegate(NSString* title, NSString* message, id<UIAlertViewDelegate> aDelegate) {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:aDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


void moAlert(NSString* title, NSString* message) {
	moAlertWithDelegate(title, message, nil);
}


// May be nil
UIWindow* moWindow(void) {
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	// Possible to get nil back for window, not sure why, we retry once. If still nil, we give up
	if (!window) window = [UIApplication sharedApplication].keyWindow;

	return window;
}


CGRect moScreenBounds(UIInterfaceOrientation orientation) {
	CGRect bounds = [UIScreen mainScreen].bounds;

	if (!UIDeviceOrientationIsPortrait(orientation)) {
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}

	return bounds;
}


NSString* moOrientationAsString(UIInterfaceOrientation orientation) {
	NSArray* values = [NSArray arrayWithObjects:@"unknown",@"portrait",@"portrait upside down",@"landscape left",@"landscape right",@"face up",@"face down",nil];
	return [values objectAtIndex:orientation];
}


BOOL moSupportsMultitasking(void) {
	return [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported];
}


BOOL moSupportsBackgroundCompletionTaskAPI(void) {
	return [[UIApplication sharedApplication] respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)] && moSupportsMultitasking();
}


UIImage* moSinglePixelImageWithColor(UIColor* aColor) {
	UIGraphicsBeginImageContext(CGSizeMake(1, 1));
	CGContextRef context = UIGraphicsGetCurrentContext();

	[aColor set];
	CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}


UIImage* moSolidColorImageWithSize(UIColor* aColor, CGSize aSize) {
	UIGraphicsBeginImageContext(aSize);
	CGContextRef context = UIGraphicsGetCurrentContext();

	[aColor set];
	CGContextFillRect(context, CGRectMake(0, 0, aSize.width, aSize.height));
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return result;
}


BOOL moIsSimulator(void) {
	if ([[[UIDevice currentDevice] name] rangeOfString:@"Simulator"].location != NSNotFound) return YES;
	if ([[[UIDevice currentDevice] name] rangeOfString:@"Unknown"].location != NSNotFound) return YES;

	return NO;
}

#if TARGET_OS_IPHONE
#endif
