//
//  MOToggleValue.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on May/24/2011.
//
/*
 Copyright 2011 Yar Hwee Boon. All rights reserved.
 
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
#import "MOToggleValue.h"

@implementation MOToggleValue

@synthesize value1;
@synthesize value2;
@synthesize currentValue;

+ (id)value:(id)val1 value:(id)val2 {
	MOToggleValue* toggle = [[MOToggleValue alloc] init];
	toggle.value1 = val1;
	toggle.value2 = val2;

	return [toggle autorelease];
}


- (void)dealloc {
	self.value1 = nil;
	self.value2 = nil;
	self.currentValue = nil;

	[super dealloc];
}


- (id)toggle {
	if (!self.currentValue) {
		self.currentValue = self.value1;
	} else if (self.currentValue == self.value1) {
		self.currentValue = self.value2;
	} else {
		self.currentValue = self.value1;
	}

	return self.currentValue;
}


- (id)otherValue {
	return self.currentValue != self.value1? self.value1: self.value2;
}

@end