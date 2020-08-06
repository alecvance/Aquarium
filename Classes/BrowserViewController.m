#import "BrowserViewController.h"
#import "XmlParserBase.h"
#import	"XmlParserProperty.h"
#import "AquariumAppDelegate.h"
#import "ConnectViewController.h"
#import "Constants.h"

#define kProgressIndicatorSize 20.0

@interface NSNetService (BrowserViewControllerAdditions)
@end

@implementation NSNetService (BrowserViewControllerAdditions)
- (NSComparisonResult) localizedCaseInsensitiveCompareByName:(NSNetService*)aService 
{
	return [[self name] localizedCaseInsensitiveCompare:[aService name]];
}
@end

@interface BrowserViewController()
- (void)hideResolvingActivityIndicator;
@end

@implementation BrowserViewController
@synthesize bdconnection;
@synthesize currentSelection = _currentSelection;
@synthesize currentResolve = _currentResolve;
@synthesize netServiceBrowser = _netServiceBrowser;
@synthesize services = _services;
@synthesize cellOfCurrentResolve = _cellOfCurrentResolve;
@synthesize delegate;

/**
 * Standard iPhone Code
 */
- (void)dealloc {
	//NSLog(@"BrowserViewController: dealloc");
	
	// Cleanup any running resolve and free memory.
	[self stopCurrentResolve];
	//self.services = nil;
	//self.netServiceBrowser = nil;
	[self setTimer:nil];
	
	[delegate release];
	[_currentSelection release];
	[_services release];
	[_netServiceBrowser release];
	[_currentResolve release];
	[_cellOfCurrentResolve release];
	
	[bdconnection release];
	
	[super dealloc];
}


/**
 * The delegate has which can be the MainViewController
 */
//- (void)setDeletage:(id)sender
//{
//		
//	delegate = sender;
//}

/**
 * Standard iPhone Code
 */
- (id)initWithStyle:(UITableViewStyle)style 
{
	//NSLog(@"BrowserViewController: initWithStyle");
	
	if (self = [super initWithStyle:style]) 
	{
		appDelegate = (AquariumAppDelegate *)[[UIApplication sharedApplication] delegate];
		BOOL ok = [self setUpServiceBrowserForDomain:nil type:@"_bdconnect._tcp."];
		if (!ok) {
			[self release];
			return nil;
		}
		self.title = NSLocalizedString(@"BD Touch Titles", @"Web Services title");
		self.services = [[NSMutableArray alloc] init];
	}
	return self;
}

/**
 * This is for the Bonjour Service
 */
- (BOOL)setUpServiceBrowserForDomain:(NSString *)domain type:(NSString *)type 
{
	//NSLog(@"BrowserViewController: setUpServiceBrowserForDomain");

	self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
	if(!self.netServiceBrowser) {
		NSLog(@"ERROR*** BrowserViewController: setUpServiceBrowserForDomain --> FAILED ***");

		return NO;
	}
	
	[self.netServiceBrowser setDelegate:self];
	[self.netServiceBrowser searchForServicesOfType:type inDomain:domain];
	
	return YES;
}	

/**
 * This is for the Bonjour Service
 */
- (NSTimer *)timer
{
    return _timer;
}

/**
 * This is for the Bonjour Service
 */
- (void)setTimer:(NSTimer *)newTimer
{
    [_timer invalidate];
    
    [newTimer retain];
    [_timer release];
    _timer = newTimer;
}


/**
 * Standard iPhone Code
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section
	return 1;
}

/**
 * Standard iPhone Code
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// If there are no services, show one row to tell the user.
	NSUInteger count = [self.services count];
	if (count == 0)
		return 1;
	
	return count;
}

/**
 * Standard iPhone Code
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:tableCellIdentifier] autorelease];
	}
	
	NSUInteger count = [self.services count];
	if (count == 0) {
		// If there are no services, show one row explaining that to the user.
		cell.textLabel.text = NSLocalizedString(@"No BD Touch Discs", @"No web services cell");
		cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		return cell;
	}
	
	// Set up the text for the cell
	NSNetService* service = [self.services objectAtIndex:indexPath.row];
	cell.textLabel.text = [service name];
	cell.textLabel.textColor = [UIColor blackColor];
	return cell;
}

/**
 * Standard iPhone Code
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Ignore the selection if there are no services.
	if ([self.services count] == 0)
		return nil;
	
	return indexPath;
}

/**
 * This is for the Bonjour Service
 */
