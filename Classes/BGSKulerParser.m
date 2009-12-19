//
//  BGSKulerParser.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSKulerParser.h"

@interface BGSKulerParser (Private)

- (UIColor *)colorForHex:(NSString *)hexColor;

@end


@implementation BGSKulerParser

@synthesize xml;
@synthesize element;
@synthesize entries;
@synthesize entry;
@synthesize swatch;

- (NSMutableArray *)entries
{
	if (entries == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setEntries:a];
		[a release];
	}
	return entries;
}

- (NSMutableDictionary *)entry
{
	if (entry == nil)
	{
		NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
		[self setEntry:d];
		[d release];
	}
	return entry;
}

- (NSArray *)fetchEntriesFromURL:(NSString *)url
{
	NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	[p setDelegate:self];
	[p setShouldProcessNamespaces:NO];
	[p setShouldReportNamespacePrefixes:NO];
	[p setShouldResolveExternalEntities:NO];
	[self setXml:p];
	[p release];
	
	[self.xml parse];
	
	return [[self.entries copy] autorelease];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser 
{
	// nothing
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError 
{
	NSLog(@"error parsing XML: %@", [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i )", [parseError code]]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"kuler:swatch"])
	{
		NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
		[self setSwatch:d];
		[d release];
	}
	else if ([elementName isEqualToString:@"item"]) 
	{
		self.entry = nil;
		
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self.entry setValue:a forKey:@"swatches"];
		[a release];
	}
	[self setElement:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{	
	if ([elementName isEqualToString:@"kuler:swatch"])
	{
		NSMutableArray *swatches = [self.entry objectForKey:@"swatches"];
		[swatches addObject:self.swatch];
		[self setSwatch:nil];
	}
	else if ([elementName isEqualToString:@"item"]) 
	{
		[self.entries addObject:[self.entry copy]];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{	
	if ([self.element hasPrefix:@"kuler:"])
	{
		NSMutableString *key = [[NSMutableString alloc] initWithString:self.element];
		[key replaceOccurrencesOfString:@"kuler:" withString:@"" options:0 range:NSMakeRange(0, [key length])];
		
		if (self.swatch != nil)
			[self.swatch setValue:string forKey:key];
		else 
			[self.entry setValue:string forKey:key];
		
		[key release];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	// nothing
}

- (void)dealloc
{
	[xml release];
	[element release];
	[entries release];
	[entry release];
	[swatch release];
	[super dealloc];
}

@end
