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

#import "MONSDataAdditions.h"

NSDictionary* moVDictionary(NSString* s);

CGFloat moDegreeToRadian(CGFloat aFloat) {
	return aFloat * M_PI / 180;
}


CGFloat moRadianToDegree(CGFloat aFloat) {
	return aFloat * 180 / M_PI;
}


int moRoundUp(double f) {
	return round(f+0.49999);
}

BOOL moIsEmpty(id thing) {
	return thing == nil ||
	thing == [NSNull null] ||
	([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
	([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

BOOL moNotEmpty(id thing) {
	return !moIsEmpty(thing);
}

NSString* moEmptyStringIfNull(NSString* str) {
	if (!str) return @"";
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


NSString* moAppVersion(void) {
	NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	if (moNotEmpty(version)) return version;
	NSString* buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	return buildVersion;
}


void moAlertWithDelegate(NSString* title, NSString* message, id<UIAlertViewDelegate> aDelegate) {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:aDelegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
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

	if (!UIInterfaceOrientationIsPortrait(orientation)) {
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}

	return bounds;
}


NSString* moOrientationAsString(UIInterfaceOrientation orientation) {
	NSArray* values = @[@"unknown",@"portrait",@"portrait upside down",@"landscape left",@"landscape right",@"face up",@"face down"];
	return values[orientation];
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


BOOL moIsIphone5(void) {
	return [UIScreen mainScreen].bounds.size.height > 480;
}


void moTime1(void(^block)(void), NSString* s) {
	NSDate* start = [NSDate date];
	block();
	MO_LogDebug(@"%@ %f", s, [[NSDate date] timeIntervalSinceDate:start]);
}


CGFloat moTime2(void(^block)(void)) {
	NSDate* start = [NSDate date];
	block();
	return [[NSDate date] timeIntervalSinceDate:start];
}


CGRect moRectLessHeight(CGRect rect, CGFloat h) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-h);
}


CGRect moRectLessWidth(CGRect rect, CGFloat w) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width-w, rect.size.height);
}


// Assumes r1 contains r2 and share either the same width or same height, and must have 3 common edges
CGRect moCGRectMinusRect(CGRect r1, CGRect r2) {
	if (r1.size.width == r2.size.width) {
		if (r1.origin.y == r2.origin.y) {
			return CGRectMake(r2.origin.x, r2.origin.y+r2.size.height, r2.size.width, r1.size.height-r2.size.height);
		} else {
			return CGRectMake(r1.origin.x, r1.origin.y, r1.size.width, r1.size.height-r2.size.height);
		}
	} else {
		//Assume height same
		if (r1.origin.x == r2.origin.x) {
			return CGRectMake(r2.origin.x+r2.size.width, r2.origin.y, r1.size.width-r2.size.width, r2.size.height);
		} else {
			return CGRectMake(r1.origin.x, r1.origin.y, r1.size.width-r2.size.width, r1.size.height);
		}
	}
}


NSDictionary* moVDictionary(NSString* s) {
	NSString* debugValuesFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"moDebugValues.plist"];
	NSDictionary* applicationSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:debugValuesFilePath];
	return applicationSettingsDictionary;
}


CGFloat moVF(NSString* s) {
	return [[moVDictionary(s) valueForKeyPath:s] doubleValue];
}


int moVN(NSString* s) {
	return [[moVDictionary(s) valueForKeyPath:s] intValue];
}


BOOL moAnyEmpty(id obj, ...) {
	id v;
	va_list argumentList;
	if (obj) {
		NSMutableArray* list = [NSMutableArray arrayWithObject:obj];
		va_start(argumentList, obj);
		while ((v = va_arg(argumentList, id))) {
			[list addObject:v];
		}
		va_end(argumentList);

		for (id each in list) {
			if (moIsEmpty(each)) return YES;
		}
	}

	return NO;
}


NSString* moPathOfFileInDocumentDirectoryWithFileName(NSString* aString) {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:aString];
}


NSDictionary* moDictionaryOrEmpty(NSDictionary* dict) {
	if (!dict) return @{};

	return dict;
}


