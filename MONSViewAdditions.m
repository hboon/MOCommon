//
//  MONSViewAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Jan/21/2011.
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

#import "MONSViewAdditions.h"

@implementation NSView (MONSViewAdditions)

- (CGFloat)moLeft {
	return self.frame.origin.x;
}

- (void)setMoLeft:(CGFloat)x {
	NSRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)moTop {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setMoTop:(CGFloat)y {
	NSRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)moRight {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setMoRight:(CGFloat)right {
	NSRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)moBottom {
	return self.frame.origin.y;
}

- (void)setMoBottom:(CGFloat)bottom {
	NSRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)moCenterX {
	return self.moLeft + self.frame.size.width/2;
}

- (void)setMoCenterX:(CGFloat)centerX {
	NSRect frame = self.frame;
	frame.origin.x = centerX - frame.size.width/2;
	self.frame = frame;
	
}

- (CGFloat)moCenterY {
	return self.moBottom + self.frame.size.height/2;
}

- (void)setMoCenterY:(CGFloat)centerY {
	NSRect frame = self.frame;
	frame.origin.y = centerY - frame.size.height/2;
	self.frame = frame;
}

- (CGFloat)moWidth {
	return self.frame.size.width;
}

- (void)setMoWidth:(CGFloat)width {
	NSRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)moHeight {
	return self.frame.size.height;
}

- (void)setMoHeight:(CGFloat)height {
	NSRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

@end
