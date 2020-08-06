//
//  SongPlayer.h
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import "Constants.h"

@class SongPlayer;

@protocol SongPlayerDelegate
@optional 
-(void)songPlayerDidChangeSongs;
@end


@interface SongPlayer : NSObject <AVAudioPlayerDelegate>{
	
	id <SongPlayerDelegate> delegate;
	
	NSArray *playlist;
	NSMutableArray *mixerChannels; // channels for real-time mixer (channel 0 = song)
	AVAudioPlayer *mainPlayer; // used for mp3 song mainPlayerpreview 
	AVAudioPlayer *preloadPlayer; // used for mp3 song mainPlayerpreview 

	NSInteger currentSongNum;
	NSInteger preloadSongNum;
	NSInteger playlistPosition;
	BOOL loopSong;
	BOOL shuffle;
	NSMutableArray *songOrder;
	BOOL systemPausedAudio;
	
}
@property (nonatomic, retain) id <SongPlayerDelegate> delegate;
@property (nonatomic, retain) NSArray *playlist;
@property (assign) NSInteger currentSongNum;
@property (assign) NSInteger playlistPosition;
@property (assign) BOOL loopSong;
@property (assign) BOOL shuffle;
@property (nonatomic, retain) NSMutableArray *songOrder;

+(id) sharedManager;
-(void)rebuildPlaylist;
-(NSInteger) numberOfSongs;
-(NSDictionary *) audioInfoForSong:(NSInteger)i;
-(NSString *)titleForSong:(NSInteger)i;
-(NSString *)artistNameForSong:(NSInteger)i;
-(NSString *)genreNameForSong:(NSInteger)i;
-(NSString *)fullFilePathForSongAt:(NSInteger)i;
-(void)startPlaylistFromSong:(int)i;
-(void)playSong:(int)i;
-(int)nextSongNumInPlaylist;
-(int)playlistPositionForSong:(int)i;
-(void)preloadNextSong;
-(void)playNextSong;
-(void)stopSong;
-(void) toggleShuffle;
-(BOOL)enterBackgroundMode;
-(BOOL)leaveBackgroundMode;

@end
