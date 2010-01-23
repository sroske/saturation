//
//  BGSListViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSListViewController.h"
#import "SaturationAppDelegate.h"

@interface BGSListViewController (Private)

- (void)changeSection:(id)sender;
- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse;
- (void)fullRefreshEntries:(id)sender;
- (NSArray *)selectedEntries;

-(void)fetchStarted:(NSNotification *)notice;
-(void)fetchCompleted:(NSNotification *)notice;

@end


@implementation BGSListViewController

@synthesize background;
@synthesize closeButton;
@synthesize tableView;
@synthesize refreshView;
@synthesize loadingView;
@synthesize footerView;
@synthesize feed;
@synthesize newestButton;
@synthesize popularButton;
@synthesize randomButton;
@synthesize favoritesButton;
@synthesize seperator;

- (UIImageView *)background
{
	if (background == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setBackground:iv];
		[iv release];
	}
	return background;
}

- (UIButton *)closeButton
{
	if (closeButton == nil)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setShowsTouchWhenHighlighted:YES];
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-close.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[btn setImage:i forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
		[btn setFrame:CGRectMake(self.view.bounds.size.width-40.0f, 
								 -2.0f, 
								 42.0f, 
								 42.0f)];
		[self setCloseButton:btn];
		[btn release];
	}
	return closeButton;
}

- (void)close:(id)sender
{
	SaturationAppDelegate *ad = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[ad closeListView];
}

- (BGSKulerFeedController *)feed
{
	if (feed == nil)
	{
		BGSKulerFeedController *c = [[BGSKulerFeedController alloc] init];
		[self setFeed:c];
		[c release];
	}
	return feed;
}

- (BGSSectionButton *)newestButton
{
	if (newestButton == nil)
	{
		BGSSectionButton *b = [[BGSSectionButton alloc] initWithFrame:CGRectMake(14.0f, 
																				 0.0f, 
																				 70.0f, 
																				 40.0f)];
		[b.label setText:@"newest"];
		[b addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchDown];
		[self setNewestButton:b];
		[b release];
	}
	return newestButton;
}

- (BGSSectionButton *)popularButton
{
	if (popularButton == nil)
	{
		BGSSectionButton *b = [[BGSSectionButton alloc] initWithFrame:CGRectMake(floor(self.newestButton.frame.origin.x+self.newestButton.frame.size.width+14.0f), 
																				 self.newestButton.frame.origin.y, 
																				 120.0f, 
																				 40.0f)];
		[b.label setText:@"most popular"];
		[b addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchDown];
		[self setPopularButton:b];
		[b release];
	}
	return popularButton;
}

- (BGSSectionButton *)randomButton
{
	if (randomButton == nil)
	{
		BGSSectionButton *b = [[BGSSectionButton alloc] initWithFrame:CGRectMake(floor(self.popularButton.frame.origin.x+self.popularButton.frame.size.width+14.0f), 
																				 self.popularButton.frame.origin.y, 
																				 80.0f, 
																				 40.0f)];
		[b.label setText:@"random"];
		[b addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchDown];
		[self setRandomButton:b];
		[b release];
	}
	return randomButton;
}

- (BGSSectionButton *)favoritesButton
{
	if (favoritesButton == nil)
	{
		BGSSectionButton *b = [[BGSSectionButton alloc] initWithFrame:CGRectMake(floor(self.randomButton.frame.origin.x+self.randomButton.frame.size.width+14.0f), 
																				 self.randomButton.frame.origin.y, 
																				 80.0f, 
																				 40.0f)];
		[b.label setText:@"favorites"];
		[b addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchDown];
		[self setFavoritesButton:b];
		[b release];
	}
	return favoritesButton;
}

- (void)changeSection:(id)sender
{
	if (![sender isSelected])
	{
		[lastSelectedButton setSelected:NO];
		[sender setSelected:YES];
		
		if (sender == self.newestButton)
			currentSection = kKulerFeedTypeNewest;
		else if (sender == self.popularButton)
			currentSection = kKulerFeedTypePopular;
		else if (sender == self.randomButton)
			currentSection = kKulerFeedTypeRandom;
		else if (sender == self.favoritesButton)
			currentSection = kKulerFeedTypeFavorites;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setInteger:currentSection forKey:@"saturation.lastOpenedSection"];
		
		if (sender == self.favoritesButton)
		{
			[self.tableView setTableHeaderView:nil];
			[self.tableView setTableFooterView:nil];
		}
		else 
		{
			[self.tableView setTableHeaderView:self.refreshView];
			[self.tableView setTableFooterView:(self.selectedEntries.count > 5 ? self.footerView : nil)];
		}
		
		[self.tableView reloadData];
		if ([self.selectedEntries count] > 0)
		{
			NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.tableView scrollToRowAtIndexPath:ip 
								  atScrollPosition:UITableViewScrollPositionTop 
										  animated:NO];
		}
		
		lastSelectedButton = sender;
		
		[self.feed.queue cancelAllOperations];
		currentlyRefreshing = NO;
		currentlyPaging = NO;
	}
}

