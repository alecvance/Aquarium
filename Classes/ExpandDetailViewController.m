//
//  ExpandDetailViewController.m
//  Aquarium
//
//  Created by Alec Vance on 11/18/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "ExpandDetailViewController.h"
#import "WebViewController.h"

@implementation ExpandDetailViewController

@synthesize webView, contentHTML, baseDir;

- (void)dealloc {
	[webView release];
	[contentHTML release];
	[baseDir release];
	
    [super dealloc];
}

- (void) setHTMLDir:(NSString *)htmlDir{
	baseDir = [[NSString pathWithComponents:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath],kHtmlBaseDir,htmlDir, nil]] retain];
	NSString *filePath = [NSString pathWithComponents: [NSArray arrayWithObjects: baseDir, @"index.html", nil]];
	//baseURL = [NSURL URLWithString: ];
	//NSLog(@"Opening file at %@",filePath);
//	NSURL *pageURL = [NSURL fileURLWithPath: filePath];
	
	NSError *err = [[NSError alloc] init];
	contentHTML	= [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err] retain];
	
	if (err.code) {
		NSLog(@"Error opening HTML: %@",[err userInfo]);
	}else{
		//NSLog(@"Got HTML: %@", contentHTML);
	}
	
	
	
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
	
	NSString *html = contentHTML;
	
	NSStringCompareOptions o = NSCaseInsensitiveSearch;
	//html = [html stringByReplacingOccurrencesOfString: @"target='_parent'" withString: @""];
	
	//pull out A HREF=http:// so we can trap them inside our own handler for the app
	html = [html stringByReplacingOccurrencesOfString: @"<a href=\"http://" withString: @"<a href=\"aqua2app://" options:o range:NSMakeRange(0, [html length])];
	html = [html stringByReplacingOccurrencesOfString: @"<a href='http://" withString: @"<a href='aqua2app://" options:o range:NSMakeRange(0, [html length])];
	
	//NSLog(@"New HTML:\n %@", html);
	
	NSURL *baseURL = [NSURL fileURLWithPath: baseDir];
	[webView loadHTMLString:html baseURL:baseURL];
	
}

-(void) viewDidAppear:(BOOL)animated{
	//remove EXPAND title graphic
	//[[[self.navigationController.navigationBar subviews] objectAtIndex:1] removeFromSuperview];
	
	
	//add one without text
	titleBarBackgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"topbar-expand_notext.png"]];
	//	[[[self.navigationController.navigationBar subviews] objectAtIndex:1] removeFromSuperview ];
	//[self.navigationController.navigationBar addSubview:titleBarBackgroundView];
	//[self.navigationController.navigationBar sendSubviewToBack:titleBarBackgroundView];
	[self.navigationController.navigationBar insertSubview:titleBarBackgroundView atIndex:0];
	
	//[bgView release];
	
	
	[super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
	
	//REMOVE title graphic without text
	//[[[self.navigationController.navigationBar subviews] objectAtIndex:1] removeFromSuperview ];
	[titleBarBackgroundView removeFromSuperview];
	[titleBarBackgroundView release];
	
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
    [self.webView stopLoading];
	self.webView = nil;
}

#pragma mark -

-(void)openBrowserWithUrl: (NSURL *)theUrl{
	
	WebViewController *controller = [[WebViewController alloc] initWithURL:theUrl];
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}
@end