- (void)stopCurrentResolve {
	//NSLog(@"BrowserViewController: stopCurrentResolve");

	// Deselect what was selected and stop the current resolve, if necessary.
	if (self.currentSelection) {
		[self.tableView deselectRowAtIndexPath:self.currentSelection animated:NO];
		UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.currentSelection];
		if (cell.accessoryView) {
            // In -showResolvingActivityIndicator, the activity indicator is added to the cell.
            // We store a reference to it in the cell's accessory view so that we can remove it from
            // the cell here.
			[cell.accessoryView removeFromSuperview];
			cell.accessoryView = nil;
		}
		if ([self timer]) {
			[self setTimer:nil];
		}
		self.currentSelection = nil;
	}
    [self hideResolvingActivityIndicator];
	[self.currentResolve stop];
	self.currentResolve = nil;
}

/**
 * This is for the Bonjour Service
 */
- (NSString *)copyStringFromTXTDict:(NSDictionary *)dict which:(NSString*)which {
	// Helper for getting information from the TXT data
	NSData* data = [dict objectForKey:which];
	return data ? [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] : nil;
}

/**
 * This is for the Bonjour Service
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// When a row is selected, resolve the service asynchronously.
	// If another resolve was running, stop it first.
	
	[self stopCurrentResolve];
	self.currentSelection = indexPath;
    
	self.currentResolve = [self.services objectAtIndex:indexPath.row];
	
	[self.currentResolve setDelegate:self];
    // Attempt to resolve the service. A value of 0.0 sets an unlimited time to resolve it. The user can
    // choose to cancel the resolve by selecting another service in the table view.
	[self.currentResolve resolveWithTimeout:0.0]; 
	
	// Give the user some feedback that the resolve is happening.
	// The attempt to resolve occurs asynchronously, so we don't want the user to think
	// we're just stuck.
	[self setTimer:[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showResolvingActivityIndicator:) userInfo:[tableView cellForRowAtIndexPath:indexPath] repeats:NO]];
}

/**
 * Standard iPhone Code
 */
- (void)showResolvingActivityIndicator:(NSTimer*)timer {
	if (timer==[self timer]) { 
        
		UITableViewCell* cell = (UITableViewCell*)[[self timer] userInfo];
		CGRect frame = CGRectMake(0.0, 0.0, kProgressIndicatorSize, kProgressIndicatorSize);
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
		[activityIndicator startAnimating];
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
		[activityIndicator sizeToFit];
		activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleTopMargin |
										UIViewAutoresizingFlexibleBottomMargin);
		
		cell.accessoryView = activityIndicator;
		[cell addSubview:activityIndicator];
        [activityIndicator release];
        self.cellOfCurrentResolve = cell;
	}
}

/**
 * Standard iPhone Code
 */
// Stop the animation of the activity indicator in the table cell that was selected and
// remove the indicator from the cell.
- (void)hideResolvingActivityIndicator {
    if (self.cellOfCurrentResolve) {
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)self.cellOfCurrentResolve.accessoryView;
        if (activityIndicator) {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }
    }
}

/**
 * Standard iPhone Code
 */
