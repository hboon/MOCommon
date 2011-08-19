//
//  MOTextInputViewController.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on May/11/2009.
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

#import "MOTextInputViewController.h"

#import "MOUIViewAdditions.h"

#import "MOUtility.h"

@interface MOTextInputViewController()

@property(nonatomic,retain)IBOutlet UILabel *characterCountLeftLabel;
@property (nonatomic,retain)IBOutlet UITableView* tableView;
@property (nonatomic,assign) id target;
@property (nonatomic) SEL setterSelector;
@property (nonatomic,retain) NSString* text;

- (void)updateCharacterCount;
- (void)setFocusOnText;
- (void)resizeTableView;

@end


@implementation MOTextInputViewController

@synthesize characterCountLeftLabel;
@synthesize tableView;
@synthesize textInputView;

@synthesize fieldName;
@synthesize value;
@synthesize target;
@synthesize setterSelector;
@synthesize maximumLength;

- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)viewDidLoad {
	[super viewDidLoad];

	CGFloat characterCountXOffset = 22;
	self.characterCountLeftLabel = [[[UILabel alloc] initWithFrame:CGRectMake(characterCountXOffset, 0, self.view.moWidth-characterCountXOffset, 21)] autorelease];
	self.characterCountLeftLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.characterCountLeftLabel.font = [UIFont systemFontOfSize:17];
	self.characterCountLeftLabel.textColor = MO_RGBCOLOR(76, 86, 108);

	self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
	[self resizeTableView];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.tableFooterView = self.characterCountLeftLabel;
	[self.view addSubview:self.tableView];
	
	isCancel = NO;
	[self setupObserveTextChangeNotification];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;

	[self setPlaceHolder:self.fieldName];
	self.text = self.value;
	[self updateCharacterCount];
	[self setFocusOnText];
}


- (void)viewDidUnload {
	self.characterCountLeftLabel = nil;
	self.tableView = nil;
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;

	[super viewDidUnload];
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self viewDidUnload];
	self.textInputView = nil;

	self.fieldName = nil;
	self.value = nil;
	self.target = nil;
	
    [super dealloc];
}


- (void)resizeTableView {
	if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) { 
		self.tableView.frame = CGRectMake(0, 0, self.view.moWidth, [UIScreen mainScreen].bounds.size.height-MO_STATUS_BAR_HEIGHT-MO_NAVIGATION_BAR_HEIGHT_PORTRAIT-MO_KEYBOARD_HEIGHT_PORTRAIT);
		self.tableView.contentInset = UIEdgeInsetsMake([self textInputViewTopInsetPortrait], 0, 0, 0);
	} else {
		self.tableView.frame = CGRectMake(0, 0, self.view.moWidth, moScreenBounds(self.interfaceOrientation).size.height-MO_STATUS_BAR_HEIGHT-MO_NAVIGATION_BAR_HEIGHT_LANDSCAPE-MO_KEYBOARD_HEIGHT_LANDSCAPE);
		self.tableView.contentInset = UIEdgeInsetsMake([self textInputViewTopInsetLandscape], 0, 0, 0);
	}
}


- (void)setFocusOnText {
	[self.textInputView becomeFirstResponder];
}


- (int)characterUsed {
	return [self.text length];
}


- (BOOL)saveButtonShouldBeEnabled {
	return [self characterUsed] <= self.maximumLength;
}


- (void)updateCharacterCount {
	int count = self.maximumLength - [self characterUsed];
	characterCountLeftLabel.text = [NSString stringWithFormat:@"%d", count];
	self.navigationItem.rightBarButtonItem.enabled = [self saveButtonShouldBeEnabled];
	
	if (count == 0) {
		characterCountLeftLabel.textColor = MO_RGBCOLOR(76, 86, 108);
	} else if (count == -1) {
		characterCountLeftLabel.textColor = [UIColor redColor];
	}
}


- (void)cancel {
	isCancel = YES;
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)save {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)textDidChange:(NSNotification*)notification {
	[self updateCharacterCount];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (isCancel) {
		return;
	}
	
	[target performSelector:setterSelector withObject:self.text];
}


- (void)setTarget:(id)aTarget action:(SEL)aSelector {
	self.target = aTarget;
	self.setterSelector = aSelector;
}

#pragma mark To be overridden

- (CGFloat)textInputViewTopInsetPortrait {
	return 0;
}


- (CGFloat)textInputViewTopInsetLandscape {
	return 0;
}


- (UIView<UITextInputTraits>*)textInputView {
	return nil;
}


- (void)setPlaceHolder:(NSString*)aString {
}


- (NSString*)text {
	return nil;
}


- (void)setText:(NSString*)aString {
}


- (void)setupObserveTextChangeNotification {
}

#pragma mark Accessors

- (void)setFieldName:(NSString*)aString {
	if (aString == self.fieldName) return;

	[fieldName release];
	fieldName = [aString retain];

	self.title = [NSString stringWithFormat:@"Edit %@", self.fieldName];
	[self setPlaceHolder:self.fieldName];
}


- (void)setValue:(NSString*)aString {
	if (aString == self.value) return;

	[value release];
	value = [aString retain];
	self.text = self.value;
}

#pragma mark Table

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString* cellIdentifier = @"MOTextInputViewController";
	UITableViewCell* cell = (UITableViewCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}

	[cell.contentView addSubview:self.textInputView];

	return cell;
}


- (void)tableView:(UITableView*)aTableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[aTableView deselectRowAtIndexPath:[aTableView indexPathForSelectedRow] animated:YES];
}


- (CGFloat)tableView:(UITableView*)aTableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return 0;
}

#pragma mark Orientation

- (void)orientationChanged:(NSNotification*)notification {
	[self resizeTableView];
}

@end
