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
- (ccColor3B)randomColorNot:(ccColor3B)skipColor;
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

- (ccColor3B)randomColorNot:(ccColor3B)skipColor
{
	SaturationAppDelegate *a = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *swatches = [a.entry objectForKey:@"swatches"];
	ccColor3B color = ccWHITE;
	if ([swatches count] > 0)
	{
		do 
		{
			int i = arc4random()%[swatches count];
			NSDictionary *swatch = [swatches objectAtIndex:i];
			UIColor *c = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];
			const CGFloat *components = CGColorGetComponents(c.CGColor);
			color = ccc3(components[0]*255, components[1]*255, components[2]*255);
		} 
		while (color.r == skipColor.r && color.g == skipColor.g && color.b == skipColor.b);
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
		sprite.color = [self randomColorNot:ccBLACK];
		
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
	
	[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay], 
					 [CCCallFunc actionWithTarget:self selector:@selector(completedFadeIn)], nil]];
	
	[tags release];
}

- (void)completedFadeIn
{
	hasFadedIn = YES;
}

- (int)indexForPosition:(int)position startIndex:(int)start andDirection:(int)direction
{
	int temp = position+start*direction;
	if (temp > 3)
		temp -= 4;
	if (temp < 0)
		temp += 4;
	return temp;
}

- (void)duplicate:(BGSSimpleSquareSprite *)original
{
	if (original.animating) return;
	
	original.animating = YES;
	
	BGSSimpleSquareSprite *sheet = (BGSSimpleSquareSprite *) [self getChildByTag:kSquareSpriteSheet];
	
	CGSize new = CGSizeMake(original.contentSize.width*(original.scale*0.5f), 
							original.contentSize.height*(original.scale*0.5f));
	CGRect textureRect = [self rectForEntry:@"square.png"];
	
	CGPoint quads[4];
	quads[0] = CGPointMake(1.0f, 1.0f);
	quads[1] = CGPointMake(-1.0f, 1.0f);
	quads[2] = CGPointMake(-1.0f, -1.0f);
	quads[3] = CGPointMake(1.0f, -1.0f);
	
	int si = arc4random()%4;
	int d = arc4random()%100 >= 50 ? 1 : -1;
	
	for (int i = 0; i < 4; i++)
	{
		BGSSimpleSquareSprite *sprite = [BGSSimpleSquareSprite spriteWithTexture:sheet.texture 
																			rect:textureRect];
		sprite.scale = original.scale*0.5f;
		sprite.position = CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:0 startIndex:si andDirection:d]].x, 
									  original.position.y+(new.height*0.5f)*quads[[self indexForPosition:0 startIndex:si andDirection:d]].y);
		if (i == 3)
			sprite.color = original.color;
		else
		{
			sprite.animating = YES;
			sprite.color = [self randomColorNot:original.color];
		}
		[sheet addChild:sprite z:0 tag:lastTag++];
		
		id sequence = nil;
		if (i == 0)
		{
			sequence = [CCSequence actions:
						[CCMoveTo actionWithDuration:0.25 position:CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:1 startIndex:si andDirection:d]].x, 
																			   original.position.y+(new.height*0.5f)*quads[[self indexForPosition:1 startIndex:si andDirection:d]].y)],
						[CCMoveTo actionWithDuration:0.25 position:CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:2 startIndex:si andDirection:d]].x, 
																			   original.position.y+(new.height*0.5f)*quads[[self indexForPosition:2 startIndex:si andDirection:d]].y)],
						[CCMoveTo actionWithDuration:0.25 position:CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:3 startIndex:si andDirection:d]].x, 
																			   original.position.y+(new.height*0.5f)*quads[[self indexForPosition:3 startIndex:si andDirection:d]].y)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil];
		}
		else if (i == 1)
		{
			sequence = [CCSequence actions:
						[CCMoveTo actionWithDuration:0.25 position:CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:1 startIndex:si andDirection:d]].x, 
																			   original.position.y+(new.height*0.5f)*quads[[self indexForPosition:1 startIndex:si andDirection:d]].y)],
						[CCMoveTo actionWithDuration:0.25 position:CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:2 startIndex:si andDirection:d]].x, 
																			   original.position.y+(new.height*0.5f)*quads[[self indexForPosition:2 startIndex:si andDirection:d]].y)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil];
		}
		else if (i == 2)
		{
			sequence = [CCSequence actions:
						[CCMoveTo actionWithDuration:0.25 position:CGPointMake(original.position.x+(new.width*0.5f)*quads[[self indexForPosition:1 startIndex:si andDirection:d]].x, 
																			   original.position.y+(new.height*0.5f)*quads[[self indexForPosition:1 startIndex:si andDirection:d]].y)],
						[CCCallFuncN actionWithTarget:self 
											 selector:@selector(completedScaleAndMovement:)], nil];
		}
		if (sequence != nil)
			[sprite runAction:sequence];
	}

	[original runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.75],
						 [CCCallFuncN actionWithTarget:self 
											  selector:@selector(cleanupOriginal:)], nil]];	
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

