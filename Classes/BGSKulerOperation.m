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

- (id)initWithURL:(NSURL *)u scope:(int)s andFeedType:(int)ft;
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
	[super dealloc];
}

- (void)main 
{
	if (self.parser.url == nil) return;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.fetch.started" 
														object:self
													  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.parser.url, @"url",
																[NSNumber numberWithInt:self.scope], @"scope", 
																[NSNumber numberWithInt:self.feedType], @"feedType", nil]];
	
    if (self.isCancelled)
	{
		NSLog(@"cancelled before fetch, exiting");
		return;
	}
	
	[self.parser fetch];
	
    if (self.isCancelled)
	{
		NSLog(@"cancelled before parse, exiting");
		return;
	}
	
	[self.parser parse];
	
	if (!self.isCancelled)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"kuler.fetch.completed" 
															object:self
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.parser.entries, @"entries", 
																	[NSNumber numberWithInt:self.scope], @"scope", 
																	[NSNumber numberWithInt:self.feedType], @"feedType", nil]];		
	}
}

@end
