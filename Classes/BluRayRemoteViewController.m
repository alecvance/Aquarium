//
//  BluRayRemoteViewController.m
//  Aquarium
//
//  Created by Alec Vance on 11/2/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "BluRayRemoteViewController.h"
#import "Constants.h"

#define kLinkButtonOffState @"topbar-link"
#define kLinkButtonOnState @"topbar-linked"

#define kColorFadeTime 3.5
#define kButtonsLayerHideAlpha 0.25

#define kRemoteCenterX 160.0
#define kRemoteCenterY 223.0
#define kRemoteRadius 100.0
#define kOKButtonRadius 29.5

@implementation BluRayRemoteViewController

@synthesize titleBar, buttonsLayer, statusField;
@synthesize bdconnection, networkConnectionStatus;
@synthesize upButton, rightButton, downButton, leftButton, okButton;

- (void)dealloc {
	[titleBar release];
	[buttonsLayer release];
	[statusField release];
	
	[upButton release];
	[rightButton release];
	[downButton release];
	[leftButton release];
	[okButton release];
	
	[bdconnection release];
	
    [super dealloc];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	buttonsLayer.alpha = kButtonsLayerHideAlpha;
	
	statusField.text = @"";
	titleBar.image = [UIImage imageNamed:kLinkButtonOffState];

	if(! bdconnection){
		isConnected = NO;
		[self connectToBluRayDisc];
	}
		
//	palette = [[ColorModel alloc] initWithRangeFrom:@"EDEDED" to: @"00ACED"];
//	colorIndex = 0;
//	colorFwd = YES;
//	[self backgroundFadeToNextColor];


	[UIView beginAnimations:@"backgroundFadeToColor" context:nil];
	[UIView setAnimationDuration:kColorFadeTime];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:1.7E+38]; //forever
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:1.0];
	[UIView commitAnimations];

}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
}

-(void)viewWillDisappear:(BOOL)animated{
//	[self cancelPreviousPerformRequestsWithTarget:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[super viewWillDisappear:animated];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




//-(BOOL)remoteControlIsActive{
//	//if (([self plasmaControlMode]==kPlasmaModeBluRayRemote) && (self.networkConnectionStatus == ReachableViaWiFi)) {
//	if (self.networkConnectionStatus == ReachableViaWiFi) {
//			
//		return YES;
//	}
//	
//	return NO;
//}

-(void)showButtonsLayer{
	[UIView beginAnimations:@"showButtonsLayer" context:nil];
	[UIView setAnimationDuration:1.75];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 480);
	buttonsLayer.alpha = 1.0;
	[UIView commitAnimations];
	
//	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideButtonsLayer) object:nil];
//	[self performSelector:@selector(hideButtonsLayer) withObject:nil afterDelay: 5.0];
	
}

