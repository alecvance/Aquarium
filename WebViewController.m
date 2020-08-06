//
//  WebViewController.m
//  radioBPR
//
//  Created by Alec Vance on 4/5/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "WebViewController.h"


@implementation WebViewController

@synthesize webView;
@synthesize currentURL;

- (void)dealloc {
	
	
	//NSLog(@"Releasing webView...");
	webView.delegate = nil;
	[webView stopLoading];
	[webView release];
	
	//hide network indicator in status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	//NSLog(@"webView released.");
	
	[currentURL release];
	
    [super dealloc];
}





// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithURL:(NSURL *)theURL {
    if (self = [super initWithNibName:@"WebViewController" bundle:nil]) {
        // Custom initialization
		currentURL = [theURL copy];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self loadURL: currentURL];
	
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
	//self.webView = nil;
	
	[super viewDidUnload];
}


-(void)loadURL: (NSURL *)url{
	
	//NSLog(@"Loading URL %@", url);
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	
	[webView loadRequest:request];
	
	//NSLog(@"Loading request %@", request);
	
	[request release];
	
	
}


-(IBAction) done{
	[webView stopLoading];
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];	
	
}



- (IBAction)dialogActionSheet{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:@"View in Safari" 
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}


-(void) openInSafari{
	
	currentURL = [webView.request URL];
	[[UIApplication sharedApplication] openURL:currentURL];
	
}

#pragma mark -
#pragma mark Action Sheet delegate methods 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	// [actionSheet release];
	if(buttonIndex==0){
		[self openInSafari];
	}
	
}

#pragma mark -
#pragma mark UIWebViewDelegate methods 

- (void)webViewDidStartLoad:(UIWebView *)wv {
    //NSLog (@"webViewDidStartLoad");
	//show network indicator in status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	// NSLog (@"webViewDidFinishLoad");
	//hide network indicator in status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
	// NSLog (@"webView:didFailLoadWithError");
	//hide network indicator in status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (error != NULL) {
		if ([error code] != NSURLErrorCancelled) { //show error alert, etc. 			

			UIAlertView *errorAlert = [[UIAlertView alloc]
									   initWithTitle: [error localizedDescription]
									   message: [error localizedFailureReason]
									   delegate:nil
									   cancelButtonTitle:@"OK" 
									   otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
		}
	}
}


@end
