//
//  BGSMainScene.m
//  Saturation
//
//  Created by Shawn Roske on 1/14/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSMainScene.h"


@implementation BGSMainScene

- (id)init
{
	if (self = [super init])
	{
		[self addChild:[BGSMainLayer node] z:0];
	}
	return self;
}

@end

@implementation BGSMainLayer

- (id)init
{
	if (self = [super init])
	{
		CGSize s = [[CCDirector sharedDirector] winSize];
		CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		[bg setPosition:CGPointMake(s.width*0.5f, 
									s.height*0.5f)];
		[self addChild:bg z:0];
	}
	return self;
}

@end