-(void)hideButtonsLayer{
	[UIView beginAnimations:@"hideButtonsLayer" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	buttonsLayer.alpha = kButtonsLayerHideAlpha;
	[UIView commitAnimations];
}


-(UIButton *)remoteButtonAtPosition:(CGPoint)pos{
	
	// see if the touch was within the wheel...
	CGFloat dx = pos.x - kRemoteCenterX;
	CGFloat dy = pos.y - kRemoteCenterY;
	CGFloat d = sqrt(dx*dx + dy*dy);
	//NSLog(@"Got touch at position %f,%f with distance of %f", dx, dy, d);
	
	if(d<kRemoteRadius){
		
		if (d<kOKButtonRadius) {
			
			return okButton;
			
		}else{
			CGFloat theta;
			
			if (dx < 0) {
				theta = atan(dy/dx) * 180.0/kPi + 180;
			}else {
				theta = atan(dy/dx) * 180.0/kPi;
			}
			
			//NSLog(@"Wheel controller touched at theta: %f", theta);
			
			if (theta>229 || theta<-47) {
				//up
				
				return upButton;
			}
			
			if (theta>-39 && theta<39) {
				//right
				return rightButton;
			}
			
			if (theta>47 && theta <132){
				return downButton;
			}
			
			if(theta>137 && theta < 221){
				return leftButton;
			}
		}
	}
	
	return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint pos = [touch locationInView:self.view];
	
	//cancel previous
	[pressedButton setHighlighted:NO];
	
	UIButton *touchedButton;
	if((touchedButton = [self remoteButtonAtPosition:pos])){
		[touchedButton setHighlighted:YES];
		pressedButton = touchedButton;
		
	}else{
		// pass touches to superview
		[super touchesBegan:touches withEvent:event];
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint pos = [touch locationInView:self.view];
	
	[pressedButton setHighlighted:NO];
	
	UIButton *touchedButton = [self remoteButtonAtPosition:pos];
	if(touchedButton==pressedButton){

		//[touchedButton setHighlighted:NO];
		
		if (touchedButton==okButton) {
			[self sendEnterKeyCommand:touchedButton];
			return;
		}
		if (touchedButton==upButton) {
			[self sendUpKeyCommand:touchedButton];
			return;
		}
		if (touchedButton==rightButton) {
			[self sendRightKeyCommand:touchedButton];
			return;
		}
		if (touchedButton==downButton) {
			[self sendDownKeyCommand:touchedButton];
			return;
		}
		if (touchedButton==leftButton) {
			[self sendLeftKeyCommand:touchedButton];
			return;
		}
		
	}else{
		// pass touches to superview
		[super touchesBegan:touches withEvent:event];
	}
		
}

/*
-(void)backgroundFadeToNextColor{
	if(colorFwd){
		colorIndex++;
		if (colorIndex == [palette.colors count]-1) {
			colorFwd = NO;
		}
		
	}else{
		colorIndex--;
		if (colorIndex == 0) {
			colorFwd = YES;
		}
	}
	
	[self backgroundFadeToColor: [palette getColorAtIndex:colorIndex]];
	[self performSelector:@selector(backgroundFadeToNextColor) withObject:nil afterDelay:kColorFadeTime];

}

-(void)backgroundFadeToColor:(UIColor *)color{
	[UIView beginAnimations:@"backgroundFadeToColor" context:nil];
	[UIView setAnimationDuration:kColorFadeTime];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	self.view.backgroundColor = color;
	[UIView commitAnimations];
}
*/

//#pragma mark -
//#pragma mark PieWedgeViewDelegate methods
//-(void) userSelectedPieWedgeNum:(int)number{
//	NSLog(@"Selected wedge #%i", number);
//}

#pragma mark -
#pragma mark User Controls for BD
- (IBAction) linkButtonWasPressed{
	
//	//flip mode state
//	if (plasmaControlMode==kPlasmaModeNormal) {
//		plasmaControlMode=kPlasmaModeBluRayRemote;
//	}else{
//		plasmaControlMode=kPlasmaModeNormal;
//	}
//	
//	// flip wheel
//	[UIView beginAnimations:@"flipWheel" context:nil];
//	[UIView setAnimationDuration:.5];
//	[UIView setAnimationBeginsFromCurrentState:NO];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.pieView cache:YES];
//	
//	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
//	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
//	
//	
//	[plasmaController.model flipWheel];
//	[plasmaController tic:0.0001]; // forces update without really moving
//	
//	[UIView commitAnimations];
//	
	
//	if((! bdconnection)&&(plasmaControlMode==kPlasmaModeBluRayRemote)){
	if(! isConnected){
		[self connectToBluRayDisc];
	}else {
		[self disconnectFromBluRayDisc];
	}

}

//
//-(void) playBDSegmentForWedge: (int)pieceNum{
//
//	switch (pieceNum) {
//		case 0:
//			[self sendPlayChapterCommand:@"1" ofTitle:@"01014"];
//			break;
//			
//		case 1:
//			[self sendPlayChapterCommand:@"1" ofTitle:@"01012"];
//			break;
//			
//		case 2:
//			[self sendPlayChapterCommand:@"1" ofTitle:@"01002"];
//			break;
//			
//		case 3:
//			[self sendPlayChapterCommand:@"1" ofTitle:@"00006"];
//			break;
//			
//		case 4:
//			[self sendPlayChapterCommand:@"1" ofTitle:@"00011"];
//			break;
//			
//		case 5:
//			[self sendPlayChapterCommand:@"1" ofTitle:@"00014"];
//			break;
//			
//			
//		default:
//			break;
//	}
//}

#pragma mark -
#pragma mark ConnectViewControllerDelegate methods
- (void) BDdidConnectWithConnection:(BDConnect *)_bdconnection{
	bdconnection = _bdconnection;
	statusField.text = @"";
	[self showButtonsLayer];
	titleBar.image = [UIImage imageNamed:kLinkButtonOnState];
	isConnected = YES;

}


- (void) BDCouldNotConnect{
	[self hideButtonsLayer];
	statusField.text = @"Could not connect to\nthe Aquarium 2 Blu-ray disc.\n\nMake sure your player is on the network and the disc is loaded and playing in the device. Try resetting your BD Player if you continue to have problems. Touch LINK TO DISC to retry.";
	
	titleBar.image = [UIImage imageNamed:kLinkButtonOffState];
	isConnected = NO;
	
	[bdconnection release];
	bdconnection = nil;
	

}

#pragma mark -
#pragma mark BDConnect methods



-(void)connectToBluRayDisc{
	//self.internetConnectionStatus	= [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
	//NSLog(@"internetConnectionStatus = %i", internetConnectionStatus);
	
	//stash while checking
	if(	 (self.networkConnectionStatus = [self checkNetworkReachability])){
		
		// The application ships with a default database in its bundle. If anything in the application
		// bundle is altered, the code sign will fail. We want the database to be editable by users, 
		// so we need to create a copy of it in the application's Documents directory.     
		//	[self createEditableCopyOfDatabaseIfNeeded];
		
		// Call internal method to initialize database connection
		//    [self initializeDatabase];
		
		ConnectViewController *vc = [[ConnectViewController alloc] init]; // why is the NIB file not specified here? Yet it still works. WEIRD.
		[self presentModalViewController:vc animated:YES];
		[vc setDelegate: self];
		statusField.text = @"";
		//bdconnection = [[[BDConnect alloc] init] retain];
		//		[bdconnection setUniqueId:kDiscID];
		//		[bdconnection hostPath:urlString];
		//		[bdconnection setDeletage: self]; // (SIC!) should be setDelegate!!! (LOL)
		//		[bdconnection sendSignIn];
		//
		
	}else {
		
		statusField.text = @"Could not connect to Blu-ray Disc. Make sure your player is on the network and the disc is loaded in the device";
		NSLog(@"Could not connect to Blu-ray Disc. Make sure your player is on the network and the disc is loaded in the device.");
	}
	
	
}

-(void) disconnectFromBluRayDisc{
	if (bdconnection) {
		
		[bdconnection sendSignOut];
		titleBar.image = [UIImage imageNamed:kLinkButtonOffState];
		[self hideButtonsLayer];

	}
	[bdconnection release];
	bdconnection = nil;
	isConnected = NO;
}
/*
 * Sends a command to play a specific chapter number
 */

-(void) sendPlayChapterCommand:(NSString *)chapterID ofTitle:(NSString *)titleID{
	
	NSString *chapter = [NSString stringWithFormat: @"chapter_number=%@", chapterID];
	NSString *title = [NSString stringWithFormat:@"title_number=%@", titleID];
	
	//DOESNT WORK! ASSHOLES.
	
	[bdconnection sendCommand:@"play_chapter" param1:chapter param2:title param3:nil param4:nil];
	//	[bdconnection sendCommand:@"set_audio_track" param1:@"audio_track_number=3" param2:nil param3:nil param4:nil];
	
	
}

/**
 * Sends the offical BD Touch play command to the BD Touch Disc
 */
-(IBAction) sendPlayCommand:(id)sender{
	
	[bdconnection sendCommand:@"play" param1:nil param2:nil param3:nil param4:nil];
	
}


/**
 * Sends the offical BD Touch pause command to the BD Touch Disc
 */
-(IBAction) sendPauseCommand:(id)sender{
	
	[bdconnection sendCommand:@"pause" param1:nil param2:nil param3:nil param4:nil];
}

/**
 * Sends the offical BD Touch stop command to the BD Touch Disc
 */

// NOT SUPPORTED. ASSHOLES.
//-(IBAction) sendStopCommand:(id)sender{
//	
//	[bdconnection sendCommand:@"stop" param1:nil param2:nil param3:nil param4:nil];
//}

/**
 * Sends the offical BD Touch  hide all command to the BD Touch Disc (this is not expoded in the fire App)
 */
-(IBAction) sendHideAllCommand:(id)sender{
	[bdconnection sendCommand:@"hide_all" param1:nil param2:nil param3:nil param4:nil];
}

-(IBAction) sendRightKeyCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=39" param2:nil param3:nil param4:nil];
}

-(IBAction) sendLeftKeyCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=37" param2:nil param3:nil param4:nil];
}

