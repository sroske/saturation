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
	NSString *scope;
	NSString *feedType;
}

@property (nonatomic, retain) BGSKulerParser *parser;
@property (nonatomic, retain) NSString *scope;
@property (nonatomic, retain) NSString *feedType;

- (id)initWithURL:(NSURL *)u scope:(NSString *)s andFeedType:(NSString *)ft;

@end
