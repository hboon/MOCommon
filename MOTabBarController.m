//
//  MOTabBarController.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on May/26/2011.
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
#import "MOTabBarController.h"

#define MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED 5

@implementation TabButton

@synthesize normalImage;
@synthesize highlightedImage;
@synthesize text;

- (void)dealloc {
	self.normalImage = nil;
	self.highlightedImage = nil;
	self.text = nil;

	[super dealloc];
}

@end


@interface MOTabBarMoreController : UIViewController {
	UITableView* tableView;
	id<UITableViewDelegate, UITableViewDataSource> delegate;
}

@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,assign) id<UITableViewDelegate, UITableViewDataSource> delegate;

@end


@implementation MOTabBarMoreController

@synthesize tableView;
@synthesize delegate;

- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle {
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		self.title = NSLocalizedString(@"More", @"");

		self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds] autorelease];
		self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:self.tableView];
	}

	return self;
}


- (void)dealloc {
	self.tableView = nil;
	self.delegate = nil;

	[super dealloc];
}

#pragma mark Accessors

- (void)setDelegate:(id<UITableViewDelegate, UITableViewDataSource>)aDelegate {
	if (aDelegate == delegate) return;

	delegate = aDelegate;
	self.tableView.delegate = self.delegate;
	self.tableView.dataSource = self.delegate;
	[self.tableView reloadData];
}

@end


@interface MOTabBarController()

- (void)createDefaultTabButtons;
- (void)setSelectedIndex:(int)aNumber force:(BOOL)yesOrNo;

@end


//todo doesn't handle rotation
@implementation MOTabBarController

@synthesize viewControllers;
@synthesize selectedViewController;
@synthesize selectedIndex;
@synthesize tabButtons;
@synthesize buttons;
@synthesize delegate;
@synthesize moreNavigationController;

- (void)dealloc {
	[self viewDidUnload];

	self.viewControllers = nil;
	self.selectedViewController = nil;
	self.tabButtons = nil;
	self.buttons = nil;
	self.delegate = nil;
	[moreNavigationController release];

	[super dealloc];
}


- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)nibBundle {
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		selectedIndex = NSNotFound;
	}

	return self;
}


- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)viewDidLoad {
	[super viewDidLoad];

}


- (void)viewDidUnload {
	[super viewDidUnload];

}

#pragma mark View Management

- (void)bringTabButtonsToFront {
	for (UIButton* each in self.buttons) {
		[self.view bringSubviewToFront:each];
	}
}


- (void)createDefaultTabButtons {
	if ([self.tabButtons count] > 0) return;

	NSMutableArray* array = [NSMutableArray array];
	CGFloat width = 320/5;
	CGFloat height = 44;
	UIColor* backgroundColor = [UIColor blackColor];

	TabButton* b1 = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b1.backgroundColor = backgroundColor;
	//b1.text = @"b1";
	[array addObject:[b1 autorelease]];

	TabButton* b2 = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b2.backgroundColor = backgroundColor;
	//b2.text = @"b2";
	[array addObject:[b2 autorelease]];

	TabButton* b3 = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b3.backgroundColor = backgroundColor;
	//b3.text = @"b3";
	[array addObject:[b3 autorelease]];

	TabButton* b4 = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b4.backgroundColor = backgroundColor;
	//b4.text = @"b4";
	[array addObject:[b4 autorelease]];

	TabButton* b5 = [[TabButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	b5.backgroundColor = backgroundColor;
	//b5.text = @"b5";
	[array addObject:[b5 autorelease]];

	self.tabButtons = array;
}


- (void)createButtons {
	if ([self.buttons count] > 0) return;

	NSMutableArray* array = [NSMutableArray array];

	for (int i=0; i<[self.tabButtons count]; ++i) {
		UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
		[b addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"button%dTapped", i]) forControlEvents:UIControlEventTouchUpInside];
		[array addObject:b];
		[self.view addSubview:b];
	}

	self.buttons = array;
}


- (CGFloat)shortestTabButtonHeight {
	CGFloat result = 1000; //arbitary large height
	for (TabButton* each in self.tabButtons) {
		result = fmin(result, each.frame.size.height);
	}

	return result;
}


- (void)resizeViewController:(UIViewController*)aViewController {
	aViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-[self shortestTabButtonHeight]);
}


- (BOOL)viewControllerIsUnderMore:(UIViewController*)aViewController {
	return [self.viewControllers count] > MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED && [self.viewControllers indexOfObject:aViewController] >= MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED-1;
}


