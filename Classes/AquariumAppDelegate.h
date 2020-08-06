//
//  AquariumAppDelegate.h
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright Juggleware, LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioMixer.h"
#import "SongPlayer.h"

@class CreateViewController;
@class BDConnect;

@interface AquariumAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAccelerometerDelegate, AVAudioSessionDelegate> {
    UIWindow *window;
	
	UITabBarController *tabBarController;
	
    CreateViewController *viewController;
	
//	BDConnect *bdConnection;

	AudioMixer *audioMixer; // sample mixer
	SongPlayer *songPlayer; // mp3 player

	BOOL mixerWasPausedBySystem;
	BOOL songPlayerWasPausedBySystem;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet CreateViewController *viewController;

//@property (nonatomic, retain) BDConnect *bdConnection;
@property (nonatomic, retain) AudioMixer *audioMixer;
@property (nonatomic, retain) SongPlayer *songPlayer;
-(SongPlayer *)songPlayer; //redundant?

// fun hack but still a hack!
//-(void)hideTabBar;
//-(void)showTabBar;
-(void)loadSplash2;
-(void)loadTabBarController;
-(void)openBrowserWithUrl: (NSURL *)theUrl;

@end

