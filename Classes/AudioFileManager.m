//
//  AudioFileManager.m
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "AudioFileManager.h"

@implementation AudioFileManager

@synthesize playlist;
@synthesize currentSongNum, playlistPosition;
@synthesize loopSong, loopPlaylist, shuffle, songOrder;

static AudioFileManager *sharedAudioFileManager = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedAudioFileManager == nil)
			sharedAudioFileManager = [[super allocWithZone:NULL] init];
	}
	return sharedAudioFileManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [[self sharedManager] retain];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
	// never release
}
- (id)autorelease {
	return self;
}

#pragma mark -

-(void) dealloc{
	// Should never be called, but just here for clarity really.

	//[audioFiles release];
	
	[super dealloc];
}

-(id) init{
	if (self = [super init]) {
		//load
		
		NSString *path = [[NSBundle mainBundle] pathForResource: @"SoundLibrary" ofType:@"plist"];
		NSDictionary *library = [[NSDictionary alloc] initWithContentsOfFile: path];
		playlist = [library objectForKey:@"Songs"];			
		
		currentSongNum = 0; // default set number
		preloadSongNum = -1; // no song preloaded
		playlistPosition = 0;
		shuffle = NO;
		loopSong = NO;
		loopPlaylist = YES;
		
		//song order list of index #s
		songOrder = [[NSMutableArray alloc] init];
		for (int i; i<playlist.count; i++) {
			[songOrder addObject: [NSNumber numberWithInt:i] ];
		}

	}
	
	return self;
}

-(NSInteger) numberOfSongs{
	return [playlist count];
}

-(NSDictionary *) audioInfoForSong:(NSInteger)i{
	return [playlist objectAtIndex:i];
}

-(NSString *)titleForSong:(NSInteger)i{
	return [[self audioInfoForSong:i] objectForKey:@"title"];
}

-(NSString *)artistNameForSong:(NSInteger)i{
	return [[self audioInfoForSong:i] objectForKey:@"artist"];

}

-(NSString *)fullFilePathForSongAt:(NSInteger)i{
	NSDictionary *info = [self audioInfoForSong:i];
	NSString *file = [info objectForKey:@"file"];
	
	//
	//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	//	NSString *documentsDirectory = [paths objectAtIndex:0];
	//	if (!documentsDirectory) 
	//	{
	//		NSLog(@"Documents directory not found!");
	//		return;
	//	}
	
	NSString *filePath = [NSString pathWithComponents: [NSArray arrayWithObjects: @"Audio",file,nil]];	
	
	NSLog(@"Looking for soundfile at : %@",filePath);
	[[NSBundle mainBundle] pathForResource:filePath	ofType:nil]; // match filename exactly\
	
	NSString *fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filePath];
	
	//check if file exists
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL success = [fm fileExistsAtPath:fullPath];
	
	if(! success){
		NSLog(@"File not found: %@",fullPath);
		return @"";
	}
	
	return fullPath;
}

// immediate play of song ID i
-(void)playSong:(int)i{
	currentSongNum = i;
	
	// stop current playing sample (if any)
	[self stopSong];
	
	NSString *fullPath = [self fullFilePathForSongAt:currentSongNum];
	NSURL *pathURL = [NSURL fileURLWithPath:fullPath];
	songPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
//	[songPlayer prepareToPlay];
	[songPlayer play];	
	
	[self preloadNextSong];
}

// do in background?

-(int)nextSongNumInPlaylist{
	int nextSongPosition = playlistPosition +1;
	
	if (nextSongPosition>[self numberOfSongs]) {
		nextSongPosition =0;
	}
	
	return [[songOrder objectAtIndex:nextSongPosition] intValue];
	
}

-(void)preloadNextSong{
	
	preloadSongNum = [self nextSongNumInPlaylist];

	NSString *fullPath = [self fullFilePathForSongAt:preloadSongNum];
	
	NSURL *soundURL = [NSURL fileURLWithPath:fullPath];
	
	preloadPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
	
	if(loopSong) preloadPlayer.numberOfLoops = -1; // loop forever
    preloadPlayer.currentTime = 0; //rewind
    preloadPlayer.volume = 1.0; // full
	NSLog(@"Preloading audio for song %i path= %@",preloadSongNum,fullPath);
	
	[preloadPlayer prepareToPlay];

	
}

-(void)playNextSong{
	if(preloadPlayer != nil){
		songPlayer = preloadPlayer;
		[songPlayer play];
		preloadPlayer = nil;

	}else {
		[self playSong:[self nextSongNumInPlaylist]];
	}
	
}



-(void)stopSong{
	
	if (songPlayer.playing) {
		NSLog(@"Stopping audio for song player");
		[songPlayer stop];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeOut:) object:songPlayer];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeIn:) object:songPlayer];
		
	}
	
}



/*
-(void)doVolumeFadeOut:(AVAudioPlayer *)player;
{  
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeOut:) object:player];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeIn:) object:player];

	
    if (player.volume > kFadeVolumeIncrement) {
        player.volume = player.volume - kFadeVolumeIncrement;
        [self performSelector:@selector(doVolumeFadeOut:) withObject:player afterDelay:1.0/kFPS];           
	} else {
        // Stop and get the sound ready for playing again
		//player.volume = 0.0;
		//[player performSelector:@selector(stop) withObject:nil afterDelay:0.5];           
		[player stop];
      //player.currentTime = 0;
//        [player prepareToPlay];
//        player.volume = 1.0;
    }
}

-(void)doVolumeFadeIn:(AVAudioPlayer *)player;
{  
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeOut:) object:player];
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeIn:) object:player];

    if (player.volume <1.0) {
        player.volume = player.volume + kFadeVolumeIncrement;
        [self performSelector:@selector(doVolumeFadeIn:) withObject:player afterDelay:1.0/kFPS];           
	} else {
      //Done
        
	}
}
 
 */

@end
