//
//  MOUIColorAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Sep/18/2013.
//
/*
 Copyright 2013 Yar Hwee Boon. All rights reserved.
 
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

#import "MOUIColorAdditions.h"

@implementation UIColor (MOUIColorAdditions)

- (BOOL)moisGrayscaleColorSpace {
	return CGColorGetNumberOfComponents(self.CGColor) == 2;
}


- (NSArray*)moComponents {
    if ([self moisGrayscaleColorSpace]) {
      CGFloat white;
      CGFloat alpha;
	  [self getWhite:&white alpha:&alpha];
      return @[@(white), @(alpha)];
	} else {
      CGFloat red;
	  CGFloat green;
	  CGFloat blue;
	  CGFloat alpha;
	  [self getRed:&red green:&green blue:&blue alpha:&alpha];
	  return @[@(red), @(green), @(blue), @(alpha)];
	}
}


- (CGFloat)moRed {
	return [[self moComponents][0] floatValue] * 255;
}


- (CGFloat)moGreen {
	return [[self moComponents][1] floatValue] * 255;
}


- (CGFloat)moBlue {
	return [[self moComponents][2] floatValue] * 255;
}


- (CGFloat)moAlpha {
	if ([self moisGrayscaleColorSpace]) {
		return [[self moComponents][0] floatValue];
	} else {
		return [[self moComponents][3] floatValue];
	}
}


- (CGFloat)moWhite {
	return [[self moComponents][0] floatValue];
}

@end
