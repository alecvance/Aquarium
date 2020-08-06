//
//  PlasmaViewController.h
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

typedef enum {
	kPlasmaModeNormal = 0,
	kPlasmaModeBluRayRemote
} PlasmaControlMode;

@interface PlasmaViewController : UIViewController  {
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
	
	IBOutlet PlasmaView *plasmaView;
	IBOutlet PieView *pieView;
	PlasmaControlMode plasmaControlMode;
	IBOutlet UIView *buttonsLayer;
	
//	//BDConnect
//	BDConnect *bdconnection;
//	NetworkStatus networkConnectionStatus;

	AudioMixer *audioMixer;
}

@property (retain, nonatomic) CADisplayLink *animationTimer;
@property (assign) NSTimeInterval animationInterval;
@property (assign) NSTimeInterval deltaTime;
@property (assign) NSTimeInterval lastFrameStartTime;
@property (assign) NSTimeInterval timeSinceLevelStart;
@property (assign) NSDate *levelStartTime;

@property (nonatomic, retain) UILabel *status;

@property (nonatomic, retain) PlasmaView *plasmaView;
@property (nonatomic, retain) PieView *pieView;
@property (assign) PlasmaControlMode plasmaControlMode;
@property (nonatomic, retain) UIView *buttonsLayer;

@property (nonatomic, retain) AudioMixer *audioMixer;

//@property (nonatomic, retain) BDConnect *bdconnection;
//@property NetworkStatus networkConnectionStatus;


- (void) startAnimation;
- (void)initializeTimer;
- (void) stopAnimation;
- (void) applicationWillResignActive;
- (void) applicationDidBecomeActive;
- (void) updateAccelerometerWith:(UIAcceleration *)acceleration;

-(void)showButtonsLayer;
-(void)hideButtonsLayer;


- (IBAction) linkButtonWasPressed;
- (IBAction) audioSettingsButtonWasTouched;
-(void)toggleAudioForWedge:(int)pieceNum;

//-(void) playBDSegmentForWedge: (int)pieceNum;

//-(PlasmaControlMode)plasmaControlMode;

//
////BDConnect
//-(BOOL)remoteControlIsActive;
//-(void)connectToBluRayDisc;
//-(void) sendPlayChapterCommand:(NSString *)chapterID ofTitle:(NSString *)titleID;
//-(IBAction) sendPlayCommand:(id)sender;
//-(IBAction) sendPauseCommand:(id)sender;
//-(IBAction) sendStopCommand:(id)sender;
//-(IBAction) sendHideAllCommand:(id)sender;
//-(IBAction) sendShowMainMenuCommand:(id)sender;
//-(IBAction) sendShowChaptersMenuCommand:(id)sender;
////-(IBAction) sendReceiveFileCommand:(id)sender;
//-(IBAction) sendNextChapterCommand:(id)sender;
//-(IBAction) sendPreviousChapterCommand:(id)sender;
////-(IBAction) sendDownloadVideoCommand:(id)sender;
////-(IBAction) sendTextCommand:(id)sender;
//-(IBAction) sendEnterKeyCommand:(id)sender;
//-(IBAction) sendUpKeyCommand:(id)sender;
//-(IBAction) sendLeftKeyCommand:(id)sender;
//-(IBAction) sendRightKeyCommand:(id)sender;
//-(IBAction) sendDownKeyCommand:(id)sender;
//
//-(IBAction) sendFastForwardCommand:(id)sender;
//-(IBAction) sendRewindCommand:(id)sender;
//
////-(IBAction) sendRedCommand:(id)sender;
////-(IBAction) sendBlueCommand:(id)sender;
////-(IBAction) sendGreenCommand:(id)sender;
////-(IBAction) sendYellowCommand:(id)sender;
////-(IBAction) showInfo:(id)sender;
////-(IBAction) goBluLounge:(id)sender;
////-(IBAction) goBluExplore:(id)sender;
////-(IBAction) showLetters:(id)sender;
////-(IBAction) showNumbers:(id)sender;
////-(IBAction) letterPressed;
////-(IBAction) numberPressed;
////-(IBAction) numericDonePressed;
////-(IBAction)promptAddToLibrary;
////-(void)doAddToLibrary;
////-(BOOL)isDiscInLibrary;
//
//-(BOOL)checkNetworkReachability;
//- (void)reachabilityChanged:(NSNotification *)note;
//- (void)updateStatus;


@end

