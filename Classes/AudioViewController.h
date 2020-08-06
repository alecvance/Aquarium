//
//  AudioViewController.h
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongPlayer.h"

@interface AudioViewController : UIViewController <UITableViewDelegate, SongPlayerDelegate> {
	IBOutlet UITableView *_tableView;
	IBOutlet UIButton *loopButton;
	IBOutlet UIButton *shuffleButton;
	SongPlayer *songPlayer;
	UIImage *playImage, *stopImage;
	

}

@property (nonatomic, retain) UITableView *_tableView;
@property (nonatomic, retain) IBOutlet UIButton *loopButton;
@property (nonatomic, retain) IBOutlet UIButton *shuffleButton;

@property (nonatomic, retain) SongPlayer *songPlayer;

-(SongPlayer *)songPlayer;  //redundant?
- (void) setPreviewButtonToStopForSong:(int)i;
- (void) setPreviewButtonToPlayForSong:(int)i;
-(IBAction) loopButtonWasTouched;
-(IBAction) shuffleButtonWasTouched;
- (void) updateButtons;

@end
