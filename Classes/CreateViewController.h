//
//  CreateViewController.h
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright Juggleware, LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlasmaView.h"
#import "PlasmaController.h"
#import "Constants.h"
#import <QuartzCore/CADisplayLink.h>
#import "PieView.h"
//#import "BDConnect.h"
//#import "Reachability.h"
//#import "ConnectViewController.h"
#import "AudioMixer.h"
#import "AudioMixerSamplePickerController.h"

#define kMinimumSwipeLength 50
#define kMaximumSwipeVariance .25

/*
typedef enum {
	kPlasmaModeNormal = 0,
	kPlasmaModeBluRayRemote
} PlasmaControlMode;
*/
@interface CreateViewController : UIViewController <AudioMixerSamplePickerControllerDelegate>  {
	PlasmaController *plasmaController;
	
	CADisplayLink *animationTimer;
	NSTimeInterval animationInterval;
	NSTimeInterval deltaTime;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval timeSinceLevelStart;
	NSDate *levelStartTime;
	
	int frames;
	NSDate *lastFPSreading;
	IBOutlet UILabel *status;
	
	NSArray *plasmaPalettes;
	
	IBOutlet PlasmaView *plasmaView;
	IBOutlet PieView *pieView;
	//PlasmaControlMode plasmaControlMode;
	IBOutlet UIView *hintsLayer;
	IBOutlet UIImageView *hintsArrows;
	
	UIImageView *rippleAnimation;
	
//	//BDConnect
//	BDConnect *bdconnection;
//	NetworkStatus networkConnectionStatus;

	AudioMixer *audioMixer;
	
	CGPoint gestureStartPoint;
	int wedgeTouchedNum;
	
	int lastSetBeforeOpeningSetPicker; // remember this so we know if it's changed  

	
	
}

@property (retain, nonatomic) CADisplayLink *animationTimer;
@property (assign) NSTimeInterval animationInterval;
@property (assign) NSTimeInterval deltaTime;
@property (assign) NSTimeInterval lastFrameStartTime;
@property (assign) NSTimeInterval timeSinceLevelStart;
@property (assign) NSDate *levelStartTime;

@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) NSArray *plasmaPalettes;

@property (nonatomic, retain) PlasmaView *plasmaView;
@property (nonatomic, retain) PieView *pieView;
//@property (assign) PlasmaControlMode plasmaControlMode;
@property (nonatomic, retain) UIView *hintsLayer;
@property (nonatomic, retain) UIImageView *hintsArrows;

@property (nonatomic, retain) AudioMixer *audioMixer;

@property (assign) CGPoint gestureStartPoint;

- (void) startAnimation;
- (void)initializeTimer;
- (void) stopAnimation;
- (void) applicationWillResignActive;
- (void) applicationDidBecomeActive;
- (void) updateAccelerometerWith:(UIAcceleration *)acceleration;

-(void)showHintsLayer;
-(void)hideHintsLayer;

-(void)makeWheelForCurrentAudioSet;

//- (IBAction) linkButtonWasPressed;
- (void) previousAudioSet;
- (void) nextAudioSet;
//- (IBAction) audioSettingsButtonWasTouched;
-(void)toggleAudioForWedge:(int)pieceNum;
-(void)redrawHighlightStateForWedges;
-(ArcWedge *)wedgeTouchedAtPos:(CGPoint)pos;
//-(void) playBDSegmentForWedge: (int)pieceNum;

//-(PlasmaControlMode)plasmaControlMode;
-(void)oneTap;
-(void)twoTaps;
-(void)threeTaps;


// got a shake event-- stop audio
-(void)deviceShaken;
@end

