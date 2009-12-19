//
//  BGSSwatchColor.h
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"


@interface BGSSwatchColor : UIView 
{
	UIColor *color;
}

@property (nonatomic, retain) UIColor *color;

- (id)initWithFrame:(CGRect)frame 
		   andColor:(UIColor *)displayColor;

@end
