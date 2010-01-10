//
//  BGSQuadSquareVisualizer.m
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSQuadSquareVisualizer.h"

@interface BGSQuadSquareVisualizer (Private)

- (void)loadLayers;
- (UIColor *)randomColor;
- (void)dupeLayer:(CALayer *)original;
- (CABasicAnimation *)slideAnimFrom:(CGPoint)from to:(CGPoint)to withDelay:(float)delay;

@end


@implementation BGSQuadSquareVisualizer

@synthesize entry;

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData
{
    if (self = [super initWithFrame:frame]) 
	{
		fadedInCount = 0;
		isFadingIn = hasAnimated = NO;
		[self setEntry:entryData];
		[self loadLayers];
    }
    return self;
}

- (void)dealloc 
{
	[entry release];
    [super dealloc];
}

- (void)loadLayers
{	
	for (int i = 0; i < ROWS*COLS; i++)
	{
		int row = i/COLS;
		int col = i%COLS;
		CALayer *square = [CALayer layer];
		[square setFrame:CGRectMake(col*(self.bounds.size.width/COLS), 
									row*(self.bounds.size.height/ROWS), 
									self.bounds.size.width/COLS, 
									self.bounds.size.height/ROWS)];
		[square setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[square setBackgroundColor:CC_BACKGROUND.CGColor];
		[self.layer addSublayer:square];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	if (!hasAnimated)
	{
		if (animated)
		{
			isFadingIn = YES;
			
			CGFloat delay = 0.3;
			NSArray *squares = [self.layer.sublayers shuffledArray];
			for (CALayer *s in squares)
			{	
				CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
				animation.toValue = (id)[self randomColor].CGColor;
				animation.fillMode = kCAFillModeForwards;
				animation.removedOnCompletion = NO;
				animation.beginTime = CACurrentMediaTime()+delay;
				animation.duration = 0.6;
				animation.delegate = self;
				
				[s addAnimation:animation forKey:@"colorFadeIn"];
				
				delay += 0.4f;
			}		
		}
		else 
		{
			for (CALayer *s in self.layer.sublayers)
				[s setHidden:NO];
			isFadingIn = NO;
			hasAnimated = YES;
		}		
	}
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
	if ([anim.keyPath isEqualToString:@"backgroundColor"])
	{
		fadedInCount++;
		if (fadedInCount >= [self.layer.sublayers count])
		{
			isFadingIn = NO;
			hasAnimated = YES;		
		}	
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	// nothing
}

- (UIColor *)randomColor
{
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	UIColor *color = CC_WHITE;
	if ([swatches count] > 0)
	{
		int i = arc4random()%[swatches count];
		NSDictionary *swatch = [swatches objectAtIndex:i];
		color = CC_FROM_SWATCH(swatch);		
	}
	return color;
}

- (void)dupeLayer:(CALayer *)original
{	
	if (original.frame.size.width <= CUTOFF) return;
	
	CGSize size = CGSizeMake(original.frame.size.width/2, original.frame.size.height/2);
	CGRect rect = CGRectMake(original.frame.origin.x+size.width, 
							 original.frame.origin.y+size.height, 
							 size.width, 
							 size.height);
	
	CALayer *square4 = [CALayer layer];
	[square4 setBackgroundColor:[self randomColor].CGColor];
	[square4 setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[square4 setFrame:rect];
	[self.layer addSublayer:square4];
	
	CALayer *square3 = [CALayer layer];
	[square3 setBackgroundColor:[self randomColor].CGColor];
	[square3 setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[square3 setFrame:rect];
	[self.layer addSublayer:square3];
	
	CALayer *square2 = [CALayer layer];
	[square2 setBackgroundColor:[self randomColor].CGColor];
	[square2 setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[square2 setFrame:rect];
	[self.layer addSublayer:square2];
	
	CALayer *square1 = [CALayer layer];
	[square1 setBackgroundColor:(CGColorRef)[original valueForKey:@"backgroundColor"]];
	[square1 setAnchorPoint:CGPointMake(0.5f, 0.5f)];
	[square1 setFrame:rect];
	[self.layer addSublayer:square1];
	 
	CABasicAnimation *sq2Anim1 = [self slideAnimFrom:square1.position 
												  to:CGPointMake(square1.position.x-size.width, square1.position.y) 
										   withDelay:0.0f];
	[square2 addAnimation:sq2Anim1 forKey:@"sq2Anim1"];
	
	CABasicAnimation *sq3Anim1 = [self slideAnimFrom:square1.position 
												  to:CGPointMake(square1.position.x-size.width, square1.position.y) 
										   withDelay:0.0f];
	[sq3Anim1 setRemovedOnCompletion:YES];
	[square3 addAnimation:sq3Anim1 forKey:@"sq3Anim1"];
	
	CABasicAnimation *sq4Anim1 = [self slideAnimFrom:square1.position 
												  to:CGPointMake(square1.position.x-size.width, square1.position.y) 
										   withDelay:0.0f];
	[sq4Anim1 setRemovedOnCompletion:YES];
	[square4 addAnimation:sq4Anim1 forKey:@"sq4Anim1"];
	
	CABasicAnimation *sq3Anim2 = [self slideAnimFrom:CGPointMake(square1.position.x-size.width, square1.position.y)  
												  to:CGPointMake(square1.position.x-size.width, square1.position.y-size.height) 
										   withDelay:0.25f];
	[square3 addAnimation:sq3Anim2 forKey:@"sq3Anim2"];
	
	CABasicAnimation *sq4Anim2 = [self slideAnimFrom:CGPointMake(square1.position.x-size.width, square1.position.y)  
												  to:CGPointMake(square1.position.x-size.width, square1.position.y-size.height) 
										   withDelay:0.25f];
	[sq4Anim2 setRemovedOnCompletion:YES];
	[square4 addAnimation:sq4Anim2 forKey:@"sq4Anim2"];
	
	CABasicAnimation *sq4Anim3 = [self slideAnimFrom:CGPointMake(square1.position.x-size.width, square1.position.y-size.height) 
												  to:CGPointMake(square1.position.x, square1.position.y-size.height) 
										   withDelay:0.50f];
	[square4 addAnimation:sq4Anim3 forKey:@"sq4Anim3"];
}

- (CABasicAnimation *)slideAnimFrom:(CGPoint)from to:(CGPoint)to withDelay:(float)delay
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
	anim.fromValue = [NSValue valueWithCGPoint:from];
	anim.toValue = [NSValue valueWithCGPoint:to];
	anim.fillMode = kCAFillModeForwards;
	anim.removedOnCompletion = NO;
	anim.duration = 0.25;
	if (delay > 0.0f)
		anim.beginTime = CACurrentMediaTime()+delay;
	return anim;
}

#pragma mark -
#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isFadingIn) return;
	
	for (UITouch *touch in touches)
	{
		CGPoint point = [touch locationInView:self];
		point = [self.layer convertPoint:point toLayer:self.layer.superlayer];
		CALayer *hit = [self.layer hitTest:point];
		NSLog(@"hit: %@", hit);
		if (hit != nil && hit != self.layer)
			[self dupeLayer:hit];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isFadingIn) return;
	
	for (UITouch *touch in touches)
	{
		CGPoint point = [touch locationInView:self];
		CALayer *hit = [self.layer hitTest:point];
		if (hit != nil)
			[self dupeLayer:hit];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// nothing
}

@end
