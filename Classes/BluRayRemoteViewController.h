//
//  BluRayRemoteViewController.h
//  Aquarium
//
//  Created by Alec Vance on 11/2/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDConnect.h"
#import "Reachability.h"
#import "ConnectViewController.h"
#import "ColorModel.h"

@interface BluRayRemoteViewController : UIViewController <ConnectViewControllerDelegate> {
	
	
	IBOutlet UIImageView *titleBar;
	IBOutlet UILabel *statusField;
	IBOutlet UIView *buttonsLayer;

	IBOutlet UIButton *upButton;
	IBOutlet UIButton *rightButton;
	IBOutlet UIButton *downButton;
	IBOutlet UIButton *leftButton;
	IBOutlet UIButton *okButton;
	
	UIButton *pressedButton;
	
//	ColorModel *palette;
//	int colorIndex;
//	BOOL colorFwd; 
	
	//BDConnect
	BDConnect *bdconnection;
	NetworkStatus networkConnectionStatus;
	
	BOOL isConnected;

}

@property (nonatomic, retain) UIImageView *titleBar;
@property (nonatomic, retain) UILabel *statusField;
@property (nonatomic, retain) UIView *buttonsLayer;

@property (nonatomic, retain) UIButton *upButton;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) UIButton *downButton;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *okButton;

@property (nonatomic, retain) BDConnect *bdconnection;
@property NetworkStatus networkConnectionStatus;

-(void)showButtonsLayer;
-(void)hideButtonsLayer;
- (IBAction) linkButtonWasPressed;
//-(void)backgroundFadeToNextColor;
//-(void)backgroundFadeToColor:(UIColor *)color;

//BDConnect
//-(BOOL)remoteControlIsActive;
-(void)connectToBluRayDisc;
-(void)disconnectFromBluRayDisc;
-(void) sendPlayChapterCommand:(NSString *)chapterID ofTitle:(NSString *)titleID;
-(IBAction) sendPlayCommand:(id)sender;
-(IBAction) sendPauseCommand:(id)sender;
//-(IBAction) sendStopCommand:(id)sender;
-(IBAction) sendHideAllCommand:(id)sender;
-(IBAction) sendShowMainMenuCommand:(id)sender;
-(IBAction) sendShowChaptersMenuCommand:(id)sender;
//-(IBAction) sendReceiveFileCommand:(id)sender;
-(IBAction) sendNextChapterCommand:(id)sender;
-(IBAction) sendPreviousChapterCommand:(id)sender;
//-(IBAction) sendDownloadVideoCommand:(id)sender;
//-(IBAction) sendTextCommand:(id)sender;
-(IBAction) sendEnterKeyCommand:(id)sender;
-(IBAction) sendUpKeyCommand:(id)sender;
-(IBAction) sendLeftKeyCommand:(id)sender;
-(IBAction) sendRightKeyCommand:(id)sender;
-(IBAction) sendDownKeyCommand:(id)sender;

-(IBAction) sendFastForwardCommand:(id)sender;
-(IBAction) sendRewindCommand:(id)sender;

//-(IBAction) sendRedCommand:(id)sender;
//-(IBAction) sendBlueCommand:(id)sender;
//-(IBAction) sendGreenCommand:(id)sender;
//-(IBAction) sendYellowCommand:(id)sender;
//-(IBAction) showInfo:(id)sender;
//-(IBAction) goBluLounge:(id)sender;
//-(IBAction) goBluExplore:(id)sender;
//-(IBAction) showLetters:(id)sender;
//-(IBAction) showNumbers:(id)sender;
//-(IBAction) letterPressed;
//-(IBAction) numberPressed;
//-(IBAction) numericDonePressed;
//-(IBAction)promptAddToLibrary;
//-(void)doAddToLibrary;
//-(BOOL)isDiscInLibrary;

-(BOOL)checkNetworkReachability;
- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateStatus;

@end
