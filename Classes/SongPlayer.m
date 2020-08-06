//
//  SongPlayer.m
//  Aquarium
//
//  Created by Alec Vance on 11/4/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "SongPlayer.h"

#define kPreloadSongs 0

@implementation SongPlayer
@synthesize delegate;
@synthesize playlist;
@synthesize currentSongNum, playlistPosition;
@synthesize loopSong, shuffle, songOrder;

static SongPlayer *sharedSongPlayer = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedSongPlayer == nil)
			sharedSongPlayer = [[super allocWithZone:NULL] init];
	}
	return sharedSongPlayer;
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

- (id)autorelease {
	return self;
}

#pragma mark -

-(void) dealloc{
	// Should never be called, but just here for clarity really.
	[playlist release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//[audioFiles release];
	
	[super dealloc];
}

-(id) init{
	if (self = [super init]) {
		//load
		
		NSString *path = [[NSBundle mainBundle] pathForResource: @"Library" ofType:@"plist"];
		NSDictionary *library = [[NSDictionary alloc] initWithContentsOfFile: path];
		playlist = [[library objectForKey:@"Songs"] retain];			
		[library release];
		
		currentSongNum = -1; // no song playing
		preloadSongNum = -1; // no song preloaded
		playlistPosition = 0;
		shuffle = NO;
		loopSong = NO;
		systemPausedAudio = NO;
		
		[self rebuildPlaylist];
		
		/* this allows the audio to play when screen is locked;
		   and if the UIBackgroundModes (info pList) contains an item called "audio", let it play in background of other apps
		 
		
		 // DOING IN APP DELEGATE NOW
		  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
		  [[AVAudioSession sharedInstance] setActive: YES error: nil];

		 */
		
		//	NSLog(@"songOrder = %@",songOrder);
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(deviceShaken) name:@"DeviceShaken" object:nil];


	}
	
	return self;
}

