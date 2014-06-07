//
//  MOUIImageAdditions.m
//  Licensed under the terms of the BSD License, as specified below.
//
//  Created by Hwee-Boon Yar on May/04/2009.
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

#import "MOUIImageAdditions.h"

#import "MOUtility.h"

@implementation UIImage (MOUIImageAdditions)

- (CGFloat)moWidth {
	return self.size.width;
}


- (CGFloat)moHeight {
	return self.size.height;
}


- (UIImage*)moScaleToSize:(CGSize)size {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat scale = 1;
	if ([self respondsToSelector:@selector(scale)]) scale = [self scale];
	CGContextRef context = CGBitmapContextCreate(nil, size.width*scale, size.height*scale, 8, size.width*4*scale, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	
	CGImageRef imageReference = self.CGImage;
	CGContextDrawImage(context, CGRectMake(0, 0, size.width*scale, size.height*scale), imageReference);
	CGImageRef copy = CGBitmapContextCreateImage(context);
	UIImage *scaledImage;
	if ([[UIImage class] respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
		scaledImage = [UIImage imageWithCGImage:copy scale:[self scale] orientation:self.imageOrientation];
	} else {
		scaledImage = [UIImage imageWithCGImage:copy]; 
	}
	CGImageRelease(copy);
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	return scaledImage;
}


// Taken and modified from http://blog.logichigh.com/2008/06/05/uiimage-fix/#
- (UIImage*)moRotateWithOrientation:(UIImageOrientation)anOrientation {
	//Front camera? We try to make fix it
	if ((self.size.width == 640 && self.size.height == 480) || (self.size.width == 480 && self.size.height == 640)) {
		switch(anOrientation) {
			case UIImageOrientationUp: //EXIF = 1
				//do nothing
				break;
			case UIImageOrientationDown: //EXIF = 3
				anOrientation = UIImageOrientationLeftMirrored;
				break;
			case UIImageOrientationLeft: //EXIF = 6
				break;
			case UIImageOrientationRight: //EXIF = 8
				anOrientation = UIImageOrientationLeftMirrored;
				break;
			case UIImageOrientationUpMirrored: //EXIF = 2
				break;
			case UIImageOrientationDownMirrored: //EXIF = 4
				break;
			case UIImageOrientationLeftMirrored: //EXIF = 5
				break;
			case UIImageOrientationRightMirrored: //EXIF = 7
				anOrientation = UIImageOrientationRightMirrored;
				break;
			default:
				return self;
		}
	}

    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
	
    switch(anOrientation) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            return self;
    }
	
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (anOrientation == UIImageOrientationRight || anOrientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -1, 1);
        CGContextTranslateCTM(context, -height, 0);
    }
	else if (anOrientation == UIImageOrientationLeft || anOrientation == UIImageOrientationLeftMirrored || anOrientation == UIImageOrientationRightMirrored) {
		CGContextScaleCTM(context, 1, -1);
		CGContextTranslateCTM(context, 0, -width);
    }
    else {
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -height);
    }
	
    CGContextConcatCTM(context, transform);
	
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return imageCopy;
}


- (UIImage*)moRotateToCorrectOrientation {
	return [self moRotateWithOrientation:self.imageOrientation];
}


- (UIImage*)moRotateCorrectly {
	return [self moRotateToCorrectOrientation];
}


- (UIImage*)moImageByCroppingToRect:(CGRect)aRect {
	CGImageRef cropped = CGImageCreateWithImageInRect(self.CGImage, aRect);
	UIImage* img = [UIImage imageWithCGImage:cropped];
	CGImageRelease(cropped);

	return img;
}


- (UIImage*)imageByCroppingToCenterWithSize:(CGSize)aSize {
	if (aSize.width/aSize.height > self.size.width/self.size.height) {
		return [self moImageByCroppingToRect:CGRectMake(0, (self.size.height-aSize.height)/2, aSize.width, aSize.height)];
	} else {
		return [self moImageByCroppingToRect:CGRectMake((self.size.width-aSize.width)/2, 0, aSize.width, aSize.height)];
	}
}


- (UIImage*)moScaleAspectToSize:(CGSize)aSize {
	return [self moScaleAspectToMaximumSize:aSize];
}