-(IBAction) sendUpKeyCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=38" param2:nil param3:nil param4:nil];
}

-(IBAction) sendDownKeyCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=40" param2:nil param3:nil param4:nil];
}

-(IBAction) sendEnterKeyCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=10" param2:nil param3:nil param4:nil];
}

-(IBAction) sendFastForwardCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=417" param2:nil param3:nil param4:nil];
}

-(IBAction) sendRewindCommand:(id)sender{
	[bdconnection sendCommand:@"send_key" param1:@"key=412" param2:nil param3:nil param4:nil];
}

//
//-(IBAction) sendRedCommand:(id)sender{
//	[bdconnection sendCommand:@"send_key" param1:@"key=403" param2:nil param3:nil param4:nil];
//}
//
//-(IBAction) sendBlueCommand:(id)sender{
//	[bdconnection sendCommand:@"send_key" param1:@"key=406" param2:nil param3:nil param4:nil];
//}
//
//-(IBAction) sendGreenCommand:(id)sender{
//	[bdconnection sendCommand:@"send_key" param1:@"key=404" param2:nil param3:nil param4:nil];
//}
//
//-(IBAction) sendYellowCommand:(id)sender{
//	[bdconnection sendCommand:@"send_key" param1:@"key=405" param2:nil param3:nil param4:nil];
//}
//

