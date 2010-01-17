//
//  BGSSimpleCircleScene.h
//  Saturation
//
//  Created by Shawn Roske on 1/14/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FontsAndColors.h"
#import "BGSSimpleCircleSprite.h"
#import "UIColor+ColorFromHex.h"
#import "NSArray+Shuffle.h"

#define SIMPLE_CIRCLE_ROWS			2
#define SIMPLE_CIRCLE_COLS			3
#define SIMPLE_CIRCLE_MIN_SCALE		10.0f

@interface BGSSimpleCircleScene : CCScene
{
	// nothing
}

@end

enum 
{
	kCircleSpriteSheet, kBackground
};

@interface BGSSimpleCircleLayer : CCLayer
{
	NSDictionary *coordinates;
	int lastTag;
	BOOL hasFadedIn;
}

@property (nonatomic, retain) NSDictionary *coordinates;

@end