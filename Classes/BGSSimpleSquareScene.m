//
//  BGSSimpleSquareScene.m
//  Saturation
//
//  Created by Shawn Roske on 1/16/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleSquareScene.h"
#import "SaturationAppDelegate.h"


@implementation BGSSimpleSquareScene

- (id)init
{
	if (self = [super init])
	{
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		[bg setPosition:CGPointMake(s.width*0.5f, 
									s.height*0.5f)];
		[self addChild:bg z:0];
		[self addChild:[BGSSimpleSquareLayer node] z:0];
	}
	return self;
}

@end

@interface BGSSimpleSquareLayer (Private)

- (NSDictionary *)coordinates;
- (CGRect)rectForEntry:(NSString *)filename;
- (UIColor *)randomColor;
- (void)initSquares;
- (void)duplicate:(BGSSimpleSquareSprite *)original;
- (void)completedScaleAndMovement:(CCSprite *)sprite;
- (void)cleanupOriginal:(BGSSimpleSquareSprite *)original;
- (BGSSimpleSquareSprite *)touchedSprite:(UITouch *)touch;

@end


@implementation BGSSimpleSquareLayer

@synthesize coordinates;

- (NSDictionary *)coordinates
{
	if (coordinates == nil)
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"square-coordinates" ofType:@"plist"];
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
		[self setCoordinates:[dict objectForKey:@"frames"]];
		[dict release];
	}
	return coordinates;
}

- (CGRect)rectForEntry:(NSString *)filename
{
	NSDictionary *entry = [self.coordinates objectForKey:filename];
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
		
		CCSpriteSheet *sheet = [CCSpriteSheet spriteSheetWithFile:@"square-spritesheet.png" capacity:1];
		[sheet.texture setAntiAliasTexParameters];
		[self addChild:sheet z:0 tag:kSquareSpriteSheet];
		
		[self initSquares];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)initSquares
{
	CCSpriteSheet *sheet = (CCSpriteSheet *) [self getChildByTag:kSquareSpriteSheet];
	CGSize s = [[CCDirector sharedDirector] winSize];
	CGRect textureRect = [self rectForEntry:@"square.png"];
	
	NSMutableArray *tags = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < SIMPLE_SQUARE_ROWS*SIMPLE_SQUARE_COLS; i++)
	{
		int row = i/SIMPLE_SQUARE_COLS;
		int col = i%SIMPLE_SQUARE_COLS;
		CGRect rect = CGRectMake(col*(s.width/SIMPLE_SQUARE_COLS), 
								 row*(s.height/SIMPLE_SQUARE_ROWS), 
								 s.width/SIMPLE_SQUARE_COLS, 
								 s.height/SIMPLE_SQUARE_ROWS);
		BGSSimpleSquareSprite *sprite = [BGSSimpleSquareSprite spriteWithTexture:sheet.texture 
																			rect:textureRect];
		sprite.visible = NO;
		sprite.position = CGPointMake(rect.origin.x+rect.size.width*0.5f, 
									  rect.origin.y+rect.size.height*0.5f);
		const CGFloat *components = CGColorGetComponents([self randomColor].CGColor);
		sprite.color = ccc3(components[0]*255, components[1]*255, components[2]*255);
		
		int t = lastTag++;
		[sheet addChild:sprite z:0 tag:t];
		
		[tags addObject:[NSNumber numberWithInt:t]];
	}
	
	NSArray *shuffled = [tags shuffledArray];
	CGFloat delay = 0.3;
	
	for (NSNumber *t in shuffled)
	{
		BGSSimpleSquareSprite *sprite = (BGSSimpleSquareSprite *)[sheet getChildByTag:[t intValue]];
		
		CGPoint destination = sprite.position;
		CGPoint point = sprite.position;
		
		if (point.y >= s.height/SIMPLE_SQUARE_ROWS)
			point.y += sprite.contentSize.height;
		else
			point.y -= sprite.contentSize.height;
		
		if (arc4random()%100 > 50)
		{
			if (point.x < s.width/SIMPLE_SQUARE_COLS)
			{
				point.x -= sprite.contentSize.width;
				point.y = sprite.position.y;
			}
			else if (point.x >= s.width-s.width/SIMPLE_SQUARE_COLS)
			{
				point.x += sprite.contentSize.width;
				point.y = sprite.position.y;
			}
		}
		
		sprite.position = point;
		sprite.visible = YES;
		[sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay], 
						   [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:0.6 
																		   position:destination] rate:0.6], nil]];
		delay += 0.4;
	}
	
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay+0.6], 
					 [CCCallFunc actionWithTarget:self selector:@selector(completedFadeIn)], nil]];
	
	[tags release];
}

- (void)completedFadeIn
{
	hasFadedIn = YES;
}

