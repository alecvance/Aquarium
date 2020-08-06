//
//  PlasmaViewController.m
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright Juggleware, LLC 2010. All rights reserved.
//

#import "PlasmaViewController.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import "AudioMixer.h"
#import "AudioMixerSamplePickerController.h"

@implementation PlasmaViewController


@synthesize animationTimer, animationInterval, deltaTime, timeSinceLevelStart, levelStartTime, lastFrameStartTime;
@synthesize status, plasmaView, pieView, buttonsLayer, plasmaControlMode;
@synthesize audioMixer;
//@synthesize bdconnection, networkConnectionStatus;

- (void)dealloc {
	self.animationTimer = nil;
	[self stopAnimation];
	[plasmaController release];
	
	[status release];
	
	[plasmaView release];
	[pieView release];
	[buttonsLayer release];
	
//	[bdconnection release];
	[audioMixer release];
	
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView *v = [self view];
	v.multipleTouchEnabled = YES;
	
	//sets up all preliminary variables and objects
	plasmaController = [[PlasmaController alloc] initWithView: self.plasmaView];
	
	//add the pie view to it
	[plasmaController addPieView: self.pieView];
	plasmaControlMode = kPlasmaModeNormal;
	
	//[pieView setDelegate:self];
	//[pieView createWheel];
	
	//make sure buttons layer starts out hidden to start
	buttonsLayer.alpha = 0.0;
	
	// starts the game loop
	[self startAnimation];
	
	audioMixer = [[AudioMixer alloc] init];
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[self stopAnimation];
	self.pieView = nil;
	self.plasmaView = nil;
	
	
}


// Override to allow orientations other than the default portrait orientation.
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


//
// Core game loop
//
// these methods are copied over from the EAGLView template

- (void)startAnimation {
	NSLog(@"Starting animation...");
		
	//[pieView startAnimation];
	
		
	
	
	// plasma animation
	self.animationInterval = 1.0/kFPS;
	self.levelStartTime = nil;
	self.timeSinceLevelStart = 0;
	self.deltaTime = 0;
	frames = 0;
	self.levelStartTime = [[NSDate date] retain];
	lastFPSreading = [[NSDate date] retain];
	self.lastFrameStartTime = [levelStartTime timeIntervalSinceNow];
	/*
	 self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval
	 target:self 
	 selector:@selector(gameLoop) 
	 userInfo:nil 
	 repeats:YES];
	 */
	[self initializeTimer];
	
	
}

- (void)initializeTimer {
	if (animationTimer == nil) {
		animationTimer = [CADisplayLink displayLinkWithTarget:self 
													 selector:@selector(gameLoop)];
		animationTimer.frameInterval = 2; // 1=60FPS, 2=30FPS, 3=20FPS, 4=15FPS 
		[animationTimer addToRunLoop: [NSRunLoop currentRunLoop] 
							 forMode: NSDefaultRunLoopMode];
	}
}

- (void)stopAnimation {
	
	NSLog(@"Stopping animation...");
	///[pieView stopAnimation];
		
	self.animationTimer = nil;
}

/*
 - (void)setAnimationTimer:(NSTimer *)newTimer {
 [animationTimer invalidate];
 animationTimer = newTimer;
 }
 
 - (void)setAnimationInterval:(NSTimeInterval)interval {	
 animationInterval = interval;
 if (animationTimer) {
 [self stopAnimation];
 [self startAnimation];
 }
 }
 */
- (void)gameLoop
{
	// we use our own autorelease pool so that we can control when garbage gets collected
	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
	 
	self.timeSinceLevelStart = [levelStartTime timeIntervalSinceNow];
	self.deltaTime =  lastFrameStartTime - timeSinceLevelStart;
	self.lastFrameStartTime = timeSinceLevelStart;	
	
	[plasmaController tic: self.deltaTime];
	
	if(frames++ ==10){
		//NSLog(@"FPS: %f",  -(frames/[lastFPSreading timeIntervalSinceNow]));
	
		status.text = [NSString stringWithFormat:@"%i Sprites @ %f FPS T=%f",
					   [self.plasmaView.model.sprites count],
					   -(frames/[lastFPSreading timeIntervalSinceNow]), -timeSinceLevelStart];

		
		frames = 0;
		[lastFPSreading release];
		lastFPSreading = [[NSDate date] retain];
	}
	
	//[apool drain];
	[apool release];
	
}


- (void) applicationWillResignActive
{
	[self stopAnimation];
}

- (void) applicationDidBecomeActive
{
	[self startAnimation];
}

- (void) updateAccelerometerWith:(UIAcceleration *)acceleration {
		[plasmaController updateAccelerometerWith:(UIAcceleration *)acceleration];
}

- (void) viewWillAppear:(BOOL)animated {
	[self startAnimation];
}

