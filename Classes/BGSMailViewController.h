//
//  BGSMailViewController.h
//  Saturation
//
//  Created by Shawn Roske on 1/22/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FontsAndColors.h"
#import "UIColor+ColorFromHex.h"


@interface BGSMailViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
	UIImageView *background;
	NSDictionary *entry;
	MFMailComposeViewController *mailer;
	NSString *bodyHTMLTemplate;
	NSString *swatchHTMLTemplate;
}

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) MFMailComposeViewController *mailer;
@property (nonatomic, retain) NSString *bodyHTMLTemplate;
@property (nonatomic, retain) NSString *swatchHTMLTemplate;

- (id)initWithEntry:(NSDictionary *)entryData;

- (BOOL)canSendMail;

@end
