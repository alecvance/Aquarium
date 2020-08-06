//
//  AudioMixer.m
//  Aquarium
//
//  Created by Alec Vance on 11/10/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "AudioMixer.h"
#define soundSets 	[library objectForKey:@"Sets"]

@implementation AudioMixer

@synthesize library;
@synthesize currentSetNum;

/*
//static AudioMixer *sharedAudioMixer = nil;

#pragma mark -
#pragma mark Singleton Methods

+ (id)sharedAudioMixer {
	@synchronized(self) {
		if(sharedAudioMixer == nil)
			sharedAudioMixer = [[super allocWithZone:NULL] init];
	}
	return sharedAudioMixer;
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
*/
#pragma mark -

-(void) dealloc{
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	
	[library release];
	[super dealloc];
}

-(id) init{
	if (self = [super init]) {
		//load
		
		NSString *path = [[NSBundle mainBundle] pathForResource: @"Library" ofType:@"plist"];
		library = [[NSDictionary alloc] initWithContentsOfFile: path];
		
		mixerChannels = [[NSMutableArray alloc] initWithCapacity:kMixerChannels];
		
		for (int i=0; i<kMixerChannels; i++) {
			//			mixerChannels[i] = 0;
			//[mixerChannels addObject:[[AVAudioPlayer alloc] init]];
			[mixerChannels addObject:[NSNull null]]; // placeholders
		}
		
		channelsPausedBySystem = [[NSMutableArray alloc] init]; 

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(deviceShaken) name:@"DeviceShaken" object:nil];
		
		currentSetNum = 0; // default set number
	//	[self preloadSet];
	}
	
	return self;
}

-(NSInteger) numberOfSoundSets{
	return [soundSets count];
}


-(NSDictionary *)infoForSet:(NSInteger)i{
	return [soundSets objectAtIndex:i]; 
}

-(NSString *)titleOfSet:(NSInteger)i{
	return [[self infoForSet:i] objectForKey: @"title"];
}

-(NSString *)artistNameForSet:(NSInteger)i{
	return [[self infoForSet:i] objectForKey: @"artist"];
}

-(NSString *)colorForSet:(NSInteger)i{
	return [[self infoForSet:i] objectForKey: @"color"];
}

-(NSArray *)colorArrayForSamplesInSet:(NSInteger)i{
	NSMutableArray *colors = [[[NSMutableArray alloc] initWithCapacity: kMixerChannels] autorelease];
	for (int j=0; j<[self numberOfSamplesInSet:i]; j++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
		[colors addObject:[[self audioInfoAtIndexPath:indexPath] objectForKey: @"color"]];
	}
	
	return colors; // need to cast?
}
-(NSArray *)colorArrayForSamplesInCurrentSet{
	return [self colorArrayForSamplesInSet:currentSetNum];
}

-(NSInteger) numberOfSamplesInSet:(NSInteger)i{
	return [[[self infoForSet:i] objectForKey: @"samples"] count];
}

-(NSInteger) numberOfSamplesInCurrentSet{
	return [self numberOfSamplesInSet:currentSetNum];
}

/*
-(NSInteger) numberOfAudioFilesInSet:(NSInteger)i{
	return [self numberOfSamplesInSet:i]+1; // +1 for the song; assume it is there.
}
*/
-(NSDictionary *) audioInfoAtIndexPath:(NSIndexPath *)indexPath{
	
	NSInteger sampleNum = indexPath.row;
	return [[[soundSets objectAtIndex:indexPath.section] objectForKey: @"samples"] objectAtIndex:sampleNum];

	
}

-(NSString *)fullFilePathForAudioAtIndexPath:(NSIndexPath *)indexPath{
	NSDictionary *info = [self audioInfoAtIndexPath:indexPath];
	NSString *dir =  [[soundSets objectAtIndex:indexPath.section] objectForKey: @"id"];
	NSString *file = [info objectForKey:@"file"];
	
	//
	//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);		
	//	NSString *documentsDirectory = [paths objectAtIndex:0];
	//	if (!documentsDirectory) 
	//	{
	//		NSLog(@"Documents directory not found!");
	//		return;
	//	}
	
	NSString *filePath = [NSString pathWithComponents: [NSArray arrayWithObjects: @"Audio",dir,file,nil]];	
	
	//NSLog(@"Looking for soundfile at : %@",filePath);
	[[NSBundle mainBundle] pathForResource:filePath	ofType:nil]; // match filename exactly\
	
	NSString *fullPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filePath];
	
	//check if file exists
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL success = [fm fileExistsAtPath:fullPath];
	
	if(! success){
		NSLog(@"File not found: %@",fullPath);
		return nil;
	}
	
	return fullPath;
}