- (void)duplicate:(BGSSimpleSquareSprite *)original
{
	if (original.animating) return;
	
	BGSSimpleSquareSprite *sheet = (BGSSimpleSquareSprite *) [self getChildByTag:kSquareSpriteSheet];
	
	original.animating = YES;
	CGSize new = CGSizeMake(original.contentSize.width*(original.scale*0.5f), 
							original.contentSize.height*(original.scale*0.5f));
	CGRect textureRect = [self rectForEntry:@"square.png"];
	CGPoint origin = CGPointMake(original.position.x+new.width*0.5f, 
								 original.position.y+new.height*0.5f);
	
	BGSSimpleSquareSprite *sprite4 = [BGSSimpleSquareSprite spriteWithTexture:sheet.texture 
																		 rect:textureRect];
	sprite4.position = origin;
	sprite4.scale = original.scale*0.5f;
	const CGFloat *components4 = CGColorGetComponents([self randomColor].CGColor);
	sprite4.color = ccc3(components4[0]*255, 
						 components4[1]*255, 
						 components4[2]*255);
	sprite4.animating = YES;
	[sheet addChild:sprite4 z:0 tag:lastTag++];
	
	BGSSimpleSquareSprite *sprite3 = [BGSSimpleSquareSprite spriteWithTexture:sheet.texture 
																		 rect:textureRect];
	sprite3.position = origin;
	sprite3.scale = original.scale*0.5f;
	const CGFloat *components3 = CGColorGetComponents([self randomColor].CGColor);
	sprite3.color = ccc3(components3[0]*255, 
						 components3[1]*255, 
						 components3[2]*255);
	sprite3.animating = YES;
	[sheet addChild:sprite3 z:0 tag:lastTag++];
	
	BGSSimpleSquareSprite *sprite2 = [BGSSimpleSquareSprite spriteWithTexture:sheet.texture 
																		 rect:textureRect];
	sprite2.position = origin;
	sprite2.scale = original.scale*0.5f;
	const CGFloat *components2 = CGColorGetComponents([self randomColor].CGColor);
	sprite2.color = ccc3(components2[0]*255, 
						 components2[1]*255, 
						 components2[2]*255);
	sprite2.animating = YES;
	[sheet addChild:sprite2 z:0 tag:lastTag++];
	
	BGSSimpleSquareSprite *sprite1 = [BGSSimpleSquareSprite spriteWithTexture:sheet.texture 
																		 rect:textureRect];
	sprite1.position = origin;
	sprite1.scale = original.scale*0.5f;
	sprite1.color = original.color;
	sprite1.animating = YES;
	[sheet addChild:sprite1 z:0 tag:lastTag++];

	[original runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.75],
						 [CCCallFuncN actionWithTarget:self 
											  selector:@selector(cleanupOriginal:)], nil]];	
	
	[sprite2 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.25 
															   position:CGPointMake(-new.width, 0.0f)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil]];
	
	[sprite3 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.25 
															   position:CGPointMake(-new.width, 0.0f)],
						[CCMoveBy actionWithDuration:0.25 
											position:CGPointMake(0.0f, -new.height)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil]];
	
	[sprite4 runAction:[CCSequence actions:[CCMoveBy actionWithDuration:0.25 
															   position:CGPointMake(-new.width, 0.0f)],
						[CCMoveBy actionWithDuration:0.25 
											position:CGPointMake(0.0f, -new.height)],
						[CCMoveBy actionWithDuration:0.25 
											position:CGPointMake(new.width, 0.0f)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil]];
}

- (void)completedScaleAndMovement:(BGSSimpleSquareSprite *)sprite
{
	sprite.animating = NO;
}

- (void)cleanupOriginal:(BGSSimpleSquareSprite *)original
{
	BGSSimpleSquareSprite *sheet = (BGSSimpleSquareSprite *) [self getChildByTag:kSquareSpriteSheet];
	[sheet removeChild:original cleanup:YES];
}

#pragma mark -
#pragma mark Touch Handlers

- (BGSSimpleSquareSprite *)touchedSprite:(UITouch *)touch
{
	CCSpriteSheet *sheet = (CCSpriteSheet *) [self getChildByTag:kSquareSpriteSheet];
	CGPoint point = [touch locationInView:[touch view]];
	point.y = [[CCDirector sharedDirector] winSize].height-point.y;
	for (BGSSimpleSquareSprite *sprite in sheet.children)
	{
		if (sprite.contentSize.width*sprite.scale <= SIMPLE_SQUARE_MIN_SCALE) continue;
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
		BGSSimpleSquareSprite *sprite = [self touchedSprite:touch];
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
		BGSSimpleSquareSprite *sprite = [self touchedSprite:touch];
		if (sprite != nil)
		{
			[self duplicate:sprite];
			return kEventHandled;
		}
	}
	return NO;
}

@end

