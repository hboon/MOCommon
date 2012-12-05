//
//  MOTextFieldViewController.m
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

#import "MOTextFieldViewController.h"

#import "MOUtility.h"

@implementation MOTextFieldViewController

#pragma mark Table

- (CGFloat)tableView:(UITableView*)aTableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return 44;
}

#pragma mark To be overridden

- (CGFloat)textInputViewTopInsetPortrait {
	return 80;
}


- (CGFloat)textInputViewTopInsetLandscape {
	return 10;
}


- (UIView<UITextInputTraits>*)textInputView {
	if (![super textInputView]) {
		self.textInputView = [[UITextField alloc] initWithFrame:CGRectMake(11, 10, 279, 31)];
		((UITextField*)self.textInputView).font = [UIFont systemFontOfSize:17];
		((UITextField*)self.textInputView).textColor = MO_RGBCOLOR(57, 79, 133);
	}

	return [super textInputView];
}


- (void)setPlaceHolder:(NSString*)aString {
	((UITextField*)self.textInputView).placeholder = aString;
}


- (NSString*)text {
	return ((UITextField*)self.textInputView).text;
}


- (void)setText:(NSString*)aString {
	((UITextField*)self.textInputView).text = aString;
}


- (void)setupObserveTextChangeNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textInputView];
}

@end
