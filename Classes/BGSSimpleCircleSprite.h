//
//  BGSSimpleCircleSprite.h
//  Saturation
//
//  Created by Shawn Roske on 1/15/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BGSSimpleCircleSprite : CCSprite 
{
	BOOL animating;
}

@property (nonatomic, assign) BOOL animating;

@end
