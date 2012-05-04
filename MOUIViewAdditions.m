//
//  MOUIViewAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Nov/24/2010.
//
/*
 Copyright 2010 Yar Hwee Boon. All rights reserved.
 
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

#import "MOUIViewAdditions.h"

@implementation UIView (MOUIViewAdditions)

// Courtesy of https://github.com/facebook/three20

- (CGFloat)moLeft {
	return self.frame.origin.x;
}

- (void)setMoLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)moTop {
	return self.frame.origin.y;
}

- (void)setMoTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)moRight {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setMoRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)moBottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setMoBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)moCenterX {
	return self.center.x;
}

- (void)setMoCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)moCenterY {
	return self.center.y;
}

- (void)setMoCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)moWidth {
	return self.frame.size.width;
}

- (void)setMoWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)moHeight {
	return self.frame.size.height;
}

- (void)setMoHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}


- (void)moSizeWidthToFit {
	CGFloat height = self.moHeight;
	[self sizeToFit];
	self.moHeight = height;
}


- (void)moSizeHeightToFit {
	CGFloat width = self.moWidth;
	//Otherwise it doesn't expand short UILabel when it's too short to fit longer text
	self.moHeight = 1000;
	[self sizeToFit];
	self.moWidth = width;
}


- (void)moSizeWidthToFitAlignRight {
	CGFloat x = self.moRight;
	[self moSizeWidthToFit];
	self.moRight = x;
}


- (void)moAlignSubviewsCenterVertical:(UIView*)aView, ... {
	id v;
	va_list argumentList;
	if (aView) {
		NSMutableArray* list = [NSMutableArray arrayWithObject:aView];
		va_start(argumentList, aView);
		while ((v = va_arg(argumentList, UIView*))) {
			[list addObject:v];
		}
		va_end(argumentList);

		for (UIView* each in list) {
			each.moTop = (self.moHeight-each.moHeight)/2;
		}
	}
}


- (void)moAlignSubviewsCenterHorizontal:(UIView*)aView, ... {
	id v;
	va_list argumentList;
	if (aView) {
		NSMutableArray* list = [NSMutableArray arrayWithObject:aView];
		va_start(argumentList, aView);
		while ((v = va_arg(argumentList, UIView*))) {
			[list addObject:v];
		}
		va_end(argumentList);

		for (UIView* each in list) {
			each.moLeft = (self.moWidth-each.moWidth)/2;
		}
	}
}


- (void)moAddSubviews:(UIView*)aView, ... {
	id v;
	va_list argumentList;
	if (aView) {
		[self addSubview:aView];
		va_start(argumentList, aView);
		while ((v = va_arg(argumentList, UIView*))) {
			[self addSubview:v];
		}
		va_end(argumentList);
	}
}


- (CGPoint)moOriginRelativeToSuperview:(UIView*)aView {
	UIView* sup = self.superview;
	if (!sup || aView == sup) return self.frame.origin;

	CGPoint d = [sup moOriginRelativeToSuperview:aView];
	return CGPointMake(self.moLeft+d.x, self.moTop+d.y);
}

@end