- (void) viewDidDisappear:(BOOL)animated {
	[self stopAnimation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	UITouch *touch = [[event allTouches] anyObject];
	CGPoint pos = [touch locationInView:self.view];
	
	// see if the touch was within the wheel...
	CGFloat dx = pos.x - kScreenWidth/2 - kWheelControllerX;
	CGFloat dy = pos.y - kScreenHeight/2 - kWheelControllerY;
	CGFloat d = sqrt(dx*dx + dy*dy);
	//NSLog(@"Got touch at position %f,%f with distance of %f", dx, dy, d);
		
	if(d<kWheelRadius){
		
		CGFloat theta;
		
		if (dx < 0) {
			theta = atan(dy/dx) * 180.0/kPi + 180;
		}else {
			theta = atan(dy/dx) * 180.0/kPi;
		}


		PlasmaModel *m = plasmaController.model;
		ArcWedge *touchedWedge = [m wedgeAtAngle: theta];
		NSLog(@"Wedge #%i touched at angle = %f", touchedWedge.pieceNum, theta);

		//removed animate Touch as well since we are animating it for playback
		//[touchedWedge wasTouched];
		
		
		/*
		 
		 ------------
		 HERE LIES THE
		 AWESOME SPIN CODE
		 R.I.P.
		 --------
		 
		touchedWedge.spinTo = 270 - touchedWedge.pieceNum * 360.0/[m.wedges count] - touchedWedge.arcTheta/2.0;
		CGFloat spinBy = touchedWedge.spinTo - touchedWedge.rotation;

		for (ArcWedge *wedge in m.wedges) {
			wedge.spinTo = wedge.rotation + spinBy;
			wedge.spinSpeed = 3.0 * 100; // degrees per second
		}
		
		NSLog(@"Wedge #%i spinning to %f", touchedWedge.pieceNum, touchedWedge.spinTo);
		 
		 
		*/
		
		// IF the remote control mode is active then send command to the BluRay player
		if(plasmaControlMode==kPlasmaModeBluRayRemote){
			
			//plasmaControlMode = kPlasmaModeBluRayRemote;
			
			[m switchToMonochromePalette: touchedWedge.pieceNum];
			
			/*
			 
			 C1 Orange
			 EF5A28
			 EFEFEF
			 Play Title 1, C1
			 
			 C2 Coral
			 EB297B
			 EBEBEB
			 Play Title 5, Chapter 1
			 
			 
			 C3 Maroon
			 800000
			 808080
			 Play Title 7, Chapter 1
			 
			 C4 Current
			 2B388E
			 8E8E8E
			 Play Title 8, C1
			 
			 C5 Jelly
			 00ACED
			 EDEDED
			 Play Title 9, C1
			 
			 C6 River
			 009245
			 929292
			 Play Title 10, C1
			 
			 
			 13 - Mashiko
			 Title 13, C1
			 *in extras*
			 
			 14 - Help Video
			 Title 14, C1
			 *In ? area*
			 
			 15 - Future
			 Title 15, C1
			 **Bonus, Easter Egg**
*/			 
			
		//	[self playBDSegmentForWedge: touchedWedge.pieceNum];
			
			
			
		}else {
			//plasmaControlMode = kPlasmaModeNormal;

		}
		
		[self toggleAudioForWedge: touchedWedge.pieceNum];
		
		
		
	}else {
	//hack:	[[[UIApplication sharedApplication] delegate] showTabBar];
		[self showButtonsLayer];

	}

	
	
}

-(void)showButtonsLayer{
	[UIView beginAnimations:@"showButtonsLayer" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 480);
	buttonsLayer.alpha = 1.0;
	[UIView commitAnimations];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideButtonsLayer) object:nil];
	[self performSelector:@selector(hideButtonsLayer) withObject:nil afterDelay: 5.0];
	
}

-(void)hideButtonsLayer{
	[UIView beginAnimations:@"hideButtonsLayer" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	buttonsLayer.alpha = 0.0;
	[UIView commitAnimations];
}

//
//-(BOOL)remoteControlIsActive{
//	if (([self plasmaControlMode]==kPlasmaModeBluRayRemote) && (self.networkConnectionStatus == ReachableViaWiFi)) {
//		return YES;
//	}
//	
//	return NO;
//}
//
//
////#pragma mark -
////#pragma mark PieWedgeViewDelegate methods
////-(void) userSelectedPieWedgeNum:(int)number{
////	NSLog(@"Selected wedge #%i", number);
////}
//
#pragma mark -
#pragma mark User Controls for BD
- (IBAction) linkButtonWasPressed{
	
	//flip mode state
	if (plasmaControlMode==kPlasmaModeNormal) {
		plasmaControlMode=kPlasmaModeBluRayRemote;
	}else{
		plasmaControlMode=kPlasmaModeNormal;
	}
	
	// flip wheel
	[UIView beginAnimations:@"flipWheel" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.pieView cache:YES];

	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	
	
	[plasmaController.model flipWheel];
	[plasmaController tic:0.0001]; // forces update without really moving
	
	[UIView commitAnimations];
	
	
//	if((! bdconnection)&&(plasmaControlMode==kPlasmaModeBluRayRemote)){
//		[self connectToBluRayDisc];
//	}
}

- (IBAction) audioSettingsButtonWasTouched{
	// show audio settings controller
	AudioMixerSamplePickerController *vc = [[AudioMixerSamplePickerController alloc] init];
//											initWithNibName:@"AudioMixerSamplePickerController" bundle:nil];

	vc.audioMixer = self.audioMixer;										
	[self presentModalViewController:vc animated:YES];
	//[vc setDelegate: self];
	
}

-(void)toggleAudioForWedge:(int)pieceNum{
	BOOL isPlaying = [audioMixer toggleMixerChannel:pieceNum];
	
	ArcWedge *touchedWedge = [plasmaController.model.wedges objectAtIndex:pieceNum];
	
	[touchedWedge setHighlightState:isPlaying];
	
}




@end
