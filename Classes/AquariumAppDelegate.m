//
//  AquariumAppDelegate.m
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright Juggleware, LLC 2010. All rights reserved.
//

#import "AquariumAppDelegate.h"
#import "CreateViewController.h"
#import "BDConnect.h"
#import <AVFoundation/AVAudioSession.h>
#import "WebViewController.h"

@implementation AquariumAppDelegate

@synthesize window, tabBarController;
@synthesize viewController;
//@synthesize bdConnection;
@synthesize audioMixer;
@synthesize songPlayer;

#pragma mark -
#pragma mark get reference to SongPlayer singleton

-(SongPlayer *)songPlayer{
	if(songPlayer == nil){
		songPlayer = [SongPlayer sharedManager];
		//songPlayer.delegate = self;
	}	
	return songPlayer;
}


- (void)dealloc {
	[audioMixer release];
	[songPlayer release];
	//[bdConnection release];
	
    [viewController release];
	[tabBarController release];
    [window release];
    [super dealloc];
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	//self.bdConnection = [[[BDConnect alloc] init] retain]; // this retain seems redundant!
	//[bdConnection setUniqueId:kDiscID];

    // Override point for customization after application launch.
	//[application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated: NO];
	[application setStatusBarHidden: YES withAnimation: NO];

    // Add the view controller's view to the window and display.
    //[window addSubview:viewController.view];
	
	[window addSubview: [[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Default.png"]] autorelease] ];
	[window makeKeyAndVisible];
	
	UIImageView *headLogo = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"head-logo.png"]];
	[headLogo setCenter: CGPointMake(160.0, 240.0)];
	headLogo.alpha = 0.0f;
	[window addSubview: headLogo];
	
	
	[UIView beginAnimations:@"showHeadLogo" context:nil];
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	headLogo.alpha = 1.0f;
	[UIView commitAnimations];
	[headLogo release];
	
	[self performSelector: @selector(loadSplash2) withObject:nil afterDelay: 2.0f];

	audioMixer = [[AudioMixer alloc] init]; //may cause delay loading first set?
	mixerWasPausedBySystem = NO;
	songPlayerWasPausedBySystem = NO;
	
	return YES;
}


-(void)loadSplash2{
	[window addSubview: [[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"psychic_summit-aquarium_2-splash.png"]]autorelease]];
	[self performSelector: @selector(loadTabBarController) withObject:nil afterDelay: 3.0f];
	[self performSelector: @selector(preloadAudio) withObject:nil afterDelay: 0.01f];

}

// no longer relevant?

-(void)preloadAudio{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//NSLog(@"preloading audio...");
	[self.audioMixer preloadSet]; // forces init
	//NSLog(@"audio preloaded");

	[pool drain];
}


-(void)loadTabBarController{
	//[SongPlayer sharedManager]; // makes sure it's ready
	
	tabBarController.view.frame = CGRectMake(0, 0, 320, 529);

	[window addSubview: tabBarController.view];
	
	[UIView beginAnimations:@"showTabBar" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	
	tabBarController.view.frame = CGRectMake(0, 0, 320, 480);
	[window addSubview: tabBarController.view];

	[UIView commitAnimations];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self	];
	
}

// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    // Update the accelerometer graph view
    [viewController updateAccelerometerWith:acceleration];
}

- (BOOL)pauseAudioWhenScreenLocked{
	return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	
	//NSLog(@"applicationWillResignActive");
	
	//[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
	[viewController applicationWillResignActive];
	
	// we want to pause audio here if user prefs ask for no audio on screen lock.
	if ([self pauseAudioWhenScreenLocked]) {
		mixerWasPausedBySystem = [self.audioMixer enterBackgroundMode];
		songPlayerWasPausedBySystem = [self.songPlayer enterBackgroundMode];
	}
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */

	//NSLog(@"applicationDidEnterBackground");
	
	//pause all audio

	// we want to pause audio here, instead of above
	// if user prefs ask for audio on screen lock.
	
	if (![self pauseAudioWhenScreenLocked]) {
		mixerWasPausedBySystem = [self.audioMixer enterBackgroundMode];
		songPlayerWasPausedBySystem = [self.songPlayer enterBackgroundMode];
	}
	//AVAudioSession *session = [AVAudioSession sharedInstance]; 
	//[session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
	//[session setActive: YES error: nil];
	//session.delegate = self;
	
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
	//NSLog(@"applicationWillEnterForeground");

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	//NSLog(@"applicationDidBecomeActive");
	
	[viewController applicationDidBecomeActive];
	
	AVAudioSession *session = [AVAudioSession sharedInstance]; 
	[session setCategory:AVAudioSessionCategoryPlayback error:nil];
	[session setActive: YES error: nil];
	session.delegate = self;
	
	//resume all audio that was paused by entering background
	if(songPlayerWasPausedBySystem) {		
		[self.songPlayer leaveBackgroundMode];
	}				
	
	if(mixerWasPausedBySystem) {
		[self.audioMixer leaveBackgroundMode];
	}		
	
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
	//NSLog(@"applicationWillTerminate");
	
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark -
#pragma mark AVAudioSessionDelegate methods

-(void)beginInterruption{
	//NSLog(@"AVAudioSessionDelegate: beginInterruption");

	//only need to do this if not triggered by screen lock 
	// which would happen at applicationWillResignActive
	if (![self pauseAudioWhenScreenLocked]) {
		mixerWasPausedBySystem = [self.audioMixer enterBackgroundMode];
		songPlayerWasPausedBySystem = [self.songPlayer enterBackgroundMode];
	}
	
	
	
}

-(void)endInterruptionWithFlags:(NSUInteger)flags{
	//NSLog(@"AVAudioSessionDelegate: endInterruptionWithFlags flags= %i",flags);

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	// Do something with the url here
	
	
	NSString *urlString = [url absoluteString];
	urlString = [urlString stringByReplacingOccurrencesOfString: @"aqua2app://" withString: @"http://" ];
	
	/*
	 
	 UIViewController *viewController = [navigationController visibleViewController];
	 
	 if ([viewController isKindOfClass:[IngredientViewController class]]) {
	 NSLog(@"Got URL %@", urlString);	
	 IngredientViewController *ingredientViewController = (IngredientViewController *) viewController;
	 [ingredientViewController openBrowserWithUrl: [NSURL URLWithString: urlString]];	
	 }
	 */
	
	[self openBrowserWithUrl: [NSURL URLWithString: urlString] ];
	return TRUE;
}

#pragma mark -
#pragma mark other
-(void)openBrowserWithUrl: (NSURL *)theUrl{
	
	// open browser
	
	WebViewController *controller = [[WebViewController alloc] initWithURL:theUrl];
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[tabBarController presentModalViewController:controller animated:YES];
	[controller release];
		
	//open in Safari for now
	
	// [[UIApplication sharedApplication] openURL:theUrl];
	
}



/*
-(void)hideTabBar{
	//for(UIView *view in tabBarController.view.subviews)
	//	{
	//		if([view isKindOfClass:[UITabBar class]])
	//		{
	//			view.hidden = YES;
	//			break;
	//		}
	//	}
	
	[UIView beginAnimations:@"hideTabBar" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	[UIView commitAnimations];

}

-(void)showTabBar{
	
	[UIView beginAnimations:@"showTabBar" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
//	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];

	tabBarController.view.frame = CGRectMake(0, 0, 320, 480);
	[UIView commitAnimations];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTabBar) object:nil];
	[self performSelector:@selector(hideTabBar) withObject:nil afterDelay: 4.0];
}

*/



@end
