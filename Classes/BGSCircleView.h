//
//  CircleView.h
//  Recursion
//
//  Created by Shawn Roske on 10/2/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGSCircleView : UIView 
{
	UIColor *color;
	UIColor *newColor;
	CGRect newFrame;
	BOOL animating;
	BGSCircleView *overlay;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *newColor;
@property (nonatomic, assign) CGRect newFrame;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, retain) BGSCircleView *overlay;

- (void)animateWithDuration:(float)duration andDelay:(float)delay;

@end
