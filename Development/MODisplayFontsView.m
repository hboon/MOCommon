//
//  MODisplayFontsView.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on Dec/30/2010.
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

#import "MODisplayFontsView.h"

#import "MOAssociation.h"

NSInteger fontAndFontFamilyCompare(id first, id second, void* context);

NSInteger fontAndFontFamilyCompare(id first, id second, void* context) {
	return [[first key] compare:[second key]];
}


@implementation MODisplayFontsView

@synthesize sampleString;
@synthesize fontNames;

- (id)initWithFrame:(CGRect)frame {
	frame = [UIScreen mainScreen].bounds;
	frame = CGRectMake(0, 20, frame.size.width, frame.size.height-20);
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor whiteColor];
		self.sampleString = @"The quick red fox jumped over the lazy brown dog.";
		self.fontNames = [NSMutableArray array];

		for (NSString* eachFamilyName in [UIFont familyNames]) {
			for (NSString* eachFontName in [UIFont fontNamesForFamilyName:eachFamilyName]) {
													 [self.fontNames addObject:[MOAssociation key:eachFontName value:eachFamilyName]];
			}
		}

		[self.fontNames sortUsingFunction:fontAndFontFamilyCompare context:nil];
		self.dataSource = self;
		self.delegate = self;
	}

	return self;
}

#pragma mark Table

- (NSInteger)tableView:(UITableView*)view numberOfRowsInSection:(NSInteger)section {
	return [self.fontNames count];
}


- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString* reuseIdentifier = @"FontTableViewCell";
	UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	}

	cell.detailTextLabel.text = self.sampleString;
	cell.detailTextLabel.font = [UIFont fontWithName:[[self.fontNames objectAtIndex:indexPath.row] key] size:12];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ --- %@", [[self.fontNames objectAtIndex:indexPath.row] value], [[self.fontNames objectAtIndex:indexPath.row] key]];
	cell.textLabel.font = [UIFont systemFontOfSize:9];

	return cell;
}


- (void)tableView:(UITableView*)view didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[view deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"%@", [[self.fontNames objectAtIndex:indexPath.row] key]);
}

@end
