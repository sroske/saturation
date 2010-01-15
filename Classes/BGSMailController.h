//
//  BGSMailController.h
//  Saturation
//
//  Created by Shawn Roske on 1/14/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "FontsAndColors.h"
#import "UIColor+ColorFromHex.h"

@interface BGSMailController : NSObject
{
	NSDictionary *entry;
	MFMailComposeViewController *mailer;
	NSString *bodyHTMLTemplate;
	NSString *swatchHTMLTemplate;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) MFMailComposeViewController *mailer;
@property (nonatomic, retain) NSString *bodyHTMLTemplate;
@property (nonatomic, retain) NSString *swatchHTMLTemplate;

- (id)initWithEntry:(NSDictionary *)entryData;

@end