/**
 * Sends the offical BD Touch  hide all command to the BD Touch Disc (this is not expoded in the fire App)
 */
-(IBAction) sendShowMainMenuCommand:(id)sender{
	
	[bdconnection sendCommand:@"show_main_menu" param1:@"set_number=0" param2:@"button_number=2" param3:nil param4:nil];
	
}


-(IBAction) sendShowChaptersMenuCommand:(id)sender{
	[bdconnection sendCommand:@"show_submenu" param1:@"set_number=0" param2:@"button_number=5" param3:@"submenu_number=4" param4:nil];	
}

/**
 * TODO: Add your own features to download files from the BD Touch Disc Application
 */
//-(IBAction) sendReceiveFileCommand:(id)sender{
//	
//}
//
-(IBAction) sendNextChapterCommand:(id)sender{
	[bdconnection sendCommand:@"next_chapter" param1:nil param2:nil param3:nil param4:nil];
	
}
-(IBAction) sendPreviousChapterCommand:(id)sender{
	[bdconnection sendCommand:@"previous_chapter" param1:nil param2:nil param3:nil param4:nil];
	
}
//	
//-(IBAction) sendDownloadVideoCommand:(id)sender{
//	[bdconnection sendDownloadMovieFile: sender];
//}
//
//-(IBAction) sendTextCommand:(id)sender
//{
//	[bdconnection sendCommand:@"text" param1: textField.text param2:nil param3:nil param4:nil];
//}
//


#pragma mark -
#pragma mark Reachability


/* make sure network is on, and server is reachable 
 (will handle displaying the error, too)
 */

-(BOOL)checkNetworkReachability{
	//Reachability *r = [Reachability reachabilityWithHostName:kWebServer];
	Reachability *r = [Reachability reachabilityForLocalWiFi];
	
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
	BOOL reachable = (internetStatus == ReachableViaWiFi); // || (internetStatus == ReachableViaWWAN));
	
	NSLog(@"WiFi Network is reachable? %i", reachable); 
	
	//	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	//	
	//	if([NSURLConnection canHandleRequest:request] && reachable) {
	//		return YES;
	//		
	//	}else{
	//		
	//		// Display error
	//		
	//		UIAlertView *errorAlert = [[UIAlertView alloc]
	//								   initWithTitle: @"Network Error"
	//								   message: @"Can't reach server via network. Please check your network connection."
	//								   delegate:nil
	//								   cancelButtonTitle:@"OK" 
	//								   otherButtonTitles:nil];
	//		[errorAlert show];
	//		[errorAlert release];
	//	}
	//	
	//	return NO;
	
	return internetStatus;
	
}

- (void)reachabilityChanged:(NSNotification *)note{
	
}
- (void)updateStatus{
	
}

		

@end