-(void)previewAudioAtIndexPath:(NSIndexPath *)indexPath{
	NSString* fullPath = [self fullFilePathForAudioAtIndexPath:(NSIndexPath *)indexPath];
	
	//NSString *fileExtension = [[fullPath componentsSeparatedByString:@"."] lastObject];
	//if([fileExtension isEqualToString:@"mp3"]){
		//mp3
		[self previewSongAtPath: fullPath];
	//}else{
		//CAF sample 
	//	[self previewSampleAtPath: fullPath];
	//}
	
}


static void sampleFinishedPlaying (SystemSoundID  mySSID, void* myself) {
	//NSLog(@"sampleFinishedPlaying completion Callback");
	AudioServicesRemoveSystemSoundCompletion (mySSID);
	
	//[(SoundEffect*)myself release];
}

-(void)stopAllPreviewSounds{
	//stop currently playing song (if any)
	[previewSongPlayer stop];
	
	// stop current playing sample (if any)
	if (samplePlayingID){
		AudioServicesDisposeSystemSoundID(samplePlayingID);
		samplePlayingID = 0;
	}
}


-(void)previewSongAtPath:(NSString *)fullPath{
	// stop current playing sample (if any)
	[self stopAllPreviewSounds];
	
	NSURL *pathURL = [NSURL fileURLWithPath:fullPath];
	previewSongPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error:nil];
	//	[previewSongPlayer prepareToPlay];
	[previewSongPlayer play];	
}

-(void)previewSampleAtPath:(NSString *)fullPath{
	// stop current playing sample (if any)
	[self stopAllPreviewSounds];
	
	NSURL *soundURL = [NSURL fileURLWithPath:fullPath];
	
	AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &samplePlayingID);
	AudioServicesPlaySystemSound(samplePlayingID);
	
	AudioServicesAddSystemSoundCompletion(samplePlayingID, NULL, NULL, sampleFinishedPlaying, (void *)self);
	
}
/* 
 
 http://www.raywenderlich.com/259/audio-101-for-iphone-developers-playing-audio-programmatically
 
 Doesn’t get much easier than that. However there are some strong drawbacks to this method:
 It only supports audio data formats linear PCM or IMA4.
 It only supports audio file formats CAF, AIF, or WAV.
 The sounds must be 30 seconds or less in length.
 And more – see the iPhone Application Programming Guide, page 149.
 
 */

-(void)switchSetTo:(NSInteger)setNum{
	[self stopAllPreviewSounds];
	if (setNum!=currentSetNum) {
		//NSLog(@"switching to set %i",setNum);
		//clear all channels
		[self clearAllMixerChannels];
		
		currentSetNum = setNum;
		[self preloadSet];
	}
}

-(void)switchToPreviousSet{
	int nextSet = currentSetNum -1;
	if (nextSet<0) {
		nextSet = [self numberOfSoundSets]-1;
	}
	[self switchSetTo: nextSet];
}
-(void)switchToNextSet{
	
	int nextSet = currentSetNum +1;
	if (nextSet>[self numberOfSoundSets]-1) {
		nextSet = 0;
	}
	[self switchSetTo: nextSet];
}


-(void)clearAllMixerChannels{
	[previewSongPlayer stop];
	
	//for(NSNumber *mixerChannel in mixerChannels){
	//		SystemSoundID soundID = [mixerChannel intValue];
	//	}
	
	//for (int i=0; i<kMixerChannels; i++) {
	for (int i=0; i<[self numberOfSamplesInSet:currentSetNum]; i++) {

		[self stopMixerChannel: i];
		//SystemSoundID soundID = mixerChannels[i];
		
	}
	
}

