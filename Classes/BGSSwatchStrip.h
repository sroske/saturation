//
//  BGSSwatchStrip.h
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

#define COLOR_STRIP_ENTRY_WIDTH		10.0f
#define COLOR_STRIP_ENTRY_HEIGHT	10.0f

@interface BGSSwatchStrip : UIView 
{
	NSArray *swatches;
}

@property (nonatomic, retain) NSArray *swatches;

- (id)initWithFrame:(CGRect)frame 
		  andSwatches:(NSArray *)andSwatches;

@end
