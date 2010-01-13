//
//  BGSSimpleCircleMaskLayer.m
//  Saturation
//
//  Created by Shawn Roske on 1/12/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleCircleMaskLayer.h"


@implementation BGSSimpleCircleMaskLayer

+ (id)defaultValueForKey:(NSString *)key
{
	//NSLog(@"default key: %@", key);
	return [CALayer defaultValueForKey:key];
}

- (CAAnimation *)animationForKey:(NSString *)key
{
	//NSLog(@"key: %@", key);
	return [super animationForKey:key];
}

@end