// Preserve aspect ratio while scaling. E.g if aSize = (612,612), the longer side will be 612 and the shorter side will be at most 612
- (UIImage*)moScaleAspectToMaximumSize:(CGSize)aSize {
	CGSize size;

	if (aSize.width/aSize.height > self.size.width/self.size.height) {
		size = CGSizeMake((int)(aSize.height/self.size.height * self.size.width), aSize.height);
	} else {
		size = CGSizeMake(aSize.width, (int)(aSize.width/self.size.width * self.size.height));
	}

	return [self moScaleToSize:size];
}


// Preserve aspect ratio while scaling. E.g if aSize = (612,612), the shorter side will be 612 and the shorter side will be at least 612
- (UIImage*)moScaleAspectToMinimumSize:(CGSize)aSize {
	CGSize size;

	if (aSize.width/aSize.height > self.size.width/self.size.height) {
		size = CGSizeMake(aSize.width, (int)(aSize.width/self.size.width * self.size.height));
	} else {
		size = CGSizeMake((int)(aSize.height/self.size.height * self.size.width), aSize.height);
	}

	return [self moScaleToSize:size];
}


// Preserve aspect ratio while scaling to fill. Part of the content may be clipped
- (UIImage*)moScaleAspectToFillSize:(CGSize)aSize {
	UIImage* croppedImg;

	if (aSize.width/aSize.height > self.size.width/self.size.height) {
		croppedImg = [self imageByCroppingToCenterWithSize:CGSizeMake(self.size.width, (int)(self.size.width/aSize.width * aSize.height))];
	} else {
		croppedImg = [self imageByCroppingToCenterWithSize:CGSizeMake((int)(self.size.height/aSize.height * aSize.width), self.size.height)];
	}

	return [croppedImg moScaleToSize:aSize];
}


// aBorderFloat - border around photo
// anEdgeFloat - transparent edge around border as workaround so that jagged edge doesn't appear around photo's border when displayed with a transform
- (UIImage*)moCopyWithBorderThickness:(CGFloat)aBorderFloat edgeThickness:(CGFloat)anEdgeFloat {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat scale = 1;
	if ([self respondsToSelector:@selector(scale)]) scale = [self scale];
	CGContextRef context = CGBitmapContextCreate(nil, (self.size.width+2*(anEdgeFloat+aBorderFloat))*scale, (self.size.height+2*(anEdgeFloat+aBorderFloat))*scale, 8, (self.size.width+2*(anEdgeFloat+aBorderFloat))*4*scale, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
	CGRect rect = CGRectMake((anEdgeFloat+aBorderFloat)*scale, (anEdgeFloat+aBorderFloat)*scale, self.size.width*scale, self.size.height*scale);
	CGContextDrawImage(context, rect, self.CGImage);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
    CGContextClosePath(context);
	CGContextSetLineWidth(context, 2*aBorderFloat);
	CGContextSetStrokeColorWithColor(context, MO_RGBCOLOR(255, 255, 255).CGColor);
	CGContextStrokePath(context);
	CGImageRef copy = CGBitmapContextCreateImage(context);
	UIImage *result; 

	if ([[UIImage class] respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
		result = [UIImage imageWithCGImage:copy scale:scale orientation:self.imageOrientation];
	} else {
		result = [UIImage imageWithCGImage:copy]; 
	}
	CGImageRelease(copy);
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	return result;
}


- (UIImage*)moCopyWithBorderThickness:(CGFloat)aFloat {
	  return [self moCopyWithBorderThickness:aFloat edgeThickness:0];
}


- (CGFloat)moShorterLength {
	return self.size.width <= self.size.height? self.size.width: self.size.height;
}


- (NSString*)moImageOrientationAsString {
	switch (self.imageOrientation) {
		case UIImageOrientationUp:
			return @"UIImageOrientationUp";
		case UIImageOrientationDown:
			return @"UIImageOrientationDown";
		case UIImageOrientationLeft:
			return @"UIImageOrientationLeft";
		case UIImageOrientationRight:
			return @"UIImageOrientationRight";
		case UIImageOrientationUpMirrored:
			return @"UIImageOrientationUpMirrored";
		case UIImageOrientationDownMirrored:
			return @"UIImageOrientationDownMirrored";
		case UIImageOrientationLeftMirrored:
			return @"UIImageOrientationLeftMirrored";
		case UIImageOrientationRightMirrored:
			return @"UIImageOrientationRightMirrored";
		default:
			return @"Uknown";
	}
}

@end
