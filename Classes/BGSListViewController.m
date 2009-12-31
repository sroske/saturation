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

-(void)fetchStarted:(NSNotification *)notice;
-(void)fetchCompleted:(NSNotification *)notice;

@end


@implementation BGSListViewController

@synthesize selectedEntries;
@synthesize background;
@synthesize closeButton;
@synthesize tableView;
@synthesize headerView;
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
		[btn setFrame:CGRectMake(self.view.bounds.size.width-i.size.width-10.0f, 
								 10.0f, 
								 i.size.width, 
								 i.size.height)];
		[self setCloseButton:btn];
		[btn release];
	}
	return closeButton;
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
		[b setTitle:@"newest" forState:UIControlStateNormal];
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
		[b setTitle:@"most popular" forState:UIControlStateNormal];
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
		[b setTitle:@"random" forState:UIControlStateNormal];
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
		[b setTitle:@"favorites" forState:UIControlStateNormal];
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
			self.selectedEntries = [self.feed newestEntries];
		else if (sender == self.popularButton)
			self.selectedEntries = [self.feed popularEntries];
		else if (sender == self.randomButton)
			self.selectedEntries = [self.feed randomEntries];
		else if (sender == self.favoritesButton)
			self.selectedEntries = [self.feed favoriteEntries];
		
		if (sender == self.favoritesButton)
		{
			[self.tableView setTableHeaderView:nil];
			[self.tableView setTableFooterView:nil];
		}
		else 
		{
			[self.tableView setTableHeaderView:self.headerView];
			[self.tableView setTableFooterView:self.footerView];
		}
		
		[self.tableView reloadData];
		if ([self.selectedEntries count] > 0)
		{
			NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.tableView scrollToRowAtIndexPath:ip 
								  atScrollPosition:UITableViewScrollPositionTop 
										  animated:NO];
										  //animated:(lastSelectedButton != self.favoritesButton)];
		}
		
		lastSelectedButton = sender;
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

- (void)close:(id)sender
{
	SaturationAppDelegate *ad = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[ad hideModalView];
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

- (BGSLoadingView *)headerView
{
	if (headerView == nil)
	{
		BGSLoadingView *h = [[BGSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 44.0f)];
		[h.titleLabel setText:@"loading new swatches"];
		[self setHeaderView:h];
		[h release];
	}
	return headerView;
}

- (BGSLoadingView *)footerView
{
	if (footerView == nil)
	{
		BGSLoadingView *f = [[BGSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 44.0f)];
		[f.titleLabel setText:@"loading additional swatches"];
		[self setFooterView:f];
		[f release];
	}
	return footerView;
}

- (id)init
{
	if (self = [super init])
	{
		currentlyRefreshing = NO;
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(fetchStarted:) 
													 name:@"kuler.fetch.started" 
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(fetchCompleted:) 
													 name:@"kuler.fetch.completed" 
												   object:nil];
	}
	return self;
}

-(void)fetchStarted:(NSNotification *)notice
{
	currentlyRefreshing = YES;
	NSLog(@"fetchStarted: %@", [notice userInfo]);
}
-(void)fetchCompleted:(NSNotification *)notice
{
	currentlyRefreshing = NO;
	NSLog(@"fetchCompleted: %@", [notice userInfo]);
	[self.tableView reloadData];
	[self.tableView setContentOffset:CGPointMake(0.0f, 44.0f)];
}

- (void)loadView 
{	
	self.selectedEntries = [self.feed newestEntries];
	[self.newestButton setSelected:YES];
	lastSelectedButton = self.newestButton;
	
	CGRect frame = CGRectMake(0.0f, 0.0f, 480.0f, 320.0f);
	
	UIView *newView = [[UIView alloc] initWithFrame:frame];
	[newView setAutoresizesSubviews:YES];
	[newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[newView sizeToFit];
	self.view = newView;
	[newView release];
	
	[self.view addSubview:self.background];
	[self.view addSubview:self.tableView];
	[self.tableView setTableHeaderView:self.headerView];
	[self.tableView setTableFooterView:self.footerView];
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
	[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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
	[selectedEntries release];
	[background release];
	[tableView release];
	[headerView release];
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
    return [self.selectedEntries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip 
{    
    static NSString *CellIdentifier = @"Cell";
    
    BGSEntryViewCell *cell = (BGSEntryViewCell *)[tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[BGSEntryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary *entry = [self.selectedEntries objectAtIndex:ip.row];
	[cell setEntry:entry];
	
    return cell;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip 
{
	NSDictionary *entry = [self.selectedEntries objectAtIndex:ip.row];
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
	if (scrollView.contentOffset.y < self.headerView.frame.size.height && !currentlyRefreshing)
	{
		[self.feed refreshNewestEntries];
	}
}

@end