- (void)displayViewController:(UIViewController*)aViewController {
	UIViewController* old = self.selectedViewController;

	if (!(old == self.moreNavigationController && [self viewControllerIsUnderMore:aViewController])) {
		[old viewWillDisappear:NO];
	}

	selectedViewController = aViewController;
	if (self.selectedViewController) {
		selectedIndex = [self.viewControllers indexOfObject:self.selectedViewController];	// Must not use accessor
	} else {
		selectedIndex = NSNotFound;
	}

	[self resizeViewController:aViewController];
	[aViewController viewWillAppear:NO];
	if (![self viewControllerIsUnderMore:aViewController]) [old.view removeFromSuperview];

	if (aViewController) {
		if (self.selectedIndex < MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED-1) {
			[self.view addSubview:aViewController.view];
		} else if (aViewController == self.moreNavigationController) {
			[self.view addSubview:self.moreNavigationController.view];
		} else {
			//todo need to restore the viewcontroller to it's navigation controller when popped - seems no need? Only trying to access same tap immediately after popping doesn't work. So it could be just an index check
			[self.moreNavigationController pushViewController:((UINavigationController*)aViewController).topViewController  animated:YES];
		}
	}

	if (!(old == self.moreNavigationController && [self viewControllerIsUnderMore:aViewController])) {
		[old viewDidDisappear:NO];
	}
	[aViewController viewDidAppear:NO];

	[self bringTabButtonsToFront];
}


- (int)tabIndex {
	return self.selectedIndex == NSNotFound? MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED - 1: fmin(MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED-1, self.selectedIndex);
}


- (int)numberOfTabsThatNeedsCheckingAgainstDelegateBeforeSelecting {
	if ([self.viewControllers count] <= MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED) {
		return [self.viewControllers count];
	} else {
		return MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED-1;
	}
}

#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.selectedViewController viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.selectedViewController viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.selectedViewController viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.selectedViewController viewDidDisappear:animated];
}

#pragma mark Accessors

- (void)setViewControllers:(NSArray*)anArray {
	[viewControllers release];
	viewControllers = [[NSArray arrayWithArray:anArray] retain];

	if ([viewControllers count] == 0) {
		self.selectedIndex = NSNotFound;
		return;
	}
	
	//todo only do this if using the default buttons
	/*
	for (int i=0; i<[self.viewControllers count]; ++i) {
		[[self.buttons objectAtIndex:i] setTitle:((UIViewController*)[self.viewControllers objectAtIndex:i]).title forState:UIControlStateNormal];
	}
	*/

	//Documented behavoir for UITabBarController -setViewControllers:animated: (although we don't do animation) to re-select the tab with the previously selected view controller, if the view controller isn't around anymore, selected the same tab index if there are enough tabs. Otherwise, select tab 0
	//todo need to handle if previously selected more tab
	int posOfPreviousViewControllerInCurrentTabs = [self.viewControllers indexOfObject:self.selectedViewController];
	if (posOfPreviousViewControllerInCurrentTabs != NSNotFound) {
		self.selectedIndex = posOfPreviousViewControllerInCurrentTabs;
	} else if (posOfPreviousViewControllerInCurrentTabs < [self.viewControllers count]) {
		[self setSelectedIndex:posOfPreviousViewControllerInCurrentTabs force:YES];
	} else {
		self.selectedIndex = 0;
	}
	[self.view setNeedsLayout];
}


- (void)setSelectedViewController:(UIViewController*)aViewController {
	if (aViewController && ![self.viewControllers containsObject:aViewController] && aViewController != self.moreNavigationController) return;
	if (self.selectedViewController == aViewController) {
		[self resizeViewController:self.selectedViewController]; // need to resize if we change the tab buttons, but still same tab
		return;
	}

	[self displayViewController:aViewController];
}


- (void)setSelectedIndex:(int)aNumber force:(BOOL)yesOrNo {
	if (!yesOrNo && self.selectedIndex == aNumber) return;
	if (aNumber >= [self.viewControllers count] && aNumber != NSNotFound) return;

	if ([self tabIndex] < [self.buttons count]) {
		UIButton* old = [self.buttons objectAtIndex:[self tabIndex]];
		TabButton* oldTb = [self.tabButtons objectAtIndex:[self tabIndex]];
		[old setImage:oldTb.normalImage forState:UIControlStateNormal];
		[old setImage:oldTb.highlightedImage forState:UIControlStateHighlighted];
	}

	selectedIndex = aNumber;

	[self createDefaultTabButtons];

	if ([self tabIndex] < [self.buttons count]) {
		UIButton* new = [self.buttons objectAtIndex:[self tabIndex]];
		TabButton* newTb = [self.tabButtons objectAtIndex:[self tabIndex]];
		[new setImage:newTb.highlightedImage forState:UIControlStateNormal];
		[new setImage:newTb.highlightedImage forState:UIControlStateHighlighted];
	}

	if (self.selectedIndex != NSNotFound) {
		self.selectedViewController = [self.viewControllers objectAtIndex:self.selectedIndex];
	} else {
		self.selectedViewController = self.moreNavigationController;
	}
}


