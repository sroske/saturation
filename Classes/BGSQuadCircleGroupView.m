//
//  BGSQuadCircleGroupView.m
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSQuadCircleGroupView.h"

@interface BGSQuadCircleGroupView (Private)

- (UIColor *)randomColor;

@end

@implementation BGSQuadCircleGroupView

@synthesize entry;
@synthesize circle;
@synthesize primaryColor;
@synthesize parent;
@synthesize children;
@synthesize isAnimating;
@synthesize hasSplit;

- (void)setEntry:(NSDictionary *)newEntryData
{
	if (entry != newEntryData)
	{
		[entry release];
		entry = [newEntryData retain];
	}
	[self setPrimaryColor:[self randomColor]];
}

- (BGSQuadCircleView *)circle
{
	if (circle == nil)
	{
		BGSQuadCircleView *c = [[BGSQuadCircleView alloc] initWithFrame:self.bounds 
															   andColor:self.primaryColor];
		[self setCircle:c];
		[c release];
	}
	return circle;
}

- (NSMutableArray *)children
{
	if (children == nil)
	{
		NSMutableArray *c = [[NSMutableArray alloc] init];
		[self setChildren:c];
		[c release];
	}
	return children;
}

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData
{
    if (self = [super initWithFrame:frame]) 
	{
		isAnimating = hasSplit = NO;
		[self setBackgroundColor:CC_CLEAR];
		[self setEntry:entryData];
		[self addSubview:self.circle];
    }
    return self;
}
- (void)dealloc 
{
	[entry release];
	[primaryColor release];
	[circle release];
	[children release];
    [super dealloc];
}

- (UIColor *)randomColor
{
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	UIColor *c = CC_WHITE;
	if ([swatches count] > 0)
	{
		int i = arc4random()%[swatches count];
		NSDictionary *swatch = [swatches objectAtIndex:i];
		c = CC_FROM_SWATCH(swatch);		
	}
	return c;
}

- (void)split
{
	if (hasSplit) return;
	
	for (int i = 0; i < QUAD_CIRCLE_GROUP_ROWS*QUAD_CIRCLE_GROUP_COLS; i++)
	{
		int row = i/QUAD_CIRCLE_GROUP_COLS;
		int col = i%QUAD_CIRCLE_GROUP_COLS;
		BGSQuadCircleGroupView *group = [[BGSQuadCircleGroupView alloc] initWithFrame:CGRectMake(col*(self.bounds.size.width/QUAD_CIRCLE_GROUP_COLS), 
																								 row*(self.bounds.size.height/QUAD_CIRCLE_GROUP_ROWS), 
																								 self.bounds.size.width/QUAD_CIRCLE_GROUP_COLS, 
																								 self.bounds.size.height/QUAD_CIRCLE_GROUP_ROWS) 
																			 andEntry:self.entry];
		[group setParent:self];
		[self.children addObject:group];
		[self addSubview:group];
		[group release];
	}
	
	[self.circle removeFromSuperview];
	self.circle = nil;
	
	self.hasSplit = YES;
}

@end