- (BGSSwatchColor *)seperator
{
	if (seperator == nil)
	{
		BGSSwatchColor *c = [[BGSSwatchColor alloc] initWithFrame:CGRectMake(0.0f, 
																			 40.0f, 
																			 480.0f, 
																			 1.0f) 
														 andColor:CC_LIST_SEPERATOR];
		[self setSeperator:c];
		[c release];
	}
	return seperator;
}

- (BGSTableView *)tableView
{
	if (tableView == nil)
	{
		BGSTableView *table = [[BGSTableView alloc] initWithFrame:CGRectMake(0.0f, 
																			 41.0f, 
																			 480.0f, 
																			 279.0f) 
															style:UITableViewStylePlain];
		[table setBackgroundColor:CC_LIST_BACKGROUND];
		[table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[table setDataSource:self];
		[table setDelegate:self];
		[table setContentOffset:CGPointMake(0.0f, 44.0f)];
		[self setTableView:table];
	}
	return tableView; 
}

- (BGSRefreshView *)refreshView
{
	if (refreshView == nil)
	{
		BGSRefreshView *h = [[BGSRefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 44.0f)];
		[h.refreshButton addTarget:self action:@selector(fullRefreshEntries:) forControlEvents:UIControlEventTouchDown];
		[self setRefreshView:h];
		[h release];
	}
	return refreshView;
}

- (void)fullRefreshEntries:(id)sender
{
	if (!currentlyRefreshing)
	{
		currentlyRefreshing = YES;
		switch (currentSection) {
			case kKulerFeedTypeNewest:
				[self.feed refreshNewestEntries];
				break;
			case kKulerFeedTypePopular:
				[self.feed refreshPopularEntries];
				break;
			case kKulerFeedTypeRandom:
				[self.feed refreshRandomEntries];
				break;
		}
		[self.tableView setTableHeaderView:self.loadingView];
	}
}

- (BGSLoadingView *)loadingView
{
	if (loadingView == nil)
	{
		BGSLoadingView *h = [[BGSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 44.0f)];
		[h.titleLabel setText:@"loading new themes"];
		[self setLoadingView:h];
		[h release];
	}
	return loadingView;
}

- (BGSLoadingView *)footerView
{
	if (footerView == nil)
	{
		BGSLoadingView *f = [[BGSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 44.0f)];
		[f.titleLabel setText:@"loading additional themes"];
		[self setFooterView:f];
		[f release];
	}
	return footerView;
}

- (id)init
{
	if (self = [super init])
	{
		currentlyRefreshing = currentlyPaging = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(fetchStarted:) 
													 name:@"kuler.feed.update.started" 
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(fetchCompleted:) 
													 name:@"kuler.feed.update.completed" 
												   object:nil];
	}
	return self;
}