NSMutableDictionary* moMutableDictionaryOrEmpty(NSMutableDictionary* dict) {
	if (!dict) return [NSMutableDictionary dictionary];

	return dict;
}


NSArray* moArrayOrEmpty(NSArray* array) {
	if (!array) return @[];

	return array;
}


NSMutableArray* moMutableArrayOrEmpty(NSMutableArray* array) {
	if (!array) return [NSMutableArray array];

	return array;
}


NSString* moStringOrEmpty(NSString* str) {
	if (!str) return @"";
	if ((NSNull*)str == [NSNull null]) return @"";

	return str;
}


NSString* moStringOrDefault(NSString* str, NSString* def) {
	if (!moIsEmpty(str)) {
		return str;
	} else {
		return def;
	}
}


id moObjOrDefault(id obj, id def) {
	if (!moIsEmpty(obj)) {
		return obj;
	} else {
		return def;
	}
}


CGSize moFitSize(CGSize s1, CGSize s2) {
	CGSize s;
	if (s1.width/s1.height < s2.width/s2.height) {
		CGFloat ratio = s1.width/s1.height;
		s.height = s2.height;
		s.width = s.height*ratio;
	} else {
		CGFloat ratio = s1.height/s1.width;
		s.width = s2.width;
		s.height = s.width*ratio;
	}

	return s;
}


CGSize moFillSize(CGSize s1, CGSize s2) {
	CGSize s;
	if (s1.width/s1.height < s2.width/s2.height) {
		CGFloat ratio = s1.height/s1.width;
		s.width = s2.width;
		s.height = s.width*ratio;
	} else {
		CGFloat ratio = s1.width/s1.height;
		s.height = s2.height;
		s.width = s.height*ratio;
	}

	return s;
}


@implementation MOTouchToTriggerView

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (self.action) {
		self.action();
	}
}

@end

void moShowImage(UIImage* img) {
	MOTouchToTriggerView* v = [MOTouchToTriggerView new];
	v.frame = moWindow().bounds;
	v.backgroundColor = MO_RGBACOLOR(0, 0, 0, 0.8);
	MOTouchToTriggerView* temp = v;
	v.action = ^{ [temp removeFromSuperview]; };

	UIImageView* iv = [[UIImageView alloc] initWithFrame:v.bounds];
	iv.contentMode = UIViewContentModeScaleAspectFit;
	iv.image = img;
	[v addSubview:iv];

	UILabel* dimensionsLabel = MO_L(0, v.bounds.size.height - 50, v.bounds.size.width, 22);
	dimensionsLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	dimensionsLabel.backgroundColor = MO_RGBACOLOR(30, 30, 30, 0.7);
	dimensionsLabel.textAlignment = NSTextAlignmentCenter;
	dimensionsLabel.textColor = MO_RGBCOLOR1(200);
	dimensionsLabel.font = [UIFont systemFontOfSize:11];
	dimensionsLabel.text = [NSString stringWithFormat:@"%dx%d (scale=%d)", (int)img.size.width, (int)img.size.height, (int)img.scale];
	[v addSubview:dimensionsLabel];

	[moWindow() addSubview:v];
}


//Speak in a campfire room
void moCampfireSpeak(NSString* aString, NSString* aRoomIDString, NSString* aSubdomainString, NSString* aTokenString, BOOL asynchronous) {
	NSString* url = [NSString stringWithFormat:@"https://%@.campfirenow.com/room/%@/speak.json", aSubdomainString, aRoomIDString];
	NSString* postString = [NSString stringWithFormat:@"<message><type>%@</type><body>%@</body></message>", @"TextMessage", aString];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];

	NSString* auth = [NSString stringWithFormat:@"%@:%@", aTokenString, @"X"];
	NSString* authValue = [NSString stringWithFormat:@"Basic %@", [[auth dataUsingEncoding:NSUTF8StringEncoding] base64EncodingWithLineLength:80]];
	[request setValue:authValue forHTTPHeaderField:@"Authorization"];

	[request addValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

	if (asynchronous) {
		[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		}];
	} else {
		NSHTTPURLResponse* response;
		NSError* error;
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	}
}

#if TARGET_OS_IPHONE
#endif
