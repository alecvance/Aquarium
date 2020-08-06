//
//  ExpandViewController.m
//  Aquarium
//
//  Created by Alec Vance on 11/17/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "ExpandViewController.h"
#import "ExpandDetailViewController.h"

@implementation ExpandViewController


#pragma mark -
#pragma mark View lifecycle

- (void)dealloc {
    [super dealloc];
}

-(void)viewDidUnload{
	[pageSets release];
	[titleBarBackgroundView release];
	
	[super viewDidUnload];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// set tint color RGB = 81,146,45
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:124.0f/255.0f 
																   green:227.0f/255.0f 
																	blue:124.0f/255.0f 
																   alpha:1.0f];
	
	
	titleBarBackgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"topbar-expand.png"]];
	
	
	
	
	NSString *path = [[NSBundle mainBundle] pathForResource: @"Library" ofType:@"plist"];
	NSDictionary *library = [[NSDictionary alloc] initWithContentsOfFile: path];
	pageSets = [[library objectForKey:@"Pages"] retain];	
	[library release];
	
}



- (void)viewWillAppear:(BOOL)animated {
	
	self.navigationItem.title = @"      "; // don't show title of button since it's in the graphic
	[self.navigationController.navigationBar addSubview:titleBarBackgroundView];
	[self.navigationController.navigationBar sendSubviewToBack:titleBarBackgroundView];

	
    [super viewWillAppear:animated];
	
		
	
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	//self.navigationItem.title = @"Expand"; // don't show title of button since it's in the graphic

    [super viewDidDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
     return [pageSets count];
}

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	return [pageSets valueForKey:@"title"];
}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [[pageSets objectAtIndex: section] objectForKey: @"title"];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	
	return [[pageSets objectAtIndex: section] objectForKey: @"footer"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[pageSets objectAtIndex:section] objectForKey: @"rows"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *set = [[[pageSets objectAtIndex:indexPath.section] objectForKey: @"rows"] objectAtIndex:indexPath.row]; //[pageSets objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [set objectForKey:@"title"]; 
						   
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	ExpandDetailViewController *vc = [[ExpandDetailViewController alloc] initWithNibName:@"ExpandDetailViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	
	NSDictionary *set = [[[pageSets objectAtIndex:indexPath.section] objectForKey: @"rows"] objectAtIndex:indexPath.row];
	
	NSString *shortName = [set objectForKey:@"shortTitle"]; 
	NSString *htmlDir = [set objectForKey:@"dir"]; 
	
	[vc setTitle:shortName];
	//[vc setHTMLDir:htmlDir];
	[vc setHTMLDir:htmlDir];
	
	self.navigationItem.title = @"Expand"; // for the back button on the next screen
	[titleBarBackgroundView removeFromSuperview];
	 [self.navigationController pushViewController:vc animated:YES];
	 [vc release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a supervievw.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}



@end

