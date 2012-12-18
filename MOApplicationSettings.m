//
//  MOApplicationSettings.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Jun/1/2012.
//
/*
 Copyright 2012 Yar Hwee Boon. All rights reserved.
 
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
#import "MOApplicationSettings.h"

#import "MONSMutableDictionaryAdditions.h"
#import "MOUtility.h"

@interface MOApplicationSettings()

@property (nonatomic,strong) NSMutableDictionary* backingDictionary;

@end


@implementation MOApplicationSettings

@synthesize filePath;
@synthesize backingDictionary;

+ (id)defaultSettings {
	static MOApplicationSettings* obj = NULL;

	@synchronized(self) {
		if (!obj) {
			obj = [[self alloc] init];
		}
	}

	return obj;
}


- (void)setDefaultObject:(id)aDefault forKey:(id)aKey {
	id obj = (self.backingDictionary)[aKey];
	if (obj) return;

	(self.backingDictionary)[aKey] = aDefault;

}


- (void)setObject:(id)aValue forKey:(id)aKey {
	(self.backingDictionary)[aKey] = aValue;
}


- (void)removeObjectForKey:(id)aKey {
	[self.backingDictionary removeObjectForKey:aKey];
}


- (id)objectForKey:(id)aKey {
	return (self.backingDictionary)[aKey];
}


- (void)setValue:(id)aValue forKeyPath:(id)aKey {
	[self setValue:aValue forKeyPath:aKey force:NO];
}


- (void)setValue:(id)aValue forKeyPath:(id)aKey force:(BOOL)yesOrNo {
	if (yesOrNo) {
		NSMutableDictionary* d = self.backingDictionary;
		NSArray* paths = [aKey componentsSeparatedByString:@"."];
		for (int i=0; i<[paths count]-1; ++i) {
			d = [d moSetDefaultForKey:paths[i] object:[NSMutableDictionary dictionary]];
		}
		d[[paths lastObject]] = aValue;
	} else {
		[self.backingDictionary setValue:aValue forKeyPath:aKey];
	}
}


- (id)valueForKeyPath:(id)aKey {
	return [self.backingDictionary valueForKeyPath:aKey];
}


- (id)objectForKeyedSubscript:(id)aKey {
	return (self.backingDictionary)[aKey];
}


- (void)setObject:(id)aValue forKeyedSubscript:(id<NSCopying>)aKey {
	(self.backingDictionary)[aKey] = aValue;
}


- (void)save {
	[backingDictionary writeToFile:self.filePath atomically:YES];
}


#pragma mark Accessors

- (NSString*)filePath {
	if (!moIsEmpty(filePath)) return filePath;

	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"moapplicationsettings.plist"];
}


- (NSMutableDictionary*)backingDictionary {
	if (!backingDictionary) {
		backingDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.filePath];
		if (!backingDictionary) {
			backingDictionary = [[NSMutableDictionary alloc] init];
		}
	}

	return backingDictionary;
}

@end
