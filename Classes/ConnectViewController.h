//
//  RootViewController.h
//  Blu Fire
//
//  Created by scott bates on 3/19/09.
//  Copyright Scott bates 2009. All rights reserved.
//
// edited by Alec Vance Oct 2010

#import <UIKit/UIKit.h>
#import "BrowserViewController.h"

@class BDConnect, BDConnectCommandViewController;
@class ConnectViewController;

@protocol ConnectViewControllerDelegate <NSObject> 

@optional
-(void)BDdidConnectWithConnection:(BDConnect *)bdconnection;
-(void)BDCouldNotConnect;
@end

@interface ConnectViewController : UIViewController <BrowserViewControllerDelegate> {
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UILabel *statusMsg;
	BrowserViewController *bdTouchTableViewController; //VC for bonjour table of found BD devices
	//IBOutlet BDConnectCommandViewController *remoteControlVC;
	//IBOutlet BluLoungeViewController *bluLoungeVC;
	//IBOutlet Blu_FireAppDelegate *appDelegate;
	IBOutlet UIButton *noConnectionButt;
	IBOutlet UIButton *infoButt;
	NSTimer *delayTimer;
	IBOutlet UIViewController *infoModalVC;
	//RootViewController *rootVC;
	
	id <ConnectViewControllerDelegate> delegate;
}

//@property(nonatomic, retain)RootViewController *rootVC;

@property (nonatomic, retain) id <ConnectViewControllerDelegate> delegate;

- (void) signInCompleteWithConnection:(BDConnect *)bdconnection;
- (void)bonjourTimeout;
//-(void)showLounge;
-(void)setup;
- (void) discIdMismatch; //alec
-(IBAction)doContinue;
-(IBAction) showInfo;

@end
