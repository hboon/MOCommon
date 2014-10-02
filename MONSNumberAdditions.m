//
//  MONSNumberAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Mar/4/2011.
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

#import "MONSNumberAdditions.h"

@implementation NSNumber (MONSNumberAdditions)

- (void)moEnumerateInColumns:(int)aColumnCount usingBlock:(MONSNumberRowsAndColumnsIterationBlock)aBlock {
	int row = 0;
	int col = 0;
	int count = [self intValue];
	for (int i=0; i<count; ++i) {
		aBlock(row, col, i);
		if (col >= aColumnCount-1) {
			col = 0;
			++row;
		} else {
			++col;
		}
	}
}


- (NSString*)moCommaSeparatorString {
	NSString* str = [self stringValue];
	for (int i=(int)[str length]-3; i>0; i-=3) {
		str = [NSString stringWithFormat:@"%@,%@", [str substringWithRange:NSMakeRange(0, i)], [str substringFromIndex:i]];
	}
	return str;
}


- (void)moDo:(MONSNumberIterationBlock)aBlock {
	int count = [self intValue];
	for (int i=0; i<count; ++i) {
		aBlock(i);
	}
}

@end
