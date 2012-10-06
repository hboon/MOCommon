//
//  MOPhotoView.m
//
//  Created by Hwee-Boon Yar on Aug/23/2012.
//  Copyright 2012 MotionObj. All rights reserved.
//

#import "MOPhotoView.h"

#import "MOUIViewAdditions.h"
#import "MOUtility.h"

@interface MOPhotoView()

@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic) BOOL isFullScreen;
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


//We simulate UIViewContentModeScaleAspectFit. We can't use UIViewContentModeScaleAspectFit instead because the non-fullscreen version is UIViewContentModeScaleAspectFill. Mixing the 2 is very odd during animation
- (CGRect)fullScreenRectToFitImage:(UIImage*)anImage {
	CGRect frame = moWindow().bounds;
	if (!anImage) {
		//MO_LogDebug(@" no image yet");
		return frame;
	}

	if (anImage.size.width/anImage.size.height > frame.size.width/frame.size.height) {
		MO_LogDebug(@" has image. Longer width");
		frame.size.height = anImage.size.height/anImage.size.width * frame.size.width;
		frame.origin.y = self.moHeight/2 - frame.size.height/2;
	} else {
		MO_LogDebug(@" has image. Longer height");
		frame.size.width = anImage.size.width/anImage.size.height * frame.size.height;
		frame.origin.x = self.moWidth/2 - frame.size.width/2;
	}

	return frame;
}


- (void)enterFullScreen {
	if (!self.image) return;

	[self willEnterFullScreen];
	self.isFullScreen = YES;
	self.nonFullScreenSuperview = self.superview;
	self.nonFullScreenFrame = self.frame;
	self.nonFullScreenGlobalOrigin = [self moOriginRelativeToSuperview:moWindow()];
	[moWindow() addSubview:self];
	self.frame = moWindow().frame;
	self.imageView.moLeft = self.nonFullScreenGlobalOrigin.x;
	self.imageView.moTop = self.nonFullScreenGlobalOrigin.y;
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
	self.backgroundView.backgroundColor = [UIColor blackColor];
	self.backgroundView.alpha = 0;
	[self insertSubview:self.backgroundView belowSubview:self.imageView];

	[UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
		self.backgroundView.alpha = 1;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
			self.imageView.frame = [self fullScreenRectToFitImage:self.image];
		} completion:^(BOOL finished) {
			[self didEnterFullScreen];
		}];
	}];
}


- (void)leaveFullScreen {
	[self willLeaveFullScreen];
	self.isFullScreen = NO;
	CGRect frame = self.nonFullScreenFrame;
	frame.origin = self.nonFullScreenGlobalOrigin;
	[UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
		self.imageView.frame = frame;
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.2 delay:0.05 options:UIViewAnimationOptionCurveLinear animations:^{
			self.backgroundView.alpha = 0;
		} completion:^(BOOL finished) {
			self.backgroundView = nil;
			[self.nonFullScreenSuperview addSubview:self];
			self.frame = self.nonFullScreenFrame;
			self.imageView.frame = CGRectMake(0, 0, self.moWidth, self.moHeight);
			[self didLeaveFullScreen];
		}];
	}];
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

	//Not sure why disabling userInteractionEnabled didn't help to ignore touch, so we have to use our own toggleFullScreenDisabled
	if (self.toggleFullScreenDisabled) return;

	if (self.isFullScreen) {
		[self leaveFullScreen];
	} else {
		[self enterFullScreen];
	}
}

@end