- (void)setSelectedIndex:(int)aNumber {
	[self setSelectedIndex:aNumber force:NO];
}


- (void)setTabButtons:(NSArray*)anArray {
	if (anArray == tabButtons) return;

	[tabButtons release];
	if (!anArray) {
		tabButtons = nil;
		return;
	}

	tabButtons = [[NSArray arrayWithArray:anArray] retain];
	[self createButtons];

	CGFloat x = 0;
	for (int i=0; i<[self.tabButtons count]; ++i) {
		TabButton* tb = [self.tabButtons objectAtIndex:i];
		UIButton* b = [self.buttons objectAtIndex:i];
		b.frame = CGRectMake(x, 460-tb.frame.size.height, tb.frame.size.width, tb.frame.size.height);
		if (tb.normalImage) {
			[b setImage:tb.normalImage forState:UIControlStateNormal];
			[b setImage:tb.highlightedImage forState:UIControlStateHighlighted];
			b.backgroundColor = [UIColor clearColor];
		} else {
			b.backgroundColor = tb.backgroundColor;
			[b setTitle:tb.text forState:UIControlStateNormal];
		}
		x += b.frame.size.width;
	}

	[self setSelectedIndex:0 force:YES];
}


- (UINavigationController*)moreNavigationController {
	if (!moreNavigationController) {
		MOTabBarMoreController* moreController = [[MOTabBarMoreController alloc] init];
		moreController.delegate = self;
		moreNavigationController = [[UINavigationController alloc] initWithRootViewController:[moreController autorelease]];
		moreNavigationController.delegate = self;
	}

	return moreNavigationController;
}

#pragma mark Button taps

- (void)tabButtonTapped:(int)aNumber {
	if ([self.viewControllers count] <= aNumber && aNumber != NSNotFound) return;

	//Only send -tabBarController:shouldSelectViewController: for first 5 tabs, including More. But not for the view controllers within more to be consistent with UITabBarController
	if ([self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)] && (aNumber < [self numberOfTabsThatNeedsCheckingAgainstDelegateBeforeSelecting] || aNumber == NSNotFound)) {
		UIViewController* vc = aNumber != NSNotFound? [self.viewControllers objectAtIndex:aNumber]: self.moreNavigationController;
		if (![self.delegate tabBarController:self shouldSelectViewController:vc]) return;
	}

	self.selectedIndex = aNumber;

	//According to UITabBarControllerDelegate docs, >= iOS 3.0, delegate called even if tapped on current selection
	if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
		[self.delegate tabBarController:self didSelectViewController:self.selectedViewController];
	}
}


- (void)button0Tapped {
	[self tabButtonTapped:0];
}


- (void)button1Tapped {
	[self tabButtonTapped:1];
}


- (void)button2Tapped {
	[self tabButtonTapped:2];
}


- (void)button3Tapped {
	[self tabButtonTapped:3];
}


- (void)button4Tapped {
	if ([self.viewControllers count] > MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED) {
		if ([self tabIndex] == MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED-1 && [self.moreNavigationController.viewControllers count] > 1) {
			[self.moreNavigationController popToRootViewControllerAnimated:YES];
			// Don't use accessors
			selectedIndex = NSNotFound;
			selectedViewController = self.moreNavigationController;
		} else {
			[self tabButtonTapped:NSNotFound];
		}
	} else {
		[self tabButtonTapped:4];
	}
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView*)aTableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	[self tabButtonTapped:(indexPath.row + MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED - 1)];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section {
	return [self.viewControllers count] - MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED + 1;
}


- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString* cellIdentifier = @"MOTabBarControllerTableViewCell";

	UITableViewCell* cell = (UITableViewCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	}

	cell.textLabel.text = ((UIViewController*)[self.viewControllers objectAtIndex:(indexPath.row + MOTABBARMORECONTROLLER_MAXIMUM_NUMBER_OF_TABS_DISPLAYED - 1)]).title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}


#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController*)navigationController didShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
	if (viewController != [self.moreNavigationController.viewControllers objectAtIndex:0]) return;

	// Don't use accessors
	selectedIndex = NSNotFound;
	selectedViewController = self.moreNavigationController;
}

@end
