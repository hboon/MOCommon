//
//  MOUtility.h
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

#import <Foundation/Foundation.h>

#import "VTPG_Common.h"

/* For both Mac OS and iOS */

// Logging
#ifdef DEBUG
	#define MO_LogDebug(fmt, ...) NSLog((@"DEBUG " fmt), ##__VA_ARGS__)
#else
	#define MO_LogDebug(...)
#endif

#define MO_LogWarn(fmt, ...) NSLog((@"WARN [%@:%d]%s " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define MO_LogSevere(fmt, ...) NSLog((@"SEVERE [%@:%d]%s " fmt), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)


#if TARGET_OS_IPHONE
// Courtesy of https://github.com/facebook/three20
	#define MO_RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
	#define MO_RGBCOLOR1(c) [UIColor colorWithRed:c/255.0 green:c/255.0 blue:c/255.0 alpha:1]
	#define MO_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#else
	#define MO_RGBCOLOR(r,g,b) [NSColor colorWithDeviceRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
	#define MO_RGBACOLOR(r,g,b,a) [NSColor colorWithDeviceRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

CGFloat moDegreeToRadian(CGFloat aFloat);
CGFloat moRadianToDegree(CGFloat aFloat);
int moRoundUp(double f);
NSString* moEmptyStringIfNull(NSString* str);
void moLogLanguagesAndIdentifiers(void);

// http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
static inline BOOL moIsEmpty(id thing) {
	return thing == nil ||
			([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
			([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

// Courtesy of, and derived from http://news.ycombinator.com/item?id=1789839
#define A(obj, objs...) [NSArray arrayWithObjects:obj, ## objs , nil]
#define D(val, key, vals...) [NSDictionary dictionaryWithObjectsAndKeys:val, key, ## vals , nil]
#define MA(obj, objs...) [NSMutableArray arrayWithObjects:obj, ## objs , nil]
#define MD(val, key, vals...) [NSMutableDictionary dictionaryWithObjectsAndKeys:val, key, ## vals , nil]

#define NB(n) [NSNumber numberWithBool:n]
#define NN(n) [NSNumber numberWithInt:n]
#define ND(n) [NSNumber numberWithDouble:n]
#define MO_LONG_TO_NUM(n) [NSString stringWithFormat:@"%ld", n]

#define MO_CLAMP_MIN_MAX(var, min, max)	var<min? min: (var>max? max: var)

id<UIApplicationDelegate> moApplicationDelegate(void);
void moAlertWithDelegate(NSString* title, NSString* message, id<UIAlertViewDelegate> aDelegate);
void moAlert(NSString* title, NSString* message);
UIWindow* moWindow(void);
CGRect moScreenBounds(UIInterfaceOrientation orientation);
NSString* moOrientationAsString(UIInterfaceOrientation orientation);
BOOL moSupportsMultitasking(void);
BOOL moSupportsBackgroundCompletionTaskAPI(void);
UIImage* moSinglePixelImageWithColor(UIColor* aColor);
UIImage* moSolidColorImageWithSize(UIColor* aColor, CGSize aSize);
BOOL moIsSimulator(void);

#define MO_STATUS_BAR_HEIGHT 20
#define MO_KEYBOARD_HEIGHT_PORTRAIT 216
#define MO_KEYBOARD_HEIGHT_LANDSCAPE 160
#define MO_NAVIGATION_BAR_HEIGHT_PORTRAIT 44
#define MO_NAVIGATION_BAR_HEIGHT_LANDSCAPE 33

#ifdef ADHOC
	#define MO_TF_INIT(appId) [TestFlight takeOff:appId]
	#define MO_TF(fmt, ...) [TestFlight passCheckpoint:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#else
	#define MO_TF_INIT(appId)
	#define MO_TF(...)
#endif

/* iOS-specific */

#if TARGET_OS_IPHONE

#endif


/* Mac OS-specific */

#if TARGET_OS_MAC
#endif

