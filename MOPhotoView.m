//
//  MOPhotoView.m
//
//  Created by Hwee-Boon Yar on Aug/23/2012.
//  Copyright 2012 MotionObj. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MOPhotoView.h"

#import "MOUIViewAdditions.h"

#import "MOUtility.h"
#import "Utility.h"

@interface MOPhotoView()

@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) UIView* blackBackgroundView;
@property (nonatomic,strong) UIImageView* resizableImageView;
@property (nonatomic,strong) UIScrollView* scrollView;
//Hide the bottom of resizableImageView as it animates so we don't have to change the height (which will force the tall images to scroll very quickly)
@property (nonatomic,strong) UIView* blockingView;
@property (nonatomic) CGRect nonFullScreenFrame;
@property (nonatomic,assign) UIView* nonFullScreenSuperview;
@property (nonatomic) CGPoint nonFullScreenGlobalOrigin;
@property (nonatomic,strong) UIView* backgroundView;
@property (nonatomic) BOOL toggleFullScreenDisabled;

@end


@implementation MOPhotoView

@synthesize image;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.clipsToBounds = YES;

		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		self.imageView.contentMode = UIViewContentModeScaleAspectFill;
		self.imageView.clipsToBounds = YES;
		self.imageView.image = [UIImage imageNamed:@"photoPlaceholder.png"];
		[self addSubview:self.imageView];

		self.enabled = YES;
	}

	return self;
}


- (void)enterFullScreen {
	[self enterFullScreenWithAnimation:YES withCallbacks:YES];
}


- (void)leaveFullScreen {
	[self leaveFullScreenWithAnimation:YES];
}


- (void)willEnterFullScreen {
	self.toggleFullScreenDisabled = YES;
	if ([self.delegate respondsToSelector:@selector(photoViewWillEnterFullScreen:)]) {
		[self.delegate photoViewWillEnterFullScreen:self];
	}
}


- (void)didEnterFullScreen {
	self.toggleFullScreenDisabled = NO;
	if ([self.delegate respondsToSelector:@selector(photoViewDidEnterFullScreen:)]) {
		[self.delegate photoViewDidEnterFullScreen:self];
	}
}


- (void)willLeaveFullScreen {
	self.toggleFullScreenDisabled = YES;
	if ([self.delegate respondsToSelector:@selector(photoViewWillLeaveFullScreen:)]) {
		[self.delegate photoViewWillLeaveFullScreen:self];
	}
}


- (void)didLeaveFullScreen {
	self.toggleFullScreenDisabled = NO;
	if ([self.delegate respondsToSelector:@selector(photoViewDidLeaveFullScreen:)]) {
		[self.delegate photoViewDidLeaveFullScreen:self];
	}
}

#pragma mark Accessors

- (void)setImage:(UIImage*)anImage {
	image = anImage;

	if (image) {
		self.imageView.image = self.image;
	} else {
		self.imageView.image = [UIImage imageNamed:@"photoPlaceholder.png"];
	}
}


- (UIImage*)image {
	return image;
}

#pragma mark Touch Events

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[super touchesEnded:touches withEvent:event];

	if (!self.enabled) return;

	[self enterFullScreen];
}

#pragma mark Fullscreen

