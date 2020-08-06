//
//  CreateViewController.m
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright Juggleware, LLC 2010. All rights reserved.
//

#import "CreateViewController.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import "AudioMixer.h"
#import "AudioMixerSamplePickerController.h"
#import "UIColor-Expanded.h"
#import "AquariumAppDelegate.h"

@implementation CreateViewController


@synthesize animationTimer, animationInterval, deltaTime, timeSinceLevelStart, levelStartTime, lastFrameStartTime;
@synthesize status, plasmaPalettes, plasmaView, pieView, hintsLayer, hintsArrows;
@synthesize audioMixer;
@synthesize gestureStartPoint;

//@synthesize bdconnection, networkConnectionStatus;

- (void)dealloc {
	self.animationTimer = nil;
	[self stopAnimation];
	[plasmaController release];
	
	[status release];
	
	[plasmaView release];
	[pieView release];
	[hintsArrows release];
	[hintsLayer release];
	[plasmaPalettes release];
//	[bdconnection release];
	[audioMixer release]; // crash?
	
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView *v = [self view];
	v.multipleTouchEnabled = NO;
	
	status.text = @"";
	
	//sets up all preliminary variables and objects
	ColorModel *palette1 = [[ColorModel alloc] initWithHexValues: [NSArray arrayWithObjects:
		   @"DAE120", @"E5E72F", @"CDE14A", @"B5DB66", @"9CD681", @"84D09C", @"6CCAB8", @"54C4D3",
		   @"3CBEEE", @"3CB2E6", @"3CA6DD", @"3D9AD4", @"3D8ECC", @"3D81C3", @"3E66B0", @"3E62AD",
		   @"3E5DAA", @"515CA8", @"655AA7", @"7859A5", @"8B58A3", @"9F57A2", @"B256A0", @"C6549F",
		   @"D9539D", @"DC589A", @"E05D96", @"E36293", @"E66790", @"E96C8D", @"EC718A", @"F07686",
		   @"F37B83", @"F48975", @"F59867", @"F7A659", @"F8B44B", @"F9C23E", @"FBD030", @"FCDF22",
		   nil]];
	
	plasmaPalettes = [[NSArray alloc] initWithObjects:  palette1, nil];
					  /*
						 [[ColorModel alloc] initWithRangeFrom:@"EFEFEF" to: @"EF5A28"],
						 [[ColorModel alloc] initWithRangeFrom:@"EBEBEB" to: @"EB297B"], 
						 [[ColorModel alloc] initWithRangeFrom:@"808080" to: @"800000"],
						 [[ColorModel alloc] initWithRangeFrom:@"8E8E8E" to: @"2B388E"],
						 [[ColorModel alloc] initWithRangeFrom:@"EDEDED" to: @"00ACED"],
						 [[ColorModel alloc] initWithRangeFrom:@"929292" to: @"009245"],
						[[ColorModel alloc] initWithRangeFrom:@"7e7e7e" to: @"900000"],
						 nil
						 ];
	*/
	
	plasmaController = [[PlasmaController alloc] initWithView:self.plasmaView palette:palette1];
	[palette1 release];
	
	//add the pie view to it
	[plasmaController addPieView: self.pieView];
	//plasmaControlMode = kPlasmaModeNormal;
	
	//[pieView setDelegate:self];
	//[pieView createWheel];
	
	//make sure buttons layer starts out hidden to start
	hintsLayer.alpha = 0.0;
	
	// starts the game loop
	[self startAnimation];
	
	//audioMixer = [[AudioMixer alloc] init];
	AquariumAppDelegate *app = (AquariumAppDelegate *)[[UIApplication sharedApplication] delegate];
	audioMixer = app.audioMixer;
	
	[self makeWheelForCurrentAudioSet];
	
	wedgeTouchedNum = -1;
	
	
	hintsArrows.animationImages = [NSArray arrayWithObjects:
								   [UIImage imageNamed:@"create-swipe_ani_00.png"],
								   [UIImage imageNamed:@"create-swipe_ani_01.png"],
								   [UIImage imageNamed:@"create-swipe_ani_02.png"],
								   [UIImage imageNamed:@"create-swipe_ani_03.png"],
								   [UIImage imageNamed:@"create-swipe_ani_04.png"],
								   [UIImage imageNamed:@"create-swipe_ani_05.png"],
								   [UIImage imageNamed:@"create-swipe_ani_06.png"],
								   [UIImage imageNamed:@"create-swipe_ani_07.png"],
								   [UIImage imageNamed:@"create-swipe_ani_08.png"],
								   [UIImage imageNamed:@"create-swipe_ani_09.png"],
								   [UIImage imageNamed:@"create-swipe_ani_10.png"],
								   [UIImage imageNamed:@"create-swipe_ani_11.png"],
								   [UIImage imageNamed:@"create-swipe_ani_12.png"],
								   [UIImage imageNamed:@"create-swipe_ani_13.png"],
								   [UIImage imageNamed:@"create-swipe_ani_14.png"],
								   [UIImage imageNamed:@"create-swipe_ani_15.png"],
								   [UIImage imageNamed:@"create-swipe_ani_16.png"],
								   [UIImage imageNamed:@"create-swipe_ani_17.png"],
								   [UIImage imageNamed:@"create-swipe_ani_18.png"],
								   [UIImage imageNamed:@"create-swipe_ani_19.png"],
								   nil];
	hintsArrows.animationDuration = 2.0;
	hintsArrows.animationRepeatCount = -1;
	
	
	rippleAnimation = [[UIImageView alloc] init]; 
						/*]WithFrame:CGRectMake(0, 0, 
				[UIImage imageNamed:@"create-button_ani_00.png"].size.width,
				[UIImage imageNamed:@"create-button_ani_00.png"].size.height)];
						 */
	rippleAnimation.animationImages = [NSArray arrayWithObjects:
									   [UIImage imageNamed:@"create-button_ani_00.png"],
									   [UIImage imageNamed:@"create-button_ani_01.png"],
									   [UIImage imageNamed:@"create-button_ani_02.png"],
									   [UIImage imageNamed:@"create-button_ani_03.png"],
									   [UIImage imageNamed:@"create-button_ani_04.png"],
									   [UIImage imageNamed:@"create-button_ani_05.png"],
									   [UIImage imageNamed:@"create-button_ani_06.png"],
									   [UIImage imageNamed:@"create-button_ani_07.png"],
									   [UIImage imageNamed:@"create-button_ani_08.png"],
									   [UIImage imageNamed:@"create-button_ani_09.png"],
									   [UIImage imageNamed:@"create-button_ani_10.png"],
									   [UIImage imageNamed:@"create-button_ani_11.png"],
									   [UIImage imageNamed:@"create-button_ani_12.png"],
									   [UIImage imageNamed:@"create-button_ani_13.png"],
									   [UIImage imageNamed:@"create-button_ani_14.png"],
									   [UIImage imageNamed:@"create-button_ani_15.png"],
									   [UIImage imageNamed:@"create-button_ani_16.png"],
									   [UIImage imageNamed:@"create-button_ani_17.png"],
									   [UIImage imageNamed:@"create-button_ani_18.png"],
									   [UIImage imageNamed:@"create-button_ani_19.png"],
									   [UIImage imageNamed:@"create-button_ani_20.png"],
									   [UIImage imageNamed:@"create-button_ani_21.png"],
									   [UIImage imageNamed:@"create-button_ani_22.png"],
									   [UIImage imageNamed:@"create-button_ani_23.png"],
									   [UIImage imageNamed:@"create-button_ani_24.png"],
									   [UIImage imageNamed:@"create-button_ani_25.png"],
									   [UIImage imageNamed:@"create-button_ani_26.png"],
									   [UIImage imageNamed:@"create-button_ani_27.png"],
									   [UIImage imageNamed:@"create-button_ani_28.png"],
									   [UIImage imageNamed:@"create-button_ani_29.png"],
									   nil];
	rippleAnimation.animationDuration = 0.4; // 1 sec 10 frames @ 24fps = 1 & 5/12 sec
	rippleAnimation.animationRepeatCount = 1;
	rippleAnimation.alpha = 0.6;
	rippleAnimation.opaque = NO;
	[self.view addSubview:rippleAnimation];

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
	//NSLog(@"Starting animation...");
		
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
	[self redrawHighlightStateForWedges];
	
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
	
	//NSLog(@"Stopping animation...");
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
	
		if(kShowDebugStatus){
			
			status.text = [NSString stringWithFormat:@"%i Sprites @ %f FPS T=%f",
						   [self.plasmaView.model.sprites count],
						   -(frames/[lastFPSreading timeIntervalSinceNow]), -timeSinceLevelStart];
			
		}
		
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

- (void) viewDidAppear:(BOOL)animated {
	[self startAnimation];
	
	[self showHintsLayer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceShaken) name:@"DeviceShaken" object:nil];
	
	
}

