//
//  MONSDateAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Nov/21/2008.
//
/*
 Copyright 2008 Yar Hwee Boon. All rights reserved.
 
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
#include <sys/sysctl.h>  
#include <mach/mach.h>

#import "MONSDateAdditions.h"

@implementation NSDate (MONSDateAdditions)

+ (BOOL)moIsLeapYear:(int)aYear {
	if (aYear % 4 != 0) return NO;
	if (aYear % 100 != 0) return YES;
	return aYear % 400 == 0;
}


//aMonth is 1-12 representing Jan-Dec
+ (int)moDaysInMonth:(int)aMonth ofYear:(int)aYear {
	switch (aMonth) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
			break;
		case 2:
			return [self moIsLeapYear:aYear]? 29: 28;
		default:
			NSAssert(NO, @" Invalid month %d", aMonth);
			return 0;
	}
}


- (NSString*)moPrettyPrint {
	// All in seconds
	#define ONE_MINUTE 60
	#define TWO_MINUTE 120
	#define ONE_HOUR 3600
	#define TWO_HOURS 7200
	#define ONE_DAY 86400
	#define TWO_DAYS 172800
	#define ONE_WEEK 604800
	#define TWO_WEEKS 1209600
	#define ONE_MONTH 2419200
	#define TWO_MONTHS 4838400
	#define ONE_YEAR 29030400
	
	NSTimeInterval seconds = -[self timeIntervalSinceNow];
	NSString *text;
	
	if (seconds < ONE_MINUTE) {
		text = [[NSString alloc] initWithFormat:@"%d sec ago", (int)seconds];
	} else if (seconds < TWO_MINUTE) {
		text = @"a min ago";
	} else if (seconds < ONE_HOUR) {
		int number = (int)seconds/ONE_MINUTE;
		text = [[NSString alloc] initWithFormat:@"%d min ago", number];
	} else if (seconds < TWO_HOURS) {
		text = @"an hr ago";
	} else if (seconds < ONE_DAY) {
		int number = (int)seconds/ONE_HOUR;
		text = [[NSString alloc] initWithFormat:@"%d hr ago", number];
	} else if (seconds < TWO_DAYS) {
		text = @"yesterday";
	} else if (seconds < ONE_WEEK) {
		int number = (int)seconds/ONE_DAY;
		text = [[NSString alloc] initWithFormat:@"%d day%@ ago", number, number>1?@"s":@""];
	} else if (seconds < TWO_WEEKS) {
		text = @"a wk ago";
	} else if (seconds < ONE_MONTH) {
		int number = (int)seconds/ONE_WEEK;
		text = [[NSString alloc] initWithFormat:@"%d wk%@ ago", number, number>1?@"s":@""];
	} else if (seconds < TWO_MONTHS) {
		text = @"a mth ago";
	} else if (seconds < ONE_YEAR) {
		int number = (int)seconds/ONE_MONTH;
		text = [[NSString alloc] initWithFormat:@"%d mth%@ ago", number, number>1?@"s":@""];
	} else {
		int number = (int)seconds/ONE_YEAR;
		text = [[NSString alloc] initWithFormat:@"%d year%@ ago", number, number>1?@"s":@""];
	}
	
	return text;
}


- (NSString*)moPrettyPrintShort {
	// All in seconds
	#define ONE_MINUTE 60
	#define TWO_MINUTE 120
	#define ONE_HOUR 3600
	#define TWO_HOURS 7200
	#define ONE_DAY 86400
	#define TWO_DAYS 172800
	#define ONE_WEEK 604800
	#define TWO_WEEKS 1209600
	#define ONE_MONTH 2419200
	#define TWO_MONTHS 4838400
	#define ONE_YEAR 29030400
	
	NSTimeInterval seconds = -[self timeIntervalSinceNow];
	NSString *text;
	
	if (seconds < ONE_MINUTE) {
		text = [NSString stringWithFormat:@"%ds", (int)seconds];
	} else if (seconds < TWO_MINUTE) {
		text = @"1m";
	} else if (seconds < ONE_HOUR) {
		int number = (int)seconds/ONE_MINUTE;
		text = [NSString stringWithFormat:@"%dm", number];
	} else if (seconds < TWO_HOURS) {
		text = @"1h";
	} else if (seconds < ONE_DAY) {
		int number = (int)seconds/ONE_HOUR;
		text = [NSString stringWithFormat:@"%dh", number];
	} else if (seconds < TWO_DAYS) {
		text = @"1d";
	} else if (seconds < ONE_WEEK) {
		int number = (int)seconds/ONE_DAY;
		text = [NSString stringWithFormat:@"%dd", number];
	} else if (seconds < TWO_WEEKS) {
		text = @"1w";
	} else if (seconds < ONE_MONTH) {
		int number = (int)seconds/ONE_WEEK;
		text = [NSString stringWithFormat:@"%dw", number];
	} else if (seconds < TWO_MONTHS) {
		text = @"1mth";
	} else if (seconds < ONE_YEAR) {
		int number = (int)seconds/ONE_MONTH;
		text = [NSString stringWithFormat:@"%dmth", number];
	} else {
		int number = (int)seconds/ONE_YEAR;
		text = [NSString stringWithFormat:@"%dy", number];
	}
	
	return text;
}

@end
