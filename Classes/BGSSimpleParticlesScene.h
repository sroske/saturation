//
//  BGSSimpleParticlesScene.h
//  Saturation
//
//  Created by Shawn Roske on 1/17/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NSArray+Shuffle.h"

@interface BGSSimpleParticlesScene : CCScene 
{
	// nothing
}

@end

#define PARTICLE_TOUCH_DISTANCE	100.0f

@interface BGSSimpleParticlesLayer : CCLayer
{
	int lastTag;
	CFMutableDictionaryRef touchLocations;
}

@end

