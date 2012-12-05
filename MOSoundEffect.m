//
//  MOSoundEffect.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Aug/21/2009.
//
/*
 Copyright 2009 Yar Hwee Boon. All rights reserved.
 
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
#import "MOSoundEffect.h"

#import <MediaPlayer/MediaPlayer.h>

#import "MOUtility.h"

@interface MOSoundEffect()

@property (nonatomic,strong) NSURL* soundPath;
@property (nonatomic,strong) AVAudioPlayer* audioPlayer;

@end


@implementation MOSoundEffect

+ (BOOL)songIsCurrentlyPlaying {
	NSTimeInterval playbackTime1 = [MPMusicPlayerController iPodMusicPlayer].currentPlaybackTime;
	NSTimeInterval playbackTime2 = [MPMusicPlayerController iPodMusicPlayer].currentPlaybackTime;

	return playbackTime1 != playbackTime2;
}


+ (id)soundEffectWithContentsOfFile:(NSString *)aPath {
    if (aPath) {
        return [[MOSoundEffect alloc] initWithContentsOfFile:aPath];
    }
	
    return nil;
}


- (id)initWithContentsOfFile:(NSString *)path {
    if (self = [super init]) {
		self.soundPath = [NSURL fileURLWithPath:path isDirectory:NO];
	}
	
    return self;
}


- (NSURL*)path {
	return self.soundPath;
}


-(void)play {
	if (!self.audioPlayer) {
		self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.soundPath error:nil];
		self.audioPlayer.delegate = self;
		if (self.audioSessionCategory) {
			[[AVAudioSession sharedInstance] setCategory:self.audioSessionCategory error:nil];
		} else {
			[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
		}
		NSError *activationError = nil;
		[[AVAudioSession sharedInstance] setActive:YES error:&activationError];
	}
	
	// Playing in simulator often (always?) crashes
	if (!moIsSimulator) {
		[self.audioPlayer prepareToPlay];
		[self.audioPlayer play];
	}
} 

#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag {
	if (self.repeats) {
		[self play];
	}
}

@end
