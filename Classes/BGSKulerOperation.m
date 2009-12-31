//
//  BGSKulerOperation.m
//  Saturation
//
//  Created by Shawn Roske on 12/30/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSKulerOperation.h"


@implementation BGSKulerOperation

@synthesize parser;
@synthesize scope;
@synthesize feedType;

- (id)initWithURL:(NSURL *)u scope:(NSString *)s andFeedType:(NSString *)ft;
{
	if (self = [super init])
	{
		BGSKulerParser *p = [[BGSKulerParser alloc] initWithURL:u];
		[self setParser:p];
		[p release];
		
		self.scope = s;
		self.feedType = ft;
	}
	return self;
}

- (void)dealloc
{
	[parser release];
	[scope release];
	[feedType release];
	[super dealloc];
}

- (void)main 
{
	if (self.parser.url == nil || self.scope == nil || self.feedType == nil) return;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.fetch.started" 
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"scope", self.scope, 
																@"feedType", self.feedType, nil]];
	
    if (self.isCancelled) return;
	[self.parser fetch];
	
    if (self.isCancelled) return;
	[self.parser parse];
	
	if (self.isCancelled) return;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.fetch.completed" 
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.parser.entries, @"entries", 
																self.scope, @"scope", 
																self.feedType, @"feedType", nil]];
}

@end
