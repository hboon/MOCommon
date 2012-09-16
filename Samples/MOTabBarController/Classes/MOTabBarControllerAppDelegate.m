//
//  MOTabBarControllerAppDelegate.m
//  MOTabBarController demo
//
//  Created by Hwee-Boon Yar on 5/30/11.
//  Copyright 2011 MotionObj. All rights reserved.
//

#import "MOTabBarControllerAppDelegate.h"

#import "MOTabBarController.h"

@implementation MOTabBarControllerAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)dealloc {
	self.tabBarController = nil;
	self.window = nil;
	[super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.tabBarController = [[[MOTabBarController alloc] init] autorelease];
	NSMutableArray* viewControllers = [NSMutableArray array];

	UIViewController* v1 = [[[UIViewController alloc] init] autorelease];
	v1.view.backgroundColor = [UIColor redColor];
	v1.title = @"v1";
	[viewControllers addObject:[[[UINavigationController alloc] initWithRootViewController:v1] autorelease]];

	UIViewController* v2 = [[[UIViewController alloc] init] autorelease];
	v2.view.backgroundColor = [UIColor yellowColor];
	v2.title = @"v2";
	[viewControllers addObject:[[[UINavigationController alloc] initWithRootViewController:v2] autorelease]];

	UIViewController* v3 = [[[UIViewController alloc] init] autorelease];
	v3.view.backgroundColor = [UIColor blueColor];
	v3.title = @"v3";
	[viewControllers addObject:[[[UINavigationController alloc] initWithRootViewController:v3] autorelease]];

	UIViewController* v4 = [[[UIViewController alloc] init] autorelease];
	v4.view.backgroundColor = [UIColor greenColor];
	v4.title = @"v4";
	[viewControllers addObject:[[[UINavigationController alloc] initWithRootViewController:v4] autorelease]];

	UIViewController* v5 = [[[UIViewController alloc] init] autorelease];
	v5.view.backgroundColor = [UIColor magentaColor];
	v5.title = @"v5";
	[viewControllers addObject:[[[UINavigationController alloc] initWithRootViewController:v5] autorelease]];

	UIViewController* v6 = [[[UIViewController alloc] init] autorelease];
	v6.view.backgroundColor = [UIColor brownColor];
	v6.title = @"v6";
	[viewControllers addObject:[[[UINavigationController alloc] initWithRootViewController:v6] autorelease]];


	// The main difference from UITabBarController is you specific the buttons (size and images) here
	NSMutableArray* buttons = [NSMutableArray array];

	MOTabButton* b1 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
	b1.normalImage = [UIImage imageNamed:@"one-off.png"];
	b1.highlightedImage = [UIImage imageNamed:@"one-on.png"];
	[buttons addObject:[b1 autorelease]];

	MOTabButton* b2 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
	b2.normalImage = [UIImage imageNamed:@"two-off.png"];
	b2.highlightedImage = [UIImage imageNamed:@"two-on.png"];
	[buttons addObject:[b2 autorelease]];

	MOTabButton* b3 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, 80, 60)];
	b3.normalImage = [UIImage imageNamed:@"three-off.png"];
	b3.highlightedImage = [UIImage imageNamed:@"three-on.png"];
	[buttons addObject:[b3 autorelease]];

	MOTabButton* b4 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
	b4.normalImage = [UIImage imageNamed:@"four-off.png"];
	b4.highlightedImage = [UIImage imageNamed:@"four-on.png"];
	[buttons addObject:[b4 autorelease]];

	MOTabButton* b5 = [[MOTabButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
	b5.normalImage = [UIImage imageNamed:@"five-off.png"];
	b5.highlightedImage = [UIImage imageNamed:@"five-on.png"];
	[buttons addObject:[b5 autorelease]];

	self.tabBarController.tabButtons = buttons;

	self.tabBarController.delegate = self;
	self.tabBarController.viewControllers = viewControllers;
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];

	return YES;
}

#pragma mark MOTabBarControllerDelegate

- (void)tabBarController:(MOTabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController {
	NSLog(@" select %@", viewController);
	NSLog(@" vc: %@", self.tabBarController.selectedViewController);
}


- (BOOL)tabBarController:(MOTabBarController*)tabBarController shouldSelectViewController:(UIViewController*)viewController {
	NSLog(@" should select? %@", viewController);
	return YES;
}

@end