- (void)enterFullScreenWithAnimation:(BOOL)withAnimation withCallbacks:(BOOL)withCallbacks {
	if (!self.image) return;

	if (withCallbacks) {
		[self willEnterFullScreen];
	}
	self.isFullScreen = YES;
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	if (!withAnimation) {
		[UIView setAnimationsEnabled:NO];
	}

	if (!self.blackBackgroundView) {
		self.blackBackgroundView = [[UIView alloc] initWithFrame:moWindow().bounds];
		UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self.blackBackgroundView addGestureRecognizer:tapGestureRecognizer];
	}
	self.blackBackgroundView.moTop = 0;
	self.blackBackgroundView.backgroundColor = [UIColor blackColor];
	CGPoint org = [self.imageView moOriginRelativeToSuperview:moWindow()];

	CGRect r = self.imageView.bounds;
	r.origin.x = org.x;
	r.origin.y = org.y;
	r.size.width = self.moWidth;
	r.size.height = self.imageView.image.size.height*self.moWidth/self.imageView.image.size.width;

	if (r.size.height < self.imageView.moHeight) {
		//wide
		r.size.height = self.imageView.moHeight;
	}

	if (!self.resizableImageView) {
		self.resizableImageView = [[UIImageView alloc] initWithFrame:r];
		self.resizableImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.resizableImageView.backgroundColor = UIColor.grayColor;
		self.resizableImageView.clipsToBounds = YES;
	}

	self.resizableImageView.frame = r;
	self.resizableImageView.image = self.imageView.image;
	[self.blackBackgroundView addSubview:self.resizableImageView];
	self.blackBackgroundView.alpha = 0;
	self.blockingView = [[UIView alloc] initWithFrame:CGRectMake(0,org.y+self.imageView.moHeight, self.blackBackgroundView.moWidth, 500)];
	self.blockingView.backgroundColor = self.blackBackgroundView.backgroundColor;
	[self.blackBackgroundView addSubview:self.blockingView];
	//We need to rasterize so that the subview self.blockingView isn't itself seen through to expose the parts of the image it is suppose to hide
	self.blackBackgroundView.layer.shouldRasterize = YES;
	//Otherwise might cause blurry images on retina
	self.blackBackgroundView.layer.rasterizationScale = UIScreen.mainScreen.scale;
	[moWindow() addSubview:self.blackBackgroundView];
	[UIView animateWithDuration:0.3 delay:(withAnimation? 0.1:0) options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.blackBackgroundView.alpha = 1;
	} completion:^(BOOL finished) {
		self.blackBackgroundView.layer.shouldRasterize = NO;
		[UIView animateWithDuration:0.2 delay:(withAnimation? 0.1:0) options:UIViewAnimationOptionCurveLinear animations:^{
			CGRect r = self.resizableImageView.frame;
			r.origin.x = 0;
			r.origin.y = 0;
			r.size.width = self.blackBackgroundView.moWidth;
			r.size.height = self.resizableImageView.image.size.height*self.blackBackgroundView.moWidth/self.resizableImageView.image.size.width;
			if (r.size.height < self.blackBackgroundView.moHeight) {
				r.origin.y = (self.blackBackgroundView.moHeight-r.size.height)/2;
			}
			self.resizableImageView.frame = r;
			self.blockingView.moTop = self.blackBackgroundView.moHeight;
		} completion:^(BOOL finished) {
			[self.blockingView removeFromSuperview];
			CGRect r = self.resizableImageView.frame;
			r.size.height = self.blackBackgroundView.moHeight;
			self.scrollView = [UIScrollView.alloc initWithFrame:r];
			self.scrollView.backgroundColor = [UIColor blackColor];
			self.scrollView.contentSize = self.resizableImageView.frame.size;
			self.scrollView.scrollEnabled = NO;
			self.resizableImageView.moLeft = 0;
			self.resizableImageView.moTop = 0;
			[self.scrollView addSubview:self.resizableImageView];
			self.scrollView.scrollEnabled = YES;
			[self.blackBackgroundView addSubview:self.scrollView];
			[self didEnterFullScreen];
		}];
	}];

	if (!withAnimation) {
		[UIView setAnimationsEnabled:YES];
	}
}


- (void)leaveFullScreenWithAnimation:(BOOL)yesOrNo {
	[self willLeaveFullScreen];
	self.isFullScreen = NO;

	if (!yesOrNo) {
		[UIView setAnimationsEnabled:NO];
	}
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

	//remove scroll view, restore image view. no animation yet
	CGRect r = self.resizableImageView.frame;
	if (self.resizableImageView.image.size.height*self.moWidth/self.resizableImageView.image.size.width > self.moHeight) {
		r.origin.y = 0;
	} else {
		r.origin.y = (self.blackBackgroundView.moHeight-r.size.height)/2;
	}
	self.resizableImageView.frame = r;
	[self.blackBackgroundView addSubview:self.resizableImageView];
	[self.scrollView removeFromSuperview];
	//resize image view
	[self.blackBackgroundView addSubview:self.blockingView];

	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
	  CGPoint org = [self.imageView moOriginRelativeToSuperview:moWindow()];
	  CGRect r = self.resizableImageView.frame;
	  r.origin.x = org.x;
	  r.origin.y = org.y;
	  r.size.width = self.imageView.moWidth;
	  //r.size.height = self.imageView.image.size.height*self.moWidth/self.imageView.image.size.width;
	  //r.size.height = self.imageView.moHeight;

	  if (r.size.height < self.imageView.moHeight) {
		  //wide
		  r.size.height = self.imageView.moHeight;
	  }
	  self.resizableImageView.frame = r;
	  self.blockingView.moTop = org.y + self.imageView.moHeight;

	} completion:^(BOOL finished) {
	  [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		  //We need to rasterize so that the subview self.blockingView isn't itself seen through to expose the parts of the image it is suppose to hide
		  self.blackBackgroundView.layer.shouldRasterize = YES;
		  //Otherwise might cause blurry images on retina
		  self.blackBackgroundView.layer.rasterizationScale = UIScreen.mainScreen.scale;
		  self.blackBackgroundView.alpha = 0;
	  } completion:^(BOOL finished) {
		  self.blackBackgroundView.layer.shouldRasterize = NO;
		  //remove self.blackBackgroundView no animation
		  [self.blockingView removeFromSuperview];
		  [self.blackBackgroundView removeFromSuperview];
		  [self didLeaveFullScreen];
	  }];
	}];
	if (!yesOrNo) {
		[UIView setAnimationsEnabled:YES];
	}
}

#pragma mark Events

- (void)tapped:(UITapGestureRecognizer *)tapRecognizer  {
	[self leaveFullScreen];
}

@end
