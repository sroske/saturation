//
//  BGSSimpleParticlesScene.m
//  Saturation
//
//  Created by Shawn Roske on 1/17/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleParticlesScene.h"


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

@implementation BGSSimpleParticlesLayer

@end
