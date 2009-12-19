//
//  UIColor+CMYK.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "UIColor+CMYK.h"


@implementation UIColor (BGSCMYKAdditions)

- (NSDictionary *)cmykValues
{
	NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
	CGColorRef ref = [self CGColor];
	if (CGColorGetNumberOfComponents(ref) == 4)
	{
		const CGFloat *parts = CGColorGetComponents(ref);
		CGFloat r = parts[0];
		CGFloat g = parts[1];
		CGFloat b = parts[2];
		
		/*
		 Black   = minimum(1-Red,1-Green,1-Blue)
		 Cyan    = (1-Red-Black)/(1-Black)
		 Magenta = (1-Green-Black)/(1-Black)
		 Yellow  = (1-Blue-Black)/(1-Black) 
		*/
		CGFloat k = MIN(1-r,MIN(1-g,1-b));
		CGFloat c = (1.0f-r-k)/(1.0f-k);
		CGFloat m = (1.0f-g-k)/(1.0f-k);
		CGFloat y = (1.0f-b-k)/(1.0f-k);
		
		[values setObject:[NSNumber numberWithFloat:c] forKey:@"c"];
		[values setObject:[NSNumber numberWithFloat:m] forKey:@"m"];
		[values setObject:[NSNumber numberWithFloat:y] forKey:@"y"];
		[values setObject:[NSNumber numberWithFloat:k] forKey:@"k"];
	}
	return [values autorelease];
}


@end
