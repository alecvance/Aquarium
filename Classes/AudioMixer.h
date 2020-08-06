//
//  AudioMixer.h
//  Aquarium
//
//  Created by Alec Vance on 11/10/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

#import "Constants.h"

@interface AudioMixer : NSObject {
	
	NSDictionary *library;
        //SystemSoundID mixerChannels[kMixerChannels]; // channels for CAF mixer
    SystemSoundID samplePlayingID; // single channel for CAF preview

	NSMutableArray *mixerChannels; // channels for real-time mixer (channel 0 = song)
	AVAudioPlayer *previewSongPlayer; // used for mp3 song previewSongPlayerpreview 
	NSInteger currentSetNum;
	NSMutableArray *channelsPausedBySystem; // list of AVAudioPlayers temp paused in BG mode
	
}

@property (nonatomic, retain) NSDictionary *library;
@property (assign) NSInteger currentSetNum;
//@property (nonatomic, retain) NSMutableArray *mixerChannels;

//+(id) sharedAudioMixer;

-(NSInteger) numberOfSoundSets;
-(NSDictionary *)infoForSet:(NSInteger)i;
-(NSString *)titleOfSet:(NSInteger)i;
-(NSString *)artistNameForSet:(NSInteger)i;
-(NSString *)colorForSet:(NSInteger)i;
-(NSArray *)colorArrayForSamplesInSet:(NSInteger)i;
-(NSArray *)colorArrayForSamplesInCurrentSet;
-(NSInteger) numberOfSamplesInSet:(NSInteger)i;
-(NSInteger) numberOfSamplesInCurrentSet;
//-(NSInteger) numberOfAudioFilesInSet:(NSInteger)i;
-(NSDictionary *) audioInfoAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)fullFilePathForAudioAtIndexPath:(NSIndexPath *)indexPath;
-(void)previewAudioAtIndexPath:(NSIndexPath *)indexPath;
-(void)stopAllPreviewSounds;
-(void)previewSongAtPath:(NSString *)fullPath;
-(void)previewSampleAtPath:(NSString *)fullPath;
-(void)switchSetTo:(NSInteger)setNum;
-(void)clearAllMixerChannels;
-(void)stopMixerChannel:(int)i;
-(void)preloadSet;
-(void)preloadMixerChannel:(int)i;
-(void)startMixerChannel:(int)i;
-(BOOL)toggleMixerChannel:(int)i;
-(BOOL)isPlayingMixerChannel:(int)i;
-(void)doVolumeFadeOut:(AVAudioPlayer *)player;
-(void)doVolumeFadeIn:(AVAudioPlayer *)player;
-(void)switchToPreviousSet;
-(void)switchToNextSet;
-(BOOL)enterBackgroundMode;
-(BOOL)leaveBackgroundMode;
-(void)deviceShaken;
@end
