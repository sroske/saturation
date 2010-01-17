//
//  BGSSimpleSquareSprite.m
//  Saturation
//
//  Created by Shawn Roske on 1/16/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleSquareSprite.h"


@implementation BGSSimpleSquareSprite

@synthesize animating;

- (id)init
{
	if (self = [super init])
	{
		self.animating = NO;
		[self setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
	}
	return self;
}

@end
