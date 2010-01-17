//
//  BGSSimpleCircleScene.m
//  Saturation
//
//  Created by Shawn Roske on 1/14/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleCircleScene.h"
#import "SaturationAppDelegate.h"


@implementation BGSSimpleCircleScene

- (id)init
{
	if (self = [super init])
	{
		[self addChild:[BGSSimpleCircleLayer node] z:1];
	}
	return self;
}

@end

@interface BGSSimpleCircleLayer (Private)

- (UIColor *)randomColor;
- (CGRect)rectForEntry:(int)size;
- (void)initCircles;
- (void)completedFadeIn;
- (void)duplicate:(BGSSimpleCircleSprite *)original;
- (BGSSimpleCircleSprite *)touchedSprite:(UITouch *)touch;
- (void)completedScaleAndMovement:(BGSSimpleCircleSprite *)sprite;
- (void)completedColorShift:(BGSSimpleCircleSprite *)sprite;

@end

@implementation BGSSimpleCircleLayer

@synthesize coordinates;

- (NSDictionary *)coordinates
{
	if (coordinates == nil)
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"circle-coordinates" ofType:@"plist"];
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
		[self setCoordinates:[dict objectForKey:@"frames"]];
		[dict release];
	}
	return coordinates;
}

- (CGRect)rectForEntry:(int)size
{
	NSDictionary *entry = [self.coordinates objectForKey:[NSString stringWithFormat:@"%i.png", size]];
	if (entry == nil)
		return CGRectZero;
	return CGRectMake([[entry objectForKey:@"x"] floatValue], 
					  [[entry objectForKey:@"y"] floatValue], 
					  [[entry objectForKey:@"width"] floatValue], 
					  [[entry objectForKey:@"height"] floatValue]);
}

- (UIColor *)randomColor
{
	SaturationAppDelegate *a = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *swatches = [a.entry objectForKey:@"swatches"];
	UIColor *color = CC_WHITE;
	if ([swatches count] > 0)
	{
		int i = arc4random()%[swatches count];
		NSDictionary *swatch = [swatches objectAtIndex:i];
		color = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];		
	}
	return color;
}

- (id)init
{
	if (self = [super init])
	{
		self.isTouchEnabled = YES;
		lastTag = 0;
		hasFadedIn = NO;
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		[bg setPosition:CGPointMake(s.width*0.5f, 
									s.height*0.5f)];
		[self addChild:bg z:0 tag:kBackground];
		
		[bg runAction:[CCFadeOut actionWithDuration:0.25]];
		
		CCSpriteSheet *sheet = [CCSpriteSheet spriteSheetWithFile:@"circle-spritesheet.png" capacity:5];
		[sheet.texture setAntiAliasTexParameters];
		[self addChild:sheet z:0 tag:kCircleSpriteSheet];
		
		[self initCircles];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)initCircles
{
	CCSpriteSheet *sheet = (CCSpriteSheet *) [self getChildByTag:kCircleSpriteSheet];
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	NSMutableArray *tags = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < SIMPLE_CIRCLE_ROWS*SIMPLE_CIRCLE_COLS; i++)
	{
		int row = i/SIMPLE_CIRCLE_COLS;
		int col = i%SIMPLE_CIRCLE_COLS;
		CGRect rect = CGRectMake(col*(s.width/SIMPLE_CIRCLE_COLS), 
								 row*(s.height/SIMPLE_CIRCLE_ROWS), 
								 s.width/SIMPLE_CIRCLE_COLS, 
								 s.height/SIMPLE_CIRCLE_ROWS);
		BGSSimpleCircleSprite *sprite = [BGSSimpleCircleSprite spriteWithTexture:sheet.texture 
																			rect:[self rectForEntry:rect.size.width]];
		sprite.position = CGPointMake(rect.origin.x+rect.size.width*0.5f, 
									  rect.origin.y+rect.size.height*0.5f);
		const CGFloat *components = CGColorGetComponents(CC_BACKGROUND.CGColor);
		sprite.color = ccc3(components[0]*255, components[1]*255, components[2]*255);
		
		int t = lastTag++;
		[sheet addChild:sprite z:0 tag:t];
		
		[tags addObject:[NSNumber numberWithInt:t]];
	}
	
	NSArray *shuffled = [tags shuffledArray];
	CGFloat delay = 0.3;
	
	for (NSNumber *t in shuffled)
	{
		const CGFloat *components = CGColorGetComponents([self randomColor].CGColor);
		BGSSimpleCircleSprite *sprite = (BGSSimpleCircleSprite *)[sheet getChildByTag:[t intValue]];
		[sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay], 
						   [CCEaseOut actionWithAction:[CCTintTo actionWithDuration:0.6 
																				red:components[0]*255 
																			  green:components[1]*255 
																			   blue:components[2]*255]
												  rate:0.6f], nil]];
		delay += 0.4;
	}
	
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay], 
					 [CCCallFunc actionWithTarget:self selector:@selector(completedFadeIn)], nil]];
	
	[tags release];
}

- (void)completedFadeIn
{
	hasFadedIn = YES;
	
	CCSprite *bg = (CCSprite *) [self getChildByTag:kBackground];
	[bg runAction:[CCFadeIn	actionWithDuration:0.25]];
}

