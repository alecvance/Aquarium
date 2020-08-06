//
//  AudioMixerSamplePickerController.h
//  Aquarium
//
//  Created by Alec Vance on 11/10/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioMixer.h"

@class AudioMixerSamplePickerController;

@protocol AudioMixerSamplePickerControllerDelegate<NSObject>
@optional
-(void)audioMixerSamplePickerWasDismissed;
@end


@interface AudioMixerSamplePickerController : UIViewController <UITableViewDelegate> {
	id <AudioMixerSamplePickerControllerDelegate> delegate;
	IBOutlet UITableView *_tableView;
	AudioMixer *audioMixer;
	NSIndexPath *samplePlayingIndexPath;
	UIImage *playImage, *stopImage;
	UIImage *setSelectedImage; //, *setNotSelectedImage;
	
}

@property (nonatomic, retain) id <AudioMixerSamplePickerControllerDelegate> delegate;
@property (nonatomic, retain) UITableView *_tableView;
@property (nonatomic, retain) AudioMixer *audioMixer;
-(UIColor *)colorForSection: (NSInteger)section;
- (void) setPreviewButtonToStopAtIndexPath:(NSIndexPath *)indexPath;
- (void) setPreviewButtonToPlayAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction) doneButtonTouched:(id)sender;
@end