-(void)rebuildPlaylist{
	if (shuffle) {		
		//song order list of index #s
		NSMutableArray *temp = [[NSMutableArray alloc] init];
		for (int i=0; i<playlist.count; i++) {
			[temp addObject: [NSNumber numberWithInt:i] ];
		}
		
		songOrder = [[NSMutableArray alloc] init];
		while (temp.count) {
			int r = RANDOM_INT(0,temp.count-1);
			[songOrder addObject:[temp objectAtIndex:r]];
			[temp removeObjectAtIndex:r];
		}
		
		[temp release];
		
	}else {
		
		//song order list of index #s
		songOrder = [[NSMutableArray alloc] init];
		for (int i=0; i<playlist.count; i++) {
			[songOrder addObject: [NSNumber numberWithInt:i] ];
		}
	}

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

-(NSString *)genreNameForSong:(NSInteger)i{
	return [[self audioInfoForSong:i] objectForKey:@"genre"];
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
	
	//NSLog(@"Looking for soundfile at : %@",filePath);
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


-(void)startPlaylistFromSong:(int)i{

	// find the playlist position that matches this song.
	//playlistPosition = [self playlistPositionForSong:i];
	
	[self playSong: i];
	
}

// immediate play of song ID i
-(void)playSong:(int)i{
	
	// stop current playing sample (if any)
	[self stopSong];
	
	currentSongNum = i;
	playlistPosition = [self playlistPositionForSong:i];
	
	if (currentSongNum==preloadSongNum) {
		mainPlayer = preloadPlayer;
	}else {
		NSString *fullPath = [self fullFilePathForSongAt:currentSongNum];
		NSURL *pathURL = [NSURL fileURLWithPath:fullPath];
		mainPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
		mainPlayer.delegate = self;

	}

	//NSLog(@"Playing song id %i which is at position %i in the playlist.",currentSongNum, playlistPosition); 
	//NSLog(@"The next song id in the playlist is %i",[self nextSongNumInPlaylist]);
	
	[mainPlayer play];	
	preloadPlayer = nil;
	preloadSongNum = -1;
	
	if (kPreloadSongs){
		[self preloadNextSong];
	}
	
	// refresh table of delegate
	[delegate songPlayerDidChangeSongs];

		
}

// do in background?

-(int)playlistPositionForSong:(int)i{
	for (int j=0; j<[self numberOfSongs]; j++) {
		if ([[songOrder objectAtIndex:j] intValue] == i) {
			return j;
		}
	}
	
	return -1; // should never happen!
}

-(int)nextSongNumInPlaylist{
	if (loopSong) {
		return currentSongNum;
	}
	
	int nextSongPosition = playlistPosition +1;
	
	if (nextSongPosition>=[self numberOfSongs]) {
		nextSongPosition =0;
	}
	
	return [[songOrder objectAtIndex:nextSongPosition] intValue];
	
}

-(void)preloadNextSong{
	if([self nextSongNumInPlaylist] == currentSongNum) return;
	
	preloadSongNum = [self nextSongNumInPlaylist];

	NSString *fullPath = [self fullFilePathForSongAt:preloadSongNum];
	
	NSURL *soundURL = [NSURL fileURLWithPath:fullPath];
	
	preloadPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
	
	if(loopSong) preloadPlayer.numberOfLoops = -1; // loop forever
    preloadPlayer.currentTime = 0; //rewind
    preloadPlayer.volume = 1.0; // full
	//NSLog(@"Preloading audio for song %i path= %@",preloadSongNum,fullPath);
	
	[preloadPlayer prepareToPlay];

	
}

-(void)playNextSong{
	if(preloadPlayer != nil){
		mainPlayer = preloadPlayer;
		
		preloadPlayer = nil;
		preloadSongNum = -1;
		
		mainPlayer.delegate = self;
		[mainPlayer play];
		
		// refresh table of delegate
		
		[delegate songPlayerDidChangeSongs];
		

	}else {
		[self playSong:[self nextSongNumInPlaylist]];
	}
	
}



-(void)stopSong{
	
	if (mainPlayer.playing) {
		//NSLog(@"Stopping audio for song player");
		[mainPlayer stop];
		//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeOut:) object:mainPlayer];
		//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeIn:) object:mainPlayer];
		
	}
	
	currentSongNum = -1;
	playlistPosition = -1;
	[delegate songPlayerDidChangeSongs];
	
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *) player successfully:(BOOL) flag {
	
	if (flag==YES) {
        //[secondWindow makeKeyAndVisible];
		[self playNextSong];
    }else {
		//
		NSLog(@"playback stopped because the system could not decode the audio data.");
		[self stopSong];
	}

}

-(void) toggleShuffle{
	shuffle = !shuffle;
	[self rebuildPlaylist];
	
	// if not playing, start playing
	if(currentSongNum == -1){
		[self playSong:[[songOrder objectAtIndex:0] intValue]];
	}
}


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
		[player pause];
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

-(BOOL)enterBackgroundMode{
	//NSLog(@"SongPlayer: enterBackgroundMode");
	
	BOOL soundsWerePaused = NO;
	systemPausedAudio = NO;
	
	if ([mainPlayer isPlaying]) {
		//NSLog(@"SongPlayer: System background fade out audio...");
		[self doVolumeFadeOut:mainPlayer];
		systemPausedAudio = YES;
		soundsWerePaused = YES;
	}
	
	return soundsWerePaused;
}

-(BOOL)leaveBackgroundMode{
	//NSLog(@"SongPlayer: leaveBackgroundMode");

	BOOL soundsWereResumed = NO;
	
	if (systemPausedAudio){
		if (![mainPlayer isPlaying]) {
			//NSLog(@"SongPlayer: System background fade audio back in...");
			mainPlayer.volume = 0.0;
			[mainPlayer	play];
			[self doVolumeFadeIn:mainPlayer];
			soundsWereResumed = YES;
		}
	}
	systemPausedAudio = NO;
	return soundsWereResumed;
	
}


// got a shake event-- stop audio
-(void)deviceShaken{
	[self stopSong];
}

@end
