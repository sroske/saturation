//
//  BGSQuadCircleView.h
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSQuadCircleView : UIView 
{
	UIColor *color;
	BOOL isAnimating;
}

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) BOOL isAnimating;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)newColor;

@end
