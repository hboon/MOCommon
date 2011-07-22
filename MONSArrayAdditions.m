//
//  MONSArrayAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Feb/25/2011.
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

#import "MONSArrayAdditions.h"

#import "MONSSetAdditions.h"
#import "MOUtility.h"

@implementation NSArray (MONSArrayAdditions)

+ (id)moRangeFrom:(int)aStartNumber to:(int)anEndNumber {
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:anEndNumber-aStartNumber+1];
	for (int i=aStartNumber; i<anEndNumber; ++i) {
		[result addObject:NN(i)];
	}

	return result;
}


+ (id)moArrayWithObject:(id)anObject copies:(int)count {
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:count];
	for (int i=0; i<count; ++i) {
		[result addObject:anObject];
	}

	return result;
}


- (void)moEnumerateObjectsInColumns:(int)aColumnCount usingBlock:(MONSArrayRowsAndColumnsIterationBlock)aBlock {
	int row = 0;
	int col = 0;
	for (id each in self) {
		aBlock(row, col, each);
		if (col >= aColumnCount-1) {
			col = 0;
			++row;
		} else {
			++col;
		}
	}
}


- (id)moAny {
	if ([self count] == 0) return nil;

	return [self objectAtIndex:arc4random() % [self count]];
}


- (NSSet*)moAny:(int)aNumber {
	if ([self count] == 0) return [NSSet set];

	int count = fmin(aNumber, [self count]);
	NSMutableSet* indexes = [NSMutableSet setWithCapacity:count];

	for (int i=0; i<count; ++i) {
		NSNumber* pick;
		
		do {
			pick = NN(arc4random() % [self count]);
		} while ([indexes containsObject:pick]);

		[indexes addObject:pick];
	}

	return [indexes moMap:^(id each) {
		return [self objectAtIndex:[each intValue]];
	}];
}


- (NSArray*)moMap:(MONSArrayBlock)aBlock {
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];
	for (id each in self) {
		id new = aBlock(each);
		[results addObject:new? new:[NSNull null]];
	}
	return results;
}


- (NSArray*)moMapWithIndex:(MONSArrayBlockWithIndex)aBlock {
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[self count]];
	for (int i=0; i<[self count]; ++i) {
		id new = aBlock([self objectAtIndex:i], i);
		[results addObject:new? new:[NSNull null]];
	}
	return results;
}

@end