-(void)stopMixerChannel:(int)i{
	//SystemSoundID soundID = mixerChannels[i];
	//	if (soundID){
	//		AudioServicesDisposeSystemSoundID(soundID);
	//		mixerChannels[i] = 0;
	//	}
	
	AVAudioPlayer *player = [mixerChannels objectAtIndex:i];
	if ([player isPlaying]) {
		//NSLog(@"stop audio for channel %i",i);
		[player stop];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeOut:) object:player];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doVolumeFadeIn:) object:player];
		
		
	}
	
}

-(void)preloadSet{
	//NSLog(@"Preloading set...");
	//NSDate *t = [NSDate date];
	for(int i=0; i<[self numberOfSamplesInSet:currentSetNum]; i++){
		[self preloadMixerChannel: i];
	}
	//NSTimeInterval seconds = [t timeIntervalSinceNow];
	//NSLog(@"Preload audio set took %f seconds",-seconds);
	
}

-(void)preloadMixerChannel:(int)i{
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:currentSetNum];
	
	NSString *fullPath = [self fullFilePathForAudioAtIndexPath:indexPath];
	
	if(! fullPath){
		
		NSLog(@"File not found for channel %i",i);
		[mixerChannels replaceObjectAtIndex:i withObject:[NSNull null]];
		return;
		
	}

	NSURL *soundURL = [NSURL fileURLWithPath:fullPath];
	AVAudioPlayer *player = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil] autorelease];

	player.numberOfLoops = -1;
    player.currentTime = 0;
    player.volume = 1.0;
	//NSLog(@"Preloading audio for channel %i path= %@",i,fullPath);
	
	[player prepareToPlay];
	
	[mixerChannels replaceObjectAtIndex:i withObject:player];
	
	
}

-(void)startMixerChannel:(int)i{
	AVAudioPlayer *player = [mixerChannels objectAtIndex:i];
	
	//	[previewSongPlayer prepareToPlay];
	//	player.numberOfLoops = -1;
	//   player.currentTime = 0;
	
    player.volume = 0.0;
	[player play];	
	
	//Do fadein
	[self doVolumeFadeIn:player];
	
	
	//NSLog(@"Starting audio for channel %i",i);
}

//returns YES if playing as a result of this call
-(BOOL)toggleMixerChannel:(int)i{
	AVAudioPlayer *player = [mixerChannels objectAtIndex:i];
	//if ([player respondsToSelector:@selector(isPlaying)]) {
		if ([player isPlaying]) {
			//[self stopMixerChannel:i];
			[self doVolumeFadeOut:player];
			return NO;
		}
	//}	
	
	[self startMixerChannel:i];
	return YES;
	
}

-(BOOL)isPlayingMixerChannel:(int)i{
	AVAudioPlayer *player = [mixerChannels objectAtIndex:i];
	if ([player isPlaying]) {
		return YES;
	}
	return NO;
	
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
	//NSLog(@"AudioMixer: enterBackgroundMode");
	
	BOOL soundsWerePaused = NO;
	
	[self stopAllPreviewSounds];

	for (int i=0; i<[self numberOfSamplesInSet:currentSetNum]; i++) {
		AVAudioPlayer *player = [mixerChannels objectAtIndex:i];
		if ([player isPlaying]) {
			//NSLog(@"System background fadeout audio for channel %i...",i);
			[self doVolumeFadeOut:player];
			[channelsPausedBySystem addObject:player];
			soundsWerePaused = YES;
		}
	}
	
	return soundsWerePaused;
}

-(BOOL)leaveBackgroundMode{
	//NSLog(@"AudioMixer: leaveBackgroundMode");
	
	BOOL soundsWereResumed = NO;

	for (AVAudioPlayer *player in channelsPausedBySystem){
		int channelNum = [mixerChannels indexOfObject:player];
		if(channelNum>=0){
			//if (![player isPlaying]) {
				//NSLog(@"System background fade audio back in for channel %i...",channelNum);
				player.volume = 0.0;
				[player play];	
				[self doVolumeFadeIn:player];
				soundsWereResumed = YES;
			//}
			
		}
	}
	
	[channelsPausedBySystem removeAllObjects];
	
	return soundsWereResumed;
	
}

// got a shake event-- stop audio
-(void)deviceShaken{
	[self clearAllMixerChannels];
}

@end