- (void)updateUI {
	// Sort the services by name.
	[self.services sortUsingSelector:@selector(localizedCaseInsensitiveCompareByName:)];
    
    if (self.currentSelection) {
		assert(self.currentResolve);
		
		NSUInteger count = [self.services indexOfObject:self.currentResolve];
		assert(count != NSNotFound);
		
		[self.tableView deselectRowAtIndexPath:self.currentSelection animated:NO];
		
		NSIndexPath* old = self.currentSelection;
		self.currentSelection = [old indexPathByRemovingLastIndex];
		[old release];
		old = self.currentSelection;
		self.currentSelection = [old indexPathByAddingIndex:count];
		[old release];
		
		[self.tableView selectRowAtIndexPath:self.currentSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
	}
    
	[self.tableView reloadData];
}                            

/**
 * This is for the Bonjour Service
 */
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didRemoveService:(NSNetService*)service moreComing:(BOOL)moreComing {
	//NSLog(@"BrowserViewController: netServiceBrowser didRemoveService");

	// If a service went away, stop resolving it if it's currently being resolve,
	// remove it from the list and update the table view if no more events are queued.
	
	if (self.currentResolve && [service isEqual:self.currentResolve]) {
		[self stopCurrentResolve];
    }
	
	[self.services removeObject:service];
	
	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
	if (!moreComing) {
		[self updateUI];
    }
}	

/**
 * This is for the Bonjour Service
 */
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindService:(NSNetService*)service moreComing:(BOOL)moreComing {
	//NSLog(@"BrowserViewController: netServiceBrowser didFindService");

    // If a service came online, add it to the list and update the table view if no more events are queued.
	[self.services addObject:service];
	//NSLog(@"Added net service: %@",service);
	
	//scott::  inserting hack to immediately connect to first device found
	[self stopCurrentResolve];
    
	self.currentResolve = service;
	
	[self.currentResolve setDelegate:self];
    // Attempt to resolve the service. A value of 0.0 sets an unlimited time to resolve it. The user can
    // choose to cancel the resolve by selecting another service in the table view.
	[self.currentResolve resolveWithTimeout:0.0]; 
	
	
	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
	if (!moreComing) {
		[self updateUI];
    }
}	

/**
 * This is for the Bonjour Service
 */
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	//NSLog(@"BrowserViewController: didNotResolve");

    [self stopCurrentResolve];
}

/**
 * This is for the Bonjour Service
 */
- (void)netServiceDidResolveAddress:(NSNetService *)service 
{
	
	//NSLog(@"BrowserViewController: netServiceDidResolveAddress");

	assert(service == self.currentResolve);
	
	[service retain];
    [self stopCurrentResolve];

	// If the service was resolved, construct the corresponding URL, taking into account
	// the port number as well as the path, username and password fields that can be in the TXT record
	NSDictionary* dict = [[NSNetService dictionaryFromTXTRecordData:[service TXTRecordData]] retain];
			    	
	NSString* user = [[self copyStringFromTXTDict:dict which:@"u"] retain];
	NSString* pass = [[self copyStringFromTXTDict:dict which:@"p"] retain];
	
	NSString* portStr = [[self copyStringFromTXTDict:dict which:@"Port"] retain];	
	NSString* path =  [[self copyStringFromTXTDict:dict which:@"Uri"] retain];	
	NSString* host =  [[self copyStringFromTXTDict:dict which:@"Ip"] retain];		

	if (!path || [path length]==0) {
		path = [[[NSString alloc] initWithString:@"/"] autorelease];
	} else if (![[path substringToIndex:1] isEqual:@"/"]) {
		path = [[[NSString alloc] initWithFormat:@"/%@",path] autorelease];
	}

	NSString* urlString = [[NSString alloc] initWithFormat:@"http://%@%@%@%@%@:%@%@",
						user?user:@"",
						pass?@":":@"",
						pass?pass:@"",
						(user||pass)?@"@":@"",
						host,
						portStr,
						path];
	
	//bdconnection = [[appDelegate bdConnection] retain];
	bdconnection = [[BDConnect alloc] init]; // this retain seems redundant!
	[bdconnection setUniqueId:kDiscID];
	
	
	[bdconnection setDelegate:self];
	[bdconnection hostPath:urlString];
	[bdconnection sendSignIn];
	
	[portStr release];
	[pass release];
	[user release];
	[dict release];

	[service release];
}

