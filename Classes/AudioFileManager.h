//
//  AudioFileManager.h
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "Constants.h"

@interface AudioFileManager : NSObject {
	
	NSArray *playlist;
	NSMutableArray *mixerChannels; // channels for real-time mixer (channel 0 = song)
	AVAudioPlayer *songPlayer; // used for mp3 song songPlayerpreview 
	AVAudioPlayer *preloadPlayer; // used for mp3 song songPlayerpreview 

	NSInteger currentSongNum;
	NSInteger preloadSongNum;
	NSInteger playlistPosition;
	BOOL loopSong;
	BOOL loopPlaylist;
	BOOL shuffle;
	NSMutableArray *songOrder;
}

@property (nonatomic, retain) NSArray *playlist;
@property (assign) NSInteger currentSongNum;
@property (assign) NSInteger playlistPosition;
@property (assign) BOOL loopSong;
@property (assign) BOOL loopPlaylist;
@property (assign) BOOL shuffle;
@property (nonatomic, retain) NSMutableArray *songOrder;

+(id) sharedManager;

-(NSInteger) numberOfSongs;
-(NSDictionary *) audioInfoForSong:(NSInteger)i;
-(NSString *)titleForSong:(NSInteger)i;
-(NSString *)artistNameForSong:(NSInteger)i;
-(NSString *)fullFilePathForSongAt:(NSInteger)i;
-(void)playSong:(int)i;
-(int)nextSongNumInPlaylist;
-(void)preloadNextSong;
-(void)playNextSong;
-(void)stopSong;

@end
