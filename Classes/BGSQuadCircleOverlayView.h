//
//  BGSQuadCircleOverlayView.h
//  Saturation
//
//  Created by Shawn Roske on 1/4/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BGSQuadCircleOverlayView : UIView 
{
	UIColor *color;
}

@property (nonatomic, retain) UIColor *color;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)newColor;

@end