/**
 * Calls the MainView Controller and passes it the bdConnection class
 */
- (void) signInComplete:(NSString* )responseString
{	
	
	//scott:: delaying this until I can get the discID
	//[delegate signInComplete:responseString connection:bdconnection];
	xmlCallback = @"signIn";
	
	//response has been updated to include discID in the signIn repsonse and a skin background so parse them out now.
	NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
	XmlParserBase *myXmlParser = [[XmlParserBase alloc] initWithNodeName:@"RESPONSE"];
	[myXmlParser setDelegate:self];
	[myXmlParser parseXMLFromData:[responseString dataUsingEncoding:NSASCIIStringEncoding]];
	[myXmlParser release];
	[myPool release];	
	
	
	//xmlCallback = @"none";
	//[bdconnection sendCommand:@"disc_id" param1:nil param2:nil param3:nil param4:nil];
	//store the BDConnect object in the appDelegate
	//[appDelegate setBdConnection:bdconnection];
	
	//successfull connection so move on!
	//[delegate signInComplete];
	
}


//THIS NEVER GETS CALLED _WTF__!!! --- ALEC
-(void)receiveResponseString:(NSString*)response
{
	if([xmlCallback isEqualToString:@"signIn"]){
		NSLog(@"unhandled server response: %@", response);
		//looking for discID
		NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
		XmlParserBase *myXmlParser = [[XmlParserBase alloc] initWithNodeName:@"DiscId"];
		[myXmlParser setDelegate:self];
		[myXmlParser parseXMLFromData:[response dataUsingEncoding:NSASCIIStringEncoding]];
		[myXmlParser release];
		[myPool release];	
	}
	/*
	 
	 // Alec uncommented... as we're not using.
	 
	else if([xmlCallback isEqualToString:@"skinBg"]){
		//skin is ready to be applied
		[bdconnection updateImageFile:[NSString stringWithFormat:@"/%@/skinBg.png", [bdconnection uniqueId]] forImageView:appDelegate.mainBG];
		//check for netflixID and name
		xmlCallback = @"bdtmdlist";
		[bdconnection sendCommand:@"list_bdtouchmetadata" param1:nil param2:nil param3:nil param4:nil];
		
		//then proceed with login
		//[(ConnectViewController*)delegate signInComplete];
		
	}else if([xmlCallback isEqualToString:@"bdtmdlist"]){
		NSLog(@"about to parse response of: %@", response);
		NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];
		XmlParserProperty *myXmlParserProperty = [[XmlParserProperty alloc] initWithNodeName:@"BDTMDList"];
		[myXmlParserProperty setDelegate:self];
		[myXmlParserProperty parseXMLFromData:[response dataUsingEncoding:NSASCIIStringEncoding]];
		[myXmlParserProperty release];
		[myPool release];	
	}
	 */
	
}

