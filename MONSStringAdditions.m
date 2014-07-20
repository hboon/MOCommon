//
//  MONSStringAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Dec/2/2010.
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

#import "MONSStringAdditions.h"


@implementation NSString (MONSStringAdditions)

- (NSString*)moSetterName {
	return [NSString stringWithFormat:@"set%@%@:", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1]];
}


- (NSString*)moTruncateToEllipsisIfMoreThanLength:(int)aNumber {
	if ([self length] <= aNumber) {
		return self;
	}

	return [NSString stringWithFormat:@"%@...", [self substringToIndex:aNumber-3]];
}


- (NSString*)moCapitalizeFirstLetter {
	if ([self length] == 0) return self;

	return [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1]];
}


- (NSString*)moFirstLetterAsString {
	if ([self length] == 0) return self;
	return [self substringToIndex:1];
}


// Encoding URL strings as in http://tools.ietf.org/html/rfc3986-
- (NSString*)moUrlEncode {
	NSArray *escapeChars = @[@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", @" ", @"✪df.ws"];
	
	NSArray *replaceChars = @[@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", @"+", @"xn--df-oiy.ws"];
	
	NSMutableString *result = [self mutableCopy];
	
    for(int i=0; i<[escapeChars count]; ++i) {
		[result replaceOccurrencesOfString:escapeChars[i] withString:replaceChars[i] options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	}
	
	return result;
}


- (NSString*)moValidURLString {
	return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, (CFStringRef)@"%", (CFStringRef)@" ", kCFStringEncodingUTF8);
}


- (NSString*)moUrlEncodeTreatingSpaceTheSame {
	return (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8);
}


- (NSString*)moUrlDecode {
	NSArray *escapeChars = @[@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", @" ", @"✪df.ws", @" "];
	
	NSArray *replaceChars = @[@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", @"+", @"xn--df-oiy.ws", @"%20"];
	
	NSMutableString *result = [self mutableCopy];
	
    for(int i=0; i<[replaceChars count]; ++i) {
		[result replaceOccurrencesOfString:replaceChars[i] withString:escapeChars[i] options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	}
	
	return result;
}


- (NSString*)moTrimWhiteSpace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString*)moWithoutFirstCharacter {
	if ([self length] == 0) return nil;

	return [self substringFromIndex:1];
}


- (NSString*)moDomainOnly {
	if ([self length] == 0) return nil;

	int i = [self rangeOfString:@"//"].location;
	if (i == NSNotFound) return self;

	int j = [self rangeOfString:@"/" options:0 range:NSMakeRange(i+2, [self length]-i-2)].location;
	if (j == NSNotFound) {
		return [self substringFromIndex:i+2];
	} else {
		return [self substringWithRange:NSMakeRange(i+2, j-i-2)];
	}
}


- (NSString*)moURLSlugOnly {
	if ([self length] == 0) return nil;

	int i = [self rangeOfString:@"/" options:NSBackwardsSearch].location;
	if (i == NSNotFound) {
		return nil;
	} else {
		return [self substringWithRange:NSMakeRange(i+1, [self length]-i-1)];
	}
}


- (BOOL)moContainsString:(NSString*)aString {
	return [self rangeOfString:aString].location != NSNotFound;
}


- (NSString*)moSubStringToString:(NSString*)aString {
	int i = [self rangeOfString:aString].location;
	if (i == NSNotFound) {
		return nil;
	} else {
		return [self substringToIndex:i];
	}
}


- (CGSize)moSizeWithFont:(UIFont*)aFont {
	return [self sizeWithAttributes:@{NSFontAttributeName:aFont}];
}

@end


@implementation NSNull (MONSStringAdditions)

- (NSString*)moSetterName {
	return nil;
}


- (NSString*)moTruncateToEllipsisIfMoreThanLength:(int)aNumber {
	return nil;
}


- (NSString*)moCapitalizeFirstLetter {
	return nil;
}


- (NSString*)moUrlEncode {
	return nil;
}


- (NSString*)moUrlEncodeTreatingSpaceTheSame {
	return nil;
}


- (NSString*)moValidURLString {
	return nil;
}


- (NSString*)moTrimWhiteSpace {
	return nil;
}


- (NSString*)moWithoutFirstCharacter {
	return nil;
}


- (NSString*)moDomainOnly {
	return nil;
}


- (NSString*)moURLSlugOnly {
	return nil;
}


- (BOOL)moContainsString:(NSString*)aString {
	return NO;
}

@end
