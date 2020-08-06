//
//  ConnectViewController.m
//  Blu Fire
//
//  Created by scott bates on 3/19/09.
//  Copyright Scott bates 2009. All rights reserved.
//
// Modified by Alec Vance October/November 2010

#import "ConnectViewController.h"
//#import "Blu_FireAppDelegate.h"
#import "BrowserViewController.h"
//#import "BluLoungeViewController.h"
//#import "BDConnectCommandViewController.h"
#import "BDConnect.h"
//#import "RootViewController.h"


@implementation ConnectViewController
//@synthesize rootVC;
@synthesize delegate;


- (void)dealloc {
	[delegate release];
	
    [super dealloc];
}


// this is old based on old UINavigation Controller...  now using ViewDidLoad above
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//NSLog(@"viewWillAppear: Connect View");
	[noConnectionButt setEnabled:NO];
	[noConnectionButt setHidden:YES];
	[infoButt setEnabled:NO];
	[infoButt setHidden:YES];
	bdTouchTableViewController = nil;
}

// this is old based on old UINavigation Controller...  now using ViewDidLoad above
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	//NSLog(@"viewDidAppear: Connect View");

	//if([appDelegate isConnectionAvailable]){
		//Wifi connected so go ahead and start bonjour search
		
		[noConnectionButt setEnabled:YES];
		[noConnectionButt setHidden:NO];
		[infoButt setEnabled:YES];
		[infoButt setHidden:NO];		
		[spinner startAnimating];
		
		//[statusMsg setText:@"Looking for BD Touch discs on your network"];
		[statusMsg setText:@"Searching for the Aquarium 2\nBlu-ray disc on your network"];

		bdTouchTableViewController = [[BrowserViewController alloc] initWithStyle:UITableViewStylePlain];
		[bdTouchTableViewController setDelegate:self];
		
		//success message is recieved in signInComplete method
		
		//where is the timeout, none found, message coming from?
		delayTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(bonjourTimeout) userInfo:nil repeats:NO];
		
	//}else{
//		
//		//this app requires a wifi function to do any of the bonjour connect to a player, so must auto-fail if no wifi connection exists
//		[statusMsg setText:@"This application requires a WiFi connection to access a Blu-ray player on your local network. Without a Wifi connection, you may still view media files previously downloaded from BDTouch enabled discs."];
//		//delayTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(showLounge) userInfo:nil repeats:NO];
//		[noConnectionButt setEnabled:YES];
//		[noConnectionButt setHidden:NO];
//		[infoButt setEnabled:YES];
//		[infoButt setHidden:NO];
//		
//	}
	
}

-(void)setup{

}

- (void)bonjourTimeout
{
	[statusMsg setText:@"Timed out: The Aquarium 2 disc was not found."];
	[spinner stopAnimating];
	//delayTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showLounge) userInfo:nil repeats:NO];
	[noConnectionButt setEnabled:YES];
	[noConnectionButt setHidden:NO];
	[infoButt setEnabled:YES];
	[infoButt setHidden:NO];
	[delegate BDCouldNotConnect]; // Alec
}

/*
-(void)showLounge
{
	//[remoteControlVC setConnection:[appDelegate bdConnection]];
	//[[appDelegate navigationController] pushViewController:bluLoungeVC animated:YES];
	//set tab controller to be on Blu Lounge
	[[rootVC tabVC] setSelectedIndex:1];
	[rootVC setWhichTab:@"Blu Lounge"];
	//initiate any setup in that tab.  because it is part of a tab controller viewDidAppear and viewWillAppear are not auto called.
	[[[rootVC tabVC] selectedViewController] viewWillAppear:NO];
	[[[rootVC tabVC] selectedViewController] viewDidAppear:NO];

	//tell parent to switch to tab vie
	[rootVC toggleView];
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
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

//- (void) signInComplete{
- (void) signInCompleteWithConnection:(BDConnect *)bdconnection{

	if(delayTimer != nil){
		[delayTimer invalidate]; // <-- was crashing us. nil should destroy the timer.
		delayTimer = nil;
	}
	
	[spinner stopAnimating];
	[statusMsg setText:@"Success: BD Touch Disc found.  Connecting"];
	//do a wait so user can read new status message
	//now push remoteControlVC to the view.
	
	//[remoteControlVC setConnection:[appDelegate bdConnection]];
	
	
	//[[appDelegate navigationController] pushViewController:remoteControlVC animated:YES]; //this was the old mechanism
	//this is the new mechanism
	//set tab controller to be on Blu Lounge
	//[[rootVC tabVC] setSelectedIndex:0];
	//[rootVC setWhichTab:@"Remote"];
	//initiate any setup in that tab.  because it is part of a tab controller viewDidAppear and viewWillAppear are not auto called.
	//[[[rootVC tabVC] selectedViewController] viewWillAppear:NO];
	//[[[rootVC tabVC] selectedViewController] viewDidAppear:NO];
	
	//tell parent to switch to tab vie
	//[rootVC toggleView];
	
	[self doContinue];
	[delegate BDdidConnectWithConnection:(BDConnect *)bdconnection];
	
}

//added by alec
- (void) discIdMismatch{
	
	if(delayTimer != nil){
		[delayTimer invalidate]; // <-- was crashing us. nil should destroy the timer.
		delayTimer = nil;
	}
	
	[spinner stopAnimating];
	[statusMsg setText:@"Did not find the correct disc in the BD Player."];

	[self doContinue];
	[delegate BDCouldNotConnect];
	
}

- (IBAction)doContinue
{
	//[self showLounge];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) showInfo
{
	[self presentModalViewController:infoModalVC animated:YES];
}



@end