- (void)xmlParserDone:(NSMutableArray *)items{
	/*
	if([xmlCallback isEqualToString:@"discId"]){
		// I dont think this case is needed any longer, discID is now returned in the signIn
		xmlCallback = @"none";
		//store the discID in the appDelegate
		[appDelegate setDiscId:[(NSDictionary*)[items objectAtIndex:0] objectForKey:@"DiscId"]];
		//store the BDConnect object in the appDelegate
		//[appDelegate setBdConnection:bdconnection];
		
		//successfull connection so move on!
		[(ConnectViewController*)delegate signInComplete];
	}else 
		*/
		if ([xmlCallback isEqualToString:@"signIn"]){
		xmlCallback = @"none";
		
		//Alec Added...
		NSString *receivedDiscId = [(NSDictionary*)[items objectAtIndex:0] objectForKey:@"DISCID"];
		
		if(! [receivedDiscId isEqualToString: kDiscID]){
			// wrong discID, disconnect
			[bdconnection sendSignOut];
			[(ConnectViewController*)delegate discIdMismatch];

			return;
		}
		//end Alec added
		   
		
		[bdconnection setDiscId:[(NSDictionary*)[items objectAtIndex:0] objectForKey:@"DISCID"]];
		[bdconnection setOrgId:[(NSDictionary*)[items objectAtIndex:0] objectForKey:@"ORGID"]];
		[bdconnection setUniqueId:[NSString stringWithFormat:@"%@%@",[bdconnection orgId], [bdconnection discId]]];
		
		
		//the BD Connect object attempts to grab the session ID form the signIn response by simply doing a range select on the string.
		//I could override that more accurately here just in case the repsonse changes slightly.
		[bdconnection updateSessionId:[(NSDictionary*)[items objectAtIndex:0] objectForKey:@"SESSIONID"]];
		
		NSString* skinPath = [(NSDictionary*)[items objectAtIndex:0] objectForKey:@"BDTSKIN"];
		if(skinPath){
			//one was actually defined
			//download the file
			xmlCallback = @"skinBg";
			[bdconnection sendDownloadFile:skinPath theFileName:[NSString stringWithFormat:@"/%@/skinBg.png", [bdconnection uniqueId]] theFileType:@"Image"];

		}else{
			//no skin, check for netflixID and name
			xmlCallback = @"bdtmdlist";
			[bdconnection sendCommand:@"list_bdtouchmetadata" param1:nil param2:nil param3:nil param4:nil];
			
			//[(ConnectViewController*)delegate signInComplete];
		}
		
			//[(ConnectViewController*)delegate signInCompleteWithConnection:bdconnection]; // ALEC: COMMENT OUT???
			[delegate signInCompleteWithConnection:bdconnection]; // ALEC: COMMENT OUT???

		
	}

}

- (void)xmlParserPropertyDone:(NSMutableArray *)items{
	NSString* nfid = [NSString stringWithString:@""];
	NSString* name = [NSString stringWithString:@""];
	NSString *bdtUrlString = [NSString stringWithFormat:@"http://www.bdtouch.com/bdnetflixmap.asp?orgid=%@&discId=%@", [bdconnection orgId], [bdconnection discId]];
	NSString *newId = [NSString stringWithString:@""];
	if ([xmlCallback isEqualToString:@"bdtmdlist"]){
		if([items count]>0){
			
			@try{
				nfid = [(NSDictionary*)[items objectAtIndex:0] objectForKey:@"nfid"];
				//NSLog(@"nfid is: %@",nfid);
			}@catch (NSException *e) {
				nfid = [NSString stringWithString:@""];
			}
			@try{
				name = [(NSDictionary*)[items objectAtIndex:0] objectForKey:@"titleName"];
				//NSLog(@"name is: %@",name);
			}@catch (NSException *e) {
				name=[NSString stringWithString:@""];
			}
			if(![nfid isEqualToString:@""]){
				//there was an nfid present
				bdconnection.nfId = nfid;
			}else{
				//attempt to get it from the bdtouch.com
				

				NSURL *bdTouchUrl = [NSURL URLWithString:bdtUrlString];
				
				//newId = [NSString stringWithContentsOfURL:bdTouchUrl]; // was deprecated in 2.0; alec replaced with next 3 lines
				NSError *err;
				NSStringEncoding enc = NSUTF8StringEncoding; 
				newId = [NSString stringWithContentsOfURL:bdTouchUrl encoding:enc error:&err];
				if(newId!=nil){
					nfid = newId;
				}
				bdconnection.nfId = nfid;
			}
			if(![name isEqualToString:@""]){
				bdconnection.discName = name;
			}else{
				//assign a default "No Name"
				bdconnection.discName = name;
			}
			
		}
		
		//all done so send the connected message along
		[(ConnectViewController*)delegate signInCompleteWithConnection:bdconnection]; // AV: COMMENT OUT?
	}
	
}
- (void)xmlParserDoneWithError:(NSError *)parseError{
	
}



@end
