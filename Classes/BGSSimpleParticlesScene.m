//
//  BGSSimpleParticlesScene.m
//  Saturation
//
//  Created by Shawn Roske on 1/17/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleParticlesScene.h"
#import "SaturationAppDelegate.h"

@implementation BGSSimpleParticlesScene

- (id)init
{
	if (self = [super init])
	{
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		[bg setPosition:CGPointMake(s.width*0.5f, 
									s.height*0.5f)];
		[self addChild:bg z:0];
		[self addChild:[BGSSimpleParticlesLayer node] z:1];
	}
	return self;
}

@end

@interface BGSSimpleParticlesLayer (Private)

- (CCPointParticleSystem *)emitterForColor:(ccColor3B)color;
- (void)initEmitters;

@end


@implementation BGSSimpleParticlesLayer

- (id)init
{
	if (self = [super init])
	{
		self.isTouchEnabled = YES;
		
		lastTag = 0;
		touchLocations = CFDictionaryCreateMutable(NULL, 
												   0, 
												   &kCFTypeDictionaryKeyCallBacks, 
												   &kCFTypeDictionaryValueCallBacks);
		
		[self initEmitters];
	}
	return self;
}

- (void)dealloc
{
	CFRelease(touchLocations);
	[super dealloc];
}

- (CCPointParticleSystem *)emitterForColor:(ccColor3B)color
{
	CCPointParticleSystem *e = [[CCPointParticleSystem alloc] initWithTotalParticles:100];
	
	e.duration = -1;
	e.gravity = ccp(0, 0);
	e.angle = 0;
	e.angleVar = 360;
	e.radialAccel = 70;
	e.radialAccelVar = 10;
	e.tangentialAccel = 80;
	e.tangentialAccelVar = 0;
	e.speed = 50;
	e.speedVar = 10;
	e.posVar = CGPointZero;
	e.life = 3.0f;
	e.lifeVar = 0.3f;
	e.emissionRate = e.totalParticles/e.life;
	e.startSize = 2.0f;
	e.endSize = 40.0f;
	e.blendAdditive = NO;
	
	ccColor4F startColor4F = { color.r/255.0f, color.g/255.0f, color.b/255.0f, 1.0f };
	e.startColor = startColor4F;
	e.endColor = startColor4F;
	
	return [e autorelease];
}

- (void)initEmitters
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	SaturationAppDelegate *a = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSArray *shuffled = [[a.entry objectForKey:@"swatches"] shuffledArray];
	for (NSDictionary *swatch in shuffled)
	{
		UIColor *c = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];
		const CGFloat *components = CGColorGetComponents(c.CGColor);

		CCPointParticleSystem *emitter = [self emitterForColor:ccc3(components[0]*255, components[1]*255, components[2]*255)];
		emitter.position = ccp(s.width*0.5f, s.height*0.5f);
		[self addChild:emitter z:0 tag:lastTag++];
	}
}

#pragma mark -
#pragma mark Touch Handlers

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[CCDirector sharedDirector] isPaused]) return NO;
	
	for (UITouch *touch in touches)
	{
		CGPoint location = [touch locationInView:[touch view]];
		location.y = [[CCDirector sharedDirector] winSize].height-location.y;
		
		for (CCPointParticleSystem *emitter in self.children)
		{
			float dx = location.x-emitter.position.x;
			float dy = location.y-emitter.position.y;
			float distance = sqrt(dx*dx+dy*dy);
			if (distance <= PARTICLE_TOUCH_DISTANCE)
			{
				CGPoint tagPoint = CGPointMake(emitter.tag, 0.0f);
				if (CFDictionaryContainsKey(touchLocations, touch))
					CFDictionarySetValue(touchLocations, touch, CGPointCreateDictionaryRepresentation(tagPoint));
				else
					CFDictionaryAddValue(touchLocations, touch, CGPointCreateDictionaryRepresentation(tagPoint));
				
				continue;
			}
		}
	}
	
	return kEventHandled;
}

- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[CCDirector sharedDirector] isPaused]) return NO;
	
	for (UITouch *touch in touches)
	{
		CGPoint location = [touch locationInView:[touch view]];
		location.y = [[CCDirector sharedDirector] winSize].height-location.y;
		
		if (CFDictionaryContainsKey(touchLocations, touch))
		{
			CFDictionaryRef ref = (CFDictionaryRef)CFDictionaryGetValue(touchLocations, touch);
			CGPoint tagPoint;
			CGPointMakeWithDictionaryRepresentation(ref, &tagPoint);
			
			CCPointParticleSystem *emitter = (CCPointParticleSystem *)[self getChildByTag:(int)tagPoint.x];
			emitter.position = location;
		}
	}
	
    return kEventIgnored;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[CCDirector sharedDirector] isPaused]) return NO;
	
	for (UITouch *touch in touches)
	{
		if (CFDictionaryContainsKey(touchLocations, touch))
			CFDictionaryRemoveValue(touchLocations, touch);
	}
	
	return kEventHandled;
}

@end
