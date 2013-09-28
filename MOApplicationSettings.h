//
//  MOApplicationSettings.h
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
#import <UIKit/UIKit.h>

@interface MOApplicationSettings : NSObject

@property (nonatomic,strong) NSString* filePath;

+ (id)defaultSettings;
- (void)setDefaultObject:(id)aDefault forKey:(id)aKey;
- (void)setObject:(id)aValue forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (id)objectForKey:(id)aKey;
- (void)setValue:(id)aValue forKeyPath:(id)aKey;
- (void)setValue:(id)aValue forKeyPath:(id)aKey force:(BOOL)yesOrNo;
- (id)valueForKeyPath:(id)aKey;
- (id)objectForKeyedSubscript:(id)aKey;
- (void)setObject:(id)aValue forKeyedSubscript:(id<NSCopying>)aKey;
- (void)save;
- (void)activateWithBlock:(void(^)())aBlock;

@end
