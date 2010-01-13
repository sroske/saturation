//
//  BGSSimpleCircleView.m
//  Saturation
//
//  Created by Shawn Roske on 1/12/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleCircleView.h"


@implementation BGSSimpleCircleView

@synthesize destinationRect;
@synthesize animating;

static CGImageRef mask;

+ (void)initialize
{
	NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mask-circle.png"];
	UIImage *i = [UIImage imageWithContentsOfFile:p];
	mask = [i CGImage];
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		self.animating = NO;
		
		[self setBackgroundColor:CC_CLEAR];
		
		BGSSimpleCircleMaskLayer *maskLayer = [BGSSimpleCircleMaskLayer layer];
		[maskLayer setBounds:self.bounds];
		[maskLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[maskLayer setPosition:CGPointMake(frame.size.width/2, frame.size.height/2)];
		[maskLayer setContents:(id)mask];
		
		[self.layer setMask:maskLayer];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.layer.mask.frame = self.bounds;
}

- (void)dealloc 
{
    [super dealloc];
}


@end
