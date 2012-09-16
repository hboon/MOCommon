//
//  MOStatusMessageView.h
//
//  Created by Hwee-Boon Yar on Apr/25/2011.
//  Copyright 2011 MotionObj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOStatusMessageView : UIView

@property (nonatomic,strong) NSString* text;
@property (nonatomic) CGFloat offsetY;

- (void)showInView:(UIView*)aView;

@end
