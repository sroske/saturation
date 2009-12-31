//
//  BGSKulerOperation.h
//  Saturation
//
//  Created by Shawn Roske on 12/30/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGSKulerParser.h"

@interface BGSKulerOperation : NSOperation 
{
	BGSKulerParser *parser;
	int scope;
	int feedType;
}

@property (nonatomic, retain) BGSKulerParser *parser;
@property (nonatomic, assign) int scope;
@property (nonatomic, assign) int feedType;

- (id)initWithURL:(NSURL *)u scope:(int)s andFeedType:(int)ft;

@end