- (void) viewWillDisappear:(BOOL)animated {
	[self stopAnimation];
	[[NSNotificationCenter defaultCenter] removeObserver:self];

}
#pragma mark -
#pragma mark touches

-(ArcWedge *)wedgeTouchedAtPos:(CGPoint)pos{
	CGFloat dx = pos.x - self.view.bounds.size.width /2.0 - kWheelControllerX;
	CGFloat dy = pos.y - self.view.bounds.size.height /2.0 - kWheelControllerY;
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
//		NSLog(@"Wedge #%i touched at angle = %f", touchedWedge.pieceNum, theta)
		
		return touchedWedge;
	}
	
	return nil;
}


-(void)oneTap
{
	//NSLog(@"Single tap");
	//; show Hints
	[self showHintsLayer];

}

-(void)twoTaps
{
	//NSLog(@"Double tap");
	
	AudioMixerSamplePickerController *vc = [[AudioMixerSamplePickerController alloc] init];
	//											initWithNibName:@"AudioMixerSamplePickerController" bundle:nil];
	
	vc.audioMixer = self.audioMixer;				
	lastSetBeforeOpeningSetPicker = self.audioMixer.currentSetNum; 
	[self presentModalViewController:vc animated:YES];
	[vc setDelegate: self];
}

-(void)threeTaps
{
	//NSLog(@"Triple tap");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//NSLog(@"touchesBegan");

	UITouch *touch = [touches anyObject];
	gestureStartPoint = [touch locationInView:self.view]; // store for swipe!
	//NSLog(@"gestureStartPoint = %f,%f", gestureStartPoint.x, gestureStartPoint.y);
	
	
	wedgeTouchedNum = -1; 
	ArcWedge *wedge;
	if ((wedge = [self wedgeTouchedAtPos:gestureStartPoint])) {
		wedgeTouchedNum = wedge.pieceNum;
		
		// ripple animation
		UIImage *firstImage = [rippleAnimation.animationImages lastObject];
		CGFloat w = firstImage.size.width;
		CGFloat h = firstImage.size.height;
		rippleAnimation.frame = CGRectMake(gestureStartPoint.x - w/2.0, gestureStartPoint.y - h/2.0, w, h);
		[rippleAnimation startAnimating];
		
	}
	
		

}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	CGPoint pos = [touch locationInView: self.view];
	//NSLog(@"touchesEnded with %f,%f",gestureStartPoint.x - pos.x,gestureStartPoint.y - pos.y);

	CGFloat deltaX = fabsf(gestureStartPoint.x - pos.x);
	CGFloat deltaY = fabsf(gestureStartPoint.y - pos.y);
	
	if(deltaX >= kMinimumSwipeLength){
	//swipe!
		//NSLog(@"swipe!");
		
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];

		
		if(deltaY/deltaX <= kMaximumSwipeVariance){
			//NSLog(@"horizontal!");

			// horizontal swipe!
			if (pos.x > gestureStartPoint.x) {
				//swiped to right = page left 
				[self previousAudioSet];
			}else {
				//swiped to left = page right
				[self nextAudioSet];
			}
		}

	}else{
		//tap!
		//NSLog(@"tap!");
		
		// see if the touch was within the wheel...
		ArcWedge *wedge;
		if ((wedge = [self wedgeTouchedAtPos:pos])) {
			
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
			

			
		//	NSLog(@"Wedge #%i touched at angle = %f", wedge.pieceNum, theta);
			
			//make sure touch up was on same wedge as touch down!
			if(wedge.pieceNum == wedgeTouchedNum){
				
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
				//		if(plasmaControlMode==kPlasmaModeBluRayRemote){
				//			
				//			//plasmaControlMode = kPlasmaModeBluRayRemote;
				//			
				//			[m switchToMonochromePalette: touchedWedge.pieceNum];
				//			
				//			//			
				//		//	[self playBDSegmentForWedge: touchedWedge.pieceNum];
				//			
				//			
				//			
				//		}else {
				//			//plasmaControlMode = kPlasmaModeNormal;
				//
				//		}
				
				[self toggleAudioForWedge: wedge.pieceNum];
			}else {
				// Touch ended inside wheel area but started outside; show Hints
				[self showHintsLayer];
			}

		}else {
			
			// Touch ended outside wheel area
			
			
			switch ([touch tapCount]) 
			{
				case 1:
					[self performSelector:@selector(oneTap) withObject:nil afterDelay:.5];
					break;
					
				case 2:
					[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
					//[self performSelector:@selector(twoTaps) withObject:nil afterDelay:.5];
					[self twoTaps];
					break;
					
					/*case 3:
					 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoTaps) object:nil];
					 [self performSelector:@selector(threeTaps) withObject:nil afterDelay:.5];
					 break;
					 */
					
				default:
					//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];

					break;
			}
			

		}	
	}
	
	wedgeTouchedNum = -1; 

}




