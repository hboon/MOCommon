//
//  MOPhotoView.h
//
//  Created by Hwee-Boon Yar on Aug/23/2012.
//  Copyright 2012 MotionObj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOPhotoView;

@protocol MOPhotoViewDelegate

@optional
- (void)photoViewWillEnterFullScreen:(MOPhotoView*)aPhotoView;
- (void)photoViewDidEnterFullScreen:(MOPhotoView*)aPhotoView;
- (void)photoViewWillLeaveFullScreen:(MOPhotoView*)aPhotoView;
- (void)photoViewDidLeaveFullScreen:(MOPhotoView*)aPhotoView;

@end


@interface MOPhotoView : UIView

@property (nonatomic,strong) UIImage* image;
@property (nonatomic,assign) id<NSObject, MOPhotoViewDelegate> delegate;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL isFullScreen;

- (void)leaveFullScreen;

@end
