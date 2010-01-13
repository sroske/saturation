//
//  BGSSimpleCircleView.h
//  Saturation
//
//  Created by Shawn Roske on 1/12/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FontsAndColors.h"
#import "BGSSimpleCircleMaskLayer.h"

@interface BGSSimpleCircleView : UIView 
{
	CGRect destinationRect;
	BOOL animating;
}

@property (nonatomic, assign) CGRect destinationRect;
@property (nonatomic, assign) BOOL animating;

@end
