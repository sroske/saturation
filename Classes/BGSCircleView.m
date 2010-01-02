//
//  CircleView.m
//  Recursion
//
//  Created by Shawn Roske on 10/2/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSCircleView.h"

#define HIDE_PADDING 4.0f

@implementation BGSCircleView

@synthesize color;
@synthesize newColor;
@synthesize newFrame;
@synthesize animating;
@synthesize overlay;

- (void)setColor:(UIColor *)nc
{
	if (color != nc)
	{
		[color release];
		color = [nc retain];
	}
	[self setNeedsDisplay];
}

- (BGSCircleView *)overlay
{
	if (overlay == nil)
	{
		BGSCircleView *v = [[BGSCircleView alloc] initWithFrame:self.bounds];
		[v setColor:self.color];
		[self setOverlay:v];
		[v release];
	}
	return overlay;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		self.animating = NO;
		self.backgroundColor = [UIColor clearColor];
		self.color = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0];
    }
    return self;
}

- (void)animateWithDuration:(float)duration andDelay:(float)delay
{
	self.animating = YES;
	
	[self.overlay removeFromSuperview];
	self.overlay = nil;
	[self addSubview:self.overlay];
	
	[self setColor:self.newColor];
	
	[self setFrame:CGRectMake(self.frame.origin.x+HIDE_PADDING, 
							  self.frame.origin.y+HIDE_PADDING, 
							  self.frame.size.width-HIDE_PADDING*2, 
							  self.frame.size.height-HIDE_PADDING*2)];
	[self.overlay setFrame:CGRectMake(self.overlay.frame.origin.x-HIDE_PADDING, 
									  self.overlay.frame.origin.y-HIDE_PADDING, 
									  self.overlay.frame.size.width, 
									  self.overlay.frame.size.height)];
	
	NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
	NSLog(@"self.overlay.frame: %@", NSStringFromCGRect(self.overlay.frame));
	
	[UIView beginAnimations:@"move" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:duration];
	[UIView setAnimationDelay:delay];
	
	[self setFrame:self.newFrame];
	[self.overlay setFrame:self.newFrame];
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeCompleted:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:duration-0.4];
	[UIView setAnimationDelay:delay+0.4];
	
	[self.overlay setAlpha:0.0f];
	
	[UIView commitAnimations];
}

- (void)fadeCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	[self.overlay removeFromSuperview];
	self.overlay = nil;
	
	self.animating = NO;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.overlay.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	CGContextSetFillColorWithColor(context, [self.color CGColor]);
	CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2*M_PI, false);
	CGContextFillPath(context);
}

- (void)dealloc 
{
	[color release];
	[newColor release];
	[overlay release];
    [super dealloc];
}


@end