-(void)fetchStarted:(NSNotification *)notice
{
	if ([NSThread isMainThread]) 
	{
		@synchronized (self.tableView) 
		{
			NSLog(@"BGSListViewController::fetchStarted - url: %@, scope: %@, feedType: %@", 
				  [[notice userInfo] objectForKey:@"url"],
				  [[notice userInfo] objectForKey:@"scope"], 
				  [[notice userInfo] objectForKey:@"feedType"]);
			
			int scope = [[[notice userInfo] objectForKey:@"scope"] intValue];
			if (scope == kKulerFeedScopeFull)
			{
				currentlyRefreshing = YES;
				currentlyPaging = NO;
			}
			else
			{
				currentlyPaging = YES;
				currentlyRefreshing = NO;
			}
		}
	} 
	else 
	{
		[self performSelectorOnMainThread:@selector(fetchStarted:) withObject:notice waitUntilDone:YES];
	}
}
-(void)fetchCompleted:(NSNotification *)notice
{
	if ([NSThread isMainThread]) 
	{
		@synchronized (self.tableView) 
		{
			NSLog(@"BGSListViewController::fetchCompleted - scope: %@, feedType: %@", 
				  [[notice userInfo] objectForKey:@"scope"], 
				  [[notice userInfo] objectForKey:@"feedType"]);
			
			BOOL success = [[[notice userInfo] objectForKey:@"success"] intValue];
			NSLog(@"success: %i", success);
			if (success)
			{
				int scope = [[[notice userInfo] objectForKey:@"scope"] intValue];
				if (scope == kKulerFeedScopeFull)
				{
					currentlyRefreshing = NO;
					[self.tableView setTableHeaderView:self.refreshView];
					[self.tableView setTableFooterView:(self.selectedEntries.count > 5 ? self.footerView : nil)];
					
					if (self.tableView.contentOffset.y > 0.0f)
					{
						[self.tableView reloadData];
					}
					else
					{
						[self.tableView setContentOffset:CGPointMake(0.0f, 44.0f)];
						[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
					}
				}	
				else
				{
					currentlyPaging = NO;
					[self.tableView reloadData];
				}		
			}
			else 
			{
				currentlyPaging = currentlyRefreshing = NO;
				[self.tableView setTableHeaderView:nil];
				[self.tableView setTableFooterView:nil];
			}
		}
	} 
	else 
	{
		[self performSelectorOnMainThread:@selector(fetchCompleted:) withObject:notice waitUntilDone:YES];
	}
}

- (NSArray *)selectedEntries
{
	NSArray *entries = nil;
	switch (currentSection) {
		case kKulerFeedTypeNewest:
			entries = [self.feed newestEntries];
			break;
		case kKulerFeedTypePopular:
			entries = [self.feed popularEntries];
			break;
		case kKulerFeedTypeRandom:
			entries = [self.feed randomEntries];
			break;
		default:
			entries = [self.feed favoriteEntries];
			break;
	}
	return entries;
}

- (void)loadView 
{	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	currentSection = [defaults integerForKey:@"saturation.lastOpenedSection"];
	switch (currentSection) {
		case kKulerFeedTypeNewest:
			[self.newestButton setSelected:YES];
			lastSelectedButton = self.newestButton;
			break;
		case kKulerFeedTypePopular:
			[self.popularButton setSelected:YES];
			lastSelectedButton = self.popularButton;
			break;
		case kKulerFeedTypeRandom:
			[self.randomButton setSelected:YES];
			lastSelectedButton = self.randomButton;
			break;
		default:
			[self.favoritesButton setSelected:YES];
			lastSelectedButton = self.favoritesButton;
			break;
	}
	
	CGRect frame = [[UIScreen mainScreen] bounds];
	
	UIView *v = [[UIView alloc] initWithFrame:frame];
	[v setTransform:CGAffineTransformMakeRotation(M_PI/2)];
	[v setBounds:CGRectMake(0.0f, 0.0f, frame.size.height, frame.size.width)];
	[v setAutoresizesSubviews:YES];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[v sizeToFit];
	self.view = v;
	[v release];
	
	[self.view addSubview:self.background];
	[self.view addSubview:self.tableView];
	if (currentSection == kKulerFeedTypeFavorites)
	{
		[self.tableView setTableHeaderView:nil];
		[self.tableView setTableFooterView:nil];
	}
	else 
	{
		[self.tableView setTableHeaderView:self.refreshView];
		[self.tableView setTableFooterView:(self.selectedEntries.count > 5 ? self.footerView : nil)];
	}

	[self.view addSubview:self.closeButton];
	[self.view addSubview:self.newestButton];
	[self.view addSubview:self.popularButton];
	[self.view addSubview:self.randomButton];
	[self.view addSubview:self.favoritesButton];
	[self.view addSubview:self.seperator];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated 
{
	// clear the feed on display to ensure we get the latest updates from the other controllers
	self.feed = nil;
	[self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animate 
{
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
						  atScrollPosition:UITableViewScrollPositionTop 
								  animated:NO];
	[super viewDidDisappear:animate];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[background release];
	[tableView release];
	[refreshView release];
	[loadingView release];
	[footerView release];
	[feed release];
	[newestButton release];
	[popularButton release];
	[randomButton release];
	[favoritesButton release];
	[seperator release];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
    return [[self selectedEntries] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip 
{    
    static NSString *CellIdentifier = @"Cell";
    
    BGSEntryViewCell *cell = (BGSEntryViewCell *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[BGSEntryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell.favoriteView.iconButton addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchDown];
    }
	
	NSDictionary *entry = [[self selectedEntries] objectAtIndex:ip.row];
	[cell setEntry:entry];
	[cell.favoriteView setIsFavorite:[self.feed isFavorite:entry]];
	[cell.favoriteView.iconButton setTag:ip.row];
	
    return cell;
}

- (void)toggleFavorite:(id)sender
{
	BGSEntryViewCell *cell = (BGSEntryViewCell *)[[sender superview] superview];
	NSIndexPath *ip = [self.tableView indexPathForCell:cell];
	NSDictionary *entry = [[self selectedEntries] objectAtIndex:ip.row];
	if (cell.favoriteView.isFavorite)
	{
		[self.feed removeFromFavorites:entry];
		[cell.favoriteView setIsFavorite:NO];
		if (currentSection == kKulerFeedTypeFavorites)
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationLeft];
	}
	else
	{
		[self.feed addToFavorites:entry];
		[cell.favoriteView setIsFavorite:YES];
	}
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip 
{
	NSDictionary *entry = [[self selectedEntries] objectAtIndex:ip.row];
	SaturationAppDelegate *ad = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[ad changeEntry:entry];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.y > (44.0f+self.selectedEntries.count*44.0f-279.0f) && !currentlyPaging)
	{
		currentlyPaging = YES;
		switch (currentSection) {
			case kKulerFeedTypeNewest:
				[self.feed pageNewestEntries];
				break;
			case kKulerFeedTypePopular:
				[self.feed pagePopularEntries];
				break;
			case kKulerFeedTypeRandom:
				[self.feed pageRandomEntries];
				break;
		}
	}
}

@end

