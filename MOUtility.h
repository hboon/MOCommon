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

// Courtesy of https://github.com/facebook/three20
#define MO_RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define MO_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// Courtesy of http://vgable.com/blog/2010/08/19/the-most-useful-objective-c-code-ive-ever-written/
#define LOG_EXPR(_X_) do{\
	__typeof__(_X_) _Y_ = (_X_);\
	const char * _TYPE_CODE_ = @encode(__typeof__(_X_));\
	NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_);\
	if(_STR_)\
		NSLog(@"%s = %@", #_X_, _STR_);\
	else\
		NSLog(@"Unknown _TYPE_CODE_: %s for expression %s in function %s, file %s, line %d", _TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);\
}while(0)

// Courtesy of, and derived from http://news.ycombinator.com/item?id=1789839
#define A(obj, objs...) [NSArray arrayWithObjects:obj, ## objs , nil]
#define D(val, key, vals...) [NSDictionary dictionaryWithObjectsAndKeys:val, key, ## vals , nil]
#define MA(obj, objs...) [NSMutableArray arrayWithObjects:obj, ## objs , nil]
#define MD(val, key, vals...) [NSMutableDictionary dictionaryWithObjectsAndKeys:val, key, ## vals , nil]

#define NB(n) [NSNumber numberWithBool:n]

id<UIApplicationDelegate> moApplicationDelegate();
void moAlertWithDelegate(NSString* title, NSString* message, id<UIAlertViewDelegate> aDelegate);
void moAlert(NSString* title, NSString* message);
UIWindow* moWindow();
NSString* moOrientationAsString(UIInterfaceOrientation orientation);
BOOL moSupportsMultitasking();
BOOL moSupportsBackgroundCompletionTaskAPI();
UIImage* singlePixelImageWithColor(UIColor* aColor);
CGFloat degreeToRadian(CGFloat aFloat);
CGFloat radianToDegree(CGFloat aFloat);
BOOL isSimulator();
