//
//  BGSSimpleSquareView.m
//  Saturation
//
//  Created by Shawn Roske on 1/10/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleSquareView.h"


@implementation BGSSimpleSquareView

@synthesize animating;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		self.animating = NO;
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}


@end
