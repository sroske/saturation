//
//  BGSSimpleSquareScene.h
//  Saturation
//
//  Created by Shawn Roske on 1/16/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FontsAndColors.h"
#import "BGSSimpleSquareSprite.h"
#import "UIColor+ColorFromHex.h"
#import "NSArray+Shuffle.h"

#define SIMPLE_SQUARE_ROWS			2
#define SIMPLE_SQUARE_COLS			3
#define SIMPLE_SQUARE_MIN_SCALE		10.0f

@interface BGSSimpleSquareScene : CCScene 
{
	// nothing
}

@end

enum
{
	kSquareSpriteSheet
};

@interface BGSSimpleSquareLayer : CCLayer 
{
	NSDictionary *coordinates;
	int lastTag;
	BOOL hasFadedIn;
}

@property (nonatomic, retain) NSDictionary *coordinates;

@end
