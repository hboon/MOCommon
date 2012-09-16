//
//  MOStatusMessageView.m
//
//  Created by Hwee-Boon Yar on Apr/25/2011.
//  Copyright 2011 MotionObj. All rights reserved.
//

// Inspired by https://github.com/digdog/uidickbar

#import "MOStatusMessageView.h"

#import "MOUIViewAdditions.h"
#import "MOUtility.h"

@implementation MOStatusMessageView

@synthesize text;

- (id)initWithFrame:(CGRect)aRect {
	if (self = [super initWithFrame:aRect]) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}

	return self;
}


- (id)init {
	CGFloat height = 44;
	return [self initWithFrame:CGRectMake(0, -height, [UIScreen mainScreen].bounds.size.width, height)];
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


- (void)setText:(NSString*)aString {
	if (aString == text) return;

	text = aString;
	[self setNeedsDisplay];
}


- (void)showInView:(UIView*)aView {
	if (aView) {
		if (self.superview) {
			[self removeFromSuperview];
		}

		self.frame = CGRectMake(0, -self.moHeight+self.offsetY, aView.moWidth, self.moHeight);

		[aView addSubview:self];
		[UIView animateWithDuration:0.4
						delay:0
					  options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
						 animations:^{
							 self.moTop = self.offsetY;
						 }
						completion:^(BOOL finished) {
							[UIView animateWithDuration:0.3
											delay:1
										  options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
											 animations:^{
												 self.moTop = -self.moHeight+self.offsetY;
											 }
											completion:^(BOOL finished) {
												[self removeFromSuperview];
										    }];
								   }];
	}
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSaveGState(context);
	CGFloat colors[] = {
		//95/255.0, 100/255.0, 110/255.0, 0.95f,
		//87/255.0, 99/255.0, 108/255.0, 0.95f
		0.0f, 0.0f, 0.0f, 0.8f,
		0.1f, 0.1f, 0.1f, 0.8f
	};

	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
	CGColorSpaceRelease(rgb);

	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + 1);

	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);

	CGContextRestoreGState(context);

	if (self.text) {
		CGContextSaveGState(context);
		UIFont *dickTitleFont = [UIFont boldSystemFontOfSize:18.0f];
		CGSize dickTitleSize = [self.text sizeWithFont:dickTitleFont];
		CGFloat dickTitlePointY = lround((rect.size.height - dickTitleSize.height) / 2);
		CGFloat dickTitlePointX = (rect.size.width - dickTitleSize.width)/2;

		[[UIColor colorWithWhite:0.0 alpha:0.8] set];
		[self.text drawAtPoint:CGPointMake(dickTitlePointX, dickTitlePointY) withFont:dickTitleFont];

		[[UIColor colorWithWhite:1.0 alpha:0.8] set];
		[self.text drawAtPoint:CGPointMake(dickTitlePointX, dickTitlePointY + 1) withFont:dickTitleFont];
		CGContextRestoreGState(context);
	}
}

#pragma mark orientation

- (void)orientationChanged:(NSNotification*)notification {
	[self setNeedsDisplay];
}

@end
