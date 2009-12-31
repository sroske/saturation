//
//  BGSCircleScrollView.m
//  Saturation
//
//  Created by Shawn Roske on 12/31/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSCircleScrollView.h"


@implementation BGSCircleScrollView


- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		self.scrollEnabled = NO;
		self.minimumZoomScale = 1.0f;
		self.maximumZoomScale = 16.0f;
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([self.delegate respondsToSelector:@selector(touchesBegan:withEvent:)])
		[self.delegate performSelector:@selector(touchesBegan:withEvent:) withObject:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if ([self.delegate respondsToSelector:@selector(touchesMoved:withEvent:)])
		[self.delegate performSelector:@selector(touchesMoved:withEvent:) withObject:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([self.delegate respondsToSelector:@selector(touchesEnded:withEvent:)])
		[self.delegate performSelector:@selector(touchesEnded:withEvent:) withObject:touches];
}

@end