#pragma mark -

-(void)showHintsLayer{
	[UIView beginAnimations:@"showHintsLayer" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 480);
	hintsLayer.alpha = 1.0;
	[UIView commitAnimations];
	
/*	
	hintsArrows.animationImages = [NSArray arrayWithObjects:
							  [UIImage imageNamed:@"create-swipe_ani_1.png"],
							  [UIImage imageNamed:@"create-swipe_ani_2.png"],
							  [UIImage imageNamed:@"create-swipe_ani_3.png"],
							  [UIImage imageNamed:@"create-swipe_ani_4.png"],
							  [UIImage imageNamed:@"create-swipe_ani_5.png"],
							  nil];
	hintsArrows.animationDuration = 1.0;
	hintsArrows.animationRepeatCount = -1;
 */
	[hintsArrows startAnimating];
	
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHintsLayer) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHintsLayerFinished) object:nil];
	[self performSelector:@selector(hideHintsLayer) withObject:nil afterDelay: 5.0];
	
}

-(void)hideHintsLayer{
	[UIView beginAnimations:@"hideHintsLayer" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	//	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	//tabBarController.view.frame = CGRectMake(0, 0, 320, 529);
	hintsLayer.alpha = 0.0;
	[UIView commitAnimations];
	[self performSelector:@selector(hideHintsLayerFinished) withObject:nil afterDelay: 0.5];

}

-(void)hideHintsLayerFinished{
	[hintsArrows stopAnimating];
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

//#pragma mark -
//#pragma mark User Controls for BD
//- (IBAction) linkButtonWasPressed{
//	
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
//	
////	if((! bdconnection)&&(plasmaControlMode==kPlasmaModeBluRayRemote)){
////		[self connectToBluRayDisc];
////	}
//}
	 
#pragma mark -
#pragma mark Wheel 

 -(void)makeWheelForCurrentAudioSet{
	 NSArray *wheelColors = [self.audioMixer colorArrayForSamplesInCurrentSet];
	 ColorModel *wheelPalette = [[[ColorModel alloc] initWithHexValues:wheelColors] autorelease];
	 //[plasmaController.model makeVectorWheelControllerWithPalette:(ColorModel *)wheelPalette];
	 [plasmaController.model replaceWheelForColorsInPalette:wheelPalette];
	 
	 //put this elsewhere?
	 ColorModel *plasmaPalette = nil;
	 if(self.audioMixer.currentSetNum <= plasmaPalettes.count -1){
		 plasmaPalette = [plasmaPalettes objectAtIndex:self.audioMixer.currentSetNum];
	 }	 
	
	 if (! plasmaPalette) {
		// create one from audio color settings
		 
	 
		 UIColor *color1 = [UIColor colorWithHexString: [self.audioMixer colorForSet:self.audioMixer.currentSetNum]];
		 
			// const float kLightenBy = 0.2; 
	//	 UIColor *color0 = [color1 colorByAddingRed: -kLightenBy green:-kLightenBy blue:-kLightenBy alpha:0.0];
	//	 UIColor *color2 = [color1 colorByAddingRed: kLightenBy green:kLightenBy blue:kLightenBy alpha:0.0];
		
		 const float kDarken = 0.6;
		 const float kLighten = 1.5;
		 UIColor *color0 = [UIColor colorWithRed:color1.red * kDarken green:color1.green * kDarken blue:color1.blue * kDarken alpha:1.0];		 
		 UIColor *color2 = [UIColor colorWithRed:color1.red * kLighten green:color1.green * kLighten blue:color1.blue * kLighten alpha:1.0];		 
		 
		if( self.audioMixer.currentSetNum % 2 == 0){
			// every other palette is swapped for better contrast!
			
			plasmaPalette = [[[ColorModel alloc] initWithRangeFrom:[color2 hexStringFromColor] to:[color0 hexStringFromColor]] autorelease]; 

		}else {
			plasmaPalette = [[[ColorModel alloc] initWithRangeFrom:[color0 hexStringFromColor] to:[color2 hexStringFromColor]] autorelease]; 

		}

		 
	 }
	 
	 [plasmaController.model setPalette:plasmaPalette];
	 
 }

- (void) previousAudioSet{
	[self.audioMixer switchToPreviousSet];
	// flip wheel
	[UIView beginAnimations:@"flipWheel" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.pieView cache:YES];
	
	[self makeWheelForCurrentAudioSet];
	
	[plasmaController tic:0.0001]; // forces update without really moving
	
	[UIView commitAnimations];
	
	
}
- (void) nextAudioSet{
	[self.audioMixer switchToNextSet];
	// flip wheel
	[UIView beginAnimations:@"flipWheel" context:nil];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.pieView cache:YES];
	
	[self makeWheelForCurrentAudioSet];
	
	[plasmaController tic:0.0001]; // forces update without really moving
	
	[UIView commitAnimations];


}

/*
- (IBAction) audioSettingsButtonWasTouched{
	// show audio settings controller
	AudioMixerSamplePickerController *vc = [[AudioMixerSamplePickerController alloc] init];
//											initWithNibName:@"AudioMixerSamplePickerController" bundle:nil];

	vc.audioMixer = self.audioMixer;				
	lastSetBeforeOpeningSetPicker = self.audioMixer.currentSetNum; 
	[self presentModalViewController:vc animated:YES];
	[vc setDelegate: self];
	
}
*/

-(void)toggleAudioForWedge:(int)pieceNum{
	
	//NSAssert(pieceNum<[self.audioMixer numberOfSamplesInCurrentSet],@"Out of bounds!");
	NSAssert2((0 <= pieceNum) && (pieceNum <= [self.audioMixer numberOfSamplesInCurrentSet]-1),
			  @"PieceNum %i out of range in audio set of %i samples", pieceNum,[self.audioMixer numberOfSamplesInCurrentSet]);

	
	BOOL isPlaying = [audioMixer toggleMixerChannel:pieceNum];
	
	ArcWedge *touchedWedge = [plasmaController.model.wedges objectAtIndex:pieceNum];
	
	[touchedWedge setHighlightState:isPlaying];
	
}

-(void)redrawHighlightStateForWedges{
	if([plasmaController.model.wedges count]==0) return;
	
	for (int i=0; i<[self.audioMixer numberOfSamplesInCurrentSet]; i++) {
		BOOL isPlaying = [audioMixer isPlayingMixerChannel:i];
		ArcWedge *touchedWedge = [plasmaController.model.wedges objectAtIndex:i];
		[touchedWedge setHighlightState:isPlaying];
	}
}


// got a shake event-- stop audio
-(void)deviceShaken{
	[self redrawHighlightStateForWedges];
}


//delegate method
-(void)audioMixerSamplePickerWasDismissed{
	if (self.audioMixer.currentSetNum != lastSetBeforeOpeningSetPicker) {
		[self makeWheelForCurrentAudioSet];
	}
}


@end