- (void)duplicate:(BGSSimpleCircleSprite *)original
{
	if (original.animating) return;
	
	CCSpriteSheet *sheet = (CCSpriteSheet *) [self getChildByTag:kCircleSpriteSheet];
	
	original.animating = YES;
	CGSize new = CGSizeMake(original.contentSize.width*(original.scale*0.5f), 
							original.contentSize.height*(original.scale*0.5f));

	BGSSimpleCircleSprite *sprite2 = [BGSSimpleCircleSprite spriteWithTexture:sheet.texture 
																		 rect:original.textureRect];
	sprite2.position = original.position;
	sprite2.scale = original.scale;
	sprite2.color = original.color;
	sprite2.animating = YES;
	[sheet addChild:sprite2 z:0 tag:lastTag++];

	BGSSimpleCircleSprite *sprite3 = [BGSSimpleCircleSprite spriteWithTexture:sheet.texture 
																		 rect:original.textureRect];
	sprite3.position = original.position;
	sprite3.scale = original.scale;
	sprite3.color = original.color;
	sprite3.animating = YES;
	[sheet addChild:sprite3 z:0 tag:lastTag++];
	
	BGSSimpleCircleSprite *sprite4 = [BGSSimpleCircleSprite spriteWithTexture:sheet.texture 
																		 rect:original.textureRect];
	sprite4.position = original.position;
	sprite4.scale = original.scale;
	sprite4.color = original.color;
	sprite4.animating = YES;
	[sheet addChild:sprite4 z:0 tag:lastTag++];
	
	[original runAction:[CCScaleBy actionWithDuration:0.5f 
												scale:0.5f]];
	[original runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.5 
																position:CGPointMake(-new.width*0.5f, new.height*0.5f)],
						 [CCCallFuncN actionWithTarget:self 
											  selector:@selector(completedScaleAndMovement:)], nil]];
	
	[sprite2 runAction:[CCScaleBy actionWithDuration:0.5f 
											   scale:0.5f]];
	[sprite2 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.5 
															   position:CGPointMake(new.width*0.5f, new.height*0.5f)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil]];
	
	[sprite3 runAction:[CCScaleBy actionWithDuration:0.5f 
											   scale:0.5f]];
	[sprite3 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.5 
															   position:CGPointMake(-new.width*0.5f, -new.height*0.5f)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil]];
	
	[sprite4 runAction:[CCScaleBy actionWithDuration:0.5f 
											   scale:0.5f]];
	[sprite4 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.5 
															   position:CGPointMake(new.width*0.5f, -new.height*0.5f)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil]];
}

- (void)completedScaleAndMovement:(BGSSimpleCircleSprite *)sprite
{
	CGSize s = CGSizeMake(sprite.contentSize.width*sprite.scale, 
						  sprite.contentSize.height*sprite.scale);
	[sprite setTextureRect:[self rectForEntry:s.width]];
	[sprite setScale:1.0f];
	const CGFloat *components = CGColorGetComponents([self randomColor].CGColor);
	[sprite runAction:[CCSequence actions:[CCEaseOut actionWithAction:[CCTintTo actionWithDuration:0.5 
																							   red:components[0]*255 
																							 green:components[1]*255 
																							  blue:components[2]*255] 
																 rate:0.5f],
					   [CCCallFuncN actionWithTarget:self 
											selector:@selector(completedColorShift:)], nil]];
}

- (void)completedColorShift:(BGSSimpleCircleSprite *)sprite
{
	sprite.animating = NO;
}

#pragma mark -
#pragma mark Touch Handlers

- (BGSSimpleCircleSprite *)touchedSprite:(UITouch *)touch
{
	CCSpriteSheet *sheet = (CCSpriteSheet *) [self getChildByTag:kCircleSpriteSheet];
	CGPoint point = [touch locationInView:[touch view]];
	point.y = [[CCDirector sharedDirector] winSize].height-point.y;
	for (BGSSimpleCircleSprite *sprite in sheet.children)
	{
		if (sprite.contentSize.width <= SIMPLE_CIRCLE_MIN_SCALE) continue;
		CGSize spriteSize = CGSizeMake(sprite.contentSize.width*sprite.scaleX, 
									   sprite.contentSize.height*sprite.scaleY);
		CGRect spriteRect = CGRectMake(sprite.position.x-spriteSize.width*0.5f, 
									   sprite.position.y-spriteSize.height*0.5f, 
									   spriteSize.width,
									   spriteSize.height);
		if (CGRectContainsPoint(spriteRect, point))
			return sprite;
	}
	return nil;
}

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!hasFadedIn || [[CCDirector sharedDirector] isPaused]) return NO;

	for (UITouch *touch in touches)
	{
		BGSSimpleCircleSprite *sprite = [self touchedSprite:touch];
		if (sprite != nil)
		{
			[self duplicate:sprite];
			return kEventHandled;
		}
	}
	return NO;
}

- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!hasFadedIn || [[CCDirector sharedDirector] isPaused]) return NO;
	
	for (UITouch *touch in touches)
	{
		BGSSimpleCircleSprite *sprite = [self touchedSprite:touch];
		if (sprite != nil)
		{
			[self duplicate:sprite];
			return kEventHandled;
		}
	}
	return NO;
}

@end

