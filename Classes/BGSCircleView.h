//
//  CircleView.h
//  Recursion
//
//  Created by Shawn Roske on 10/2/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BGSCircleView : UIView 
{
	UIColor *color;
	UIColor *newColor;
	BOOL animating;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *newColor;
@property (nonatomic, assign) BOOL animating;

@end
