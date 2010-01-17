//
//  BGSSimpleSquareSprite.h
//  Saturation
//
//  Created by Shawn Roske on 1/16/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BGSSimpleSquareSprite : CCSprite 
{
	BOOL animating;
}

@property (nonatomic, assign) BOOL animating;

@end
